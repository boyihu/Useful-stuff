#!/bin/bash

if [ -z $3 ]; then
    echo ""
    echo "An Input Argument was not Supplied"
    echo ""
    echo "Usage: ./extract_frames.sh [Input_Folder] [Output_Folder_Prefix] [Sample_Rate]"
    exit
fi

INPUT_FOLDER="$(pwd)/$( basename ${1%.*} )"
OUTPUT_FOLDER="$(pwd)/${2%.*}_$(date +%m-%d-%y-%R:%S)" #added
FRAMES=$3
WORKING_FOLDER=""

print_and_make_folder() {
    if [ ! -z "$1" ]; then
        WORKING_FOLDER=$1  
       	echo "Working Folder: $WORKING_FOLDER"
    	mkdir $WORKING_FOLDER
    fi
}

echo "Input Folder: $INPUT_FOLDER"              #added
echo "Output Folder: $OUTPUT_FOLDER"			#added
echo "Sample Rate: $FRAMES"		                #added
echo ""

mkdir -m 755 $OUTPUT_FOLDER                     #make new output folder

#obtain list of all folders in the input folder
FOLDER_LIST=$( ls $INPUT_FOLDER --group-directories-first -x --classify | grep / )

#loop through data folders
for FOLDER in $FOLDER_LIST; do
	FOLDER=$(basename $FOLDER)
	
	#new WORKING_FOLDER is output folder of internal data folder
	print_and_make_folder "$OUTPUT_FOLDER/$FOLDER"
	
	#obtain list of only files in the video folder
	FILE_LIST=$( ls "$INPUT_FOLDER/$FOLDER" --group-directories-first -x --classify | grep "/" -v )
	
	#loop through videos
	for FILE in $FILE_LIST; do
	    FILE_FOLDER=$(basename ${FILE%.*})
	    
	    echo "On file $FILE"
	    #new WORKING_FOLDER is folder for pictures of video
	    print_and_make_folder "$OUTPUT_FOLDER/$FOLDER/$FILE_FOLDER"
	    
	    #run ffmpeg 
    	ffmpeg -loglevel warning -i "$INPUT_FOLDER/$FOLDER/$FILE" -r $FRAMES $WORKING_FOLDER/$FILE.%4d.jpg
    done
done



