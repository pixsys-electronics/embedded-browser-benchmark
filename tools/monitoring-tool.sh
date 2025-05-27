#!/bin/bash

# Generate ISO 8601 timestamp (safe for filenames)                     
timestamp=$(date -u +%Y-%m-%dT%H-%M-%SZ)
logfile="cpu_usage_$timestamp.csv"

# Write CSV header                                                     
echo "datetime,cpu_usage" > "$logfile"

# Loop to log data every second                                        
while true; do
  datetime=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  cpu_usage=$(mpstat 1 1 | awk '/Average/ {printf("%.2f", 100 - $NF)}')
  # RAM usage (used / total * 100)
  ram_usage=$(free | awk '/^Mem:/ { printf("%.2f", $3/$2 * 100.0) }')
  echo "$datetime,$cpu_usage,$ram_usage" >> "$logfile"
done
