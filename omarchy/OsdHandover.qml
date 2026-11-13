import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"

Item {
    id: root

    readonly property string osdScript: {
        const url = Qt.resolvedUrl("../scripts/osd-handover").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property bool enabled: typeof SettingsData === "undefined" || SettingsData.enableOsdTakeover

    function claim() {
        if (!root.enabled) return;
        proc.command = [root.osdScript, "claim"];
        proc.running = true;
    }

    function release() {
        if (!root.enabled) return;
        proc.command = [root.osdScript, "release"];
        proc.running = true;
    }

    Process {
        id: proc
    }

    Component.onCompleted: claim()
    Component.onDestruction: release()
}
