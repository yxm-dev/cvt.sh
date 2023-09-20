#! /bin/bash

# DEPENDENCIES
    echo "Welcome to the cvt installation."
    printf "Checking for minimal depencies...\n* pandoc\n* ffmpeg\n* sox\n"
## identifying the package manager  
    if [[ -x "$(command -v apt-get)" ]]; then 
        install_command="sudo apt-get install"
    elif [[ -x "$(command -v dnf)" ]]; then 
        install_command="sudo dnf install"
    elif [[ -x "$(command -v zypper)" ]]; then 
        install_command="sudo zypper install"
    elif [[ -x "$(command -v pacman)" ]]; then
        install_command="sudo pacman -S"
    else
        install_command="Package manager not identified. Minimal dependencies must be installed manually."
    fi
## pandoc    
    if [[ -x "$(command -v pandoc)" ]]; then
        printf "* pandoc (OK)\n* ffmpeg\n* sox\n"
    else
        $install_command pandoc
        printf "* pandoc (OK)\n* ffmpeg\n* sox\n"
    fi
## ffmpeg
    if [[ -x "$(command -v ffmpeg)" ]]; then
        printf "* pandoc (OK)\n* ffmpeg (OK)\n* sox\n"
    else
        $install_command ffmpeg
        printf "* pandoc (OK)\n* ffmpeg (OK)\n* sox\n"
    fi
## sox 
    if [[ -x "$(command -v sox)" ]]; then
        printf "* pandoc (OK)\n* ffmpeg (OK)\n* sox (OK)\n"
    else
        $install_command sox
        printf "* pandoc (OK)\n* ffmpeg (OK)\n* sox (OK)\n"
    fi
    echo "Dependencies have been installed."

# INSTALLING
## creating install dir
    printf "Where do you wanna install \"cvt\"? Default is $XDG/cvt-sh.\n For default, leave in blank."
    read -e -p "install dir: " install_dir
    current_dir=$(find $HOME/ -name cvt-sh -type d -exec dirname {}\;)

    if [[ -z "$install_dir" ]]; then
        mkdir $XDG/cvt-sh
        install_dir=$XDG/cvt-sh
        copy -r $current_dir/* $install_dir/
        rm -r $current_dir
    else 
        copy -r $current_dir/* $install_dir/
        rm -r $current_dir
    fi
    echo "Installing directory was created."
## defining variables
    echo "Defining variables..."
    sed -n -i 'p;3a "install_dir=$install_dir"' $install_dir/cvt.sh
    sed -n -i 'p;3a "install_dir=$install_dir"' $install_dir/pb/pb-tpl
    sed -n -i 'p;3a "install_dir=$install_dir"' $install_dir/pb/pb-tpl

    echo "Variables were defined."
    
    printf "\"cvt\" has been installed at \"$install_dir\".\n* To configure type \"cvt --config\"\n* To uninstall just delete \"$install_dir\"\n* For help type \"cvt --help\".\n"
 
