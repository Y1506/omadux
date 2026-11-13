import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DButton {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankButton", "DButton", "qs.DCommon.Widgets")
}
