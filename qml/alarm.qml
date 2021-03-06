import QtQuick 2.0
import QtQml 2.15
import QtMultimedia 5.15

Item
{
    signal signal_alarm_finished(int timerID_value)

    Audio {
        id: player_alarm
        source: "qrc:/audio/alarm.wav" // Dziala, ale strasznie dlugo sie buduje aplikacja
//        source: "https://upload.wikimedia.org/wikipedia/commons/b/bb/Test_ogg_mp3_48kbps.wav"
        volume: 1.0

        property var wasPlayed: false
    }

    QtObject
    {
        //W obiekcie QObject nie moze byc wiecej obiektow, bo inaczej bedzie wywlac blad, ze component nie zaladowany
        id: alarm

        property var timerID: 0 //Zmienna do ktorej bedzie przypisywana wartosc na podstawie ktore bedzie mozna znalezc obiekt

        property int start_date_unix_timestamp: 0 //Data dodania alarmu uzywajac unix time. Od tego czasu liczy sie alarm
        property int stop_date_unix_timestamp: 0 //Data uruchomienia alarmu uzywajac unix time.
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

    function getStartDate()
    {
        return alarm.start_date_unix_timestamp
    }

    function getStoptDate()
    {
        return alarm.stop_date_unix_timestamp
    }

    function getMessage()
    {
        return alarm.message
    }

    function getTypeAlarm()
    {
        return alarm.type_of_alarm
    }

    function getElapsedTime()
    {
        return alarm.timer_elapsed
    }

    function getRemainingTime()
    {
        return alarm.timer_remaining
    }

    function isAlarmFinished()
    {
        return alarm.alarm_finished
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
        alarm.message = message_value
    }

    function setTypeOfAlarm(type_of_alarm_value)
    {
        alarm.type_of_alarm = type_of_alarm_value
    }

    function runAlarm(timer_value_sec, type_value, message_value)
    {
        alarm.start_date_unix_timestamp = Math.round((new Date()).getTime() / 1000)
        alarm.stop_date_unix_timestamp = alarm.start_date_unix_timestamp + timer_value_sec
        alarm.type_of_alarm = type_value
        alarm.message = message_value

        timerAlarmID.start()
    }

    function updateAlarm()
    {
        var currentDate_UnixTime = Math.round((new Date()).getTime() / 1000)
        alarm.timer_elapsed = currentDate_UnixTime - alarm.start_date_unix_timestamp
        alarm.timer_remaining = alarm.stop_date_unix_timestamp - currentDate_UnixTime

        var milliseconds = alarm.timer_elapsed * 1000
        var data = new Date(milliseconds)

        if(alarm.stop_date_unix_timestamp <= currentDate_UnixTime && alarm.alarm_finished !== true)
        {
            //Alarm doszedl do zera
//            timerAlarmID.stop()
            alarm.alarm_finished = true
            signal_alarm_finished(getTimerID())

            player_alarm.play()
            player_alarm.wasPlayed = true
        }
    }

    function convertSecondsIntoDaysAndTime(seconds)
    {
        seconds = Number(seconds);

        var negativeValue = false
        if (seconds < 0)
        {
            negativeValue = true
            seconds = Math.abs(seconds)
        }

        var d = Math.floor(seconds / 86400).toString();
        var h = Math.floor(seconds / 3600 % 24).toString();
        var m = Math.floor(seconds % 3600 / 60).toString();
        var s = Math.floor(seconds % 3600 % 60).toString();

        var outputFormat = d + " day(s)" + " " + h.padStart(2, '0') + ":" + m.padStart(2, '0') + ":" + s.padStart(2, '0')
        d = Number(d)
        if( d === 0)
        {
            outputFormat = h.padStart(2, '0') + ":" + m.padStart(2, '0') + ":" + s.padStart(2, '0')
        }

        if (negativeValue === true)
        {
            outputFormat = "-" + outputFormat
        }

        return outputFormat
    }

    function stopPlaying()
    {
        player_alarm.stop()
    }

    function wasPlayed()
    {
        return player_alarm.wasPlayed
    }




    Component.onCompleted:
    {
        alarm.timerID = Date.now()
    }

    Timer
    {
        id: timerAlarmID
        interval: 1000; running: false; repeat: true; triggeredOnStart: true
        onTriggered: updateAlarm()
    }
}
