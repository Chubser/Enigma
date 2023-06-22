#!/bin/bash

reg_filename="[a-zA-Z]+\."
reg_message="^[A-Z ]+$"
key=3

function print_menu(){
echo """0. Exit
1. Create a file
2. Read a file
3. Encrypt a file
4. Decrypt a file
Enter an option:"""
}

function process_input(){
    read input
    case $input in 
        '0')
            echo "See you later!"
            exit
            ;;
        '1')
            option_1
            ;;
        '2')
            option_2
            ;;
        '3')
            option_3
            ;;
        '4')
            option_4
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
}

function option_1(){
    echo "Enter the filename:"
    read filename
    if [[ $filename =~ $reg_filename ]]; then
        echo "Enter a message:"
        read message
        if [[ $message =~ $reg_message ]]; then
            echo $message >> $filename 
            echo "The file was created successfully!"  
        else
            echo "This is not a valid message!"
        fi
    else
        echo "File name can contain letters and dots only!"
    fi
}

function option_2(){
    echo "Enter the filename:"
    read filename
    if [[ -f $filename ]]; then
        echo "File content:"
        cat $filename
    else
        echo "File not found!"
    fi
}

function option_3(){
    echo "Enter the filename:"
    read filename
    if [[ -f $filename ]]; then
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$filename" -out "$filename.enc" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            echo "Success"
            rm $filename
        fi
    else
        echo "File not found!"
    fi
}

function option_4(){
    echo "Enter the filename:"
    read filename
    if [[ -f $filename ]]; then
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$filename" -out "$(echo $filename | cut -d '.' -f 1-2)" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            echo "Success"
            rm $filename
        fi
    else
        echo "File not found!"
    fi
}

echo "Welcome to the Enigma!"
while(true);
do
    print_menu
    process_input
done
