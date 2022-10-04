.data
new_line: .asciiz "\n"
initial_message: .asciiz "Please enter the following matrix: \n"
matrix: .asciiz "[a,b]\n[c,d]\n"
message1: .asciiz "Enter integer (a): "
message2: .asciiz "Enter integer (b): "
message3: .asciiz "Enter integer (c): "
message4: .asciiz "Enter integer (d): "
guess_message: .asciiz "Enter your guess: "
det_message: .asciiz "The determinant of the matrix is: "
correct_message : .asciiz "Correct! You win!"
incorrect_message : .asciiz "Incorrect! You lose!"

.text

det_verifier:
	# if s0 is equal to s1, then return 1
	# else return 0
	mul $t4, $a0, $a3
	mul $t5, $a1, $a2
	sub $v1, $t4, $t5
	# call user guess from stack into $a0
	lw $v0, 0($sp)
	addi $sp, $sp, 4
	# call the data into the registers
	beq $v0, $v1, det_verifier_true
	j det_verifier_false

	det_verifier_true:
		li $v1, 1
		jr $ra

	det_verifier_false:
		li $v1, 0
		jr $ra


det:
# takes 4 agruments, abcd, and returns the determinant of the matrix
	mul $t4, $a0, $a3
	mul $t5, $a1, $a2
	sub $v1, $t4, $t5
	jr $ra


main:

	# print initial message
	li $v0, 4
	la $a0, initial_message
	syscall

	# print matrix diagram
	li $v0, 4
	la $a0, matrix
	syscall

	# print message1
	li $v0, 4
	la $a0, message1
	syscall

	# read the user input into $t0
	li $v0, 5
	syscall
	move $t0, $v0

	# print message2
	li $v0, 4
	la $a0, message2
	syscall

	# read the user input into $t1
	li $v0, 5
	syscall
	move $t1, $v0

	# print message3
	li $v0, 4
	la $a0, message3
	syscall

	# read the user input into $t2
	li $v0, 5
	syscall
	move $t2, $v0

	# print message4
	li $v0, 4
	la $a0, message4
	syscall

	# read the user input into $t3
	li $v0, 5
	syscall
	move $t3, $v0

	# move values from temp into arg registers
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	move $a3, $t3
	
	# Call the determinant function
	jal det

	# save the result in $s0
	move $s0, $v1

	# print the det_message
	li $v0, 4
	la $a0, det_message
	syscall

	# print the result of the determinant
	li $v0, 1
	move $a0, $s0
	syscall

	# print a new line
	li $v0, 4
	la $a0, new_line
	syscall

	# prompt the user for a guess
	li $v0, 4
	la $a0, guess_message
	syscall

	# store the user's guess on the stack
	li $v0, 5
	syscall
	addi $sp, $sp -4
	sw $v0, 0($sp)

	# move values from temp into arg registers
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	move $a3, $t3
	

	# call the determinant identifier
	jal det_verifier

	# save the result in $s2
	move $s2, $v1

	# if the result is 1, then print correct message
	beq $s2, $zero, incorrect
	li $v0, 4
	la $a0, correct_message
	syscall
	j exit

	# if the result is 0, then print incorrect message
incorrect:
	li $v0, 4
	la $a0, incorrect_message
	syscall

exit:
	# exit the program
	li $v0, 10
	syscall

