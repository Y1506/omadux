import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.DiskUsage {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "DiskUsage", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
