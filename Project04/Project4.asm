TITLE Project 4     (Project4.asm)

; Author: Max MacEachern
; Course / Project ID  CS 271 Project 4           Date: 5-8-16
; Description: This program prompts the user for the number of composite numbers they would like to see and returns the sequence of numbers.
;			   Two different loops are used to determine the number and if there is a divisor that would yield a remainder of zero (i.e. a
;              composite number).

INCLUDE Irvine32.inc

;Constant Definitions
UPPERLIMIT = 400
LOWERLIMIT = 1
COMPSTART = 4
DIVISORSTART = 2

.data
;Variable declartions
welcomeMessage		BYTE		"Composite Numbers        Programmed by Max MacEachern",0
infoMessage			BYTE		"Enter the number of composite numbers you would like to see.",0
uptoMessage			BYTE		"I'll accept orders for up to 400 composites.",0
numPrompt			BYTE		"Enter the number of composites to display [1 .. 400]: ",0
highPrompt			BYTE		"The number you entered is too high. Try again.",0
lowPrompt			BYTE		"The number you entered is too low. Try again.",0
farewellMesssage	BYTE		"Results certified by Max MacEachern. Have a good day! Goodbye.",0
spaceOffset			BYTE		"   ",0
userInput			DWORD		?	
lineCounter			DWORD		0
compNum				DWORD		0

.code
main PROC
		call	introduction
		call	getUserData
		call	showComposites
		call	farewell
		exit											; exit to operating system
main ENDP

introduction PROC
		mov		edx, OFFSET welcomeMessage				;Greet user with title and author
		call	WriteString
		call	CrLf
		call	CrLF
		mov		edx, OFFSET infoMessage					;Give direction to the user
		call	WriteString
		call	CrLf
		mov		edx, OFFSET uptoMessage					;Highlight program constraints 
		call	WriteString
		call	CrLF
		ret
introduction ENDP

getUserData PROC
		mov		edx, OFFSET numPrompt					;Ask user to enter the number composite numbers they'd like to see
		call	WriteString
		call	ReadInt
		mov		userInput, eax
		call	validate								;Call validate procedure to ensure input is within bounds
		ret

getUserData ENDP

validate PROC
		mov		eax, userInput
		cmp		eax, UPPERLIMIT							;Compare to upper limit, if too high, let user know
		jg		tooHigh
		cmp		eax, LOWERLIMIT							;Compare to lower limit, if too low, let user know
		jl		tooLow
		ret												;If the code reaches this, the input is valid

	tooHigh:
		mov		edx, OFFSET highPrompt					;Informs the user their number is too high
		call	WriteString
		call	CrLF
		jmp		getUserData								;Loop back to user input section

	tooLow:
		mov		edx, OFFSET lowPrompt					;Informs the user their number is too low
		call	WriteString
		call	CrLF
		jmp		getUserData								;Loop back to user input section
validate ENDP

showComposites PROC
		mov		ecx, userInput							;User input is effectively a loop counter and will be used as such
		mov		eax, COMPSTART							;Minimum composite number if 4						
		mov		compNum, eax							;Assigned to the initial value of compNum
		mov		ebx, DIVISORSTART						;Minimum possible divisor for a composite number is 2, initialize there

	compositeLoop:

		call	isComposite								;Call procedure to determine the number is composite

		mov		eax, compNum							;Prints the currently calculated composite number
		call	WriteDec
		inc		compNum

		inc		lineCounter								;Once composite number is found, the lineCounter is incremented
		mov		eax, lineCounter
		cmp		eax, 10									;If the lineCounter is at 10, go to new line, otherwise add spacing
		js		spacing
		jns		nextLine
		
	spacing:
		mov		edx, OFFSET spaceOffset
		call	WriteString
		jmp		jumpBack

	nextLine:
		call	CrLf
		mov		eax, lineCounter
		sub		eax, 10
		mov		lineCounter, eax						;Reset the lineCounter to zero

	jumpBack:
		mov		ebx, DIVISORSTART						;Reset starting divisor
		mov		eax, compNum
		loop	compositeLoop
		
	ret		

showComposites ENDP

isComposite PROC
		
	divisorLoop:
		cmp		ebx, eax								;If this is zero, then all potential divisors have been exhausted
		je		notComposite							;If so, jump to this code

		cdq												;A number is a composite if it divides evenly
		div		ebx
		cmp		edx, 0									;A number divides evenly if there is a remainder of zero
		je		composite								;If the comparison yields a zero, jump to the composite code
		jne		incDivisor								;If not, jump to the code that increases the divisor

	composite:
		ret												;If a clean divisor is found, implying a composite number, return

	incDivisor:
		mov		eax, compNum							;Increments the divisor if the previous one did not yield a composite number
		inc		ebx
		jmp		divisorLoop

	notComposite:										;If the number is not a composite number, this is run
		inc		compNum									;The next possible composite number is set by incrementing compNum
		mov		eax, compNum
		mov		ebx, DIVISORSTART						;Reset the lowest possible divisor
		jmp		divisorLoop								;Head back to the start of the loop

isComposite ENDP

farewell PROC
		call	CrLf		
		mov		edx, OFFSET farewellMesssage			;Say goodbye!
		call	WriteString
		call	CrLf
		ret
farewell ENDP
END main
