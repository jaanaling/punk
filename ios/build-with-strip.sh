#!/bin/bash

flutter build ipa --release --no-codesign --obfuscate --split-debug-info=build/app/outputs/symbols

APP_PATH="../../build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app"

find "${APP_PATH}" -type f ! -name "*.*" -print | while read -r file; do
    if file "$file" | grep -qE "Mach-O|executable|ELF"; then
        BINARY="$(pwd)/$file"
        ../strip-paths.sh "${BINARY}"
    fi
done

echo "Re-signing..."