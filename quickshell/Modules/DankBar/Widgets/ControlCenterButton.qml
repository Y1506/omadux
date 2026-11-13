import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.ControlCenterButton {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "ControlCenterButton", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
