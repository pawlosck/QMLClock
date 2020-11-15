import QtQuick 2.0
import QtQml 2.15

Item
{
    signal signal_alarm_finished(int timerID_value)

    QtObject
    {
        //W obiekcie QObject nie moze byc wiecej obiektow, bo inaczej bedzie wywlac blad, ze component nie zaladowany
        id: alarm

        property var timerID: 0 //Zmienna do ktorej bedzie przypisywana wartosc na podstawie ktore bedzie mozna znalezc obiekt

        property int start_date_unix_timestamp: 0 //Data dodania alarmu uzywajac unix time. Od tego czasu liczy sie alarm
        property int stop_date_unix_timestamp: 0 //Data uruchomienia alarmu uzywajac unix time.
//        property int timer_value_seconds: 0 // za ile ma sie wlaczyc alarm w sekundach
        property string message: "Default message"
        property string type_of_alarm: "Default" //rodzaj alarmu. Np alarm informujacy o telefonie, programie w tv, czy tez w radio

        property int timer_elapsed: 0 //Ile uplynelo sekund od uruchomienia alarmu
        property int timer_remaining: 0 //Ile czasu zostalo do uruchomienia alarmu

        property bool alarm_finished: false

        property date dateObject: new Date
    }


    function getTimerID()
    {
        return alarm.timerID
    }

//    function setStartDate(startDate)
//    {
//        start_date_unix_timestamp = startDate
//    }

//    function setValueTimer(value)
//    {
//        timer_value_seconds = value
//    }

    function setMessage(message_value)
    {
        message = message_value
    }

    function setTypeOfAlarm(type_of_alarm_value)
    {
        type_of_alarm = type_of_alarm_value
    }

    function runAlarm(timer_value_sec, type_value, message_value)
    {
        alarm.start_date_unix_timestamp = Math.round((new Date()).getTime() / 1000)
        alarm.stop_date_unix_timestamp = alarm.start_date_unix_timestamp + timer_value_sec
        alarm.type_of_alarm = type_value
        alarm.message = message_value

        console.log("runAlarm =============================================")
//        console.log("type_value: " + type_value)
//        console.log("message_value: " + message_value)
        console.log("timer_value_sec: " + timer_value_sec)
        console.log("alarm.start_date_unix_timestamp: " + alarm.start_date_unix_timestamp)
        console.log("alarm.stop_date_unix_timestamp: " + alarm.stop_date_unix_timestamp)
        console.log("=============================================")

        timerAlarmID.start()
    }

    function updateAlarm()
    {
        var currentDate_UnixTime = Math.round((new Date()).getTime() / 1000)
        alarm.timer_elapsed = currentDate_UnixTime - alarm.start_date_unix_timestamp
        alarm.timer_remaining = alarm.stop_date_unix_timestamp - currentDate_UnixTime

        var milliseconds = alarm.timer_elapsed * 1000
        var data = new Date(milliseconds)

        console.log("UNIX elapsed:" + alarm.timer_elapsed + " : " + alarm.timer_remaining)
        console.log("Time:" + alarm.start_date_unix_timestamp + " : " + alarm.stop_date_unix_timestamp + " : " + currentDate_UnixTime)
        console.log("Type:" + alarm.type_of_alarm + " Message: " + alarm.message)

        if(alarm.stop_date_unix_timestamp <= currentDate_UnixTime)
        {
            console.log("Alarm doszedl do zera")
            timerAlarmID.stop()
            alarm.alarm_finished = true
            signal_alarm_finished(getTimerID())
        }

//        console.log("updateAlarm =============================================")
////        console.log("timer_value_sec: " + timer_value_sec)
////        console.log("type_value: " + type_value)
////        console.log("message_value: " + message_value)
//        console.log("alarm.start_date_unix_timestamp: " + alarm.start_date_unix_timestamp)
//        console.log("alarm.stop_date_unix_timestamp: " + alarm.stop_date_unix_timestamp)
//        console.log("=============================================")
    }

    function isAlarmFinished()
    {
        return alarm.alarm_finished
    }

    Component.onCompleted:
    {
        alarm.timerID = Date.now()

        console.log("Obiekt utworzony")
//        runAlarm(4, "type", "message")
    }

    Timer
    {
        id: timerAlarmID
        interval: 1000; running: false; repeat: true
        onTriggered: updateAlarm()
    }


}
