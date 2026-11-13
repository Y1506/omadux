import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.Clock {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "Clock", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
