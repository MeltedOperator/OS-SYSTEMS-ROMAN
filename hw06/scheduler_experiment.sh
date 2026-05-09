#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
	echo "Запусти через sudo"
	exit 1
fi

for _ in $(seq 1 3); do
    dd if=/dev/urandom of=/dev/null bs=1M &
done

# Шаг 2: Два замера одновременно
default_out="~/os-systems-work/hw06/README.md"

out_file="${1:-$default_out}"

{ time nice -n 19  dd if=/dev/urandom of=/dev/null bs=1M count=1 2>/dev/null ; } 2>> "$out_file" &
pid1=$!
{ time nice -n -10 dd if=/dev/urandom of=/dev/null bs=1M count=1 2>/dev/null ; } 2>> "$out_file" &
pid2=$!
wait $pid1 $pid2

# Шаг 3: Сравнить
echo "=== nice 19 === " && cat "$out_file"
echo "=== nice -10 === " && cat "$out_file"

# Шаг 4: Убить фоновые
kill %1 %2 %3 
