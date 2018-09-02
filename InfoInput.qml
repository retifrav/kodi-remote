import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

// a background for it, so the field clearly stands out
Rectangle {
    // take all the width avaulable
    Layout.fillWidth: true
    // leave anough room for symbols in the line
    Layout.preferredHeight: ti.contentHeight * 1.5

    // expose the text property
    property alias text: ti.text
    // expose also the placeholder property
    property alias placeholder: placeholder.text
    // in case of a password field
    property alias echoMode: ti.echoMode

    TextInput {
        id: ti
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        horizontalAlignment: Text.AlignRight
        // make paddings so you inputs don't look like your average Linux application GUI
        leftPadding: 5
        rightPadding: leftPadding
        clip: true

        Text {
            id: placeholder
            anchors.fill: parent
            horizontalAlignment: parent.horizontalAlignment
            leftPadding: parent.leftPadding
            rightPadding: leftPadding
            clip: parent.clip
            font.italic: true
            color: "grey"
            // hide placeholder when any text in entered
            visible: !ti.text
        }
    }
}
