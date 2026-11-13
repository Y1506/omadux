import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DGridView {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankGridView", "DGridView", "qs.DCommon.Widgets")
}
