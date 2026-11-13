import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.RamMonitor {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "RamMonitor", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
