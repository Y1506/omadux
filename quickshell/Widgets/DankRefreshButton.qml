import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DRefreshButton {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankRefreshButton", "DRefreshButton", "qs.DCommon.Widgets")
}
