echo $(swift -print-target-info | grep runtimeResourcePath | cut -f 2 -d ':' | cut -f 2 -d '"')
