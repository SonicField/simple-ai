#!/usr/bin/env bash

set -euo pipefail

if [[ ! -t 0 || ! -t 1 || ! -t 2 ]]; then
    printf 'ERROR: a controlling terminal is required\r\n' >&2
    exit 2
fi

# Keep commands sent through the PTY out of the rendered screen. The READY
# marker is emitted only after the terminal is prepared to accept input.
stty -echo
printf '\033[2J\033[HREADY'

while IFS= read -r command; do
    command=${command%$'\r'}
    case "$command" in
        render)
            printf '\033[2J\033[H'
            printf '\033[1;1HProgress: 10%%'
            printf '\033[1;1H\033[2KProgress: 100%%'
            printf '\033[2;1HRESULT: complete'
            printf '\033[3;1HDONE'
            ;;
        quit)
            printf '\033[4;1HBYE'
            exit 0
            ;;
        *)
            printf '\033[4;1H\033[2KERROR: unknown command'
            ;;
    esac
done
