pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

DSocket {
    id: shim
    readonly property bool linkUp: connected
}
