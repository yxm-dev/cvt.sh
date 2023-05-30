    installdir=$HOME/.config/cvt.sh
    cvt_files=$(find $installdir/cvt/ -type f \( ! -iname "README.txt" \)) 
    std_files=$(find $installdir/std/ -maxdepth 1 -type f)

# including files
    for f in ${cvt_files[@]}; do
        source $f
    done
    for f in ${std_files[@]}; do
        source $f
    done
    source $installdir/config/data


# FUNCTION "CVT"
    function cvt(){  
## defining auxiliary functions
    function cvt_txt(){
         var0="${1##*.}"
         echo $var0
         for i in ${!input_txt[@]}; do
            var1="${input_txt[$i]}"
            var2="${var1//-/}"
            echo $var2
            if [[ "${var0}" == "${var2}" ]]; then
                var="${var1}"
                echo ${var}
            fi
         done
         if [[ -z $var ]]; then
             echo "Extension .${var0} not recognized."
         fi

        input=${inv_input_txt[$var]}
        output=${inv_output_txt[$2]}

        if [[ "${pb[@]}" =~ "$3" ]] && [[ "${tpl[@]}" =~ "$4" ]]; then
                txt_${input}_${output} $3 $4 $5
        elif  [[ "${pb[@]}" =~ "$3" ]] && [[ ! "${tpl[@]}" =~  "$4" ]]; then
                txt_${input}_${output} $3 ${tpl_std[${input},${output}]} $4
        elif [[ "$3" =~ "${tpl[@]}" ]]; then
                txt_${input}_${output} ${pb_std[${input},${output}]} $3
        elif [[ ! "${pb[@]}" =~ "$3" ]] && [[ ! "${tpl[@]}" =~ "$3" ]] && [[ -z "$4" ]]; then
                txt_${input}_${output} ${pb_std[${input},${output}]} ${tpl_std[${input},${output}]} $3
        else
                printf "\nError in the syntax or not defined preamble/header.\nTry \"cvt --help.\"\n"
            fi
    }

    function cvt_img(){
        input_id=${inv_input_img[$1]}
        output_id=${inv_output_img[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        img_${input_id}_${output_id} "$underscore"
    }
    function cvt_aud(){
        input_id=${inv_input_aud[$1]}
        output_id=${inv_output_aud[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        aud_${input_id}_${output_id} "$underscore"
    }
    function cvt_vid(){
        input_id=${inv_input_vid[$1]}
        output_id=${inv_output_vid[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        vid_${input_id}_${output_id} "$underscore"
    }
## Function CVT properly
### text to text 
        if  [[ "${input_txt[@]}" =~ "$1" ]] || 
            [[ "${input_long_txt[@]}" =~ "$1" ]] || 
            [[ "${input_alt_txt[@]}" =~ "$1" ]] && 
            [[ "${output_txt[@]}" =~ "$2" ]] || 
            [[ "${output_long_txt[@]}" =~ "$2" ]] || 
            [[ "${output_alt_txt[@]}" =~ "$2" ]]; then
            cvt_txt $1 $2 $3 $4 $5

        elif [[ -n $ok_txt ]] &&
             [[ "${output_txt[@]}" =~ "$2" ]] ||
             [[ "${output_long_txt[@]}" =~ "$2" ]] ||
             [[ "${output_alt_txt[@]}" =~ "$2" ]]; then
             cvt_txt $1 $2 $1 $3 $4

### image to image
        elif [[ "${input_img[@]}" =~ "$1" ]] || 
             [[ "${input_long_img[@]}" =~ "$1" ]] || 
             [[ "${input_alt_img[@]}" =~ "$1" ]] && 
             [[ "${output_img[@]}" =~ "$2" ]] || 
             [[ "${output_long_img[@]}" =~ "$2" ]] || 
             [[ "${output_alt_img[@]}" =~ "$2" ]]; then
             cvt_img $1 $2 $3 

        elif [[ -n $ok_img ]] &&
             [[ "${output_img[@]}" =~ "$2" ]] ||
             [[ "${output_long_img[@]}" =~ "$2" ]] ||
             [[ "${output_alt_img[@]}" =~ "$2" ]]; then
             cvt_img $ext_img $2 $1

### audio to audio
         elif [[ "${input_aud[@]}" =~ "$1" ]] || 
             [[ "${input_long_aud[@]}" =~ "$1" ]] || 
             [[ "${input_alt_aud[@]}" =~ "$1" ]] && 
             [[ "${output_aud[@]}" =~ "$1" ]] || 
             [[ "${output_long_aud[@]}" =~ "$1" ]] || 
             [[ "${output_alt_aud[@]}" =~ "$1" ]]; then
            input_id=${inv_input_aud[$1]}
            output_id=${inv_output_aud[$2]}
            aud_${input_id}_${output_id} "$3"

### video to video
        elif [[ "${input_vid[@]}" =~ "$1" ]] || 
             [[ "${input_long_vid[@]}" =~ "$1" ]] || 
             [[ "${input_alt_vid[@]}" =~ "$1" ]] && 
             [[ "${output_vid[@]}" =~ "$1" ]] || 
             [[ "${output_long_vid[@]}" =~ "$1" ]] || 
             [[ "${output_alt_vid[@]}" =~ "$1" ]]; then            
            input_id=${inv_input_vid[$1]}
            output_id=${inv_output_vid[$2]}
            vid_${input_id}_${output_id} "$3"

### text to media
        elif [[ "${input_txt[@]}" =~ "$1" ]] || 
             [[ "${input_long_txt[@]}" =~ "$1" ]] || 
             [[ "${input_alt_txt[@]}" =~ "$1" ]] && 
             [[ "${output_img[@]}" =~ "$2" ]] || 
             [[ "${output_long_img[@]}" =~ "$2" ]] || 
             [[ "${output_alt_img[@]}" =~ "$2" ]]
             [[ "${output_aud[@]}" =~ "$2" ]] || 
             [[ "${output_long_aud[@]}" =~ "$2" ]] || 
             [[ "${output_alt_aud[@]}" =~ "$2" ]]
             [[ "${output_vid[@]}" =~ "$2" ]] || 
             [[ "${output_long_vid[@]}" =~ "$2" ]] || 
             [[ "${output_alt_vid[@]}" =~ "$2" ]]; then
                echo "Text files cannot be converted into media files."
### media to text
        elif [[ "${output_img[@]}" =~ "$1" ]] || 
             [[ "${output_long_img[@]}" =~ "$1" ]] || 
             [[ "${output_alt_img[@]}" =~ "$1" ]]
             [[ "${output_aud[@]}" =~ "$1" ]] || 
             [[ "${output_long_aud[@]}" =~ "$1" ]] || 
             [[ "${output_alt_aud[@]}" =~ "$1" ]]
             [[ "${output_vid[@]}" =~ "$1" ]] || 
             [[ "${output_long_vid[@]}" =~ "$1" ]] || 
             [[ "${output_alt_vid[@]}" =~ "$1" ]] && 
             [[ "${input_txt[@]}" =~ "$2" ]] || 
             [[ "${input_long_txt[@]}" =~ "$2" ]] || 
             [[ "${input_alt_txt[@]}" =~ "$2" ]]; then
                 echo "Media files cannot be converted into text files."
### other media to media...
### configuring mode
        elif [[ "$1" == "-c" ]] ||  
             [[ "$1" == "-conf" ]] || 
             [[ "$1" == "-config" ]] || 
             [[ "$1" == "--conf" ]] || 
             [[ "$1" == "--config" ]] || 
             [[ "$1" == "--configure" ]]; then
             echo "configuring mode..."
### help mode
        elif [[ "$1" == "-h" ]] ||  
             [[ "$1" == "-help" ]] || 
             [[ "$1" == "--help" ]]; then
             echo "help mode..."
### interactive mode
        elif [[ -z $1 ]]; then
            echo "interactive mode..."
### else
        else
            printf "Option not defined for the \"cvt()\" function.\n* Probably you are using a wrong syntax or trying to convert from/to not implemented file types. \n* Try \"cvt --help.\"\n"
        fi
## Unseting Auxiliary Functions
    unset -f cvt_txt
    unset -f cvt_img
    unset -f cvt_aud
    unset -f cvt_vid
}

