import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4

//https://doc.qt.io/qt-5/qml-qtqml-date.html
ApplicationWindow
{
    id: mainWindow
    visible: true
    title: qsTr("QML Clock")

    property string title_string: "QML Clock"

    property string czas_string: "Hour"
    property string data_string: "Date"

    property int titleLastUsedTimeOrDate: 0

    property var component: Qt.createComponent("settings_window.qml")
    property var window_settings: component.createObject(mainWindow)

    property string timeOnly: window_settings.getValue("timeOnly")
    property string border_option: window_settings.getValue("border")
    property string onTop_option: window_settings.getValue("onTop")

    Connections
    {
        target: window_settings
        function onSignal_background_color_changed(color_value)
        {
            color = color_value
            console.log("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS")
        }
    }

    Component.onCompleted:
    {
        //aplikacja uruchomiona
        console.log("Aplikacja uruchomiona")

        timeOnly = window_settings.getValue("timeOnly")
        border_option = window_settings.getValue("border")
        onTop_option = window_settings.getValue("onTop")

        color = window_settings.getValue("background_color")
        timeLabel.color = window_settings.getValue("font_color")
        dateLabel.color = window_settings.getValue("font_color")

        console.log("timeOnly: " + timeOnly)

        if (timeOnly === "true")
        {
            console.log("timeOnly true: " + timeOnly)
            setMenuTimeOnly()
            menu.items[3].checked = false
            timeOnly = true
        }
        else
        {
            console.log("timeOnly false: " + timeOnly)
            setMenuTimeAndDate()
            menu.items[3].checked = true
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
        console.log("Zamykam aplikacje")
        window_settings.setValue("posX", x)
        window_settings.setValue("posY", y)

        window_settings.setValue("width", width)
        window_settings.setValue("height", height)

        window_settings.setValue("timeOnly", timeOnly)
        window_settings.setValue("border", border_option)
        window_settings.setValue("onTop", onTop_option)

        console.log("timeOnly: " + timeOnly)

        Qt.quit()
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
        MenuSeparator { }
        MenuItem
        {
            id: date
            checkable: true
            checked: false
            text: "Data"
            shortcut: "Ctrl+D"

            onTriggered:
            {
                console.log("timeOnly: " + timeOnly)
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
            }
            else
            {
            }
        }

        onPositionChanged:
        {
            if (mouse.buttons == Qt.LeftButton)
            {
                console.log("Mouse: X:Y: " + mouseX + ":" + mouseY)
                console.log("Window: X:Y: " + mainWindow.x + ":" + mainWindow.y)
                console.log(mapToGlobal(mouseX, mouseY))

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
        var resultOfMod = seconds_string % 4;

        title = title_string + " -> " + textTimeAndDate[titleLastUsedTimeOrDate];

        if (resultOfMod === 0)
        {
            titleLastUsedTimeOrDate = titleLastUsedTimeOrDate + 1
            if (titleLastUsedTimeOrDate > 2)
            {
                titleLastUsedTimeOrDate = 0
            }
        }

        console.log("timeOnly: " + timeOnly)
        console.log("border_option: " + border_option)
        console.log("onTop_option: " + onTop_option)
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
