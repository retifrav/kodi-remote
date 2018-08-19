import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import Qt.labs.settings 1.0

Window {
    id: root
    visible: true
    width: 900
    minimumWidth: 600
    height: 500
    minimumHeight: 350
    title: qsTr("Kodi remote")
    color: "#121212"

    property string playerURL: "http://" + ti_iPort.text + "/jsonrpc"
    property string methodTemplate: "{\"jsonrpc\":\"2.0\",\"method\":-=PLACEHOLDER=-,\"id\":1}"
    property string user: ti_user.text
    property string password: ti_password.text

    Settings {
        id: settings

        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height

        property alias iPort: ti_iPort.text
        property alias user: ti_user.text
        property alias password: ti_password.text
    }

    Shortcut {
        sequence: "Up"
        onActivated: btn_up.clicked()
    }
    Shortcut {
        sequence: "Down"
        onActivated: btn_down.clicked()
    }
    Shortcut {
        sequence: "Left"
        onActivated: btn_left.clicked()
    }
    Shortcut {
        sequence: "Right"
        onActivated: btn_right.clicked()
    }
    Shortcut {
        sequence: "Space"
        onActivated: btn_space.clicked()
    }
    Shortcut {
        sequences: [StandardKey.Cancel, "Backspace"]
        onActivated: btn_back.clicked()
    }
    Shortcut {
        sequence: "Return"
        onActivated: btn_enter.clicked()
    }
    Shortcut {
        sequence: "Ctrl+I"
        onActivated: btn_menu.clicked()
    }
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: btn_stop.clicked()
    }
    Shortcut {
        sequence: "Ctrl+Right"
        onActivated: {
            request(
                prepateRequest("\"Player.Seek\",\"params\":{\"playerid\":1,\"value\":\"smallforward\"}"),
                function (o) { processResults(o); }
            );
        }
    }
    Shortcut {
        sequence: "Ctrl+Left"
        onActivated: {
            request(
                prepateRequest("\"Player.Seek\",\"params\":{\"playerid\":1,\"value\":\"smallbackward\"}"),
                function (o) { processResults(o); }
            );
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 15
        rows: 3
        columns: 5
        rowSpacing: 30
        columnSpacing: 20

        ControlButton {
            id: btn_stop
            Layout.row: 0
            Layout.column: 0
            source: "qrc:/img/stop.svg"
            onClicked: {
                request(
                    prepateRequest("\"Player.Stop\",\"params\":{\"playerid\":1}"),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_up
            Layout.row: 0
            Layout.column: 1
            source: "qrc:/img/up.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Up\""),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_back
            Layout.row: 0
            Layout.column: 2
            source: "qrc:/img/back.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Back\""),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_left
            Layout.row: 1
            Layout.column: 0
            source: "qrc:/img/left.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Left\""),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_down
            Layout.row: 1
            Layout.column: 1
            source: "qrc:/img/down.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Down\""),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_right
            Layout.row: 1
            Layout.column: 2
            source: "qrc:/img/right.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Right\""),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_space
            Layout.row: 2
            Layout.columnSpan: 3
            source: "qrc:/img/space.svg"
            onClicked: {
                request(
                    prepateRequest("\"Player.PlayPause\",\"params\":{\"playerid\":1}"),
                    function (o) { processResults(o); }
                );
            }
        }
        ControlButton {
            id: btn_enter
            Layout.row: 0
            Layout.rowSpan: 2
            Layout.column: 3
            source: "qrc:/img/enter.svg"
            onClicked: {
                request(
                    prepateRequest("\"Input.Select\""),
                    function (o) { processResults(o); }
                );
            }
        }
        RowLayout {
            Layout.row: 2
            Layout.column: 3

            ControlButton {
                id: btn_menu
                source: "qrc:/img/menu.svg"
                onClicked: {
                    request(
                        prepateRequest("\"Input.ContextMenu\""),
                        function (o) { processResults(o); }
                    );
                }
            }
        }
        Rectangle {
            Layout.rowSpan: 3
            Layout.column: 4
            Layout.preferredWidth: parent.width * 0.25
            Layout.fillHeight: true

            color: "#094354"
            border.width: 3
            border.color: "#12B1E6"

            visible: root.width < 800 || root.height < 400 ? false : true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                InfoText { text: "<h3>⌘ + S</h3><i>stop playing</i>" }
                InfoText { text: "<h3>⌘ + I</h3><i>context menu</i>" }
                InfoText { text: "<h3>⌘ + ←</h3><i>30 seconds backward</i>" }
                InfoText { text: "<h3>⌘ + →</h3><i>30 seconds forward</i>" }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ColumnLayout {
                    InfoText { text: "IP and port" }
                    InfoInput {
                        id: ti_iPort
                        placeholder: "192.168.1.5:8080"
                    }
                }
                ColumnLayout {
                    InfoText { text: "User" }
                    InfoInput {
                        id: ti_user
                        placeholder: "osmc"
                    }
                }
                ColumnLayout {
                    InfoText { text: "Password" }
                    InfoInput {
                        id: ti_password
                        placeholder: "osmc"
                        echoMode: TextInput.Password
                    }
                }
            }
        }
    }

    MessageBox {
        id: dialogError
        title: "Some error"
        textMain: "Some error"
    }

    function request(url, callback)
    {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(myxhr.readyState === 4) { callback(myxhr); }
            }
        })(xhr);
        xhr.open("GET", url);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("Authorization", "Basic " + Qt.btoa(user + ":" + password));
        xhr.send();
    }

    function prepateRequest(actionName)
    {
        return playerURL
                + "?request="
                + encodeURIComponent(
                    methodTemplate.replace("-=PLACEHOLDER=-", actionName)
                    );
    }

    function processResults(o)
    {
        if (o.status === 200)
        {
            var jsn = JSON.parse(o.responseText);
            if (!jsn.hasOwnProperty("error")) { return; }
            else
            {
                dialogError.textMain = "Some error has occurred<br/>Code: "
                        + jsn["error"]["code"] + "<br/>Error: "
                        + jsn["error"]["message"];
                console.log(dialogError.textMain.replace(/<br\/>/g, " | "));
                dialogError.show();
            }
        }
        else
        {
            dialogError.textMain = "Some error has occurred<br/>Code: "
                    + o.status + "<br/>Status: " + o.statusText;
            console.log(dialogError.textMain.replace(/<br\/>/g, " | "));
            dialogError.show();
        }
    }
}