import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DNFIcon {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankNFIcon", "DNFIcon", "qs.DCommon.Widgets")
}
