#!/usr/bin/bash
set -euo pipefail
tmux new-session -d -s mysession
tmux run-shell -t mysession ~/.tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.tmux.conf
tmux kill-session -t mysession
