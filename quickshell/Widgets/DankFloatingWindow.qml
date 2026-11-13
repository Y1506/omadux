import QtQuick
import "../Common"

DFloatingWindow {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankFloatingWindow", "DFloatingWindow", "qs.Widgets")
}
