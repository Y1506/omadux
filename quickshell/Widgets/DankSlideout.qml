import QtQuick
import "../Common"

DSlideout {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankSlideout", "DSlideout", "qs.Widgets")
}
