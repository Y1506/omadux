import QtQuick
import "../../../Common"
import "../../DDash/Overview" as New

New.CalendarEventEditor {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "CalendarEventEditor", "qs.Modules.DankDash.Overview", "qs.Modules.DDash.Overview")
}
