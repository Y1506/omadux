package main

import (
	"context"
	"fmt"
	"os/exec"
	"time"

	"github.com/duxlabs-dev/dux-go/qtbase"
	"github.com/duxlabs-dev/dux-shell/core/internal/qtbaseembed"
)

func quickshellCommand(ctx context.Context, args ...string) (*exec.Cmd, error) {
	if _, err := qtbaseembed.Resolve(); err == nil {
		testCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
		defer cancel()
		if testErr := qtbase.Command(testCtx, "--version").Run(); testErr == nil {
			return qtbase.Command(ctx, args...), nil
		}
	}
	if sysPath, err := exec.LookPath("quickshell"); err == nil {
		return exec.CommandContext(ctx, sysPath, args...), nil
	}
	if sysPath, err := exec.LookPath("qs"); err == nil {
		return exec.CommandContext(ctx, sysPath, args...), nil
	}
	return nil, fmt.Errorf("quickshell binary not found in PATH")
}
