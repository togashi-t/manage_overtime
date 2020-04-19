document.addEventListener('turbolinks:load', () => {

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

  // 個人毎のグラフ
  if(document.getElementById("show-chart")) {

    // グラフを描く場所を取得
    const chartContext = document.getElementById("show-chart").getContext('2d')

    // グラフ描画期間
    const extractYearAndMonth = (date) => [date.getFullYear(), date.getMonth() + 1]
    const TODAY = new Date()
    const ELEVEN_MONTH_AGO = new Date()
    ELEVEN_MONTH_AGO.setMonth(TODAY.getMonth() - 11)
    let chartBeginning = extractYearAndMonth(ELEVEN_MONTH_AGO)
    let chartEnd = extractYearAndMonth(TODAY)

    // 引数はどちらも[year, month]の形
    const yearAndMonthList = (beginning, end) => {
      const list = []
      let year
      let month
      [year, month] = beginning
      while(JSON.stringify([year, month]) != JSON.stringify(end)) {
        list.push([year, month])
        if(month != 12) {
          month += 1
        } else {
          year += 1
          month = 1
        }
      }
      list.push(end)
      return list
    }

    // 引数は[year, month]の形
    const convertYearAndMonthFormat = (yearAndMonth) => {
      let year
      let month
      [year, month] = yearAndMonth
      return `${year}年${month}月`
    }

    const formatedYearAndMonthList = (beginning, end) => {
      const list = []
      yearAndMonthList(beginning, end).forEach(el => {
        list.push(convertYearAndMonthFormat(el))
      })
      return list
    }

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

    // 年月・残業時間のデータ
    const monthlyChartData = complementedMonthlyChartData(chartBeginning, chartEnd)
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

    // グラフを描画
    new Chart(chartContext, {
      type: 'bar',
      data: overtimeData,
      options: overtimeOption
    })

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
    console.log(hourAtTheEndOfMonthList)
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
