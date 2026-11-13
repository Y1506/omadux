import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DSpinner {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankSpinner", "DSpinner", "qs.DCommon.Widgets")
}
