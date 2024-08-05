#!/bin/bash

# Function for Caesar cipher encryption and decryption
caesar_cipher() {
    local text="$1"
    local shift="$2"
    local mode="$3"
    local result=""

    if [[ "$mode" == "decrypt" ]]; then
        shift=$((26 - shift))
    fi

    for ((i = 0; i < ${#text}; i++)); do
        char="${text:$i:1}"
        if [[ "$char" =~ [A-Za-z] ]]; then
            if [[ "$char" =~ [A-Z] ]]; then
                base=65
            else
                base=97
            fi
            offset=$(( ( $(printf "%d" "'$char") - base + shift ) % 26 ))
            new_char=$(printf "\\$(printf "%03o" $((offset + base)))")
            result+="$new_char"
        else
            result+="$char"
        fi
    done

    echo "$result"
}

# Function for Vigenère cipher encryption and decryption
vigenere_cipher() {
    local text="$1"
    local key="$2"
    local mode="$3"
    local result=""
    local key_length=${#key}

    for ((i = 0, j = 0; i < ${#text}; i++)); do
        char="${text:$i:1}"
        if [[ "$char" =~ [A-Za-z] ]]; then
            if [[ "$char" =~ [A-Z] ]]; then
                base=65
                key_char=${key:$((j % key_length)):1}
                key_shift=$(( $(printf "%d" "'${key_char^^}") - 65 ))
            else
                base=97
                key_char=${key:$((j % key_length)):1}
                key_shift=$(( $(printf "%d" "'${key_char,,}") - 97 ))
            fi

            if [[ "$mode" == "decrypt" ]]; then
                key_shift=$((26 - key_shift))
            fi

            offset=$(( ( $(printf "%d" "'$char") - base + key_shift ) % 26 ))
            new_char=$(printf "\\$(printf "%03o" $((offset + base)))")
            result+="$new_char"
            j=$((j + 1))
        else
            result+="$char"
        fi
    done

    echo "$result"
}

# Function for Atbash cipher
atbash_cipher() {
    local text="$1"
    local result=""

    for ((i = 0; i < ${#text}; i++)); do
        char="${text:$i:1}"
        if [[ "$char" =~ [A-Za-z] ]]; then
            if [[ "$char" =~ [A-Z] ]]; then
                base=65
                new_char=$(printf "\\$(printf "%03o" $((90 - ( $(printf "%d" "'$char") - base ))))")
            else
                base=97
                new_char=$(printf "\\$(printf "%03o" $((122 - ( $(printf "%d" "'$char") - base ))))")
            fi
            result+="$new_char"
        else
            result+="$char"
        fi
    done

    echo "$result"
}

# Function for Base64
base_64() {
    local text="$1"
    local mode="$2"

    if [[ "$mode" == "decrypt" ]]; then
        echo "$text" | base64 --decode
    elif [[ "$mode" == "encrypt" ]]; then
        echo "$text" | base64
    else
        echo "wrong input"
    fi
}

# Function for Base32
base_32() {
    local text="$1"
    local mode="$2"

    if [[ "$mode" == "decrypt" ]]; then
        echo "$text" | base32 --decode
    elif [[ "$mode" == "encrypt" ]]; then
        echo "$text" | base32
    else
        echo "wrong input"
    fi
}

# Function for Hexadecimal
hex() {
    local text="$1"
    local mode="$2"

    if [[ "$mode" == "decrypt" ]]; then
        echo "$text" | xxd -r -p
    elif [[ "$mode" == "encrypt" ]]; then
        echo -n "$text" | xxd -p
    else
        echo "wrong input"
    fi
}

# Main menu
while true; do
    echo "Choose a cipher:"
    echo "1) Caesar Cipher"
    echo "2) Vigenère Cipher"
    echo "3) Atbash Cipher"
    echo "4) Base64"
    echo "5) Base32"
    echo "6) Hexadecimal"
    echo "8) Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter text: " text
            read -p "Enter shift (1-25): " shift
            read -p "Encrypt or Decrypt (e/d): " action
            if [[ "$action" == "e" ]]; then
                mode="encrypt"
            else
                mode="decrypt"
            fi
            echo "Result: $(caesar_cipher "$text" "$shift" "$mode")"
            ;;
        2)
            read -p "Enter text: " text
            read -p "Enter key: " key
            read -p "Encrypt or Decrypt (e/d): " action
            if [[ "$action" == "e" ]]; then
                mode="encrypt"
            else
                mode="decrypt"
            fi
            echo "Result: $(vigenere_cipher "$text" "$key" "$mode")"
            ;;
        3)
            read -p "Enter text: " text
            echo "Result: $(atbash_cipher "$text")"
            ;;
        4)
            read -p "Enter text: " text
            read -p "Encrypt or Decrypt (e/d): " action
            if [[ "$action" == "e" ]]; then
                mode="encrypt"
            else
                mode="decrypt"
            fi
            echo "Result: $(base_64 "$text" "$mode")"
            ;;
        5)
            read -p "Enter text: " text
            read -p "Encrypt or Decrypt (e/d): " action
            if [[ "$action" == "e" ]]; then
                mode="encrypt"
            else
                mode="decrypt"
            fi
            echo "Result: $(base_32 "$text" "$mode")"
            ;;
        6)
            read -p "Enter text: " text
            read -p "Encrypt or Decrypt (e/d): " action
            if [[ "$action" == "e" ]]; then
                mode="encrypt"
            else
                mode="decrypt"
            fi
            echo "Result: $(hex "$text" "$mode")"
            ;;
        7)
            read -p "Enter the encoded JavaScript: " encoded_js
            echo "Decoded JavaScript:"
            decrypt_js "$encoded_js"
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
