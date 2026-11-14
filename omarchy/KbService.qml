pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../quickshell/Common"

Item {
    id: root

    property var pluginApi: null
    onPluginApiChanged: if (pluginApi) applyBinds()

    readonly property bool enabled: typeof SettingsData === "undefined" || SettingsData.omaduxKeybindTakeover

    readonly property string kbScript: {
        const url = Qt.resolvedUrl("../scripts/kb-takeover").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    function applyBinds() {
        if (!root.enabled) return;
        batchProc.command = [root.kbScript, "--apply"];
        batchProc.running = true;
    }

    function removeBinds() {
        if (!root.enabled) return;
        batchProc.command = [root.kbScript, "--restore"];
        batchProc.running = true;
    }

    Connections {
        target: typeof Hyprland !== "undefined" ? Hyprland : null

        function onRawEvent(event) {
            if (event && event.name === "configreloaded") {
                root.applyBinds();
            }
        }
    }

    Process {
        id: batchProc
    }

    Component.onCompleted: applyBinds()
    Component.onDestruction: removeBinds()
}
