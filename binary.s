
# Computer Systems and Architecture assignment 1

### Standard header information	
	.data
	.align 2
### Output strings
yes: .asciiz "\nYES\n"
no:	.asciiz "\nNO\n"
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
	mul $a2, $t0, 4; # Offset in stack pointer from end of list to start(Counter*4)
	sub $t2, $t7, $a2; # Left bound in $t2
	# While loop condition
	slt $t1, $t7, $t2 # Sets t1 to 1 if $t2 > $t7 (left > right)
	beq $t1, 1, PRINTNO # if $t2 > $t7 (left >right)
	li $t1, 0; # Set t1 = 0 before reusing it below
	
	sub $a3, $t7, $t2; # (Right - left) bound 
	div $a3, $t3; # Divide (Right - left) by 2
	mflo $v0 # Quotient to $v0 -> Is the offset to the mid value
	move $t5, $v0; # Move offset to mid -> t5
	add $t4, $t2, $t5; # (left+offset) => Pointer to mid value
	lw $a1, ($t4);
	div $a2, $t3; # Divide counter by 2
	mflo $v0 # Quotient to $v0 -> Counter/2
	move $t0, $v0; # Move new counter/2 back to t3 where original counter was
	beq $t6, $a1, PRINTYES; # If testNum == midValue then print YES
	# All the if(s) 
	slt $t1, $t6, $a1 # Sets t1 to 1 if $t4 > $t6 (midVal > testNum)
	
	# Print midval (Just for testing for now)!
		li 	$v0, 1		; # System call code 1 for print int
		move $a0, $t1	 ; # Argument midval
		syscall			; # Print the midval
	
	beq $t1, 1, BIGGER # if $t4 = $t6 (midVal < testNum)-> left = mid + 4bytes (t2)	
	bne $t1, 1, SMALLER # if $t4 > $t6 (midVal > testNum)-> right = mid - 4bytes (t7)
	
	# Print midval (Just for testing for now)!
	#	li 	$v0, 1		; # System call code 1 for print int
	#	lw $a0, ($t4)	 ; # Argument midval
	#	syscall			; # Print the midval
	
# Return to SEARCHVALIN where jal was called (This will be last command)	
	jr $ra;

SMALLER:
	sub $t7, $t4, 4; # RightBound = mid-1 (4bytes)
	j binarysearch;
BIGGER:
	add $t2, $t4, 4; # LeftBound = mid+1 (4bytes)
	j binarysearch;
PRINTYES:	
# Print yes 
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,yes		; # Argument string as input
	syscall			; # Print the string
	j SEARCHVALIN;
PRINTNO:	
# Print no 
	li 	$v0,4		; # System call code 4 for print string
	la 	$a0,no		; # Argument string as input
	syscall			; # Print the string
	j SEARCHVALIN;

