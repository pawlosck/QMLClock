import QtQuick 2.0
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15

Window
{
    id: newAlarmID
    width: 300
    height: 200

    GridLayout
    {
        columns: 2

        Text {
            id: name
            text: qsTr("text")
        }

        TextField
        {

            id:textEdit
            text : "00:00:00"
            inputMask: "99:99:99"
            inputMethodHints: Qt.ImhDigitsOnly
//            validator: RegExpValidator { regExp: /^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):[0-5][0-9]$ / }
            validator: RegExpValidator { regExp: /^([0-2][0-3]):([0-5][0-9]):([0-5][0-9])$/ }
        }

    }

    Component.onCompleted:
    {

    }
}
