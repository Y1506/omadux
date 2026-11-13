import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"

Item {
    id: root

    readonly property string notifScript: {
        const url = Qt.resolvedUrl("../scripts/notif-popups").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property bool enabled: typeof SettingsData === "undefined" || SettingsData.enableNotifTakeover

    function claim() {
        if (!root.enabled) return;
        proc.command = [root.notifScript, "claim"];
        proc.running = true;
    }

    function release() {
        if (!root.enabled) return;
        proc.command = [root.notifScript, "release"];
        proc.running = true;
    }

    Process {
        id: proc
    }

    Component.onCompleted: claim()
    Component.onDestruction: release()
}
