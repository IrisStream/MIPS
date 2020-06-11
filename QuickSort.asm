	.data
a:		.space	4000
size:		.word 0
buffer:		.space 5000
inputFile:	.asciiz	"input_sort.txt"
outputFile:	.asciiz "output_sort.txt"
msg_space:	.asciiz " "
	.text
main:
	la	$a0, inputFile
	la	$a1, a
	la	$a2, size
	jal	ReadFile
	
	la	$a0, a
	li	$a1, 0
	lw	$a2, size
	subi	$a2, $a2, 1
	jal 	QuickSort
	
	la	$a0, outputFile
	la	$a1, a
	lw	$a2, size
	jal	WriteFile
	
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
#Read an array in a file
#input:	$a0 links to file
#	$a1 base address of array
#	$a2 address of size variable
ReadFile:
	#backup
	addi	$sp, $sp, -28 
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s6, 20($sp)
	sw	$t0, 24($sp)
	#process
	move	$s0, $a1
	move	$s1, $a2
	
	li	$v0, 13
	li	$a1, 0
	li	$a2, 0
	syscall
	move	$s6, $v0
	
	li	$v0, 14
	move	$a0, $s6
	la	$a1, buffer
	li	$a2, 3000
	syscall
ReadFile.readN:
	li	$s2, 0
	li	$s3, 10
	ReadFile.readN.loop:
		lb	$t0, ($a1)
		beq	$t0, '\r', ReadFile.readArray
		mult	$s2, $s3
		mflo	$s2
		add	$s2, $s2, $t0
		subi	$s2, $s2, '0'
		addi	$a1, $a1, 1
		j	ReadFile.readN.loop
ReadFile.readArray:
	sw	$s2, ($s1)
	addi	$a1, $a1, 2
	li	$s2, 0
	lb	$t0, ($a1)
	ReadFile.readArray.loop:
		beq	$t0, ' ', ReadFile.readArray.loop.next		
		mult	$s2, $s3
		mflo	$s2
		add	$s2, $s2, $t0
		subi	$s2, $s2, '0'
		j	ReadFile.readArray.loop.continue
	ReadFile.readArray.loop.next:
		sw	$s2, ($s0)
		add	$s0, $s0, 4
		li	$s2, 0
	ReadFile.readArray.loop.continue:
		addi	$a1, $a1, 1
		lb	$t0, ($a1)
		bne	$t0, '\0', ReadFile.readArray.loop
	sw	$s2, ($s0)
	
	li	$v0, 16
	move	$a0, $s6
	syscall
	#restore  
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s6, 20($sp)
	lw	$t0, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
#----------------------------------
#Write an array to file
#input:	$a0 link to file
#	$a1 base address of array
#	$a2 size
WriteFile:
	#backup
	addi	$sp, $sp, -40
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	sw	$s5, 24($sp)
	sw	$s6, 28($sp)
	sw	$t0, 32($sp)
	sw	$t1, 36($sp)
	#process
	move	$s0, $a1
	move	$s1, $a2
	
	li	$v0, 13
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s6, $v0
	
	li	$v0, 9
	li	$a0, 3000
	syscall
	move	$s2, $v0
	
WriteFile.toString:
	subi	$s1, $s1, 1
	sll	$s1, $s1, 2
	add 	$s1, $s0, $s1
	lw	$t0, ($s1)
	move	$s3, $s2
	li	$s4, 10
	WriteFile.toString.loop: 
		div	$t0, $s4
		mflo	$t0
		mfhi	$s5
		addi	$s5, $s5, '0'
		sb	$s5, ($s3)
		addi	$s3, $s3, 1
		bne	$t0, 0, WriteFile.toString.loop
		li	$s5, ' '
		sb	$s5, ($s3)
		addi	$s3, $s3, 1
		addi	$s1, $s1, -4
		lw	$t0, ($s1)
		slt	$t1, $s1, $s0
		beq	$t1, 0, WriteFile.toString.loop 
	
	subi	$s3, $s3, 1	#Delete the last ' '
	move	$a0, $s2
	subu	$a1, $s3, $s2
	jal	StringReverse
	
	move	$a1, $v0
	li	$v0, 15
	move	$a0, $s6
	li	$a2, 3000
	syscall
	
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	lw	$s5, 24($sp)
	lw	$s6, 28($sp)
	lw	$t0, 32($sp)
	lw	$t1, 36($sp)
	addi	$sp, $sp, 40
	jr	$ra
#---------------------------------------------
#Reverse a string
#input:	$a0 base address of string
#	$a1 size
#output:$v0 base address of reversed string
StringReverse:
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
	
	li	$v0, 9
	li	$a0, 3000
	syscall
	move	$s2, $v0
	
	add 	$s1, $s0, $s1
	subi	$s1, $s1, 1
	StringReverse.loop:
		lb	$t0, ($s1)
		sb	$t0, ($s2)
		addi	$s1, $s1, -1
		addi	$s2, $s2, 1
		slt	$t1, $s1, $s0
		bne	$t1, 1, StringReverse.loop
	
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$t0, 16($sp)
	lw	$t1, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
