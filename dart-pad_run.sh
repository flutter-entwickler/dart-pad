#!/bin/bash
which dart
pwd
# ls -la /dart-pad
protoc --version
#dart pub global activate grinder
#dart pub get
export PATH="$PATH":"$HOME/.pub-cache/bin"
grind serve
