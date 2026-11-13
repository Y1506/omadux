import QtQuick
import "../../../Common"
import "../../../Services"
import "../../Settings/Widgets"
import "../../ControlCenter/Widgets"
import ".."

CcSheetDialog {
    id: root

    property string appId: ""
    readonly property int minutes: WellbeingService.appLimitMinutes(appId)

    function presentFor(id) {
        appId = id;
        present();
    }

    panelWidth: DashMetrics.optionSheetWidth
    iconName: "timer"
    title: WellbeingService.appName(appId)
    subtitle: I18n.tr("Daily limit", "screen time limit per day, total or for one app")
    showScrollBar: false

    SettingsGroup {
        width: parent.width
        slotColor: Theme.chipSurface

        SettingsRow {
            title: I18n.tr("Daily limit", "screen time limit per day, total or for one app")
            subtitle: root.minutes > 0 ? I18n.tr("Notifies when today's use of this app passes the limit", "per-app daily screen time limit description") : I18n.tr("Off")

            DurationSteppers {
                anchors.verticalCenter: parent.verticalCenter
                minutes: root.minutes
                onCommitted: next => WellbeingService.setAppLimit(root.appId, next)
            }
        }
    }
}
