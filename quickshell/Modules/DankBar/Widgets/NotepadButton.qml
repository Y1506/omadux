import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.NotepadButton {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "NotepadButton", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
