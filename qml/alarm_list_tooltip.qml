import QtQuick 2.0
import QtQuick.Window 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window
{
    id: tooltip_window
    x: 0
    y: 0
    width: 600
    height: 200

    ColumnLayout
    {
        id: main_layout
        x: 0
        y: 0
        spacing: 2
        width: tooltip_window.width

        height: tooltip_window.height
        RowLayout
        {
            id: header_layout
            width: tooltip_window.width
            height: 40
            Rectangle
            {
                id: rectangle_checkbox_alarm_finished
                x: 0
                y: 0
                border.width: 1
                border.color: "red"
                color: "red"
                width: header_layout.width/2
                height: header_layout.height
                Layout.fillWidth: true
            }
            Rectangle
            {
                id: rectangle_checkbox_alarm_not_finished
                x: rectangle_checkbox_alarm_finished.width
                y: 0
                border.width: 1
                border.color: "red"
                color: "yellow"
                width: header_layout.width/2
                height: header_layout.height
                Layout.fillWidth: true
            }
        }

        Rectangle
        {
            id: rectangle_listview
            x: 0
            y: header_layout.height
            width: tooltip_window.width
            height: tooltip_window.height - header_layout.height
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "green"

            ListView
            {
                id: listview_alarms
                width: tooltip_window.width
                height: 100
                Layout.fillHeight: true
                Layout.fillWidth: true

                model: modelID
                delegate: delegatID

                Component
                {
                    id: delegatID
                    Rectangle
                    {
                        id: rectangle_delegate
                        width: tooltip_window.width
                        height: 20
                        border.width: 1

//                        color: ListView.isCurrentItem ? "grey" : "black"
                        Text
                        {
                            id: remainingAl
                            x: 0
                            y: 0
                            width: tooltip_window.width
                            height: rectangle_delegate.height
//                            anchors.top: parent.top
                            text: "Remaining: " + model.idAlarm
                            font.pixelSize: (parent.height/2)-2
                        }
                    }
                }
                ListModel
                {
                    id: modelID

                    ListElement
                    {
                        idAlarm: ""
                        typeAlarm: ""
                        messageAlarm: ""
                    }
                    ListElement
                    {
                        idAlarm: "2"
                        typeAlarm: "2"
                        messageAlarm: "2"
                    }
                    ListElement
                    {
                        idAlarm: "3"
                        typeAlarm: "3"
                        messageAlarm: "3"
                    }
                }

            }
        }
    }

}
