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
    height: 600
    minimumHeight: 550
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

        property alias iPort: ti_iPort.text       // IP and port
        property alias user: ti_user.text         // username
        property alias password: ti_password.text // password
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
        sequence: "Ctrl+X"
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
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            // get the list of subtitles
            request(
                prepateRequest("\"Player.GetProperties\",\"params\":{\"playerid\":1,\"properties\":[\"subtitleenabled\",\"currentsubtitle\",\"subtitles\"]}"),
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
                                "lang": "[" + (lang.length > 0 ? lang : "unknown") + "] " + subtitles[s]["name"]
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

                InfoText { text: "<h3>⌘ + ←</h3><i>30 seconds backward</i>" }
                InfoText { text: "<h3>⌘ + →</h3><i>30 seconds forward</i>" }
                InfoText { text: "<h3>⌘ + X</h3><i>stop playing</i>" }
                InfoText { text: "<h3>⌘ + I</h3><i>context menu</i>" }
                InfoText { text: "<h3>⌘ + S</h3><i>subtitles</i>" }

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
                    var params = "{\"playerid\":1,\"subtitle\":"
                        + subsModel.get(currentIndex).index
                        + ", \"enable\":true}";
                    if (subsModel.get(currentIndex).index === "-1")
                    {
                        params = "{\"playerid\":1,\"subtitle\":\"off\"}";

                    }
                    request(
                        prepateRequest("\"Player.SetSubtitle\",\"params\":" + params),
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

    function request(url, callback)
    {
        //console.log(decodeURIComponent(url));
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
            // if there was no error, return JSON result
            if (!jsn.hasOwnProperty("error")) { return jsn; }
            else // set message text and show the dialog window
            {
                dialogError.textMain = "Some error has occurred<br/>Code: "
                    + jsn["error"]["code"] + "<br/>Error: "
                    + jsn["error"]["message"];
                //console.log(dialogError.textMain.replace(/<br\/>/g, " | "));
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
