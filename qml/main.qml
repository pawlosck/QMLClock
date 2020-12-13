import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQml 2.15

//https://doc.qt.io/qt-5/qml-qtqml-date.html
//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply
//https://stackoverflow.com/questions/45104651/qml-dynamically-create-timers-when-event-occurs
ApplicationWindow
{
    id: mainWindow
    visible: true
    title: qsTr("QML Clock")

    property var component_alarm: Qt.createComponent("alarm.qml")
    property var component_new_alarm: Qt.createComponent("new_alarm_window.qml")
    property var component_alarm_list: Qt.createComponent("alarm_list_window.qml")
    property var component_day_time_widget: Qt.createComponent("day_time_widget.qml")

    property var new_alarm_object: component_new_alarm.createObject(mainWindow)
    property var alarm_list_object: component_alarm_list.createObject(mainWindow)
    property var alarm_day_time_widget_object: component_day_time_widget.createObject(mainWindow)


    property var list_of_alarms: []

    property string title_string: "QML Clock"

    property string czas_string: "Hour"
    property string data_string: "Date"

    property int titleLastUsedTimeOrDate: 0

    property var component: Qt.createComponent("settings_window.qml")
    property var window_settings: component.createObject(mainWindow)

    property string timeOnly: window_settings.getValue("timeOnly")
    property string border_option: window_settings.getValue("border")
    property string onTop_option: window_settings.getValue("onTop")

    property int numberOfAlarms: 0          //Liczba wszystkich alarmow
    property int numberOfFinishedAlarms: 0  //Alarmy, ktore doszly do 0

    property var blinking_background_running: false


    signal signal_alarm_started_menuitem(int value, string unit)  //Wybranie alarmu z menu Alarms

    SequentialAnimation
    {
        id: blinking_background
        loops: Animation.Infinite
        alwaysRunToEnd: true
        running: blinking_background_running
        ColorAnimation { target: mainWindow; property: "color"; from: mainWindow.color; to: "red"; duration: 300 }
        ColorAnimation { target: mainWindow; property: "color"; from: "red"; to: mainWindow.color; duration: 300 }
    }

    onSignal_alarm_started_menuitem:
    {
        var value_timer = 0
        if(unit === "s")
        {
            value_timer = value
        }
        else if(unit === "m")
        {
            value_timer = 60*value
        }
        else if(unit === "h")
        {
            value_timer = 60*60*value
        }

        var alarm_object = component_alarm.createObject()
        alarm_object.signal_alarm_finished.connect(function(){showAlarmNotification(alarm_object.getTimerID())})
        alarm_object.signal_alarm_finished.connect(function(){blinking_background.running = true})
        list_of_alarms.push(alarm_object)
        alarm_object.runAlarm(value_timer, "type", "message")
        list_of_alarms.sort((a, b) => { return a.getStoptDate() - b.getStoptDate(); });
    }

    function updateNumberOfAlarms()
    {
        numberOfAlarms = list_of_alarms.length

        var index = 0
        for (var alarm of list_of_alarms)
        {
            var result = alarm.isAlarmFinished()
            if (result === true)
            {
                index++
            }
        }
        numberOfFinishedAlarms = index

    }


    Connections
    {
        target: window_settings
        function onSignal_background_color_changed(color_value)
        {
            color = color_value
        }
    }

//    Timer
//    {
//        id: timer_alarm_ID
//        property var valueInterval: 1000
//        interval: valueInterval; running: false; repeat: false
//        onTriggered: mainWindow.title = "WWWWWWWWWWWWWW"
//    }

    Connections
    {
        target: window_settings
        function onSignal_font_color_changed(color_value)
        {
            timeLabel.color = color_value
            dateLabel.color = color_value
        }
    }

    Component.onCompleted:
    {
//        alarm_list_object.visible = true
        alarm_day_time_widget_object.visible = false

        timeOnly = window_settings.getValue("timeOnly")
        border_option = window_settings.getValue("border")
        onTop_option = window_settings.getValue("onTop")

        color = window_settings.getValue("background_color")
        timeLabel.color = window_settings.getValue("font_color")
        dateLabel.color = window_settings.getValue("font_color")

        if (timeOnly === "true")
        {
            setMenuTimeOnly()
            menu.items[2].checked = false
            timeOnly = true
        }
        else
        {
            setMenuTimeAndDate()
            menu.items[2].checked = true
            timeOnly = false
        }

        if (border_option === "on")
        {
            flags = flags & ~Qt.FramelessWindowHint
            menu.items[0].checked = true
            border_option = "on"

            width = window_settings.getValue("width")
            height = window_settings.getValue("height")

            x = window_settings.getValue("posX")
            y = window_settings.getValue("posY")
        }
        else
        {
            flags = flags | Qt.FramelessWindowHint
            menu.items[0].checked = false
            border_option = "off"

            width = window_settings.getValue("width")
            height = window_settings.getValue("height")

            x = window_settings.getValue("posX")
            y = window_settings.getValue("posY")
        }

        if (onTop_option === "true")
        {

            menu.items[1].checked = true
            flags = flags | Qt.WindowStaysOnTopHint
            onTop_option = true
        }
        else
        {
            menu.items[1].checked = false
            flags = flags & ~Qt.WindowStaysOnTopHint
            onTop_option = false
        }
    }

    function setMenuTimeOnly()
    {
        //Pokazuje tylko czas
        dateLabel.visible = false

        timeLabel.width = Qt.binding(() => mainWindow.width);
        timeLabel.height = Qt.binding(() => mainWindow.height);
    }

    function setMenuTimeAndDate()
    {
        dateLabel.visible = true

        timeLabel.width = Qt.binding(() => mainWindow.width);
        timeLabel.height = Qt.binding(() => mainWindow.height/2);
    }

    function closeApp()
    {
        window_settings.setValue("posX", x)
        window_settings.setValue("posY", y)

        window_settings.setValue("width", width)
        window_settings.setValue("height", height)

        window_settings.setValue("timeOnly", timeOnly)
        window_settings.setValue("border", border_option)
        window_settings.setValue("onTop", onTop_option)

        Qt.quit()
    }

    function showAlarmNotification(timerID)
    {
        timerAlarmNotificationTimeLabel.start()
    }

    Timer
    {
        id: timerAlarmNotificationTimeLabel
        interval: 1000; running: false; repeat: true; triggeredOnStart: true
//        onTriggered: czas_string = "ALARM"
        onTriggered: switchBeetwenAlarmNotificationAndCurrentTime()
    }

    function switchBeetwenAlarmNotificationAndCurrentTime()
    {
        var seconds = new Date().getSeconds()
        var resultOfMod = seconds % 2;
        if (resultOfMod === 0 )
        {
            timeLabel.text = Qt.binding(() => mainWindow.czas_string)
        }
        else
        {
            timeLabel.text = "ALARM"
        }


    }

    onClosing:
    {
        closeApp()
    }

    Menu
    {
        id: menu
        MenuItem
        {
            id: border
            checkable: true
            checked: true
            text: qsTr("Obramowanie")
            shortcut: "Ctrl+B"
            onTriggered:
            {
                if (border_option === "off")
                {
                    flags = flags & ~Qt.FramelessWindowHint
                    border_option = "on"
                }
                else
                {
                    flags = flags | Qt.FramelessWindowHint

                    border_option = "off"
                }
            }
        }
        MenuItem
        {
            id: onTop
            checkable: true
            checked: false
            text: "Zawsze na wierzchu"
            shortcut: "Ctrl+T"
            onTriggered:
            {
                if(onTop_option === "false" )
                {
                    flags = flags | Qt.WindowStaysOnTopHint
                    checked = true
                    onTop_option = true
                }
                else
                {
                    flags = flags & ~Qt.WindowStaysOnTopHint
                    checked = false
                    onTop_option = false
                }
            }
        }

        MenuItem
        {
            id: date
            checkable: true
            checked: false
            text: "Data"
            shortcut: "Ctrl+D"

            onTriggered:
            {
                if (timeOnly === "true")
                {
                    mainWindow.setMenuTimeAndDate()
                    checked = true
                    timeOnly = false
                }
                else
                {
                    mainWindow.setMenuTimeOnly()
                    checked = false
                    timeOnly = true
                }
            }
        }

        MenuSeparator { }

        MenuItem
        {
            id: settings
            checkable: false
            text: "Settings"
            shortcut: "Ctrl+S"
            onTriggered:
            {
                if (window_settings === null)
                {
                    // Error Handling
                    console.log("Error creating object");
                }
                else
                {
                    window_settings.show()
                }
            }
        }
        MenuItem
        {
            id: settings_background_color
            checkable: false
            text: "Background color"
            shortcut: "Ctrl+C"
            onTriggered:
            {
                window_settings.openColorDialogBackground()
            }
        }

        MenuItem
        {
            id: settings_font_color
            checkable: false
            text: "Font color"
            shortcut: "Ctrl+F"
            onTriggered:
            {
                window_settings.openColorDialogFont()
            }
        }

        MenuSeparator { }

        MenuItem
        {
            id: add_new_alarm
            text: "Add new alarm"
            onTriggered:
            {
                new_alarm_object.show()
            }
        }

        MenuItem
        {
            id: alarm_list
            text: "Show alarms"
            onTriggered:
            {
                alarm_list_object.show()
            }
        }

        Menu
        {
            id: submenuAlarms
            title: "Alarms"

            Component.onCompleted:
            {
                createMenuItemDefault()

            }

            function createMenuItemDefault()
            {
                var defaultAlarms = ["5s", "30s", "1m", "3m", "5m", "10m", "15m", "20m", "30m", "1h", "24h", "48h"];
                var numberOfAlarms = defaultAlarms.length
                var alarmsItems = [numberOfAlarms];
                var index = 0
                for (var alarm of defaultAlarms)
                {
                    var item = submenuAlarms.addItem(alarm)
                    item.id = "ID_"+alarm
                    item.triggered.connect(function(){runAlarmMenuItem(alarmsItems[__selectedIndex])})
                    alarmsItems[index] = item.text
                    index++
                }
                return alarmsItems
            }

            function runAlarmMenuItem(valueAlarm)
            {
                //START: Split value alarm for number and unit
                var tmpArray = valueAlarm.split("");
                var number = ""
                var unit = ""
                for (var value of tmpArray)
                {
                    if (isNaN(value) === false)
                    {
                        number = number.concat(value);
                    }
                    else
                    {
                        unit = unit.concat(value);
                    }
                }
                //STOP: Split value alarm for number and unit
                signal_alarm_started_menuitem(number, unit)
            }
        }

        MenuSeparator { }
        MenuItem
        {
            text: "Zamknij progrm"
            shortcut: "Ctrl+Q"
            onTriggered:
            {
                mainWindow.closeApp()
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked:
        {
            if (mouse.button == Qt.RightButton)
            {
                menu.popup()
            }
            else if (mouse.button == Qt.LeftButton)
            {
                timeLabel.text = Qt.binding(() => czas_string)
                timerAlarmNotificationTimeLabel.stop()  //Wylacz timer ktory wyswietla napis ALARM na labelce z godzina


                numberOfAlarms = list_of_alarms.length
                for (var alarm of list_of_alarms)
                {
                    var result = alarm.isAlarmFinished()
                    if (result === true && alarm.wasPlayed() === true)
                    {
                        alarm.stopPlaying()
                        blinking_background.running = false
                    }
                }
            }
            else
            {
            }
        }

        onPositionChanged:
        {
            if (mouse.buttons == Qt.LeftButton)
            {
                var windowGeometry = mapToGlobal(mouseX, mouseY)
                mainWindow.setGeometry(windowGeometry.x, windowGeometry.y , mainWindow.width, mainWindow.height)
            }
        }

        onWheel:
        {

            if (wheel.angleDelta.y > 0)
            {
                if(wheel.modifiers === Qt.ControlModifier )
                {
                    mainWindow.setWidth(mainWindow.width+1)
                }
                else
                {
                    mainWindow.setHeight(mainWindow.height+1)
                }
            }
            else if (wheel.angleDelta.y < 0)
            {
                if(wheel.modifiers === Qt.ControlModifier )
                {
                    mainWindow.setWidth(mainWindow.width-1)
                }
                else
                {
                    mainWindow.setHeight(mainWindow.height-1)
                }
            }
        }

    }
    function timeChanged()
    {
        var data = new Date;

        czas_string = data.toLocaleString(Qt.locale("pl_PL"), "h:mm");
        data_string = data.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd\ndddd");

        var title_czas_string = data.toLocaleString(Qt.locale("pl_PL"), "h:mm:ss");
        var title_data_string = data.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd");
        var title_day_name_string = data.toLocaleString(Qt.locale("pl_PL"), "dddd");

        var seconds_string = data.toLocaleString(Qt.locale("pl_PL"), "s");

        var textTimeAndDate = [title_czas_string, title_data_string, title_day_name_string];

        if (list_of_alarms.length > 0)
        {
            updateNumberOfAlarms()
            var messageAlarms = numberOfAlarms + " alarms"
            var messageFinishedAlarms = numberOfFinishedAlarms + " finished alarms"
            textTimeAndDate.push(messageAlarms)
            textTimeAndDate.push(messageFinishedAlarms)
        }

        var textTimeAndDateSize = textTimeAndDate.length

        var resultOfMod = seconds_string % 4;

        title = title_string + " -> " + textTimeAndDate[titleLastUsedTimeOrDate];

        if (resultOfMod === 0)
        {
            titleLastUsedTimeOrDate = titleLastUsedTimeOrDate + 1
            if (titleLastUsedTimeOrDate > (textTimeAndDateSize-1))
            {
                titleLastUsedTimeOrDate = 0
            }
        }
    }
    Timer
    {
        interval: 1000; running: true; repeat: true
        onTriggered: mainWindow.timeChanged()
    }

    Text
    {
        x: 0
        y: 0
        id: timeLabel
        text: qsTr(czas_string)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: mainWindow.width
        height: mainWindow.height/2
        font.pointSize: 400
        minimumPointSize: 8
        fontSizeMode: Text.Fit
    }
    Text
    {
        x: 0
        y: mainWindow.height/2
        id: dateLabel
        text: qsTr(data_string)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: mainWindow.width
        height: mainWindow.height/2
        font.pointSize: 400
        minimumPointSize: 8
        fontSizeMode: Text.Fit
    }
}
