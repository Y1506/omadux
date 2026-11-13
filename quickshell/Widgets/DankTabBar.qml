import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DTabBar {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankTabBar", "DTabBar", "qs.DCommon.Widgets")
}
