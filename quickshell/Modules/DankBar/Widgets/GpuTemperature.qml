import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.GpuTemperature {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "GpuTemperature", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
