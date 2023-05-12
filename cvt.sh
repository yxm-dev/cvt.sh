    installdir=$HOME/.config/cvt.sh
    cvt_files=$(find $installdir/cvt/ -type f) 
    std_files=$(find $installdir/std/ -maxdepth 1 -type f)

# including files
    for f in ${cvt_files[@]}; do
        source $f
    done
    for f in ${std_files[@]}; do
        source $f
    done
    source $installdir/config/data

# defining "cvt" function
    function cvt(){
## text to text 
        if  [[ "${input_txt[@]}" =~ "$1" ]] || 
            [[ "${input_long_txt[@]}" =~ "$1" ]] || 
            [[ "${input_alt_txt[@]}" =~ "$1" ]] && 
            [[ "${output_txt[@]}" =~ "$2" ]] || 
            [[ "${output_long_txt[@]}" =~ "$2" ]] || 
            [[ "${output_alt_txt[@]}" =~ "$2" ]]; then

            input_id=${inv_input_txt[$1]}
            output_id=${inv_output_txt[$2]}
            
            if [[ "${pb[@]}" =~ "$3" ]] && [[ "${tpl[@]}" =~ "$4" ]]; then
                ${input_id}_${output_id} $3 $4 $5
            elif  [[ "${pb[@]}" =~ "$3" ]] && [[ ! "${tpl[@]}" =~  "$4" ]]; then
                ${input_id}_${output_id} $3 ${tpl_std[${input_id},${output_id}]} $4
            elif [[ "$3" =~ "${tpl[@]}" ]]; then
                ${input_id}_${output_id} ${pb_std[${input_id},${output_id}]} $3
            elif [[ ! "${pb[@]}" =~ "$3" ]] && [[ ! "${tpl[@]}" =~ "$3" ]] && [[ -z "$4" ]]; then 
                ${input_id}_${output_id} ${pb_std[${input_id},${output_id}]} ${tpl_std[${input_id},${output_id}]} $3
            else
                printf "\nError in the syntax or not defined preamble/header.\nTry \"cvt --help.\"\n"
            fi
## image to image
        elif [[ "$1" =~ "${input_img[@]}" ]] || 
             [[ "$1" =~ "${input_long_img[@]}" ]] || 
             [[ "$1" =~ "${input_alt_img[@]}" ]] && 
             [[ "$2" =~ "${output_img[@]}" ]] || 
             [[ "$2" =~ "${output_long_img[@]}" ]] || 
             [[ "$2" =~ "${output_alt_img[@]}" ]]; then
                echo "img"
## audio to audio
        elif [[ "$1" =~ "${input_aud[@]}" ]] || 
             [[ "$1" =~ "${input_long_aud[@]}" ]] || 
             [[ "$1" =~ "${input_alt_aud[@]}" ]] && 
             [[ "$2" =~ "${output_aud[@]}" ]] || 
             [[ "$2" =~ "${output_long_aud[@]}" ]] || 
             [[ "$2" =~ "${output_alt_aud[@]}" ]]; then
                echo "aud"
## video to video
        elif [[ "$1" =~ "${input_vid[@]}" ]] || 
             [[ "$1" =~ "${input_long_vid[@]}" ]] || 
             [[ "$1" =~ "${input_alt_vid[@]}" ]] && 
             [[ "$2" =~ "${output_vid[@]}" ]] || 
             [[ "$2" =~ "${output_long_vid[@]}" ]] || 
             [[ "$2" =~ "${output_alt_vid[@]}" ]]; then
                echo "vid"
## text to media
        elif [[ "$1" =~ "${input_txt[@]}" ]] || 
             [[ "$1" =~ "${input_long_txt[@]}" ]] || 
             [[ "$1" =~ "${input_alt_txt[@]}" ]] && 
             [[ "$2" =~ "${output_img[@]}" ]] || 
             [[ "$2" =~ "${output_long_img[@]}" ]] || 
             [[ "$2" =~ "${output_alt_img[@]}" ]]
             [[ "$2" =~ "${output_aud[@]}" ]] || 
             [[ "$2" =~ "${output_long_aud[@]}" ]] || 
             [[ "$2" =~ "${output_alt_aud[@]}" ]]
             [[ "$2" =~ "${output_vid[@]}" ]] || 
             [[ "$2" =~ "${output_long_vid[@]}" ]] || 
             [[ "$2" =~ "${output_alt_vid[@]}" ]]; then
                echo "Text files cannot be converted into media files."
## media to text
        elif [[ "$1" =~ "${output_img[@]}" ]] || 
             [[ "$1" =~ "${output_long_img[@]}" ]] || 
             [[ "$1" =~ "${output_alt_img[@]}" ]]
             [[ "$1" =~ "${output_aud[@]}" ]] || 
             [[ "$1" =~ "${output_long_aud[@]}" ]] || 
             [[ "$1" =~ "${output_alt_aud[@]}" ]]
             [[ "$1" =~ "${output_vid[@]}" ]] || 
             [[ "$1" =~ "${output_long_vid[@]}" ]] || 
             [[ "$1" =~ "${output_alt_vid[@]}" ]] && 
             [[ "$2" =~ "${input_txt[@]}" ]] || 
             [[ "$2" =~ "${input_long_txt[@]}" ]] || 
             [[ "$2" =~ "${input_alt_txt[@]}" ]]; then
                 echo "Media files cannot be converted into text files."
## other media to media...
## configuring mode
        elif [[ "$1" == "-c" ]] ||  
             [[ "$1" == "-conf" ]] || 
             [[ "$1" == "-config" ]] || 
             [[ "$1" == "--conf" ]] || 
             [[ "$1" == "--config" ]] || 
             [[ "$1" == "--configure" ]]; then
             echo "configuring mode..."
## help mode
        elif [[ "$1" == "-h" ]] ||  
             [[ "$1" == "-help" ]] || 
             [[ "$1" == "--help" ]]; then
             echo "help mode..."
## interactive mode
        elif [[ -z $1 ]]; then
            echo "interactive mode..."
## else
        else
            printf "Option not defined for the \"cvt()\" function.\n* Probably you are using a wrong syntax or trying to convert from/to not implemented file types. \n* Try \"cvt --help.\"\n"
        fi
}


        #      pandoc -f markdown -t pdf --pdf-engine=xelatex -H ${pb[3]} -o $name.pdf $3
    #  elif ([[ "$1" == "-md" ]] || [[ "$1" == "--markdown" ]]) && ([[ "$2" == "-html" ]] || [[ "$2" == "--html" ]]); then
    #     if [[ "$3" == "-math" ]] || [[ "$3" == "--math" ]]; then
    #         name=$(basename "$4")
    #         x=$(sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g; s/(\[\[.+\]\])/\1(\1.html)/g' $4)
    #         x=$(pandoc -s $4 --filter pandoc-static-katex -t html5 --css https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.8.3/katex.min.css --template ${tpl[$i]} $x)
    #         sed -r 's/https:(.*).html/https:\1/g; s/.md.html/.html/g' $x > "$name.html"
    #     else
    #         name=$(basename "$3")
    #         x=$(sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g; s/(\[\[.+\]\])/\1(\1.html)/g' $3)
    #         x=$(pandoc -s -f markdown -t html5 --template ${tpl[$i]} $x)
    #         sed -r 's/https:(.*).html/https:\1/g; s/.md.html/.html/g' $x > "$name.html"
    #     fi
    # elif [[ "$1" = "-html" ]] || [[ "$1" = "--html" ]] && [[ "$2" = "-pdf" ]] || [[ "$2" = "--pdf" ]]; then
    #     name=$(basename "$3" .md)
    #     pandoc -f html -t pdf --pdf-engine=xelatex -H ${pb[2]} -o $name.pdf $3
    # else
    #     echo "option not defined."
    # fi
    # }
  

