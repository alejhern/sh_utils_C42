#!/bin/sh
tail -n +13 "$1" | tee "$1" > /dev/null
