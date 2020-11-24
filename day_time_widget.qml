import QtQuick 2.0
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15
import QtQml 2.12

//Item
Window
{
    width: 100
    height: 60
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
            width: 30
//            border.width: 1
//            color: ListView.isCurrentItem ? "grey" : "transparent"
            Text
            {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: 20
                width: 30
                text: number
            }
        }
    }

    ListView
    {
        id: listviewSecondsID

//        anchors.fill: parent

        width: 30
        height: 60

        preferredHighlightBegin: 20
        preferredHighlightEnd: 40
        highlightRangeMode: ListView.StrictlyEnforceRange

        highlightMoveDuration: 1000
        highlightMoveVelocity: -1

        model: modelSecondsID
        delegate: delegatSecondsID

//        displayMarginBeginning: 40
//        displayMarginEnd: 40

//        cacheBuffer: 20

//        Rectangle
//        {
//            anchors.fill: parent
//            border.width: 2
//            border.color: "red"
//            color: "transparent"
//        }

        Rectangle
        {
//            anchors.fill: parent
            x: 0
            y: 20
            width: 30
            height: 20
            color: "transparent"
            border.width: 1
        }

        MouseArea
        {
            anchors.fill: parent
//            onClicked: setCurrentItem(mouseX, mouseY)

            onWheel:
            {
                if (wheel.angleDelta.y < 0)
                {
                    listviewSecondsID.incrementCurrentIndex()
                }
                else
                {
                    listviewSecondsID.decrementCurrentIndex()
                }
            }
        }

        Component.onCompleted:
        {
            for (var i = 0; i <= 59; i++)
            {
                console.log("index: " + i)
                modelSecondsID.append( {"idSecond": i, "number": i} )
            }
            positionViewAtIndex(29, ListView.Beginning)

        }
    }
}

