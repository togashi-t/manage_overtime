document.addEventListener('turbolinks:load', () => {

  // グラフ
  if (document.querySelector(".chart")) {

    // 個人毎のグラフ・グループ毎のグラフに共通するもの
    // 所定年月
    const TODAY = new Date()
    const FIVE_MONTH_AGO = new Date()
    FIVE_MONTH_AGO.setMonth(TODAY.getMonth() - 5)

    // 日付型から[year, month]を生成
    const extractYearAndMonth = (date) => [date.getFullYear(), date.getMonth() + 1]

    // 始期以後、終期以前の年月リスト作成
    // 引数はどちらも[year, month]の形
    const yearAndMonthList = (beginning, end) => {
      const arr = []
      let year
      let month
      [year, month] = beginning
      while(JSON.stringify([year, month]) != JSON.stringify(end)) {
        arr.push([year, month])
        if(month != 12) {
          month += 1
        } else {
          year += 1
          month = 1
        }
      }
      arr.push(end)
      return arr
    }

    // 引数は[year, month]の形
    const convertYearAndMonthFormat = (yearAndMonth) => {
      let year
      let month
      [year, month] = yearAndMonth
      return `${year}年${month}月`
    }

    const formatedYearAndMonthList = (beginning, end) => {
      const arr = []
      yearAndMonthList(beginning, end).forEach(el => {
        arr.push(convertYearAndMonthFormat(el))
      })
      return arr
    }

    // 初期表示の始期・終期
    let chartBeginning = extractYearAndMonth(FIVE_MONTH_AGO)
    let chartEnd = extractYearAndMonth(TODAY)


    // グラフ表示期間の変更
    const chartPeriodBeginningYear = document.getElementById("chart_period_beginning_1i")
    const chartPeriodBeginningMonth = document.getElementById("chart_period_beginning_2i")
    const chartPeriodEndYear = document.getElementById("chart_period_end_1i")
    const chartPeriodEndMonth = document.getElementById("chart_period_end_2i")
    const chartPeriodButton = document.getElementById("chart-period-button")

    const changePeriod = (func) => {
      chartPeriodButton.addEventListener('click', function() {
        let beginningYear = parseInt(chartPeriodBeginningYear.value)
        let beginningMonth = parseInt(chartPeriodBeginningMonth.value)
        let endYear = parseInt(chartPeriodEndYear.value)
        let endMonth = parseInt(chartPeriodEndMonth.value)

        if(beginningYear > endYear) {
          alert("始期年月 < 終期年月 としてください")
        } else if((beginningYear == endYear) && (beginningMonth >= endMonth)) {
          alert("始期年月 < 終期年月 としてください")
        } else {
          func([beginningYear, beginningMonth], [endYear, endMonth])
        }
      })
    }


    // 個人毎のグラフ
    if(document.getElementById("show-chart")) {

      // グラフを描く場所を取得
      const chartContext = document.getElementById("show-chart").getContext('2d')

      // controllerから渡されたデータの残業がない月の残業時間に0を補完
      const complementedMonthlyChartData = (beginning, end) => {
        let hash = {}
        formatedYearAndMonthList(beginning, end).forEach(yearAndMonth => {
          let overtime
          overtime = gon.monthly_chart_data[yearAndMonth] || 0
          hash[yearAndMonth] = overtime
        })
        return hash
      }


      let chart

      const drawChart = (beginning, end) => {
        // 年月・残業時間のデータ
        let monthlyChartData = complementedMonthlyChartData(beginning, end)
        let months = Object.keys(monthlyChartData)
        let overtimes = Object.values(monthlyChartData)

        let overtimeData = {
          labels: months,
          datasets: [{
            label: '(時間)',
            data: overtimes,
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
          }]
        }

        let overtimeOption = {
          scales: {
            yAxes: [{
              ticks: {
                suggestedMax: 60
              }
            }]
          }
        }

        if(!chart) {
          // グラフが存在しないときはグラフを新規に描画する
          chart = new Chart(chartContext, {
            type: 'bar',
            data: overtimeData,
            options: overtimeOption
          })
        } else {
          // グラフが存在するときはグラフのデータを更新する
          chart.data = overtimeData
          chart.options = overtimeOption
          chart.update()
        }

      }


      // グラフの初期表示
      drawChart(chartBeginning, chartEnd)

      // 表示期間変更
      changePeriod(drawChart)

    }


    // グループ毎のグラフ
    if(document.getElementById("index-chart")) {

      // グラフを描く場所を取得
      const chartContext = document.getElementById("index-chart").getContext('2d')

      const groupMonthlyChartData = gon.group_monthly_chart_data

      // controllerから渡されたデータの残業がない月の残業時間に0を補完
      const complementedGroupMonthlyChartData = (beginning, end) => {
        let obj = {}
        Object.keys(groupMonthlyChartData).forEach(key => {
          obj[key] = {}
          let monthlyChartData = groupMonthlyChartData[key]

          formatedYearAndMonthList(beginning, end).forEach(yearAndMonth => {
            let overtime
            overtime = monthlyChartData[yearAndMonth] || 0
            obj[key][yearAndMonth] = overtime
          })
        })
        return obj
      }


      let chart

      const drawChart = (beginning, end) => {
        // グループ・年月・残業時間のデータ
        let groupAndMonthlyChartData = complementedGroupMonthlyChartData(beginning, end)
        let groups = Object.keys(groupAndMonthlyChartData)
        let firstGroupMonthlyChartData = Object.values(groupAndMonthlyChartData)[0]
        let months = Object.keys(firstGroupMonthlyChartData)

        let datasetList = []
        const colors = [
          "rgba(255, 0, 255, 0.8)",
          "rgba(0, 0, 255, 0.8)",
          "rgba(0, 128, 0, 0.8)",
          "rgba(0, 255, 255, 0.8)",
          "rgba(255, 0, 0, 0.8)",
          "rgba(128, 0, 128, 0.8)",
          "rgba(0, 128, 128, 0.8)",
          "rgba(255, 255, 0, 0.8)",
          "rgba(128, 128, 0, 0.8)",
          "rgba(0, 255, 0, 0.8)",
        ]
        groups.forEach((group, index) => {
          let dataset = {}
          let color = colors[index]
          dataset["label"] = group,
          dataset["data"] = Object.values(groupAndMonthlyChartData[group]),
          dataset["backgroundColor"] = color,
          dataset["borderColor"] = color,
          dataset["borderWidth"] = 1,
          dataset["lineTension"] = 0,
          dataset["fill"] = false,
          datasetList.push(dataset)
        })

        let overtimeData = {
          labels: months,
          datasets: datasetList
        }

        let overtimeOption = {
          scales: {
            yAxes: [{
              ticks: {
                suggestedMax: 150
              }
            }]
          }
        }

        if(!chart) {
          // グラフが存在しないときはグラフを新規に描画する
          chart = new Chart(chartContext, {
            type: 'line',
            data: overtimeData,
            options: overtimeOption
          })
        } else {
          // グラフが存在するときはグラフのデータを更新する
          chart.data = overtimeData
          chart.options = overtimeOption
          chart.update()
        }

      }


      // グラフの初期表示
      drawChart(chartBeginning, chartEnd)

      // 表示期間変更
      changePeriod(drawChart)

    }

  }



  // usersのshowページ
  // 追加フォーム
  if(document.getElementById("new-form")) {

    // カレンダー
    flatpickr.localize(flatpickr.l10ns.ja)
    flatpickr("#new-calendar", {
      disable: gon.recorded_dates,
      defaultDate: 'today'
    })

    // viewのformでtime_selectを使用した箇所には、自動的にidが付与される
    const newWorkStartTimeHour = document.querySelector("#new-form #overtime_work_start_time_4i")
    const newWorkStartTimeMinute = document.querySelector("#new-form #overtime_work_start_time_5i")
    const newWorkEndTimeHour = document.querySelector("#new-form #overtime_work_end_time_4i")
    const newWorkEndTimeMinute = document.querySelector("#new-form #overtime_work_end_time_5i")
    const newWorkTime = document.getElementById("new-work-time")
    const newInputs = document.querySelectorAll('#new-form .input-time')

    newInputs.forEach(el => {
      el.addEventListener('change', function(){
        let newWorkStartTimeValueConvertedToMinute = (Number(newWorkStartTimeHour.value * 60) + Number(newWorkStartTimeMinute.value))
        let newWorkEndTimeValueConvertedToMinute = (Number(newWorkEndTimeHour.value * 60) + Number(newWorkEndTimeMinute.value))

        let newWorkTimeValueConvertedToMinute = (newWorkEndTimeValueConvertedToMinute - newWorkStartTimeValueConvertedToMinute)
        let newWorkTimeHourValue = Math.floor(newWorkTimeValueConvertedToMinute / 60)
        let newWorkTimeMinuteValue = newWorkTimeValueConvertedToMinute % 60
        // ゼロフィル
        let newWorkTimeValue = ("00" + newWorkTimeHourValue).slice(-2) + ':' + ("00" + newWorkTimeMinuteValue).slice(-2)
        newWorkTime.value = newWorkTimeValue
      });
    });
  }

  // 修正フォーム
  if(document.getElementById("edit-form")) {

    // viewのformでtime_selectを使用した箇所には、自動的にidが付与される
    const editWorkStartTimeHour = document.querySelector("#edit-form #overtime_work_start_time_4i")
    const editWorkStartTimeMinute = document.querySelector("#edit-form #overtime_work_start_time_5i")
    const editWorkEndTimeHour = document.querySelector("#edit-form #overtime_work_end_time_4i")
    const editWorkEndTimeMinute = document.querySelector("#edit-form #overtime_work_end_time_5i")
    const editWorkTime = document.getElementById("edit-work-time")
    const editInputs = document.querySelectorAll('#edit-form .input-time')

    // カレンダー
    flatpickr.localize(flatpickr.l10ns.ja)
    const editCalendar = document.getElementById("edit-calendar")
    const overtimesDevidedIntoHourAndMinute= gon.overtimes_devided_into_hour_and_minute
    const recorded_dates = Object.keys(overtimesDevidedIntoHourAndMinute)

    // モーダルで日付を選択した時に、記録済残業時間を表示
    const inputTime = () => {
      let overtime = overtimesDevidedIntoHourAndMinute[editCalendar.value]
      editWorkStartTimeHour.value = ("00" + overtime["start_hour"]).slice(-2)
      editWorkStartTimeMinute.value = overtime["start_minute"]
      editWorkEndTimeHour.value = overtime["end_hour"]
      editWorkEndTimeMinute.value = ("00" + overtime["end_minute"]).slice(-2)
      let workTimeMinute =  Number(overtime["work_minute"])
      let editWorkTimeHourValue = Math.floor(workTimeMinute / 60)
      let editWorkTimeMinuteValue = workTimeMinute % 60
       // ゼロフィル
      editWorkTime.value =  ("00" + editWorkTimeHourValue).slice(-2) + ':' + ("00" + editWorkTimeMinuteValue).slice(-2)
    }

    flatpickr("#edit-calendar", {
      defaultDate: 'today',
      enable: recorded_dates,
      onChange: inputTime
    })

    editInputs.forEach(el => {
      el.addEventListener('change', function(){
        let editWorkStartTimeValueConvertedToMinute = (Number(editWorkStartTimeHour.value * 60) + Number(editWorkStartTimeMinute.value))
        let editWorkEndTimeValueConvertedToMinute = (Number(editWorkEndTimeHour.value * 60) + Number(editWorkEndTimeMinute.value))

        let editWorkTimeValueConvertedToMinute = (editWorkEndTimeValueConvertedToMinute - editWorkStartTimeValueConvertedToMinute)
        let editWorkTimeHourValue = Math.floor(editWorkTimeValueConvertedToMinute / 60)
        let editWorkTimeMinuteValue = editWorkTimeValueConvertedToMinute % 60
        // ゼロフィル
        let editWorkTimeValue = ("00" + editWorkTimeHourValue).slice(-2) + ':' + ("00" + editWorkTimeMinuteValue).slice(-2)
        editWorkTime.value = editWorkTimeValue
      });
    });

  }

  // 個人当月のテーブル
  if(document.getElementById("show-table")){
    const dayList = document.querySelectorAll(".day")
    dayList.forEach(el => {
      let day = el.innerHTML
      if (day == "土") {
        el.classList.add("text-primary")
      } else if (day == "日") {
        el.classList.add("text-danger")
      }
    })
  }


  // usersのindexページ
  // 全ユーザー当月のテーブル
  if(document.getElementById("index-table")){
    const hourAtTheEndOfMonthList = document.querySelectorAll(".hour_at_the_end_of_month")
    hourAtTheEndOfMonthList.forEach(el => {
      let hour = el.innerHTML
      if (hour >= 60) {
        el.classList.add("bg-danger")
      } else if (hour >= 30) {
        el.classList.add("bg-warning")
      }
    })
  }

})
