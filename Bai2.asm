	.data
a:		.space	4000
size:		.word 0
msg_enterN:	.asciiz "\nNhap so luong phan tu: "
msg_ai1:	.asciiz "a["
msg_ai2:	.asciiz "]="
msg_reenterN:	.asciiz "\nNhap sai, vui long nhap lai: "
msg_printArray:	.asciiz "\nMang sau khi sap xep: "
msg_space:	.asciiz " "
msg_newline:	.asciiz "\n"
	.text
main:
	la	$a0, a
	la	$a1, size
	jal	InputArray
	
	la	$a0, a
	li	$a1, 0
	lw	$a2, size
	subi	$a2, $a2, 1
	jal 	QuickSort
	
	la	$a0, a
	lw	$a1, size
	jal	OutputArray
	
	li	$v0, 10
	syscall
#------END OF MAIN---------
#Quicksort an array from left to right
#input:	$a0: base address of array
#	$a1: left position
#	$a2: right position
QuickSort:
	#backup
	addi	$sp, $sp, -48 
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$s7, 32($sp)
	sw	$t0, 36($sp)
	sw	$t1, 40($sp)
	sw	$t2, 44($sp)
	#process
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	
	slt	$t1, $s1, $s2			#if(left>=right)
	beq	$t1, 0, QuickSort.return	#	return;
	
	move	$t0, $s1			#int i = left;
	move	$t2, $s2			#int j = right;
	add	$s3, $s1, $s2			#int v = a[(left + right) / 2]
	srl	$s3, $s3, 1
	sll	$s3, $s3, 2
	add	$s3, $s0, $s3
	lw	$s3, ($s3)
	QuickSort.while:
		slt	$t1, $t0, $t2			#if(i>=j) -> recurring
		beq	$t1, 0, Quicksort.recurring
		addi	$t0, $t0, -1
		QuickSort.while.findI:
			addi	$t0, $t0, 1
			sll	$s4, $t0, 2
			add 	$s4, $s0, $s4
			lw	$s4, ($s4)
			slt	$t1, $s4, $s3
			beq	$t1, 1, QuickSort.while.findI
		
		addi	$t2, $t2, 1
		QuickSort.while.findJ:
			addi	$t2, $t2, -1
			sll	$s4, $t2, 2
			add 	$s4, $s0, $s4
			lw	$s4, ($s4)
			slt	$t1, $s3, $s4
			beq	$t1, 1, QuickSort.while.findJ
		
		slt	$t1, $t2, $t0
		beq	$t1, 1, QuickSort.while
		sll	$s4, $t0, 2
		add	$s4, $s0, $s4
		lw	$s6, ($s4)
		sll	$s5, $t2, 2
		add	$s5, $s0, $s5
		lw	$s7, ($s5)
		sw	$s6, ($s5)
		sw	$s7, ($s4)
		addi	$t0, $t0, 1
		addi	$t2, $t2, -1
		j 	QuickSort.while
Quicksort.recurring:
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $t2
	jal	QuickSort
	
	move	$a0, $s0
	move	$a1, $t0
	move	$a2, $s2
	jal	QuickSort
	#restore
QuickSort.return:
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$s7, 32($sp)
	lw	$t0, 36($sp)
	lw	$t1, 40($sp)
	lw	$t2, 44($sp)
	addi	$sp, $sp, 48
	jr	$ra
#--------------------------------------
#Read an N element integer Array(N must be positive)
#input: $a0: base address of array
#	$a1: address of size variable
InputArray:
	#backup
	addi	$sp, $sp, -24
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$t0, 16($sp)
	sw	$t1, 20($sp)
	#process
	move	$s0, $a0
	move	$s1, $a1

enterN:	
	li	$v0, 4
	la	$a0, msg_enterN
	syscall

	li	$v0, 5
	syscall
	
	slti	$t1, $v0, 1
	beq	$t1, 1, reenterN
	sw	$v0, ($s1)
	move	$s2, $v0
	li	$t0, 0
	j	enterArray
reenterN:
	li	$v0, 4
	la	$a0, msg_reenterN
	syscall
	j enterN
enterArray:
	li	$v0, 4
	la	$a0, msg_ai1
	syscall
	
	li	$v0, 1
	move	$a0, $t0
	syscall 
	
	li	$v0, 4
	la	$a0, msg_ai2
	syscall
	
	li	$v0, 5
	syscall
	
	sw	$v0, 0($s0)
	addi	$s0, $s0, 4
	addi	$t0, $t0, 1
	slt	$t1, $t0, $s2
	beq	$t1, 1, enterArray
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$t0, 16($sp)
	lw	$t1, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
#----------------------------------------------
#Print an integer array with n elements
#input: $a0: base address of array
#	$a1: size 
OutputArray:
	#backup
	addi	$sp, $sp, -20
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$t0, 12($sp)
	sw	$t1, 16($sp)
	#process
	move	$s0, $a0
	move	$s1, $a1
	
	li	$v0, 4
	la	$a0, msg_printArray
	syscall
	li	$t0, 0
	OutputArray.loop:
		li	$v0, 1
		lw	$a0, ($s0)
		syscall
		
		li	$v0, 4
		la	$a0, msg_space
		syscall
		
		addi	$s0, $s0, 4
		addi 	$t0, $t0, 1
		slt	$t1, $t0, $s1
		beq	$t1, 1, OutputArray.loop
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$t0, 12($sp)
	lw	$t1, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra