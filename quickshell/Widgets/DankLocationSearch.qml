import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DLocationSearch {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankLocationSearch", "DLocationSearch", "qs.DCommon.Widgets")
}
