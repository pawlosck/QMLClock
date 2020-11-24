import QtQuick 2.0
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15

//Item
Window
{
    ListModel
    {
        id: modelSecondsID

//        ListElement
//        {
//            idSecond: 0
//            number: 0
//        }
    }

    Component
    {
        id: delegatSecondsID
        Rectangle
        {
            id: alarmItemDelegate
            height: 20
            width: 100
            border.width: 1
            Text
            {
                text: number
            }
        }
    }

    ListView
    {
        id: listviewSecondsID

        width: 100
        height: 42


        model: modelSecondsID
        delegate: delegatSecondsID

        MouseArea
        {
            anchors.fill: parent
//            onClicked: setCurrentItem(mouseX, mouseY)
        }

        Component.onCompleted:
        {
            for (var i = 0; i <= 59; i++)
            {
                console.log("index: " + i)
                modelSecondsID.append( {"idSecond": i, "number": i} )
            }

        }
    }
}

