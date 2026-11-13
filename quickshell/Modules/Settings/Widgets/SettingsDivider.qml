import QtQuick
import "../../../Common"

Rectangle {
    property bool vertical: false

    width: vertical ? Theme.dividerWidth : parent?.width ?? 0
    height: vertical ? SettingsMetrics.splitDividerHeight : Theme.dividerWidth
    color: Theme.outlineVariant
    visible: !(parent?.isSettingsGroupHost ?? false)
    anchors.verticalCenter: vertical ? parent?.verticalCenter : undefined
}
