import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQml 2.15

import "external" as CK

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
            function getTimerID()
            {
                return idAlarm
            }
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
            ColumnLayout
            {
                spacing: 2
                Layout.alignment: Qt.AlignTop
                CK.MultiInfiniteListview
                {
                    id: counter_set_time

                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.minimumWidth: 100
                    Layout.maximumHeight: parent.height/2
                    Layout.maximumWidth: 300

                    width: 100
                    height: 42
                    visible: true

                    Component.onCompleted:
                    {
                        setPosition(0, 0)
                        setNumberOfVisibleElements(1)
                        setInternalBorderSize(0, 0)
                        setBorderSize(1)
                        setGradientColor(0, "transparent")

                        setValues(1, 0, 59, 2, '0')
                        setValues(2, 0, 59, 2, '0')
                        setValues(3, 0, 59, 2, '0')
                    }
                }

                Rectangle
                {

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 100
//                    Layout.maximumHeight: parent.height/2
                    Layout.maximumWidth: 300
                    Layout.minimumHeight: parent.height/2


                    border.width: 1


                    ListView
                    {
                        id: listviewID
                        spacing: 5
                        clip: true
                        anchors.fill: parent

                        Layout.fillHeight: true
    //                    width: 200

                        model: modelID
                        delegate: delegatID

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked: setCurrentItem(mouseX, mouseY)
                        }

                        onCurrentIndexChanged:
                        {
                            if(currentIndex === -1)
                            {
                                counter_set_time.visible = true
                                remainingInfoLabel.visible = false
                                addNewAlarmButton.visible = true
                            }
                            else
                            {
                                counter_set_time.visible = false
                                remainingInfoLabel.visible = true
                                addNewAlarmButton.visible = false
                            }
                        }
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
                        TextInput
                        {
                            id: remainingInfoLabel
                            text: remainingInfoString
                        }
                        Button
                        {
                            id: addNewAlarmButton
                            text: "New Alarm"
                            visible: false
                            height: 20
                            width: parent.width
                            clip: true
                        }
                    }
                    Rectangle
                    {
                        id: typeInfoBorder
                        border.width: 1
//                        color: "green"
                        Layout.fillWidth: true
                        Layout.minimumWidth: 40
                        height: 20
                        TextInput
                        {
                            id: typeInfoLabel
                            width: parent.width
                            height: parent.height
                            clip: true
                            text: typeInfoString

                            onTextChanged:
                            {
                                if (listviewID.currentIndex != -1)
                                {
                                    var index = 0
                                    for (var alarm of list_of_alarms)
                                    {
                                        if (alarm.getTimerID() === listviewID.currentItem.getTimerID())
                                        {
                                            alarm.setTypeOfAlarm(text)
                                        }
                                    }
                                }
                            }
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
                        TextEdit
                        {
                            id: messageInfoLabel
                            width: parent.width
                            height: parent.height
                            wrapMode: TextEdit.Wrap
                            text: messageInfoString

                            onTextChanged:
                            {
                                if (listviewID.currentIndex != -1)
                                {
                                    var index = 0
                                    for (var alarm of list_of_alarms)
                                    {
                                        if (alarm.getTimerID() === listviewID.currentItem.getTimerID())
                                        {
                                            alarm.setMessage(text)
                                        }
                                    }
                                }
                            }
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

                    onClicked:
                    {
                        if (modelID.count > 0 && listviewID.currentIndex != -1)
                        {
                            var index = 0
                            for (var alarm of list_of_alarms)
                            {
                                if (alarm.getTimerID() === listviewID.currentItem.getTimerID())
                                {
                                    list_of_alarms.splice(index,1)
                                    modelID.remove(listviewID.currentIndex)
                                }
                                index++
                            }
                        }
                    }
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
                modelID.append( {"idAlarm":alarm.getTimerID(), "remainingTime": alarm.convertSecondsIntoDaysAndTime(alarm.getRemainingTime()), "typeAlarm": alarm.getTypeAlarm(), "messageAlarm": alarm.getMessage()} )
            }
        }
        else
        {
            var index = 0

            if (modelID.count === 0)
            {
                remainingInfoString = ""
                typeInfoString = ""
                messageInfoString = ""
            }

            for (var alarm of list_of_alarms)
            {
                if (listviewID.currentIndex === index)
                {
                    remainingInfoString = alarm.convertSecondsIntoDaysAndTime(alarm.getRemainingTime())
                    typeInfoString = alarm.getTypeAlarm()
                    messageInfoString = alarm.getMessage()
                }
                else if (listviewID.currentIndex === -1)
                {
                    remainingInfoString = ""
                    typeInfoString = ""
                    messageInfoString = ""
                }

                modelID.setProperty(index, "remainingTime", alarm.convertSecondsIntoDaysAndTime(alarm.getRemainingTime()) )
                modelID.setProperty(index, "typeAlarm", alarm.getTypeAlarm())
                modelID.setProperty(index, "messageAlarm", alarm.getMessage() )
                index++
            }
        }
    }

    function setCurrentItem(x, y)
    {
        var index = listviewID.indexAt(x, y)
        listviewID.currentIndex = index
    }

    Component.onCompleted:
    {
        counter_set_time.visible = true
        remainingInfoLabel.visible = false
        addNewAlarmButton.visible = true
    }
}

