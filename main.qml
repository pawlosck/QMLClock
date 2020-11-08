import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4

//https://doc.qt.io/qt-5/qml-qtqml-date.html
Window
{
    id: mainWindow
    width: 100
    height: 75
    visible: true
    title: qsTr("QML Clock")

    property bool onlyTime: false

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

                        timeLabel.width = Qt.binding(() => mainWindow.width);
                        timeLabel.height = Qt.binding(() => mainWindow.height/2);

                        onlyTime = false
                    }
                    else
                    {
                        text = "Data"

                        dateLabel.visible = false
                        timeLabel.width = Qt.binding(() => mainWindow.width);
                        timeLabel.height = Qt.binding(() => mainWindow.height);

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
