#!/bin/bash

# Create config file if not found
if [ ! -f $HOME/.config/cgpt/cgpt.conf ]; then
    if [ ! -d $HOME/.config/cgpt ]; then
        mkdir $HOME/.config/cgpt
    fi
    touch $HOME/.config/cgpt/cgpt.conf

    # Set API Key and Personality
    echo "Please enter OpenAI API key. (see https://platform.openai.com/account/api-keys)"
    read -p ">" API
    echo "API=$API" >> $HOME/.config/cgpt/cgpt.conf
    echo "Please enter assistant personality. Leave empty for no personality."
    read -p ">" PROMPT
    echo "PROMPT=\"$PROMPT\"" >> $HOME/.config/cgpt/cgpt.conf
fi

# Change API Key
function api {
    echo "Please enter OpenAI API key. (see https://platform.openai.com/account/api-keys)"
    read -p ">" API
    sed -i "s/API=.*/API=$API/" $HOME/.config/cgpt/cgpt.conf
    echo "API Key changed."
    exit 0
}

# Change AI Personality
function personality {
    echo "Please enter assistant personality. Leave empty for no personality."
    read -p ">" PROMPT
    sed -i "s/PROMPT=.*/PROMPT=\"$PROMPT\"/" $HOME/.config/cgpt/cgpt.conf
    echo "Personality changed."
    exit 0
}

# Parse arguments
while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--personality)       personality ;;
        -a|--api-key)           api ;;
        --help)                 printf "Usage: cgpt [-a,-p]\n    -a: Change API key.\n    -p: Change assistant personality.\nChatGPT CLI written in bash.\n"; exit 0 ;;
        *)                      printf "cgpt: unrecognized option '$1'\nTry 'cgpt --help' for more information.\n"; exit 1 ;;
    esac
    shift
done

# Read config file
source $HOME/.config/cgpt/cgpt.conf

echo "Starting a new chat. Enter \"exit\" to exit."

# Set personality
messages="{\"role\": \"system\", \"content\": \"$PROMPT\"},"

# Print personality
printf "Assistant Personality (use cgpt -p to change):\n$PROMPT\n\n"

# Loop for Chat
while true; do
    # Read user message
    read -p "User: " INPUT

    # Exit if message is "exit"
    if [[ $INPUT = "exit" ]]; then
        exit 0
    fi

    # Add user message to api request
    messages+="{\"role\": \"user\", \"content\": \"$INPUT\"}"

    echo "Getting response..."

    # Make HTTP API request
    response=$(curl https://api.openai.com/v1/chat/completions \
        -s \
        -H 'Content-Type:application/json' \
        -H "Authorization:Bearer $API" \
        -d "{
            \"model\": \"gpt-3.5-turbo\",
            \"messages\": [$messages]
        }"
    )

    # Extract ChatGPT response message from API response
    response_msg=$(echo $response | jq -r '.choices[].message.content')

    # Add ChatGPT message to next API request (so conversations can be continued)
    messages+=",{\"role\": \"assistant\", \"content\": \"$response_msg\"},"

    # Print ChatGPT response
    echo "Assistant: $response_msg"
done
