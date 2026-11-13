import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DTextEdit {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankTextEdit", "DTextEdit", "qs.DCommon.Widgets")
}
