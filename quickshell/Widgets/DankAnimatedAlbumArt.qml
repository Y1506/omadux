import QtQuick
import "../Common"

DAnimatedAlbumArt {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankAnimatedAlbumArt", "DAnimatedAlbumArt", "qs.Widgets")
}
