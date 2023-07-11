    CVT_install_dir=$HOME/.config/cvt.sh
    CVT_files=$(find $CVT_install_dir/cvt/ -type f \( ! -iname "README.txt" \)) 
    CVT_std_files=$(find $CVT_install_dir/std/ -maxdepth 1 -type f)

# including files
    for f in ${CVT_files[@]}; do
        source $f
    done
    for f in ${CVT_std_files[@]}; do
        source $f
    done
    source $CVT_install_dir/config/data

# FUNCTION "CVT"
    function cvt(){
## Extension Variables
## Auxiliary Functions
### text
    function CVT_txt_kernel(){
        if [[ "${pb[@]}" =~ "$1" ]] && [[ "${tpl[@]}" =~ "$2" ]]; then
                CVT_txt_${input}_${output} $1 $2 $3
        elif  [[ "${pb[@]}" =~ "$1" ]] && [[ ! "${tpl[@]}" =~  "$2" ]]; then
            CVT_txt_${input}_${output} $1 ${tpl_std[${input},${output}]} $2
        elif [[ "$1" =~ "${tpl[@]}" ]]; then
                CVT_txt_${input}_${output} ${pb_std[${input},${output}]} $1
        elif [[ ! "${pb[@]}" =~ "$1" ]] && [[ ! "${tpl[@]}" =~ "$1" ]] && [[ -z "$2" ]]; then
                CVT_txt_${input}_${output} ${pb_std[${input},${output}]} ${tpl_std[${input},${output}]} $1
        else
                printf "\nError in the syntax or not defined preamble/header.\nTry \"cvt --help.\"\n"
        fi
    }
    function CVT_txt(){
        ext=${2##*.}
        for i in ${!CVT_input_txt[@]}; do
            if [[ "${CVT_TXT[$i]}" == "$ext" ]]; then
                input=$i
                output=$(CVT_inv_output_txt $1)
                var="ok"
                break
            else
                input=$(CVT_inv_input_txt $1)
                output=$(CVT_inv_output_txt $2)
                var=""
            fi
        done
        if [[ -n "$var" ]]; then
            CVT_txt_kernel $2 $3 $4
        else
            CVT_txt_kernel $3 $4 $5
        fi
    }
        
### image
    function CVT_img(){
        input_id=${CVT_inv_input_img[$1]}
        output_id=${CVT_inv_output_img[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        CVT_img_${input_id}_${output_id} "$underscore"
    }
### audio
    function CVT_aud(){
        input_id=${CVT_inv_input_aud[$1]}
        output_id=${CVT_inv_output_aud[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $Sunderscore
        CVT_aud_${input_id}_${output_id} "$underscore"
    }
### video
    function CVT_vid(){
        input_id=${CVT_inv_input_vid[$1]}
        output_id=${CVT_inv_output_vid[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        CVT_vid_${input_id}_${output_id} "$underscore"
    }

## Function "CVT" Properly
### interactive mode
        if [[ -z $1 ]]; then
            echo "interactive mode..."
### configuring mode
        elif [[ "$1" == "-c" ]] ||
             [[ "$1" == "-cfg" ]] || 
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
### text to text 
        elif [[ "${CVT_input_txt[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_long_txt[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_alt_txt[@]}" =~ "$1" ]]; then
            CVT_txt $1 $2 $3 $4 $5 

### image to image
        elif ([[ "${CVT_input_img[@]}" =~ "$1" ]] || 
              [[ "${CVT_input_long_img[@]}" =~ "$1" ]] || 
              [[ "${CVT_input_alt_img[@]}" =~ "$1" ]]) && 
              [[ "${CVT_output_img[@]}" =~ "$2" ]] || 
              [[ "${CVT_output_long_img[@]}" =~ "$2" ]] || 
              [[ "${CVT_output_alt_img[@]}" =~ "$2" ]]; then
             CVT_img $1 $2 $3 

        # elif [[ -n $ok_img ]] &&
        #      [[ "${output_img[@]}" =~ "$2" ]] ||
        #      [[ "${output_long_img[@]}" =~ "$2" ]] ||
        #      [[ "${output_alt_img[@]}" =~ "$2" ]]; then
        #      cvt_img $ext_img $2 $1

### audio to audio
         elif [[ "${CVT_input_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_long_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_alt_aud[@]}" =~ "$1" ]] && 
             [[ "${CVT_output_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_long_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_alt_aud[@]}" =~ "$1" ]]; then
            input_id=$(CVT_inv_input_aud $1)
            output_id=$(CVT_inv_output_aud $2)
            CVT_aud_${input_id}_${output_id} "$3"

### video to video
        elif [[ "${CVT_input_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_long_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_alt_vid[@]}" =~ "$1" ]] && 
             [[ "${CVT_output_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_long_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_alt_vid[@]}" =~ "$1" ]]; then            
            input_id=$(CVT_inv_input_vid $1)
            output_id=$(CVT_inv_output_vid $2)
            CVT_vid_${input_id}_${output_id} "$3"

### text to media
        elif [[ "${CVT_input_txt[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_long_txt[@]}" =~ "$1" ]] || 
             [[ "${CVT_input_alt_txt[@]}" =~ "$1" ]] && 
             [[ "${CVT_output_img[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_long_img[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_alt_img[@]}" =~ "$2" ]]
             [[ "${CVT_output_aud[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_long_aud[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_alt_aud[@]}" =~ "$2" ]]
             [[ "${CVT_output_vid[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_long_vid[@]}" =~ "$2" ]] || 
             [[ "${CVT_output_alt_vid[@]}" =~ "$2" ]]; then
                echo "Text files cannot be converted into media files."
### media to text
        elif [[ "${CVT_output_img[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_long_img[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_alt_img[@]}" =~ "$1" ]]
             [[ "${CVT_output_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_long_aud[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_alt_aud[@]}" =~ "$1" ]]
             [[ "${CVT_output_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_long_vid[@]}" =~ "$1" ]] || 
             [[ "${CVT_output_alt_vid[@]}" =~ "$1" ]] && 
             [[ "${CVT_input_txt[@]}" =~ "$2" ]] || 
             [[ "${CVT_input_long_txt[@]}" =~ "$2" ]] || 
             [[ "${CVT_input_alt_txt[@]}" =~ "$2" ]]; then
                 echo "Media files cannot be converted into text files."
### other media to media...
### else
        else
            printf "Option not defined for the \"cvt()\" function.\n* Probably you are using a wrong syntax or trying to convert from/to not implemented file types. \n* Try \"cvt --help.\"\n"
        fi
## Unseting Auxiliary Functions
    unset -f CVT_txt
    unset -f CVT_img
    unset -f CVT_aud
    unset -f CVT_vid
}

