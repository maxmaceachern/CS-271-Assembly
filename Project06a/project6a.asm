TITLE Programming Assignment 6A     (project6a.asm)

; Author: Max MacEachern
; Course / Project ID  CS 271               Date: 6/5/16
; Description: This program takes in user input as a string and outputs the numberic form using written ReadVal and WriteVal.
;			   If the numbers are signed or if they are too large, error handling will occur.
;			   The sum and average of the inputted numbers will be calculated and displayed to the user.

INCLUDE Irvine32.inc


.data

introduction01		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures, written by Max MacEachern",0
introduction02		BYTE	"Please provide 10 unsigned decimal integers.",0
introduction03		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
introduction04		BYTE	"After you've finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
numPrompt			BYTE	"Please enter an unsigned number: ", 0
errorPromptHigh		BYTE	"ERROR: YOUR NUMBER WAS TOO BIG SO I AM GOING TO YELL AT YOU IN ALL CAPS! TRY AGAIN: ",0
errorPromptNotUS	BYTE	"ERROR: YOU DID NOT ENTER AN UNSIGNED NUMBER SO I AM GOING TO YELL AT YOU IN ALL CAPS! TRY AGAIN: ",0
inputFeedback		BYTE	"You entered the following numbers:",0
sumFeedback			BYTE	"The sum of these numbers is: ", 0
aveFeedback			BYTE	"The average is: ",0
closingMessage		BYTE	"Thanks for playing!",0
strbuffer			BYTE	255 DUP(0)
stringTemp			DB		16 DUP(0)
comma				BYTE	", ",0
sum					DWORD	?
ave					DWORD	?
listArr				DWORD	10 DUP(0)

; ******************************************************************************************************
; getString MACRO
; Description :		 Used to read the input string from the user
; ******************************************************************************************************
getString	MACRO add, len	
	push	edx
	push	ecx
	mov  	edx, add
	mov  	ecx, len
	call 	ReadString
	pop		ecx
	pop		edx
ENDM

; ******************************************************************************************************
; displayString MACRO
; Description :		 Used to output a string
; ******************************************************************************************************
displayString	MACRO	disString
	push	edx
	mov		edx, OFFSET disString
	call	WriteString
	pop		edx
ENDM


.code
main PROC

	;Call intoduction message
	call	intro
	
	;Inititalize the loop
	mov		ecx, 10
	mov		edi, OFFSET listArr

	;Call input procedure
	call	userInput

	;Call array output procedure to display entered array to the user
	call	disArray

	;Call procedure to calculate sum
	call	calcSum

	;Call procedure to calculate average
	call	calcAverage

	;Say goodbye to the user
	call	goodBye

	exit	; exit to operating system
main ENDP

; ******************************************************************************************************
; intro PROCEDURE
; Description :	Simply displays the instructions to the user
; ******************************************************************************************************
intro PROC
	displayString	introduction01
	call	CrLf
	displayString	introduction02
	call	CrLf
	displayString	introduction03
	call	CrLf
	displayString	introduction04
	call	CrLf
	call	CrLf
intro ENDP

; ******************************************************************************************************
; readVal PROCEDURE
; Description :	Procedure to get and validate user input in the form of a string and converts it to
;				a number. Utilizes the getString macro to do so.
; ******************************************************************************************************
readVal PROC
	push	ebp
	mov		ebp, esp
	pushad

InputLoop:
	mov		edx, [ebp+12]	;strbuffer is located here in the stack
	mov		ecx, [ebp+8]	;size of strbuffer

	getString	edx, ecx	;Read input from user

	mov		esi, edx		;Set up registers to do the validation
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10

LoadString:
	lodsb					;Grab what is stored at esi
	cmp		ax, 0			;Used to determine if at the end of the string
	je		Finished

	cmp		ax, 57			;Check if nine in ASCII
	ja		ErrorTooHigh
	cmp		ax, 48			;Check if zero in ASCII
	jb		ErrorNotUS
	
	sub		ax, 48
	xchg	eax, ecx		;swap eax, ecx
	mul		ebx				;used to find the correct number
	jc		ErrorTooHigh
	jnc		Validated

ErrorTooHigh:
	displayString	errorPromptHigh
	jmp				InputLoop

ErrorNotUS:
	displayString	errorPromptNotUS
	jmp				InputLoop

Validated:
	add		eax, ecx
	xchg	eax, ecx		;Reset for the next iteration of the loop
	jmp		LoadString		;Go back to the beginning of the loop
	
Finished:
	xchg	ecx, eax
	mov		DWORD PTR strbuffer, eax	;Save variable
	popad
	pop ebp
	ret 8
readVal ENDP

; ******************************************************************************************************
; writeVal PROCEDURE
; Description :	Used to convert the interger to the string and output it to the user.
; ******************************************************************************************************
writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad		

;Set for looping through the integer
	mov		eax, [ebp+12]	;move to interact with input to convert to string
	mov		edi, [ebp+8]	;store address
	mov		ebx, 10
	push	0

ConvertLoop:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx				;push next digit onto stack

	cmp		eax, 0			;Used to check if at the end
	jne		ConvertLoop

PopLoop:
	pop		[edi]			;Pop number off the stack
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0			;Used to check if at the end
	jne		PopLoop

	mov				edx, [ebp+8]
	displayString	OFFSET stringTemp		;Write string using the displayString macro

	popad					;restore the registers to their original state
	pop ebp
	ret 8
writeVal ENDP


; ******************************************************************************************************
; userInput PROCEDURE
; Description :	Used to take in 10 numbers provided by the user and work with the data
; ******************************************************************************************************
userInput PROC

InputLoop:
	displayString	numPrompt

	push	OFFSET strbuffer
	push	SIZEOF strbuffer
	call	ReadVal


	mov		eax, DWORD PTR strbuffer	
	mov		[edi], eax
	add		edi, 4						;Next element in the array

	loop	InputLoop
userInput ENDP

; ******************************************************************************************************
; disArray PROCEDURE
; Description :	Used to display the array to the user
; ******************************************************************************************************
disArray PROC

	mov		ecx, 10					;Setting loop variables
	mov		esi, OFFSET listArr		;Setting loop variables
	mov		ebx, 0					;Used in the calculation of the sum

	displayString	inputFeedback
	call			CrLf
disArray ENDP

; ******************************************************************************************************
; calcSum PROCEDURE
; Description :	Used to calculate and display the sum of the array to the user
; ******************************************************************************************************
calcSum PROC
SumLoop:
	mov		eax, [esi]
	add		ebx, eax				;Add element to the sum

	push	eax						;Push WriteVal parameters
	push	OFFSET stringTemp		;Push WriteVal parameters
	call	WriteVal
	add		esi, 4					;Increment the loop
	displayString	OFFSET comma	;Add commas to the list of numbers
	loop	SumLoop

	mov				eax, ebx
	mov				sum, eax
	displayString	sumFeedback		;Displays the sum

	push	sum
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf
calcSum ENDP

; ******************************************************************************************************
; calcAverage PROCEDURE
; Description :	Used to calculate and display the average of array to the user
; ******************************************************************************************************
calcAverage PROC

	mov		ebx, 10			;Loop counter
	mov		edx, 0			;Reset edx

	div		ebx				;Divide by 10 to get the average

	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		edx
	cmp		eax, ebx		;Determine if rounding needs to occur
	mov		eax, ecx
	mov		ave, eax
	jb		EvenNum
	inc		eax
	mov		ave, eax

EvenNum:
	displayString	aveFeedback

	push	ave
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf

calcAverage ENDP

; ******************************************************************************************************
; goodBye PROCEDURE
; Description :	Say goodbye the the user!
; ******************************************************************************************************
goodBye PROC
	displayString	closingMessage
	call	CrLf
	ret
goodBYE ENDP


END main
