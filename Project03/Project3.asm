TITLE Programming Assignment #3    (Project3.asm)

; Author: Max MacEachern
; Course / Project ID - CS 271            Date: 5/1/16
; Description: This program allows the user to enter negative numbers and then calculates the sum and the average of those numbers.
;			   If the user enters a negative number less than -100, the program prompts the user for additional number, but if the user
;              enters a number greater than -1, the program ends asking the user for input and moves to calculate the sum and average.
;**EC: I added numbered lines for the user input section per the requirements in the assignment
 
INCLUDE Irvine32.inc


.data
welcomeMessage		BYTE			"Welcome to the Integer Accumulator by Max MacEachern", 0
namePrompt			BYTE			"What is your name? ", 0
helloMessage		BYTE			"Hello, ", 0
limitMessage		BYTE			"Please enter numbers in a range of [-100, -1].", 0
exitMessage			BYTE			"Enter a non-negative number when you are finished to see results.", 0
numPrompt			BYTE			"  Enter a number: ", 0
inputMessage1		BYTE			"You entered ", 0
inputMessage2		BYTE			" valid numbers.", 0
sumMessage			BYTE			"The sum of your valid numbers is ", 0
aveMessage			BYTE			"The rounded average is ", 0
goodbyeMessage		BYTE			"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
periodMessage		BYTE			".", 0
extraCredit			BYTE			"**EC: Added numbered lines to the user input", 0
userName			BYTE 32 DUP		(0)
userNum				DWORD			?
sum					DWORD			?
lineCount			DWORD			1
total				DWORD			?
ave					DWORD			?
floor				DWORD			-100
ceiling				DWORD			0


.code
main PROC

;Welcome Message
mov		edx, OFFSET welcomeMessage
call	WriteString
call	CrLf

;Get user name
mov		edx, OFFSET namePrompt
call	WriteString
mov		edx, OFFSET userName
mov		ecx, 33
call	ReadString

;Welcome user
mov		edx, OFFSET helloMessage
call	WriteString
mov		edx, OFFSET userName
call	WriteString
mov		edx, OFFSET periodMessage
call	WriteString
call	CrLf

;Give instructions to the user
mov		edx, OFFSET limitMessage
call	WriteString
call	CrLF
mov		edx, OFFSET exitMessage
call	WriteString
call	CrLf

InputLoop:
		;Get user input
		mov		eax, lineCount
		call	WriteDec
		mov		edx, OFFSET periodMessage
		call	WriteString
		mov		edx, OFFSET numPrompt
		call	WriteString
		call	ReadInt
		mov		userNum, eax
		
		;Increment the line counter for the EC
		inc		lineCount
		
		;Data validation
		cmp		eax, floor
		jl		InputLoop
		cmp		eax, ceiling
		jg		Calculation

		;Add valid data to sum, update number of inputs
		mov		eax, sum
		add		eax, userNum
		mov		sum, eax
		inc		total

		;Do it again if valid input and not a positive number
		loop	InputLoop

Calculation:
		
		;First display user input
		mov		edx, OFFSET inputMessage1
		call	WriteString
		mov		eax, total
		call	WriteDec
		mov		edx, OFFSET inputMessage2
		call	WriteString
		cmp		total, 0					;Move to goodbye if there were no non-negatives entered
		je		Goodbye			

		;Output the sum of the user input
		mov		edx, OFFSET sumMessage
		call	WriteString
		mov		eax, sum
		call	WriteInt
		call	CrLf

		;Next calculate the average
		mov		eax, sum
		cdq
		mov		ebx, total
		idiv	ebx
		mov		ave, eax

		;Print Average
		mov		edx, OFFSET aveMessage
		call	WriteString
		mov		eax, ave
		call	WriteInt
		call	CrLf

Goodbye:
		;Print goodbye messages
		mov		edx, OFFSET goodbyeMessage
		call	WriteString
		mov		edx, OFFSET userName
		call	WriteString
		mov		edx, OFFSET extraCredit
		call	WriteString


	exit	; exit to operating system
main ENDP


END main
