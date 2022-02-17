#! /bin/bash

# https://stackoverflow.com/a/14203146

GENRE="podcast"
TEMP_DIR="./temp-concat-dir"

if [ "$#" -ne 4 ]; then
    echo "Usage:"
    echo "	concat.sh  [-i|--input-file]=<input-file> [-t|--title]=<title> [-a|--artist]=<artist> [-o|--output-name]=<output name>"
    echo "It is expected that you are in the folder where the final output will be saved."
    echo "There is no path expansion for the input file (I think)!"
    exit 1
fi

for i in "$@" ; do
	case $i in
	-i=*|--input-dir=*)
	  INPUT_FILE="${i#*=}"
	  shift # past argument=value
	  ;;
	-t=*|--title=*)
	TITLE="${i#*=}"
	  shift # past argument=value
	  ;;
	-a=*|--artist=*)
		ARTIST="${i#*=}"
	  shift # past argument=value
	  ;;
	-o=*|--output-name=*)
		OUTPUT="${i#*=}"
	  shift # past argument=value
	  ;;
	*)
		echo "Unknown option $i"
		exit 1
		;;
	esac
done

mkdir -p "$TEMP_DIR"

unzip "$INPUT_FILE" -d "$TEMP_DIR"

cd "$TEMP_DIR"

mp3cat *

ffmpeg -i "output.mp3" -metadata title="$TITLE" -metadata artist="$ARTIST" -metadata genre="$GENRE" -c copy "../$OUTPUT"

cd ..

rm -rf "$TEMP_DIR"

echo ""
echo "Done"

exit 0
