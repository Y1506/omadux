import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.Battery {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "Battery", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
