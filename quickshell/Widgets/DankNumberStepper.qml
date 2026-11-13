import QtQuick
import "../Common"
import "../DCommon/Widgets" as DCommon

DCommon.DNumberStepper {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankNumberStepper", "DNumberStepper", "qs.DCommon.Widgets")
}
