import QtQuick
import "../../Common"
import "../DDash" as New

New.OverviewTab {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "OverviewTab", "qs.Modules.DankDash", "qs.Modules.DDash")
}
