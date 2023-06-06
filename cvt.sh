    install_dir=$HOME/.config/cvt.sh
    cvt_files=$(find $install_dir/cvt/ -type f \( ! -iname "README.txt" \)) 
    std_files=$(find $install_dir/std/ -maxdepth 1 -type f)

# including files
    for f in ${cvt_files[@]}; do
        source $f
    done
    for f in ${std_files[@]}; do
        source $f
    done
    source $install_dir/config/data

# FUNCTION "CVT"
    function cvt(){
## Extension Variables
    var_1=${1##*.}
    var_1=${var_1//-/}
    var_2=${2//-/}
## Auxiliary Functions
### text
    function cvt_txt_kernel(){
        if [[ "${pb[@]}" =~ "$1" ]] && [[ "${tpl[@]}" =~ "$2" ]]; then
                txt_${input}_${output} $1 $2 $3
        elif  [[ "${pb[@]}" =~ "$1" ]] && [[ ! "${tpl[@]}" =~  "$2" ]]; then
                txt_${input}_${output} $1 ${tpl_std[${input},${output}]} $2
        elif [[ "$1" =~ "${tpl[@]}" ]]; then
                txt_${input}_${output} ${pb_std[${input},${output}]} $1
        elif [[ ! "${pb[@]}" =~ "$1" ]] && [[ ! "${tpl[@]}" =~ "$1" ]] && [[ -z "$2" ]]; then
                txt_${input}_${output} ${pb_std[${input},${output}]} ${tpl_std[${input},${output}]} $1
        else
                printf "\nError in the syntax or not defined preamble/header.\nTry \"cvt --help.\"\n"
        fi
    }
    function cvt_txt(){
        input=${inv_input_txt[$1]}
        output=${inv_output_txt[$2]}
        cvt_txt_kernel $3 $4 $5
    }
    function cvt_txt_2(){
        for i in ${!input_txt[@]}; do
            if [[ "${TXT[$i]}" == "$var_1" ]]; then
                input=$i
                var="Ok"
            fi
        done
        output=${inv_output_txt[$1]}
        cvt_txt_kernel $2 $3 $4
    }
    
### image
    function cvt_img(){
        input_id=${inv_input_img[$1]}
        output_id=${inv_output_img[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        img_${input_id}_${output_id} "$underscore"
    }
### audio
    function cvt_aud(){
        input_id=${inv_input_aud[$1]}
        output_id=${inv_output_aud[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        aud_${input_id}_${output_id} "$underscore"
    }
### video
    function cvt_vid(){
        input_id=${inv_input_vid[$1]}
        output_id=${inv_output_vid[$2]}
        underscore=$(echo "${3// /_}")
        mv "$3" $underscore
        vid_${input_id}_${output_id} "$underscore"
    }

## Function "CVT" Properly
### text to text 
        if ([[ "${input_txt[@]}" =~ "$1" ]] || 
            [[ "${input_long_txt[@]}" =~ "$1" ]] || 
            [[ "${input_alt_txt[@]}" =~ "$1" ]]) && 
           ([[ "${output_txt[@]}" =~ "$2" ]] || 
            [[ "${output_long_txt[@]}" =~ "$2" ]] || 
            [[ "${output_alt_txt[@]}" =~ "$2" ]]); then
            cvt_txt $1 $2 $3 $4 $5 

        elif  [[ -z $var ]] &&
             ([[ "${output_txt[@]}" =~ "$2" ]] ||
              [[ "${output_long_txt[@]}" =~ "$2" ]] ||
              [[ "${output_alt_txt[@]}" =~ "$2" ]]); then
               cvt_txt_2 $2 $1 $3 $4

### image to image
        elif ([[ "${input_img[@]}" =~ "$1" ]] || 
              [[ "${input_long_img[@]}" =~ "$1" ]] || 
              [[ "${input_alt_img[@]}" =~ "$1" ]]) && 
              [[ "${output_img[@]}" =~ "$2" ]] || 
              [[ "${output_long_img[@]}" =~ "$2" ]] || 
              [[ "${output_alt_img[@]}" =~ "$2" ]]; then
             cvt_img $1 $2 $3 

        # elif [[ -n $ok_img ]] &&
        #      [[ "${output_img[@]}" =~ "$2" ]] ||
        #      [[ "${output_long_img[@]}" =~ "$2" ]] ||
        #      [[ "${output_alt_img[@]}" =~ "$2" ]]; then
        #      cvt_img $ext_img $2 $1

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

