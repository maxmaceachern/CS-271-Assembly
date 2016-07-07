TITLE Fibonacci Sequence     (project2.asm)

; Author: Max MacEachern
; Course / Project ID  CS 271                Date: 4/17/16
; Description: This program calculates Fibonacci numbers. The program will display information about the program and request input from the user.
;				The user will then be asked to select the number of Fibonacci terms to be displayed. The program will then calculate and display 
;				those numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
programInfo			BYTE		"Fibonacci Numbers", 0
authorName			BYTE		"Programmed by Max MacEachern", 0
nameMessage			BYTE		"What is your name? ", 0
fibMessage			BYTE		"Enter the number of Fibonacci terms to be displayed.", 0
cautionMessage		BYTE		"If you could, please give the number as an integer in the range [1...46]", 0
fibInput			BYTE		"How many Fibonacci terms do you want? ", 0
rangeStatement		BYTE		"Out of range. As I mentioned, please enter a number in the range [1...46]", 0
closeMessage		BYTE		"Results certified by Max MacEachern, for whatever that is worth.", 0
goodbyeMessage		BYTE		"Goodbye, ", 0
numSpacing			BYTE		"     ", 0
userName			DWORD		32 DUP(0)
userNum				DWORD		?
sum					DWORD		?
count				DWORD		?
column				DWORD		?


.code
main PROC

;Intro Section
mov			edx, OFFSET programInfo
call		WriteString
call		CrLF
mov			edx, OFFSET authorName
call		WriteString
call		CrLf
call		CrLF

;User Input Section
mov			edx, OFFSET nameMessage
call		WriteString
mov			edx, OFFSET userName
mov			ecx, SIZEOF userName
call		ReadString

mov			edx, OFFSET fibMessage
call		WriteString
call		CrLF
mov			edx, OFFSET cautionMessage
call		WriteString
call		CrLF

DataVal:								;Checks to see if the value is between 1 and 46
	mov		edx, OFFSET fibInput
	call	WriteString
	call	ReadInt
	cmp		eax, 1
	jl		Error
	cmp		eax, 46
	jg		Error
	jmp		Valid

Error:									;Error loop that Dataval jumps to
	mov		edx, OFFSET rangeStatement
	call	WriteString
	call	CrLF
	jmp		DataVal

Valid:									;If valid, assign user input to userNum
	mov		userNum, eax

; Execute Fib Calculation

mov			ecx, userNum
mov			eax, 0
mov			ebx, 1
mov			sum, 0
mov			column, 1

fibLoop:
	mov		sum, eax
	add		eax, ebx
	mov		ebx, sum
	call	WriteDec
	mov		edx, OFFSET numSpacing
	call	WriteString
	
	cmp		column, 5
	jge		yes
	mov		edx, column
	inc		edx
	mov		column, edx
	jmp		no
	
	yes:
		call	CrlF
		mov		column, 1
	
	no:
		loop	fibLoop



; Goodbye

call	CrLF
mov		edx, OFFSET goodbyeMessage
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLF	



	exit	; exit to operating system
main ENDP


END main
