TITLE Sorting Random Integers     (project5.asm)

; Author:  Max MacEachern
; Course / Project ID    CS 271 Project 5             Date: 5/22/2016
; Description: This program takes a number given by user input and generates an array of random numbers with elements
;			   equal to that that number (bounds being 100 to 999). This array is then displayed. The program then
;              sorts the array, finds the median, and the outputs the sorted array and the median. 

INCLUDE Irvine32.inc

	Min		= 10
	Max		= 200
	L		= 100
	H		= 999

.data
	progName		BYTE	"Sorting Random Integers           Programmed by Max MacEachern", 0
	progInfo01		BYTE	"This program generates random numbers in the range [100 .. 999],", 0
	progInfo02		BYTE	"displays the original list, sorts the list, and calculates the", 0
	progInfo03		BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
	rangeInput		BYTE	"How many numbers should be generated? Pick between [10 .. 200]: ", 0
	errorLow		BYTE	"The number you entered is too low, please try again.",0
	errorHigh		BYTE	"The number you entered is too high, please try again.",0
	unSortMsg		BYTE	"The unsorted random numbers are: ", 0
	medianMsg		BYTE	"The median is ", 0
	sortedMsg		BYTE	"The sorted list is:", 0
	spacing			BYTE	"   ", 0
	userInput		DWORD	?
	inputArray		DWORD	Max DUP(?)

.code
main PROC
	
	;Call randomize only once, from main
	call	Randomize	

	;Welcome the user
	call	introduction

	;Grab user input by reference to build array from
	push	OFFSET userInput	
	call	getData

	;Populate the array with random numbers
	push	OFFSET inputArray	
	push	userInput			
	call	fillArray

	;Display the unsorted array array
	mov		edx, OFFSET unSortMsg
	call	WriteString
	call	CrLf
	push	OFFSET inputArray
	push	userInput
	call	displayList
	call	CrLf
	call    CrLf

	;Sort the array
	push	OFFSET inputArray	
	push	userInput			
	call	sortList

	;Calculate the median value in the array
	push	OFFSET inputArray	
	push	userInput			
	push	OFFSET medianMsg		
	call	displayMedian

	;Display the sorted array
	call	CrLf
	mov		edx, OFFSET sortedMsg
	call	WriteString
	call	CrLf
	push	OFFSET inputArray
	push	userInput
	call	displayList

	exit	; exit to operating system
main ENDP

; ******************************************************************************************************
; INTRODUCTION PROCEDURE
; Description :		 Procedure to give the user instructions and an introduction to the program.
; ******************************************************************************************************

introduction	PROC
	;Outputs the name of the project and the author
	call	 CrLf
	mov		 edx, OFFSET progName
	call	 WriteString
	call	 CrLf
	call	 CrLF

	;Gives the user instructions
	mov		edx, OFFSET progInfo01
	call	WriteString
	call	CrLF
	mov		edx, OFFSET progInfo02
	call	WriteString
	call	CrLf
	mov		edx, OFFSET progInfo03
	call	WriteString
	call	CrLf
	call	CrLF
	ret

introduction	ENDP

; ******************************************************************************************************
; getData PROCEDURE
; Description :	Gets the data from the user and validates if it is too low or too high
; ******************************************************************************************************

getData		PROC
	
	;Stack initialization
		push	ebp
		mov		ebp, esp
		mov		ebx, [esp+8] ; get address of request into ebx, per lecture

	userInputLoop:
		mov		edx, OFFSET rangeInput		;access by reference
		call	WriteString
		call	ReadInt
		mov		[ebx], eax
		cmp		eax, Min
		jb		tooLow						;If input was less than the minimum
		cmp		eax, Max
		jg		tooHigh						;If input was more than the maximum
		jmp		valid

	tooLow:
		mov		edx, OFFSET errorLow		;access by reference
		call	WriteString
		call	CrLf
		jmp		userInputLoop

	tooHigh:
		mov		edx, OFFSET errorHigh		;access by reference
		call	WriteString
		call	CrLf
		jmp		userInputLoop

	;If user data is valid, clean up the stack
	valid:
		pop		ebp
		ret		4

getData		ENDP

; ******************************************************************************************************
; fillArray PROCEDURE
; Description :	Fills the array with pseudorandom numbers using RandomRange
; ******************************************************************************************************

fillArray PROC
		;Stack and array initialization
		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12]	;at the array
		mov		ecx, [ebp+8]	;loop control

	;Add numbers to the array as long a as there is space
	fillLoop:
		mov		eax, H
		sub		eax, L
		inc		eax
		call	RandomRange	;used to get a random number
		add		eax, L
		mov		[esi], eax  ;adds a random number to the array
		add		esi, 4		;goes to the next element
		loop	fillLoop

		;Clean up the stack
		pop		ebp
		ret		8

fillArray ENDP

; ******************************************************************************************************
; displayList PROCEDURE
; Description :	Displays the contents of the array to the user. Works for either sorted or unsorted
; ******************************************************************************************************

displayList PROC
		push	ebp
		mov		ebp, esp
		mov		ebx, 0						; counting for number spacing
		mov		esi, [ebp + 12]				; at array
		mov		ecx, [ebp + 8]				; loop control
	displayLoop:
		mov		eax, [esi]					;this grabs the current number
		call	WriteDec
		mov		edx, OFFSET spacing			;adds spacing to output
		call	WriteString
		inc		ebx
		cmp		ebx, 10						;Checks for new line
		jl		nextLine
		call	CrLf
		mov		ebx,0
	nextLine:
		add		esi, 4						; next element
		loop	displayLoop
	endDisplayLoop:
		pop		ebp
		ret		8
displayList ENDP

; ******************************************************************************************************
; sortList PROCEDURE
; Description :	Sorts the array using Selection Sort algorithm as described in class directions
; ******************************************************************************************************

sortList PROC
	;Stack initialization
		pushad
		mov		ebp, esp
		mov		ecx, [ebp+36]
		mov		edi, [ebp+40]
		dec 	ecx 			;decrements the user input value
		mov		ebx, 0

	;The first for loop in the algorithm
	firstForLoop:
		mov		eax, ebx		;array[i]=[k]
		mov		edx, eax
		inc 	edx 			;[j]=[k+1]
		push 	ecx
		mov 	ecx, [ebp+36]	;goes back to user input value

	;The second for loop in the algorithm
	secondForLoop:
		mov		esi, [edi+edx*4]
		cmp		esi, [edi+eax*4]
		jle		Skip
		mov		eax, edx

	;If not greater, skip to the next comparison
	Skip:
		inc 	edx
		loop 	secondForLoop

	;If they are greater, make the swap
		lea 	esi, [edi+ebx*4]
		push 	esi
		lea 	esi, [edi+eax*4]
		push 	esi
		call 	exchange
		pop 	ecx
		inc 	ebx
		loop 	firstForLoop
		popad
		ret 	8

sortList ENDP

; ******************************************************************************************************
; exchange PROCEDURE
; Description :	This procedure swaps the values of two elements of the array
; ******************************************************************************************************

exchange PROC
		pushad
		mov 	ebp, esp
		mov 	eax, [ebp+40] 		;lower ordered value in the array
		mov 	ecx, [eax]
		mov 	ebx, [ebp+36] 		;higher ordered value in the array
		mov		edx, [ebx]
		mov		[eax], edx
		mov 	[ebx], ecx
		popad
		ret 	8					;clean stack

exchange ENDP

; ******************************************************************************************************
; displayMedian PROCEDURE
; Description :	Both calculates and displays the median value of the array
; ******************************************************************************************************

displayMedian PROC
	;Stack initialization
		pushad
		mov     ebp, esp
		mov     edi, [ebp+44]

	;Print output information
		mov     edx, [ebp+36]
		call    WriteString

	;Calculate the median value
		mov     eax, [ebp+40]
		cdq
		mov     ebx, 2
		div     ebx
		shl     eax, 2
		add     edi, eax
		cmp     edx, 0
		jnz     OddNumber

	;If Even     
		mov     eax, [edi]
		add     eax, [edi-4]
		cdq     
		mov     ebx, 2
		div     ebx
		call    WriteDec
		call    CrLf
		jmp		endDisMedian
	

	;If Odd 
	OddNumber:
		mov     eax, [edi]
		call    writeDec
		call    CrLf
		jmp     endDisMedian

	;Clear stack
	endDisMedian:
		popad
		ret 12

displayMedian ENDP


END main
