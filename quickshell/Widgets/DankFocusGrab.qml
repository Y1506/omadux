import QtQuick
import "../Common"

DFocusGrab {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankFocusGrab", "DFocusGrab", "qs.Widgets")
}
