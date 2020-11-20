import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQml 2.15
//import QtQuick 2.0

Window
{
    id: alarmListWindow

    width: 400
    height: 400

    ListModel
    {
        id: modelID

//        ListElement
//        {
//            idAlarm: ""
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
//            x: 0
//            y: 0
            width: 200
            height: 50
            border.width: 1
            radius: 10

            Text
            {
                id: idAl
                y: 0
                text: "ID: " + model.idAlarm
            }
            Text
            {
                id: messAl
                y: idAl.height
                text: "message: " + model.messageAlarm
            }
        }
    }
    ListView
    {
        spacing: 5
        clip: true

        id: listviewID
        anchors.fill: parent
        width: 400; height: 400
        model: modelID
        delegate: delegatID
    }
    Component.onCompleted:
    {
//        modelID.append( { "idAlarm": "12345678", "typeAlarm": "TV", "messageAlarm": "Jakas wiadomosc" } )
    }
    Timer
    {
        id: timerUpdateListView
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: updateListView()
    }
    function updateListView()
    {
        modelID.append( { "idAlarm": "alarm.timer_remaining", "typeAlarm": "TT", "messageAlarm": "Jakas wiadomosc" } )
    }
}

