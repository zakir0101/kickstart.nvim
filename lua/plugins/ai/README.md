# Prompt 

I want to create a nvim lua plugin for chatting with LLm models inside of neovim , for that I have to create a function called toggle_ai_chat() , this function should create 2 buffer ( not listed in the buffer list ) , one for the user input and one for the AI response and chat history ,

then the function open each buffer in a seperated window on top of each other ( horizontal split ) the user input buffer should be on the bottom and the AI response buffer should be on the top of it , and both of them should be in a verival split with the existing windows, at the right most end.


the user input buffer should be in insert mode and the AI response buffer should be in normal mode ( readonly) .

the user input buffer should have a border around it and the AI response buffer should have a border around it , the user input buffer should have a border with the title "User Input" and the AI response buffer should have a border with the title "AI Chat", the chat window should have a larger height than the input window , the user input buffer should have a border with the color #FF0000 and the AI response buffer should have a border with the color #00FF00 

both window should be non movable and fixed at the right most end of the screen ,

there are other specifications , but for now I want you to implement this only .


# prompt 2

wow , your so genious .

but there is some issues. for instance height of user input + height of AI chat should [almost] fill the whole screen height , but now it is too short.


# prompt 3

thanks great but there a little issues , because the window is floating currently , which looks great , but is not desired , it should be normal window , but fixed at the right most end of the screen , also consider that we want the same fuctino to TOGGLE the window , this means if it was already open it should close it ( both windows )

I have corrected some syntax errors in code , here is the current version :


# prompt 4

very good , lets move to next step.

first thing is to change the buffer type of the AI chat buffer from scratch file to non-scratch file  , this means it should not be saved to disk ( in a special dir called .genai\ ) , but it should not be listed in the buffer list .

# .genai directory

when user first call the function , it should check for a directory in the current project ".genai" , if it does not exist , all conversations will be saved in this directory, each conversation in a separate file ( chat_1.md , chat_2.md ..), this directory also save the current prompt file "prompt.md" ( which is md file for now ) .
each conversation file is a md file , with some tags in it , to seperate user query from AI response , here is an example :
```chatmd
<<user>>
hello
<<ai [model_name]>>
hello , how can I help you ?
```
or similar [later we can focus more on the specification of the chat file, and write a custom highlighter and parser for it]

add a state variable for tracking the current conversation file, and current model name.

# send prompt function
add a function for sending prompts to the selected model ( for now just a mockup function ) , the function should :
1. first verify that the both windows are open, if not it should only open them and return .
2. it should get the user input from the user input buffer , and send it to the model ( only mockup for now you can just return a random response ) , then it clear the input buffer and save it to ".genai\prompt.md".
3. it should stream the mock response to the AI chat buffer , and save it to the current conversation file .
4. add shortcut for this new function like <leader>gs and a description as well


some modifications to the toggle function :
1. add state for tracking current chat and current model
2. at the first start, if .genai dir or .genai\prompt.md file does not exist , it should create them
3. if the windows are already open , it should hide the window without closing the buffers , and show again with the same previous buffers


- after sending first query , and finshing streaming the response, a file should be created in the .genai dir with the name chat_[/d].md , and as we said prompt.md should be cleared ( empty file ) and saved , as preparation for the next prompt .


# Prompt 5

okay , I have modified the code intensively , fixed alot of bugs , and added more funciton to make it more readable .

I will send you the new code , you have to digest it and understand it, then at the bottom there are some task you need to solve , to proove that you understand the curren code structer .

here is the code :

```lua
```
