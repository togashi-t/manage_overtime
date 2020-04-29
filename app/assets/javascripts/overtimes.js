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
  // 入力フォーム
  if(document.getElementById("form")) {
    // viewのformでtime_selectを使用した箇所には、自動的にidが付与される
    const workStartTimeHour = document.getElementById("overtime_work_start_time_4i")
    const workStartTimeMinute = document.getElementById("overtime_work_start_time_5i")
    const workEndTimeHour = document.getElementById("overtime_work_end_time_4i")
    const workEndTimeMinute = document.getElementById("overtime_work_end_time_5i")
    const workTime = document.getElementById("work-time")
    const inputs = document.querySelectorAll('.input-time')

    inputs.forEach(el => {
      el.addEventListener('change', function(){
        let workStartTimeValueConvertedToMinute = (Number(workStartTimeHour.value * 60) + Number(workStartTimeMinute.value))
        let workEndTimeValueConvertedToMinute = (Number(workEndTimeHour.value * 60) + Number(workEndTimeMinute.value))

        let workTimeValueConvertedToMinute = (workEndTimeValueConvertedToMinute - workStartTimeValueConvertedToMinute)
        let workTimeHourValue = Math.floor(workTimeValueConvertedToMinute / 60)
        let workTimeMinuteValue = workTimeValueConvertedToMinute % 60
        // ゼロフィル
        let workTimeValue = ("00" + workTimeHourValue).slice(-2) + ':' + ("00" + workTimeMinuteValue).slice(-2)
        workTime.value = workTimeValue
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
