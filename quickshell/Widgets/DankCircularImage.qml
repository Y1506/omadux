import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DCircularImage {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankCircularImage", "DCircularImage", "qs.DCommon.Widgets")
}
