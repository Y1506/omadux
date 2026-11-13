import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DToggle {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankToggle", "DToggle", "qs.DCommon.Widgets")
}
