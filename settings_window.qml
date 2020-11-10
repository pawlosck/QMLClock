import QtQuick 2.0
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
//import "./settings.qml"

Window
{
//    id: settings_window
    width: 250
    height: 250

    Settings
    {
        id: settings

        property int posX: 100
        property int posY: 100

        property int width: 100
        property int height: 100

        property string background_color: "yellow"
        property string font_color: "black"

        property var timeOnly: false
        property var border: "on"
        property var onTop: true
    }

        function setValue(key, value)
        {
            settings.setValue(key, value);
        }

        function getValue(key)
        {
//            var value_to_return
            var value_to_return = settings.value(key)
            return value_to_return
        }

//        function getTimeOnly()
//        {
//            Boolean value_to_return = settings.value("timeOnly")
//            return value_to_return
//        }

}
