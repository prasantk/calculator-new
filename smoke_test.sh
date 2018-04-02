#!/bin/sh
echo "Running smoke test..."
CALCULATOR_PORT=$(docker-compose -p production port calculator 8080 | cut -d: -f2)
echo "Host: $@:$CALCULATOR_PORT"
./gradlew smokeTest -Dcalculator.url=http://$@:$CALCULATOR_PORT
