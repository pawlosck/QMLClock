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

//    A ListView displays data from models created from built-in QML types like ListModel
//A ListView has a model, which defines the data to be displayed, and a delegate, which defines how the data should be displayed.


    ListModel
    {
        id: modelID

        ListElement {
            name: "Bill Smith"
            number: "555 3264"
        }
        ListElement {
            name: "John Brown"
            number: "555 8426"
        }
        ListElement {
            name: "Sam Wise"
            number: "555 0473"
        }
    }
    Component
    {
        id: delegatID
        Text
        {
            id: name
            text: "Name: " + model.name + " : Number: " + model.number
        }
    }
    ListView
    {
        id: listviewID
        anchors.fill: parent
        width: 180; height: 200
        model: modelID
        delegate: delegatID
    }

    Component.onCompleted:
    {
        modelID.append( { "name": "WWWWWWWWWWW", "number": "123456789" } )
    }
}

