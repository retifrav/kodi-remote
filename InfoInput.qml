import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: ti.contentHeight * 1.5

    property alias text: ti.text
    property alias echoMode: ti.echoMode
    property alias placeholder: placeholder.text

    TextInput {
        id: ti
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        horizontalAlignment: Text.AlignRight
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
            visible: !ti.text
        }
    }
}
