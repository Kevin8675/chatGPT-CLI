# ChatGPT-CLI
A simple shell script to give a CLI to the new ChatGPT API.

## Dependencies
This script needs curl to make api requests and jq to process the JSON API response. It also needs an OpenAI API key to authenticate with servers.

* [curl](https://www.curl.se)
* [jq](https://stedolan.github.io/jq/)
* [OpenAI API Key](https://platform.openai.com/account/api-keys)

## Installation
Simply add the cgpt.sh file to PATH.

## Usage

### Run
Simply run the *cgpt.sh* file in terminal to start a chat. On first run (or if no config file is found), it will ask for API Key and personality.

### Options
```
-a: Change API Key
-p: Change personality
```

## To do list
- [*] Add error parser
- [ ] Auto escape special symbols
- [ ] Add install script
- [ ] Change user name setting
- [ ] Add presets for different personalities
