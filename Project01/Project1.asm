TITLE Project 1 - Elementary Arithmetic     (template.asm)

; Author:	Max MacEachern
; Course / Project ID  CS271 Project01               Date: 4/10/16
; Description: This program prompts the user to enter two numbers. The program then calculates the addition, subtraction, product, quotient and remainder of those numbers. This information is outputted for the user.

INCLUDE Irvine32.inc


.data
	userNum_01			DWORD	?
	userNum_02			DWORD	?
	intro_01			BYTE	"Elementary Arithmetic         by Max MacEachern", 0
	intro_02			BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
	prompt_01			BYTE	"First Number: ", 0
	prompt_02			BYTE	"Second Number: ", 0
	addResult			DWORD	?
	subResult			DWORD	?
	multResult			DWORD	?
	divResult			DWORD	?
	remainderResult		DWORD	?
	addOutput			BYTE	" + ", 0
	subOutput			BYTE	" - ", 0
	multOutput			BYTE	" x ", 0
	divOutput_01		BYTE	" / ", 0
	divOutput_02		BYTE	" remainder ", 0
	equalOutput			BYTE	" = ", 0
	outro_01			BYTE	"Impressed? Probably, not... Goodbye!", 0


.code
main PROC

;Introduce program and programmer
	mov		edx, OFFSET	intro_01
	call	WriteString
	call	CrLf
	call	CrLf

;State program objective
	mov		edx, OFFSET	intro_02
	call	WriteString
	call	CrLF
	call	CrLF

;Get first number from user
	mov		edx, OFFSET prompt_01
	call	WriteString
	call	ReadInt
	mov		userNum_01, eax

;Get second number from user
	mov		edx, OFFSET prompt_02
	call	WriteString
	call	ReadInt
	mov		userNum_02, eax

;Calculate maths (all of them)
	mov		eax, userNum_01
	add		eax, userNum_02
	mov		addResult, eax

	mov		eax, userNum_01
	sub		eax, userNum_02
	mov		subResult, eax

	mov		eax, userNum_01
	mov		ebx, userNum_02
	mul		ebx
	mov		multResult, eax

	mov		edx, 0
	mov		eax, userNum_01
	mov		ebx, userNum_02
	div		ebx
	mov		divResult, eax
	mov		remainderResult, edx
	

;Report Addition Result
	mov		eax, userNum_01
	call	WriteDec
	mov		edx, OFFSET addOutput
	call	WriteString
	mov		eax, userNum_02
	call	WriteDec
	mov		edx, OFFSET equalOutput
	call	WriteString
	mov		eax, addResult
	call	WriteDec
	call	CrLF

;Report Addition Result
	mov		eax, userNum_01
	call	WriteDec
	mov		edx, OFFSET subOutput
	call	WriteString
	mov		eax, userNum_02
	call	WriteDec
	mov		edx, OFFSET equalOutput
	call	WriteString
	mov		eax, subResult
	call	WriteDec
	call	CrLF

;Report Multiplication Result
	mov		eax, userNum_01
	call	WriteDec
	mov		edx, OFFSET multOutput
	call	WriteString
	mov		eax, userNum_02
	call	WriteDec
	mov		edx, OFFSET equalOutput
	call	WriteString
	mov		eax, multResult
	call	WriteDec
	call	CrLF

;Report Division/Remainder Result
	mov		eax, userNum_01
	call	WriteDec
	mov		edx, OFFSET divOutput_01
	call	WriteString
	mov		eax, userNum_02
	call	WriteDec
	mov		edx, OFFSET equalOutput
	call	WriteString
	mov		eax, divResult
	call	WriteDec
	mov		edx, OFFSET divOutput_02
	call	WriteString
	mov		eax, remainderResult
	call	WriteDec
	call	CrLF
	call	CrLF

;Output ending message
	mov		edx, OFFSET outro_01
	call	WriteString
	call	CrLF

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
