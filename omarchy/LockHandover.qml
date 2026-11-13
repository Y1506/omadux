import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"

Item {
    id: root

    property var pluginApi: null
    onPluginApiChanged: if (pluginApi) setupLockShim()

    readonly property string lockShimSrc: {
        const url = Qt.resolvedUrl("../scripts/lock-screen").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property string lockShimDest: {
        const home = Quickshell.env("HOME");
        return home + "/.local/bin/omarchy-lock-screen";
    }

    readonly property bool enabled: typeof SettingsData === "undefined" || SettingsData.enableLockTakeover

    function setupLockShim() {
        if (!root.enabled) return;
        proc.command = ["ln", "-sf", root.lockShimSrc, root.lockShimDest];
        proc.running = true;
    }

    function removeLockShim() {
        proc.command = ["bash", "-c", "if [[ -L \"" + root.lockShimDest + "\" && \"$(readlink -f \"" + root.lockShimDest + "\")\" == *\"" + root.lockShimSrc + "\"* ]]; then rm -f \"" + root.lockShimDest + "\"; fi"];
        proc.running = true;
    }

    Process {
        id: proc
    }

    Component.onCompleted: setupLockShim()
    Component.onDestruction: removeLockShim()
}
