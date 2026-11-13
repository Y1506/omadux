import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"
import "../quickshell/Services"

Item {
    id: root

    readonly property string omaduxScript: {
        const url = Qt.resolvedUrl("../scripts/omadux").toString();
        return url.startsWith("file://") ? decodeURIComponent(url.slice(7)) : url;
    }

    readonly property string themeJsonPath: {
        const c = Quickshell.env("XDG_CACHE_HOME");
        const base = (c && c.length > 0) ? c : (Quickshell.env("HOME") + "/.cache");
        return base + "/DankMaterialShell/omarchy-theme.json";
    }

    readonly property string colorsTomlPath: Quickshell.env("HOME") + "/.config/omarchy/current/theme/colors.toml"
    readonly property string backgroundPath: Quickshell.env("HOME") + "/.config/omarchy/current/background"
    readonly property string backgroundsFolder: Quickshell.env("HOME") + "/.config/omarchy/current/backgrounds"

    property string currentWallpaper: ""

    function syncNow() {
        syncProc.command = [root.omaduxScript, "sync"];
        syncProc.running = true;
    }

    Process {
        id: syncProc
        onExited: code => {
            if (code === 0) {
                applyTheme();
            }
        }
    }

    function applyTheme() {
        if (typeof SettingsData !== "undefined") {
            SettingsData.customThemeFile = root.themeJsonPath;
        }
        if (typeof Theme !== "undefined" && typeof Theme.switchTheme === "function") {
            Theme.switchTheme("custom", true, false);
        }
        if (typeof SessionData !== "undefined") {
            if (root.currentWallpaper.length > 0) {
                SessionData.wallpaperPath = root.currentWallpaper;
            }
            const bgDir = root.backgroundsFolder;
            const currentFolders = Array.isArray(SessionData.wallpaperFolders) ? SessionData.wallpaperFolders.slice() : [];
            if (!currentFolders.includes(bgDir)) {
                SessionData.set("wallpaperFolders", [bgDir].concat(currentFolders));
            }
            SessionData.set("wallpaperCyclingFolderPath", bgDir);
        }
    }

    FileView {
        path: root.colorsTomlPath
        watchChanges: true
        printErrors: false
        onFileChanged: root.syncNow()
    }

    FileView {
        path: root.backgroundPath
        watchChanges: true
        printErrors: false
        onFileChanged: bgReader.running = true
    }

    Process {
        id: bgReader
        command: ["bash", "-c", "if [[ -f \"" + root.backgroundPath + "\" ]]; then cat \"" + root.backgroundPath + "\" 2>/dev/null; fi"]
        stdout: SplitParser {
            onRead: line => {
                const trimmed = String(line).trim();
                if (trimmed.length > 0) {
                    root.currentWallpaper = trimmed;
                    if (typeof SessionData !== "undefined") {
                        SessionData.wallpaperPath = trimmed;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        bgReader.running = true;
        syncNow();
    }
}
