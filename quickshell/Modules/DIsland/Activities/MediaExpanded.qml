pragma ComponentBehavior: Bound

import QtQuick
import "../../DDash"

DashTabFace {
    id: root

    activityId: "media"
    tabComponent: Component {
        MediaPlayerTab {
            live: root.live
        }
    }
}
