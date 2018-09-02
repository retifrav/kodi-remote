import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

Button {
    property alias source: img.source

    Layout.fillWidth: true
    Layout.fillHeight: true

    // gets bigger a bit when hovered
    scale: hovered ? 1.05 : 1

    background: Rectangle {
        color: "transparent"
    }

    // here goes an SVG image
    Image {
        id: img
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    // also, when hovered, the button glows a bit
    Glow {
        id: glow
        anchors.fill: img
        radius: 20
        samples: 30
        color: "#094354"
        source: img
        visible: parent.hovered
    }
}
