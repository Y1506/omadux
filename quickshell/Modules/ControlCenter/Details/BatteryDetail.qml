import QtQuick
import "../../../Common"
import "../../DBar/Popouts"
import "../../../Services"

BatteryPopoutContent {
    readonly property string title: BatteryService.batteryAvailable ? I18n.tr("Battery") : I18n.tr("Power")

    active: true
    contentPadding: 0
}
