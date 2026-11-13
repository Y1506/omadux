package config

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func LocateDMSConfig() (string, error) {
	var primaryPaths []string

	// 1. Environment override
	if omaduxDir := os.Getenv("OMADUX_DIR"); omaduxDir != "" {
		primaryPaths = append(primaryPaths, filepath.Join(omaduxDir, "quickshell"), omaduxDir)
	}

	// 2. Relative to running executable (e.g. repo/bin/dms -> repo/quickshell)
	if execPath, err := os.Executable(); err == nil {
		execDir := filepath.Dir(execPath)
		repoRoot := filepath.Dir(execDir)
		primaryPaths = append(primaryPaths,
			filepath.Join(repoRoot, "quickshell"),
			repoRoot,
			filepath.Join(execDir, "quickshell"),
			execDir,
		)
	}

	// 3. Current working directory
	if cwd, err := os.Getwd(); err == nil {
		primaryPaths = append(primaryPaths,
			filepath.Join(cwd, "quickshell"),
			cwd,
		)
	}

	// 4. User config home
	configHome, err := os.UserConfigDir()
	if err == nil && configHome != "" {
		primaryPaths = append(primaryPaths,
			filepath.Join(configHome, "omarchy", "plugins", "omadux", "quickshell"),
			filepath.Join(configHome, "omarchy", "plugins", "omadux"),
			filepath.Join(configHome, "omarchy", "plugins", "y1506.omadux.bar", "quickshell"),
			filepath.Join(configHome, "omarchy", "plugins", "y1506.omadux.bar"),
			filepath.Join(configHome, "quickshell", "dms"),
		)
	}

	// 5. System data directories
	dataDirs := os.Getenv("XDG_DATA_DIRS")
	if dataDirs == "" {
		dataDirs = "/usr/local/share:/usr/share"
	}

	for dir := range strings.SplitSeq(dataDirs, ":") {
		if dir != "" {
			primaryPaths = append(primaryPaths,
				filepath.Join(dir, "omarchy", "plugins", "y1506.omadux.bar", "quickshell"),
				filepath.Join(dir, "omarchy", "plugins", "y1506.omadux.bar"),
				filepath.Join(dir, "quickshell", "dms"),
			)
		}
	}

	// 6. User data directory
	dataHome := os.Getenv("XDG_DATA_HOME")
	if dataHome == "" {
		if home, err := os.UserHomeDir(); err == nil {
			dataHome = filepath.Join(home, ".local", "share")
		}
	}
	if dataHome != "" {
		primaryPaths = append(primaryPaths,
			filepath.Join(dataHome, "omarchy", "plugins", "omadux", "quickshell"),
			filepath.Join(dataHome, "omarchy", "plugins", "omadux"),
			filepath.Join(dataHome, "omarchy", "plugins", "y1506.omadux.bar", "quickshell"),
			filepath.Join(dataHome, "omarchy", "plugins", "y1506.omadux.bar"),
		)
	}

	// 7. System config directories (fallback)
	configDirs := os.Getenv("XDG_CONFIG_DIRS")
	if configDirs == "" {
		configDirs = "/etc/xdg"
	}

	for dir := range strings.SplitSeq(configDirs, ":") {
		if dir != "" {
			primaryPaths = append(primaryPaths, filepath.Join(dir, "quickshell", "dms"))
		}
	}

	// Build search paths with secondary (monorepo) paths interleaved
	var searchPaths []string
	seen := make(map[string]bool)
	for _, path := range primaryPaths {
		if path != "" && !seen[path] {
			seen[path] = true
			searchPaths = append(searchPaths, path)
		}
		sub := filepath.Join(path, "quickshell")
		if !seen[sub] {
			seen[sub] = true
			searchPaths = append(searchPaths, sub)
		}
	}

	for _, path := range searchPaths {
		for _, file := range []string{"shell.qml", "DMSShell.qml", "Bar.qml"} {
			shellPath := filepath.Join(path, file)
			if info, err := os.Stat(shellPath); err == nil && !info.IsDir() {
				return path, nil
			}
		}
	}

	return "", fmt.Errorf("could not find DMS config (shell.qml, DMSShell.qml, or Bar.qml) in any valid config path")
}
