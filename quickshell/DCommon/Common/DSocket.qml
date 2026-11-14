pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

Socket {
    id: root

    readonly property bool linkUp: connected
    property int reconnectBaseMs: 400
    property int reconnectMaxMs: 15000
    property int _reconnectAttempt: 0

    function send(data) {
        if (!connected)
            return;
        const json = typeof data === "string" ? data : JSON.stringify(data);
        const message = json.endsWith("\n") ? json : json + "\n";
        write(message);
        flush();
    }
}
