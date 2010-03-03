Love2d Auto-complete Functions
==============================

What is it?
-----------
This is an AutoHotKey script that allows you
to see suggested completions in any text editor on windows.
Simple start typing a function and a tooltip will appear with
up to 10 suggested functions.

To select a function type the corresponding number **twice**.
Not only will it add in the function but you can have tooltip
descriptions of the function!

Why use AutoHotkey?
-------------------
I initially though to make a notepad++ plugin as that has
support for text completion but seeing as people use different
editors I used AutoHotkey because it works in _any_ editor!

How to edit or add functions
----------------------------
All the functions are stored in a .txt file called wordlist.txt.
Open it up and you'll see it's simply one word per line.
You can also add a description using # followed by your description.

To set a standard of love2d descriptions use this layout:

	Description here.
	 ARGUMENT:type => Description of argument.
	 ARGUMENT:type => Description of argument.
	 RETURNS name:type => Description of name.

Here is an example template:

	#Description of function. \n ARGUMENT:type => Description of argument. \n ARGUMENT:type => Description of argument. \n RETURNS nothing.

If the function returns nothing, state it:

	 RETURNS nothing.

If the function returns multiple values of the same type use this format:

	 RETURNS a,b,c,d:type => Description of returns.

Alternativly you can have each return on a new line:

	 RETURNS a:type => Description of return.
	 RETURNS b:type => Description of return.

If the function is overloaded, state it with a newline between each set of arguments:

	OVERLOADED: Description of function.
	
	 ARGUMENT_A:type => Description of argument.
	 ARGUMENT_B:type => Description of argument.
	
	 ARGUMENT_C:type => Description of argument.
	
	 RETURNS a:type => Description of return.

EndOfFile.