import QtQuick 2.0
import QtQml 2.15

Item
{
    QtObject
    {
        //W obiekcie QObject nie moze byc wiecej obiektow, bo inaczej bedzie wywlac blad, ze component nie zaladowany
        id: alarm
        property int start_date_unix_timestamp: 0 //Data dodania alarmu uzywajac unix time. Od tego czasu liczy sie alarm
        property int stop_date_unix_timestamp: 0 //Data uruchomienia alarmu uzywajac unix time.
        property int timer_value_seconds: 0 // za ile ma sie wlaczyc alarm w sekundach
        property string message: "Default message"
        property string type_of_alarm: "Default" //rodzaj alarmu. Np alarm informujacy o telefonie, programie w tv, czy tez w radio

        property int timer_elapsed: 0 //Ile uplynelo sekund od uruchomienia alarmu
        property int timer_remaining: 0 //Ile czasu zostalo do uruchomienia alarmu

        property date dateObject: new Date

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
            start_date_unix_timestamp = Math.round((new Date()).getTime() / 1000);
            stop_date_unix_timestamp = start_date_unix_timestamp + timer_value_sec
            type_of_alarm = type_value
            message = message_value

            timerAlarmID.start()
        }

        function updateAlarm()
        {
            var currentDate_UnixTime = Math.round((new Date()).getTime() / 1000)
            timer_elapsed = currentDate_UnixTime - start_date_unix_timestamp
            timer_remaining = stop_date_unix_timestamp - currentDate_UnixTime

            var milliseconds = timer_elapsed * 1000
            var data = new Date(milliseconds)

            console.log("UNIX elapsed:" + timer_elapsed + " : " + timer_remaining)
            console.log("Time:" + start_date_unix_timestamp + " : " + stop_date_unix_timestamp + " : " + currentDate_UnixTime)
            console.log("Type:" + type_of_alarm + " Message: " + message)
        }

        Component.onCompleted:
        {
            console.log("Obiekt utworzony")
            runAlarm(10, "type", "message")
        }
    }

    Timer
    {
        id: timerAlarmID
        interval: 1000; running: false; repeat: true
        onTriggered: alarm.updateAlarm()
    }


}
