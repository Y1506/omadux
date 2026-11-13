import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.CpuMonitor {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "CpuMonitor", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
