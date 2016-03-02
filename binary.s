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

# Read in digits to look for in the array

# Binary search subroutine
binarysearch:
# Print yes (Just for testing for now)!
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,yes		; # Argument string as input
	syscall			; # Print the string
# Return to SEARCHVALIN where jal was called
	jr $ra;
	
# Iterate through array from end 
	# Backtrack stack pointer by 4 bytes
	# If 
	

	# Compare value in v0 with current  
		# Set a value 0 or 1 in v1 for found or not found
	# beq $v1, 1, PrintYES 	
	# beq $v1, 0, PrintNO 
	
# Subroutine to print yes

