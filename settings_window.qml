//import QtQuick 2.0
import QtQuick.Window 2.15
import Qt.labs.settings 1.0
//import QtQuick.Controls 1.4
//import QtQuick.Layouts 1.15
//import QtQml.Models 2.15
//import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.11
import QtQuick.Controls.Styles 1.4

Window
{
    width: 600
    height: 250

    signal signal_background_color_changed(string color)
    signal signal_font_color_changed(string color)

    onSignal_background_color_changed:
    {
        settings.setValue("background_color", color)
        settings.background_color = color
        buttonChangeBackgroundColor.background.color = color
        buttonChangeFontColor.background.color = color
    }

    onSignal_font_color_changed:
    {
        settings.setValue("font_color", color)
        settings.font_color = color
        buttonChangeBackgroundColor.palette.buttonText = color
        buttonChangeFontColor.palette.buttonText = color
    }

    GridLayout
    {
        columns: 2
        id: layoutButtons
        x: 0
        y: 0
        width: parent.width
//        height: parent.height
//        anchors.bottom: layoutMix.top


        Button
        {
            id: buttonChangeBackgroundColor
            text: "Background color"
            palette.buttonText: getValue("font_color")

            Layout.preferredWidth: 150
            implicitWidth: 300
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 5

            background: Rectangle
            {
                color: getValue("background_color")
                border.width: 1
            }
            onClicked:
            {
                openColorDialogBackground()
            }
        }

        Button
        {

            id: buttonChangeFontColor
            text: "Font color"
            palette.buttonText: getValue("font_color")
            Layout.preferredWidth: 150
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 5

            background: Rectangle
            {
                color: getValue("background_color")
                border.width: 1
            }

            onClicked:
            {
                openColorDialogFont()
            }
        }
    }

    ColorDialog
    {
        id: colorDialogBackground
        title: "Please choose a background color"
        onAccepted:
        {
//            setValue("background_color", colorDialogBackground.color)
            signal_background_color_changed(colorDialogBackground.color)
        }
    }

    ColorDialog
    {
        id: colorDialogFont
        title: "Please choose a font color"
        onAccepted:
        {
//            setValue("font_color", colorDialogFont.color)
            signal_font_color_changed(colorDialogFont.color)
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
