
# Computer Systems and Architecture assignment 1

### Standard header information	
	.data
	.align 2
### Output strings
yes:	.asciiz "\nYES"
no:	.asciiz "\nNO"
listIn:	.asciiz "Enter list of numbers \n"
numIn:	.asciiz "Enter a number to search for \n"
### Standard preliminaries
 	.text
	.globl main

main:

# Prompt for list	
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,listIn	; # Argument string as input
	syscall			; # Print the string
	
# Read in the numbers
	li	$t0, -1		; # Counter starts at -1
READLIST: 
	li	$v0,5		; # System call code 5 to read int input
	syscall			; # Read it
	move $t1, $v0	; # Move read in number to temp register
	beq $v0, $zero, SEARCHVALIN; # When 0 skip to test data input
	li	$v0,9		; # Code for heap allocation
	li	$a0,4		; # Each number takes 4 bytes
	syscall			; # Allocate space for this int on heap
	sw	$t1, ($v0)	; # Add value to heap
	addi $t0, $t0, 1; # Counter++
	move $t7, $v0	; # Save address of end	
	j	READLIST	; # Loop

# Read in test data, 1 by 1 and search immediately.
SEARCHVALIN: 
# Prompt for number to lookup	
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,numIn	; # Argument string as input
	syscall			; # Print the string	
# Read number in	
	li	$v0,5		; # System call code 5 to read int input
	syscall			; # Read it
	move $t6, $v0	; # Move value to temp register
# If n = 0 then exit program else binary search then loop 
	beq $t6, $zero, SAFEXT; # Quit loop (and program) if testcase = 0 
	jal binarysearch;
	j SEARCHVALIN;

# Controlled exit
SAFEXT:
	li 	$v0,10		; # System call code for exit
	syscall			;

# Binary search subroutine
binarysearch:	
	li $t3, 2; # Store 2 in $t3	
	mul $a2, $t0, 4; # Offset in stack pointer from end of list to start (Counter*4)
	sub $t2, $t7, $a2; # Left bound in $t2
	sub $a3, $t7, $t2; # (Right - left) bound 
	div $a3, $t3; # Divide (Right - left) by 2
	mflo $v0 # Quotient to $v0 -> Is the offset to the mid value
	add $t4, $t2, $a2; # (left+offset) => Pointer to mid value
	# Print midval (Just for testing for now)!
		li 	$v0, 1		; # System call code 1 for print int
		move $a0, $t4	 ; # Argument midval
		syscall			; # Print the midval

# Return to SEARCHVALIN where jal was called (This will be last command)	
	jr $ra;
	
# Print yes (Just for testing for now)!
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,yes		; # Argument string as input
	syscall			; # Print the string

