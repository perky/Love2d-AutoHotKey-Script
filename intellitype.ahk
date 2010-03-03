;  Intellitype: typing aid
;  Press 1 to 0 keys to autocomplete the word upon suggestion
;  (0 will match suggestion 10)
;                                  - Jordi S
;									- Editing by Luke P for tooltip function descriptors.
;___________________________________________

;    CONFIGURATIONS

; Editor Window Recognition
; (make it blank to make the script seek all windows)

ETitle =

;Minimum word length to make a guess
WLen = 3

keyagain=
key=
clearword=1
;Gosub,clearallvars   ; clean vars from start

; Press 1 to 0 keys to autocomplete the word upon suggestion
; (0 will match suggestion 10)
;_______________________________________

SetKeyDelay, 0
CoordMode, ToolTip, Relative
AutoTrim, Off
#EscapeChar `

;reads list of words from file
Loop, Read,  %A_ScriptDir%\Wordlist.txt   
{
   tosend = %a_loopreadline%
   cmd%a_index% = %toSend%
}
SetTimer, Winchanged, 100

Loop
{
   ;Editor window check
    WinGetActiveTitle, ATitle
    WinGet, A_id, ID, %ATitle%
    IfNotInString, ATitle, %ETitle%
    {
      ToolTip
      Setenv, Word,
      sleep, 500
      Continue
  }
   
   ;Get one key at a time
   Input, chr, L1 V,{enter}{space};`,:¿?¡!'"()]{}{bs}{esc}
   EndKey = %errorlevel%
   ; If active window has different window ID from before the input, blank word
   ; (well, assign the number pressed to the word)
   WinGetActiveTitle, ATitle
   WinGet, A_id2, ID, %ATitle%
   IfNotEqual, A_id, %A_id2%
   {
      Gosub,clearallvars
      Setenv, Word, %chr%
      Continue
   }
   
   ;Blanks word reserve
   ifequal, EndKey, Endkey:Enter, Gosub,clearallvars
   ifequal, EndKey, Endkey:Escape, Gosub,clearallvars
   ifequal, EndKey, Endkey:Space, Gosub,clearallvars
   ifequal, EndKey, Endkey:`,, Gosub,clearallvars
   ifequal, EndKey, Endkey:., Gosub,clearallvars
   ifequal, EndKey, Endkey:`:, Gosub,clearallvars
   ifequal, EndKey, Endkey:`;, Gosub,clearallvars
   ifequal, EndKey, Endkey:!, Gosub,clearallvars
   ifequal, EndKey, Endkey:¡, Gosub,clearallvars
   ifequal, EndKey, Endkey:?, Gosub,clearallvars
   ifequal, EndKey, Endkey:¿, Gosub,clearallvars
   ifequal, EndKey, Endkey:", Gosub,clearallvars
   ifequal, EndKey, Endkey:', Gosub,clearallvars
   ifequal, EndKey, Endkey:(, Gosub,clearallvars
   ifequal, EndKey, Endkey:), Gosub,clearallvars
;   ifequal, EndKey, Endkey:[, Gosub,clearallvars
   ifequal, EndKey, Endkey:], Gosub,clearallvars
   ifequal, EndKey, Endkey:{, Gosub,clearallvars
   ifequal, EndKey, Endkey:}, Gosub,clearallvars
   
   ifequal, EndKey, Endkey:), Gosub,cleartooltip
   ifequal, EndKey, Endkey:}, Gosub,cleartooltip
   ifequal, EndKey, Endkey:Enter, Gosub,cleartooltip
   
   ;Backspace clears last letter
   ifequal, EndKey, Endkey:BackSpace, StringTrimRight, Word, Word, 1
   ifnotequal, EndKey, Endkey:BackSpace, Setenv, Word, %word%%chr%
   
   ;Wait till minimum letters
   StringLen, len, Word
   IfLess, len, %wlen%
   {
      ToolTip
      Continue
   }
   
   ;Match part-word with command
   Num =
   Match =
   singlematch = 0
   number = 0
   Loop
   {
      IfEqual, cmd%a_index%,, Break
      StringLen, chars, Word
      StringLeft, strippedcmd, cmd%a_index%, %chars%
      StringLeft, strippedword, Word, %chars%
      ifequal, strippedcmd, %strippedword%
      {
         num = %a_index%
         number ++
		 if (number > 10) {
			Break
		}
         ; Create list of matches
		 delim := "#"
		 
		 StringTrimLeft, singlematch, cmd%num%, 0
		 StringGetPos, pos2, singlematch, %delim%, R1
		 if (pos2 != -1){
			;StringGetPos, pos2, singlematch, %delim%, R1
			singlematch := SubStr(singlematch, 1, pos2)
			AutoTrim, On
			singlematch = %singlematch%
			AutoTrim, Off
		 }
		 
		 if (singlematch = word) {
			number --
			Continue
		 }
		 
         match = %match%%number%. %singlematch%`n

         ; Map singlematch with corresponding cmd
         singlematch%number%=cmd%num%

         Continue
      }
   }

   ;If no match then clear Tip
   IfEqual, Num,
   {
      clearword=0
      Gosub,clearallvars
      Continue
   }
   
   ;Show matched command
   StringTrimRight, match, match, 1        ; Get rid of the last linefeed
;   IfNotEqual, Word,,ToolTip, %match%, 388, 24
   display_y = %A_CaretY%
   display_y += 20 ; Move tooltip down a little so as not to hide the caret.
   IfNotEqual, Word,,ToolTip, %match%, %A_CaretX%, %display_y%


}

; Timed function to detect change of focus (and remove tooltip when changing active window)
Winchanged:
   WinGetActiveTitle, ATitle
   WinGet, A_id3, ID, %ATitle%
   IfNotEqual, A_id, %A_id3%
   {
      ToolTip
   }
   Return
   
; Key definitions for autocomplete (0 to 9)
#MaxThreadsPerHotkey 1
$1::
key=1
Gosub, checkword
Return

$2::
key=2
Gosub, checkword
Return

$3::
key=3
Gosub, checkword
Return

$4::
key=4
Gosub, checkword
Return

$5::
key=5
Gosub, checkword
Return

$6::
key=6
Gosub, checkword
Return

$7::
key=7
Gosub, checkword
Return

$8::
key=8
Gosub, checkword
Return

$9::
key=9
Gosub, checkword
Return

$0::
key=10
Gosub, checkword
Return


; If hotkey was pressed, check wether there's a match going on and send it, otherwise send the number(s) typed
checkword:
   clearword=1
   Suspend, on    ; Suspend hotkeys so that they don't interfere with the second press

   ; If active window has different window ID from before the input, blank word
   ; (well, assign the number pressed to the word)
   WinGetActiveTitle, ATitle
   WinGet, A_id2, ID, %ATitle%
   IfNotEqual, A_id, %A_id2%
      {
         if key =10
            key = 0
         Send,%key%
         Gosub,clearallvars
         Suspend, off
         Return
      }

   if word=        ; only continue if word is not empty
      {
         if key =10
            key = 0
         Send,%key%
         Setenv, Word, %key%
         clearword=0
         Gosub,clearallvars
         Suspend, off
         Return
      }
   
   ifequal, singlematch%key%,   ; only continue singlematch is not empty
      {
         if key =10
            key = 0
         Send,%key%
         Setenv, Word, %word%%key%
         clearword=0
         Gosub,clearallvars
         Suspend, off
         Return
      }

   ; 2nd press to confirm replacement
   Input, keyagain, L1 I T0.5, 1234567890

;   msgbox, ErrorLevel=%ErrorLevel%   ; UNCOMMENT FOR TESTING 2ND PROBLEM DISCUSSED IN POST

   ; If there is a timeout, abort replacement, send key and return
   IfEqual, ErrorLevel, Timeout
   {
      if key =10
         key = 0
      Send, %key%
      Setenv, Word, %word%%key%
      clearword=0
      Gosub,clearallvars
      Suspend, off
      Return
   }
   
     
   ; Make sure it's an EndKey, otherwise abort replacement, send key and return
   IfNotInString, ErrorLevel, EndKey:
   {
      if key =10
         key = 0
      Send, %key%%keyagain%
      Setenv, Word, %word%%key%%keyagain%
      clearword=0
      Gosub,clearallvars
      Suspend, off
      Return
   }

   ; If the 2nd key is NOT the same 1st trigger key, abort replacement and send keys
   if key =10
      key = 0
   IfNotInString,ErrorLevel, %key%
   {
     StringTrimLeft, keyagain, ErrorLevel, 7
      Send, %key%%keyagain%
      Setenv, Word, %word%%key%%keyagain%
      clearword=0
      Gosub,clearallvars
      Suspend, off
      Return
   }

   ; SEND THE WORD!
   if key =0
      key = 10
	delim := "#"
   StringTrimLeft, lastone, singlematch%key%, 0 ; This is because i can't get %singlematch%%key%
   StringLen, len2, %lastone%
   
   StringGetPos, pos2, %lastone%, %delim%, R1
   if (pos2 == -1){
    pos2 = %len2%
   }
   
   StringLen, len, Word
   
   StringTrimLeft, message, %lastone%, pos2+1
   sending := SubStr(%lastone%, 1, pos2)
   
	AutoTrim, On
   sending = %sending%
	AutoTrim, Off
	
   Send, {BS %len%}    ; First do the backpaces
   SendRaw, %sending%  ; Then send word (Raw because we want the string exactly as in wordlist.txt)
   Gosub,clearallvars

   StringReplace, message, message, \n, `n, All
   display_y += 20
   ToolTip, %message%, %A_CaretX%, %display_y%, 2

   Suspend, off
   Return


; This is to blank all vars related to matches, tooltip and (optionally) word
cleartooltip:
	ToolTip
	ToolTip, , , , 2
return
clearallvars:
      ;Ifequal,clearword,1,Setenv,word,
	  word = %sending%
      ;ToolTip
      ;ToolTip, , , , 2
      ; Clear all singlematches
      Loop, 10
      {
         singlematch%a_index% =
      }
      sending =
      key=
      match=
      clearword=0
      Return