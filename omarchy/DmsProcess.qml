import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"
import "../quickshell/Services"

Item {
    id: root

    readonly property string dmsBinary: {
        const url = Qt.resolvedUrl("../bin/dms").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property string socketPath: {
        const rt = Quickshell.env("XDG_RUNTIME_DIR");
        return (rt && rt.length > 0) ? (rt + "/dms.sock") : "/tmp/dms.sock";
    }

    readonly property bool disableExternalDeploy: {
        if (typeof SettingsData !== "undefined" && SettingsData.enableExternalAppTheming) {
            return false;
        }
        return true;
    }

    property bool isRunning: proc.running

    Process {
        id: proc
        command: [root.dmsBinary, "run", "--session", "--daemon-only"]
        environment: ({
            "OMADUX_DAEMON_ONLY": "1",
            "OMADUX_DISABLE_EXTERNAL_DEPLOY": root.disableExternalDeploy ? "1" : "0",
            "DMS_SOCKET": root.socketPath
        })
        running: true

        stdout: SplitParser {
            onRead: line => {
                // When dms prints readiness or socket path
                if (typeof DMSService !== "undefined" && typeof DMSService.reconnect === "function") {
                    DMSService.reconnect();
                }
            }
        }

        onExited: code => {
            console.log("omadux: dms process exited with code " + code);
        }
    }

    Timer {
        id: reconnectTimer
        interval: 1000
        running: proc.running && (typeof DMSService !== "undefined" && !DMSService.isConnected)
        repeat: true
        onTriggered: {
            if (typeof DMSService !== "undefined" && typeof DMSService.reconnect === "function") {
                DMSService.reconnect();
            }
        }
    }

    Component.onDestruction: {
        proc.running = false;
    }
}
