import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Window {
    id: dialog

    // both title and message text properties are available to be set from "outside"
    property string title
    property string textMain

    title: dialog.title
    modality: Qt.WindowModal

    width: 400
    minimumWidth: width
    maximumWidth: width
    height: 160
    minimumHeight: height
    maximumHeight: height

    Rectangle {
        anchors.fill: parent
        //color: Styles.regionBackground
        //border.color: Styles.mainBackground
        border.width: 3

        ColumnLayout {
            anchors.fill: parent

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 10
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: dialog.textMain
                font.family: "Courier New"
                font.pixelSize: 16
                wrapMode: Text.WordWrap
            }

            Button {
                id: btn
                Layout.leftMargin: 3
                Layout.rightMargin: 3
                Layout.fillWidth: true
                text: "Close"
                onClicked: { dialog.close(); }
            }
        }
    }
}
