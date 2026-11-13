import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DScrollbar {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankScrollbar", "DScrollbar", "qs.DCommon.Widgets")
}
