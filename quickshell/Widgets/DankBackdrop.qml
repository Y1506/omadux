import QtQuick
import "../Common"

DBackdrop {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankBackdrop", "DBackdrop", "qs.Widgets")
}
