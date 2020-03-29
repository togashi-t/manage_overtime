document.addEventListener('turbolinks:load', () => {

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

})
