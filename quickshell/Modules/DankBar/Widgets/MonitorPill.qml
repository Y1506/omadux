import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.MonitorPill {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "MonitorPill", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
