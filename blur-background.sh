#!/usr/bin/env bash
set -e

WIDTH=4445
HEIGHT=2500

BLUR_WIDTH=768
BLUR_HEIGHT=432

IN_FOLDER="$1"
OUT_FOLDER="$2"

function print_usage {
	echo "must be called with <script> \$IN_FOLDER \$OUT_FOLDER"
}

function blur {
	IN="$1"
	FILENAME="${IN##*/}"
	OUT="${OUT_FOLDER}/$FILENAME"

	echo "converting ${1}"
	echo "  $IN => $OUT"
	if [[ -f $OUT ]]; then
		echo "  $OUT already exists, skipping"
		return
    fi
    convert "$IN" \
    	\( -clone 0 -resize ${BLUR_WIDTH}x${BLUR_HEIGHT}! \) \
    	\( -clone 0 -resize ${WIDTH}x${HEIGHT} \) \
        \( -clone 1 -blur 0x10 -gravity center +repage -modulate 70,40,100 \) \
    	\( -clone 1 -fill white -colorize 100 \) \
    	\( -clone 2 -fill black -colorize 100 -resize ${BLUR_WIDTH}x${BLUR_HEIGHT} \) \
    	\( -clone 4,5 -gravity center -compose over -composite -blur 0x15 \) \
    	\( -clone 3,6 -gravity center -compose multiply -composite -resize ${WIDTH}x${HEIGHT} \) \
    	\( -clone 7,2 -gravity center -compose over -composite \) \
		-delete 0,1,2,3,4,5,6,7 \
    	"${OUT}"
}

if [ -z $1 ] || [ -z $2 ]; then
	print_usage
	exit 1
fi


mkdir -p ${OUT_FOLDER}
for file in ${IN_FOLDER}/*.{jpg,JPG}; do
	blur $file
done

#time convert "$IN" \
#	\( -clone 0 -resize ${WIDTH}x${HEIGHT}! -blur 0x10 -gravity center +repage -modulate 70,30,100 \) \
#	\( -clone 0 -resize ${WIDTH}x${HEIGHT} \) \
#	\( -clone 1 -fill white -colorize 100 \) \
#	\( -clone 2 -fill black -colorize 100 \) \
#	\( -clone 3,4 -gravity center -compose over -composite -blur 0x15 \) \
#	\( -clone 1,5 -gravity center -compose multiply -composite \) \
#	\( -clone 6,2 -gravity center -compose over -composite \) \
#	-delete 0,1,2,3,4,5,6 \
#	"1_${OUT}"

#time convert "$IN" \
#	\( -clone 0 -resize ${BLUR_WIDTH}x${BLUR_HEIGHT}! \) \
#    \( -clone 1 -blur 0x10 -gravity center +repage -modulate 70,40,100 \) \
#	\( -clone 2 -resize ${WIDTH}x${HEIGHT} \) \
#	-delete 1,2 \
#	\( -clone 0 -resize ${WIDTH}x${HEIGHT} \) \
#	\( -clone 1 -fill white -colorize 100 \) \
#	\( -clone 2 -fill black -colorize 100 \) \
#	\( -clone 3,4 -gravity center -compose over -composite -blur 0x15 \) \
#	\( -clone 1,5 -gravity center -compose multiply -composite \) \
#	\( -clone 6,2 -gravity center -compose over -composite \) \
#	-delete 0,1,2,3,4,5,6 \
#	"2_${OUT}"

#time convert "$IN" \
#	\( -clone 0 -resize ${BLUR_WIDTH}x${BLUR_HEIGHT}! \) \
#	\( -clone 0 -resize ${WIDTH}x${HEIGHT} \) \
#    \( -clone 1 -blur 0x10 -gravity center +repage -modulate 70,40,100 \) \
#	\( -clone 1 -fill white -colorize 100 \) \
#	\( -clone 2 -fill black -colorize 100 -resize ${BLUR_WIDTH}x${BLUR_HEIGHT} \) \
#	\( -clone 4,5 -gravity center -compose over -composite -blur 0x15 \) \
#	\( -clone 3,6 -gravity center -compose multiply -composite -resize ${WIDTH}x${HEIGHT} \) \
#	\( -clone 7,2 -gravity center -compose over -composite \) \
#	"2_${OUT}"

