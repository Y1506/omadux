import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DActionButton {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankActionButton", "DActionButton", "qs.DCommon.Widgets")
}
