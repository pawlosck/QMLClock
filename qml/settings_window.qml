import QtQuick.Window 2.15
import Qt.labs.settings 1.0
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.11
import QtQuick.Controls.Styles 1.4
import QtQml 2.12

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

    RowLayout
    {
        anchors.top: layoutButtons.bottom
        id: layoutMix
        Text
        {
            id: labelLocale
            text: qsTr("Choose language: ")

            Layout.preferredWidth: 150
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: 5
        }
        ComboBox
        {
            id: comboboxLocale
//            Layout.preferredWidth: 150
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: 5
//            Layout.minimumHeight: labelLocale.
//            Layout.maximumHeight: 10
            Layout.preferredHeight: labelLocale.height+5
            Layout.preferredWidth: labelLocale.width

            editable: false

            background: Rectangle
            {
//                radius: 20
                color: "grey"
            }
            model: [ "Banana", "Apple", "Coconut" ]
        }

        CheckBox
        {
            id: checkboxChooseLanguageManually
            checked: false
            text: "Choose language manually"

//            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: 5

            Layout.preferredHeight: labelLocale.height+5
            Layout.preferredWidth: labelLocale.width

            indicator: Rectangle
            {
                implicitWidth: 20
                implicitHeight: 20
                x: checkboxChooseLanguageManually.leftPadding
                y: parent.height / 2 - height / 2
                border.color: checkboxChooseLanguageManually.down ? "#dark" : "#grey"

                Rectangle
                {
                    width: 20
                    height: 20
                    x: 0
                    y: 0
                    color: checkboxChooseLanguageManually.down ? "#dark" : "#grey"
                    visible: checkboxChooseLanguageManually.checked
                }
            }
            onClicked:
            {
                if (checkboxChooseLanguageManually.checked === true)
                {
                    comboboxLocale.editable = true
                }
                else
                {
                    comboboxLocale.editable = false
                }
            }

        }
    }

    ColorDialog
    {
        id: colorDialogBackground
        title: "Please choose a background color"
        onAccepted:
        {
            signal_background_color_changed(colorDialogBackground.color)
        }
    }

    ColorDialog
    {
        id: colorDialogFont
        title: "Please choose a font color"
        onAccepted:
        {
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
