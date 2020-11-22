import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQml 2.15
//import QtQuick 2.0

//Sortowanie
//https://www.w3schools.com/jsref/jsref_sort.asp
//https://www.javascripttutorial.net/array/javascript-sort-an-array-of-objects/

Window
{
    id: alarmListWindow

    width: 400
    height: 400

    property string remainingInfoString: "Remaining: " + "model.remainingTime"
    property string typeInfoString: "Type: " + "model.remainingTime"
    property string messageInfoString: "Message: " + "model.remainingTime"

    ListModel
    {
        id: modelID

//        ListElement
//        {
//            idAlarm: 0
//            remainingTime: 0
//            typeAlarm: ""
//            messageAlarm: ""
//        }
    }
    Component
    {
        id: delegatID
        Rectangle
        {
            id: alarmItemDelegate
            width: listviewID.width
            height: 35
            border.width: 1
//            radius: 5

            color: ListView.isCurrentItem ? "grey" : "transparent"
            Text
            {
                id: remainingAl
                x: 5
                anchors.top: parent.top
                text: "Remaining: " + model.remainingTime
                color: alarmItemDelegate.ListView.isCurrentItem ? "yellow" : "black"
                font.pixelSize: (parent.height/2)-2
            }
            Text
            {
                id: typeAl
                x: 5
//                anchors.verticalCenter: parent.verticalCenter
                anchors.bottom: parent.bottom
                text: "Type: " + model.typeAlarm
                color: alarmItemDelegate.ListView.isCurrentItem ? "yellow" : "black"
                font.pixelSize: (parent.height/2)-2
            }
//            Text
//            {
//                id: messageAl
//                x: 5
//                anchors.bottom: parent.bottom
//                text: "message: " + model.messageAlarm
//                color: alarmItemDelegate.ListView.isCurrentItem ? "yellow" : "black"
//            }
        }
    }
    ColumnLayout
    {
        anchors.fill: parent
        Text
        {
            id: headerAlarmListLabel
            width: parent.width
            height: 70
            text: qsTr("Lista alarmow")
        }

        RowLayout
        {
            Rectangle
            {
                border.width: 1

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 50
                Layout.maximumWidth: parent.width/2
                Layout.minimumHeight: parent.height/2
                ListView
                {
                    id: listviewID
                    spacing: 5
                    clip: true
                    anchors.fill: parent

//                    Layout.fillHeight: true
//                    width: 200

                    model: modelID
                    delegate: delegatID

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: setCurrentItem(mouseX, mouseY)
                    }
                }
            }
            ColumnLayout
            {
                ColumnLayout
                {
                    spacing: 2
                    Rectangle
                    {
                        border.width: 1
//                        color: "green"
                        Layout.fillWidth: true
//                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.minimumHeight: 20
                        Text
                        {
                            id: remainingInfoLabel
                            text: remainingInfoString
                        }
                    }
                    Rectangle
                    {
                        border.width: 1
//                        color: "green"
                        Layout.fillWidth: true
//                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.minimumHeight: 20
                        Text
                        {
                            id: typeInfoLabel
                            text: typeInfoString
                        }
                    }
                    Rectangle
                    {
                        border.width: 1
//                        color: "green"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 20
                        Layout.minimumHeight: 20
                        Text
                        {
                            id: messageInfoLabel
                            text: messageInfoString
                        }
                    }
                }
                Button
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 20
                    Layout.minimumHeight: 20
                    Layout.maximumHeight: 40
                    text: "Delete alarm"
                }
            }
        }
    }

    Timer
    {
        id: timerUpdateListView
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: updateListView()
    }
    function updateListView()
    {

        if (list_of_alarms.length !== modelID.count)
        {
            modelID.clear()
            for (var alarm of list_of_alarms)
            {
                modelID.append( { "remainingTime": alarm.getRemainingTime(), "typeAlarm": alarm.getTypeAlarm(), "messageAlarm": alarm.getMessage()} )
            }
        }
        else
        {
            var index = 0
            for (var alarm of list_of_alarms)
            {
                modelID.setProperty(index, "remainingTime", alarm.getRemainingTime() )
                index++
            }
        }
    }

    function setCurrentItem(x, y)
    {
        var index = listviewID.indexAt(x, y)
        listviewID.currentIndex = index
    }
}

