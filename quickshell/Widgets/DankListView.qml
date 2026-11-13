import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DListView {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankListView", "DListView", "qs.DCommon.Widgets")
}
