import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.NetworkMonitor {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "NetworkMonitor", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
