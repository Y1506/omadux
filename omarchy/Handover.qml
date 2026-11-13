import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string handoverScript: {
        const url = Qt.resolvedUrl("../scripts/handover.py").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property int shellPid: Quickshell.env("OMARCHY_SHELL_PID") ? parseInt(Quickshell.env("OMARCHY_SHELL_PID"), 10) : 0

    function apply() {
        const args = [root.handoverScript, "apply"];
        if (root.shellPid > 0) {
            args.push("--pid");
            args.push(String(root.shellPid));
        }
        applyProc.command = args;
        applyProc.running = true;
    }

    function restore() {
        restoreProc.command = [root.handoverScript, "restore"];
        restoreProc.running = true;
    }

    Process {
        id: applyProc
        onExited: code => {
            if (code !== 0) console.warn("omadux: handover apply returned code " + code);
        }
    }

    Process {
        id: restoreProc
        onExited: code => {
            if (code !== 0) console.warn("omadux: handover restore returned code " + code);
        }
    }

    Component.onCompleted: apply()
    Component.onDestruction: restore()
}
