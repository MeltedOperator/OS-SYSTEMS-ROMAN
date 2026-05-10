#!/bin/bash
set -euo pipefail
process_name="${1:-}"
ps -eo pid,user,%cpu,%mem,comm | grep "$process_name" | grep -v grep
