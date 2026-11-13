import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.AudioVisualization {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "AudioVisualization", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
