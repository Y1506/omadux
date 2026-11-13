import QtQuick
import "../../../Common"
import ".."
import "../../Settings/Widgets"

SettingsRow {
    minHeight: CcMetrics.rowHeight
    paddingH: CcMetrics.rowPaddingH
    paddingV: CcMetrics.rowPaddingV
    rowColor: CcMetrics.rowColor
    iconColor: active ? Theme.accentOnSelectedContainer : Theme.surfaceText
}
