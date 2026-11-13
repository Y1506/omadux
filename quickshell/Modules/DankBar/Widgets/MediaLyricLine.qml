import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.MediaLyricLine {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "MediaLyricLine", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
