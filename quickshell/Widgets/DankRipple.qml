import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DRipple {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankRipple", "DRipple", "qs.DCommon.Widgets")
}
