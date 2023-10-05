#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 input_package_name"
    exit 1
fi


download(){
    matching_line=$(adb shell pm path $1 | grep "base.apk")

    # Check if a matching line was found
    if [ -n "$matching_line" ]; then
        # Remove the prefix "package :" using sed
        path=$(echo "$matching_line" | sed 's/package://')

        # Use adb pull with the extracted path
        adb pull "$path" "./$1.apk"

        # Check if adb pull was successful
        if [ $? -eq 0 ]; then
            echo "File pulled successfully."
        else
            echo "Error: adb pull failed."
        fi
    else
        echo "No exact matches searching all packages......"
        adb shell pm list packages | grep $1

        package_result=$(adb shell pm list packages | grep "$1")
        
        # Check if a matching package name was found
        if [ -n "$package_result" ]; then
            # Remove the "package :" prefix using sed
            package_name=$(echo "$package_result" | sed 's/package://')
            read -p "Found <$package_name> is that the one? (Y/N)? " choice

            # Check if the input is "Y" or "y"
            if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
                echo "You chose to proceed."
                
                download $package_name
            else
                echo "You chose not to proceed."
            fi
        else
            echo "No app found called $1"
        fi

            
    fi

}



download $1




