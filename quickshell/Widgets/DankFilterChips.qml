import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DFilterChips {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankFilterChips", "DFilterChips", "qs.DCommon.Widgets")
}
