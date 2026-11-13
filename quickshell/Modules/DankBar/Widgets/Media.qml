import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.Media {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "Media", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
