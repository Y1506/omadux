import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DIcon {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankIcon", "DIcon", "qs.DCommon.Widgets")
}
