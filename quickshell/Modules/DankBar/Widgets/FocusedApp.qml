import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.FocusedApp {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "FocusedApp", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
