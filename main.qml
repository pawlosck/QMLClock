import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
//https://doc.qt.io/qt-5/qml-qtqml-date.html
Window
{
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("QML Clock")

    property bool onlyTime: false

    onWidthChanged:
    {
        if (onlyTime == false)
        {
            //Pokazuje czas i date
            timeLabel.width = width
            dateLabel.width = timeLabel.width

            timeLabel.x = 0
            dateLabel.x = 0

            timeLabel.horizontalAlignment = Text.AlignHCenter
            timeLabel.verticalAlignment = Text.AlignVCenter

            dateLabel.horizontalAlignment = Text.AlignHCenter
            dateLabel.verticalAlignment = Text.AlignVCenter
        }
        else
        {
            //Pokazuje tylko czas
            timeLabel.width = width
            dateLabel.width = timeLabel.width
            timeLabel.x = 0
            dateLabel.x = 0

            timeLabel.horizontalAlignment = Text.AlignHCenter
            timeLabel.verticalAlignment = Text.AlignVCenter

            dateLabel.horizontalAlignment = Text.AlignHCenter
            dateLabel.verticalAlignment = Text.AlignVCenter
        }
    }


    onHeightChanged:
    {
        if (onlyTime == false)
        {
            //Pokazuje czas i date
            timeLabel.height = height/2
            dateLabel.height = timeLabel.height

            timeLabel.y = 0
//            dateLabel.y = y/2

            timeLabel.horizontalAlignment = Text.AlignHCenter
            timeLabel.verticalAlignment = Text.AlignVCenter

            dateLabel.horizontalAlignment = Text.AlignHCenter
            dateLabel.verticalAlignment = Text.AlignVCenter
        }
        else
        {
            //Pokazuje tylko czas
            timeLabel.height = height
//            dateLabel.height = timeLabel.height

            timeLabel.y = 0
//            dateLabel.y = y/2

            timeLabel.horizontalAlignment = Text.AlignHCenter
            timeLabel.verticalAlignment = Text.AlignVCenter

//            dateLabel.horizontalAlignment = Text.AlignHCenter
//            dateLabel.verticalAlignment = Text.AlignVCenter
        }
    }

    property string czas_string: "Godzina"
    property string data_string: "Data"

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked:
        {
            if (mouse.button == Qt.RightButton)
            {
                menu.popup()
//                console.log("Prawy")
            }
            else if (mouse.button == Qt.LeftButton)
            {
//                console.log("Lewy")
            }
            else
            {
//                console.log("Inny")
            }
        }

        Menu
        {
            id: menu
            MenuItem
            {
                checkable: true
                checked: true
                text: qsTr("Obramowanie")
                shortcut: "Ctrl+B"
                onTriggered:
                {
                    if (checked == true)
                    {
                        flags = flags & ~Qt.FramelessWindowHint
                        text = "Obramowanie"
                    }
                    else
                    {
                        flags = flags | Qt.FramelessWindowHint
                        text = "Obramowanie"
                    }
                }
            }
            MenuItem
            {
                id: naWierzchu
                checkable: true
                checked: false
                text: "Zawsze na wierzchu"
                shortcut: "Ctrl+T"
                onTriggered:
                {
                    if (checked == true)
                    {
                        flags = flags | Qt.WindowStaysOnTopHint
                        text = "Zawsze na wierzchu"
                    }
                    else
                    {
                        flags = flags & ~Qt.WindowStaysOnTopHint
                        text = "Zawsze na wierzchu"
                    }
                }
            }
            MenuSeparator { }
            MenuItem
            {
                checkable: true
                checked: true
                text: "Data"
//                shortcut: "Ctrl+D"

                onTriggered:
                {
                    if (checked == true)
                    {
                        text = "Data"

                        dateLabel.visible = true
                        timeLabel.width = mainWindow.width
                        timeLabel.height = mainWindow.height/2

//                        mainWindow.width = timeLabel.width
//                        mainWindow.height = timeLabel.height

                        onlyTime = false
                    }
                    else
                    {
                        text = "Data"

                        dateLabel.visible = false
                        timeLabel.width = mainWindow.width
                        timeLabel.height = mainWindow.height

//                        mainWindow.width = timeLabel.width
//                        mainWindow.height = timeLabel.height

                        onlyTime = true
                    }
                }
            }
            MenuSeparator { }
            MenuItem
            {
                text: "Zamknij progrm"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
    }
    function timeChanged()
    {
        var data = new Date;

        czas_string = data.toLocaleString(Qt.locale("pl_PL"), "h:mm:ss");
        data_string = data.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd\ndddd");
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
//        anchors.fill: parent
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
//        anchors.fill: parent
    }
}
