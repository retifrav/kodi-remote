import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

Window {
    id: root
    visible: true
    width: 900
    minimumWidth: 600
    height: 700
    minimumHeight: 600
    title: qsTr("Kodi remote")
    color: "#121212"

    property string colorAccent: "#12B1E6"

    property string playerURL: "http://".concat(ti_iPort.text.trim(), "/jsonrpc");
    property string methodTemplate: "{\"jsonrpc\":\"2.0\",\"method\":-=PLACEHOLDER=-,\"id\":1}"
    property string user: ti_user.text
    property string password: ti_password.text

    Settings {
        id: settings

        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height

        property alias iPort: ti_iPort.text       // IP and port
        property alias user: ti_user.text         // username
        property alias password: ti_password.text // password
    }

    Shortcut {
        sequence: "Return"
        onActivated: btn_enter.clicked()
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
        sequence: "Ctrl+X"
        onActivated: btn_stop.clicked()
    }
    Shortcut {
        sequence: "Ctrl+Right"
        onActivated: {
            request(
                "POST",
                "\"Player.Seek\",\"params\":{\"playerid\":1,\"value\":\"smallforward\"}",
                function (o) { processResults(o); }
            );
        }
    }
    Shortcut {
        sequence: "Ctrl+Left"
        onActivated: {
            request(
                "POST",
                "\"Player.Seek\",\"params\":{\"playerid\":1,\"value\":\"smallbackward\"}",
                function (o) { processResults(o); }
            );
        }
    }
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            // get the list of subtitles
            request(
                "GET",
                "\"Player.GetProperties\",\"params\":{\"playerid\":1,\"properties\":[\"subtitleenabled\",\"currentsubtitle\",\"subtitles\"]}",
                function (o)
                {
                    var rez = processResults(o)["result"];

                    var subtitles = rez["subtitles"];
                    subsModel.clear();
                    subsModel.append({
                        "index": "-1",
                        "lang": "- no subtitles -"
                    });
                    subsCombo.currentIndex = 0;
                    //console.log(subtitles.length);
                    if (subtitles.length > 0)
                    {
                        for(var s in subtitles)
                        {
                            var lang = subtitles[s]["language"];
                            subsModel.append({
                                "index": subtitles[s]["index"].toString(),
                                "lang": "[".concat((lang.length > 0 ? lang : "unknown"), "] ", subtitles[s]["name"])
                            });
                            //console.log(subtitles[s]["index"] + ", " + subtitles[s]["language"] + ", " + subtitles[s]["name"]);
                        }

                        // if there is an active subtitle
                        if(rez["subtitleenabled"] === true)
                        {
                            // select the active subtitle
                            var currentSubtitle = rez["currentsubtitle"];
                            if (currentSubtitle !== null)
                            {
                                //console.log("not null");
                                //console.log(currentSubtitle["index"]);
                                for (var i = 0; i < subsModel.count; i++)
                                {
                                    //console.log(subsModel.get(i).index + " - " + currentSubtitle["index"]);
                                    if (subsModel.get(i).index === currentSubtitle["index"].toString())
                                    {
                                        subsCombo.currentIndex = i;
                                        break;
                                    }
                                }

                            }
                        }
                    }

                    subsDialog.open();
                }
            );
        }
    }
    Shortcut {
        sequence: "Ctrl+I"
        onActivated: btn_menu.clicked()
    }
    Shortcut {
        sequence: "Ctrl+E"
        onActivated: {
            dialogShutdown.open();
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
                    "POST",
                    "\"Player.Stop\",\"params\":{\"playerid\":1}",
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
                    "POST",
                    "\"Input.Up\"",
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
                    "POST",
                    "\"Input.Back\"",
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
                    "POST",
                    "\"Input.Left\"",
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
                    "POST",
                    "\"Input.Down\"",
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
                    "POST",
                    "\"Input.Right\"",
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
                    "POST",
                    "\"Player.PlayPause\",\"params\":{\"playerid\":1}",
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
                    "POST",
                    "\"Input.Select\"",
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
                        "POST",
                        "\"Input.ContextMenu\"",
                        function (o) { processResults(o); }
                    );
                }
            }

            /*
            ControlButton {
                id: btn_shutdown
                source: "qrc:/img/shutdown.svg"
                onClicked: {
                    request(
                        "POST",
                        "\"System.Shutdown\"",
                        function (o) { processResults(o); }
                    );
                }
            }
            */
        }
        Rectangle {
            Layout.rowSpan: 3
            Layout.column: 4
            Layout.preferredWidth: parent.width * 0.3
            Layout.maximumWidth: 300
            Layout.fillHeight: true

            color: "#094354"
            border.width: 3
            border.color: root.colorAccent

            visible: root.width < 800 || root.height < 400 ? false : true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                InfoText { text: "<h3>⌘ + ←</h3><i>30 seconds backward</i>" }
                InfoText { text: "<h3>⌘ + →</h3><i>30 seconds forward</i>" }
                InfoText { text: "<h3>⌘ + X</h3><i>stop playing</i>" }
                InfoText { text: "<h3>⌘ + S</h3><i>subtitles</i>" }
                InfoText { text: "<h3>⌘ + I</h3><i>context menu</i>" }
                InfoText { text: "<h3>⌘ + E</h3><i>shutdown</i>" }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    InfoText { text: "IP and port" }
                    InfoInput {
                        id: ti_iPort
                        placeholder: "192.168.1.5:8080"
                    }
                }
                RowLayout {
                    ColumnLayout {
                        InfoText { text: "User" }
                        InfoInput {
                            id: ti_user
                            placeholder: "kodi"
                        }
                    }
                    ColumnLayout {
                        InfoText { text: "Password" }
                        InfoInput {
                            id: ti_password
                            placeholder: "kodi"
                            echoMode: TextInput.Password
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors.centerIn: parent
        width: subsDialog.width
        height: subsDialog.height

        Dialog {
            id: subsDialog
            width: 300
            height: 120
            modal: true
            title: "Subtitles"

            ComboBox {
                id: subsCombo
                textRole: "lang"
                width: parent.width
                model: ListModel { id: subsModel }
                onActivated: {
                    //console.log(subsModel.get(currentIndex).index);
                    var params =
                            "{\"playerid\":1,\"subtitle\":".concat(
                                subsModel.get(currentIndex).index, ", \"enable\":true}"
                                );
                    if (subsModel.get(currentIndex).index === "-1")
                    {
                        params = "{\"playerid\":1,\"subtitle\":\"off\"}";

                    }
                    request(
                        "POST",
                        "\"Player.SetSubtitle\",\"params\":".concat(params),
                        function (o) { processResults(o); }
                    );
                    subsDialog.close();
                }
            }
        }
    }

    MessageBox {
        id: dialogError
        title: "Some error"
        textMain: "Some error"
    }

    Item {
        anchors.centerIn: parent

        Dialog {
            id: dialogShutdown
            anchors.centerIn: parent
            modal: true
            title: "Shutdown"
            standardButtons: Dialog.Yes | Dialog.No

            Label {
                text: "Are you sure you want to turn off the player?"
            }

            onAccepted: {
                request(
                    "POST",
                    "\"System.Shutdown\"",
                    function (o) { processResults(o); }
                    );
            }
        }
    }

    function request(method, params, callback)
    {
        //console.log(playerURL);
        //console.log(params);

        if (method !== "GET" && method !== "POST")
        {
            let errorText = "Unknown HTTP method: ".concat(method);
            console.log(errorText);
            dialogError.textMain = errorText;
            dialogError.show();
            return;
        }

        params = methodTemplate.replace("-=PLACEHOLDER=-", params);
        if (method === "GET")
        {
            params = "?request=".concat(encodeURIComponent(params));
        }

        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                switch (xhr.readyState)
                {
                case 0: // doesn't work yet: https://bugreports.qt.io/browse/QTBUG-75488
                    dialogError.textMain = "Looks like a timeout. Check if your player is online";
                    dialogError.show();
                    break;
                case 4:
                    callback(myxhr);
                    break;
                }
            }
        })(xhr);

        xhr.open(method, method === "GET" ? playerURL.concat(params) : playerURL);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("Authorization", "Basic ".concat(Qt.btoa("".concat(user, ":", password))));

        let xhrTimer = Qt.createQmlObject("import QtQuick 2.12; Timer {interval:3000;}", root, "XHRtimer");
        xhrTimer.triggered.connect(function() {
            if (xhr.readyState !== 4)
            {
                console.log("Request timeout");
                xhr.abort();
            }
        });
        xhrTimer.start();

        if (method === "GET") { xhr.send(); }
        else { xhr.send(params); }
    }

    function processResults(xhr)
    {
        if (xhr.status === 200)
        {
            var jsn = JSON.parse(xhr.responseText);
            // if there was no error, return JSON result
            if (!jsn.hasOwnProperty("error")) { return jsn; }
            else // set message text and show the dialog window
            {
                dialogError.textMain =
                        "Some error has occurred<br/>Code: ".concat(
                            jsn["error"]["code"], "<br/>Error: ", jsn["error"]["message"]
                            );
                //console.log(dialogError.textMain.replace(/<br\/>/g, " | "));
                dialogError.show();
            }
        }
        else
        {
            dialogError.textMain =
                    "Some error has occurred<br/>Code: ".concat(
                        xhr.status, "<br/>Status: ", xhr.statusText
                        );
            console.log(dialogError.textMain.replace(/<br\/>/g, " | "));
            dialogError.show();
        }
    }
}
