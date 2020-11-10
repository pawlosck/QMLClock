//import QtQuick 2.0
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
//import QtQuick.Controls 1.4
//import QtQuick.Layouts 1.15
//import QtQml.Models 2.15
//import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
//import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0

Window
{
    width: 250
    height: 250

    ColorDialog
    {
        id: colorDialogBackground
        title: "Please choose a background color"
        onAccepted:
        {
            setValue("background_color", colorDialogBackground.color)
        }
    }

    ColorDialog
    {
        id: colorDialogFont
        title: "Please choose a font color"
        onAccepted:
        {
            setValue("font_color", colorDialogFont.color)
        }
    }

    function openColorDialogBackground()
    {
        colorDialogBackground.visible = true
    }

    function openColorDialogFont()
    {
        colorDialogFont.visible = true
    }


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
            var value_to_return = settings.value(key)
            return value_to_return
        }
}
