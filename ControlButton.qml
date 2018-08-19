import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

Button {
    property alias source: img.source

    Layout.fillWidth: true
    Layout.fillHeight: true

    scale: hovered ? 1.05 : 1

    background: Rectangle {
        color: "transparent"
    }
    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
    Glow {
        id: glow
        anchors.fill: img
        radius: 20
        samples: 30
        color: "#094354"
        source: img
        visible: false
    }
    onHoveredChanged: {
        hovered ? glow.visible = true : glow.visible = false;
    }
}
