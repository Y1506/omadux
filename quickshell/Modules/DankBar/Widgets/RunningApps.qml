import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.RunningApps {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "RunningApps", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
