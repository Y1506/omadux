import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DButtonGroup {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankButtonGroup", "DButtonGroup", "qs.DCommon.Widgets")
}
