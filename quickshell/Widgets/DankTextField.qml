import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DTextField {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankTextField", "DTextField", "qs.DCommon.Widgets")
}
