import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../../omarchy"
import "../../../Common"

RowLayout {
    id: root

    spacing: 4

    Repeater {
        model: OmarchyPluginService.enabledPlugins

        delegate: BarWidgetSlot {
            required property var modelData
            entry: ({ id: modelData })
            host: root.parent
        }
    }
}
