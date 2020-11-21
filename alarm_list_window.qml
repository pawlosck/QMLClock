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

    ListModel
    {
        id: modelID

        ListElement
        {
            idAlarm: 0
            remainingTime: 0
            typeAlarm: ""
            messageAlarm: ""
        }
    }
    Component
    {
        id: delegatID
        Rectangle
        {
            id: alarmItemDelegate
            width: listviewID.width
            height: 45
            border.width: 1
            radius: 5

            Text
            {
                id: remainingAl
                x: 5
                y: 0
                text: "Remaining: " + model.remainingTime
            }
            Text
            {
                id: typeAl
                x: 5
                y: remainingAl.height
                text: "Type: " + model.typeAlarm
            }
            Text
            {
                id: messageAl
                x: 5
                y: remainingAl.height*2
                text: "message: " + model.messageAlarm
            }
        }
    }
    ListView
    {
        spacing: 5
        clip: true

        id: listviewID
//        anchors.fill: parent
        width: parent.width
        height: parent.height/2
        model: modelID
        delegate: delegatID
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
//                console.log("Sortowanie:" + alarm.getRemainingTime())
                modelID.append( { "remainingTime": alarm.getRemainingTime(), "typeAlarm": alarm.getTypeAlarm(), "messageAlarm": alarm.getMessage()} )
            }
        }
        else
        {
            var index = 0
            for (var alarm of list_of_alarms)
            {
                console.log("Sortowanie:" + alarm.getRemainingTime())
                modelID.setProperty(index, "remainingTime", alarm.getRemainingTime() )
                modelID.setProperty(index, "typeAlarm", alarm.getTypeAlarm() )
                modelID.setProperty(index, "messageAlarm", alarm.getMessage() )
                index++
            }
        }
    }
}

