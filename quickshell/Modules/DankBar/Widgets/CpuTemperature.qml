import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.CpuTemperature {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "CpuTemperature", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
