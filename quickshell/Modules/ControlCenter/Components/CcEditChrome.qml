import QtQuick
import "../../../Common"
import "../../../Services"
import "../../../Widgets"
import "../utils/widgets.js" as WidgetUtils
import ".."

DGridEditChrome {
    id: root

    property var widgetData: ({})

    signal configRequested(var anchor)

    hasOptions: WidgetUtils.hasOptions(widgetData.id)
    removable: WidgetUtils.isRemovable(widgetData)
    removeIcon: "remove"
    buttonSize: CcMetrics.editChromeButtonSize
    hitOverflow: CcMetrics.gridGap / 2
    iconSize: PopoutMetrics.chromeIconSize

    onOptionsRequested: anchor => root.configRequested(anchor)
}
