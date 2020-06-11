	.data
a:		.space 4000
size:		.word 0
cmd:		.byte 1
msg_enterN:	.asciiz	"Nhap so luong phan tu: "
msg_reenterN:	.asciiz	"So luong phan tu phai la so nguyen >0, vui long nhap lai!\n"
msg_ai1:	.asciiz	"a["
msg_ai2:	.asciiz	"]="
msg_printArray:	.asciiz	"\nMang vua nhap la: "
msg_printSum:	.asciiz	"\nTong la: "
msg_printPrime:	.asciiz	"\nCac phan tu nguyen to trong mang la: "
msg_printMax:	.asciiz "\nPhan tu co gia tri lon nhat la: "
msg_inputX:	.asciiz "\nNhap gia tri cua X: "
msg_printX:	.asciiz	"\nCac phan tu co gia tri bang X la: "
msg_printX_f:	.asciiz	"\nKhong co phan tu nao co gia tri bang X!"
msg_menu1:	.asciiz	"\n	1. Xuat ra cac phan tu"
msg_menu2:	.asciiz	"\n	2. Tinh tong cac phan tu"
msg_menu3:	.asciiz	"\n	3. Liet ke cac phan tu la so nguyen to"
msg_menu4:	.asciiz	"\n	4. Tim max"
msg_menu5:	.asciiz	"\n	5. Tim phan tu co gia tri X"
msg_menu6:	.asciiz	"\n	6. Thoat chuong trinh"
msg_menuChoice:	.asciiz	"\nNhap lua chon: "
msg_reCommand:	.asciiz	"\nVui long nhap lai: "
msg_space:	.asciiz " "
msg_newline:	.asciiz "\n"
	.text
main:
	la	$a0, a
	la	$a1, size
	jal	InputArray
	
	jal	Process
	
	li	$v0, 10
	syscall
#------END OF MAIN---------
Process:
	#backup
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	#process
	Process.loop:
		jal	PrintMenu
	Process.loop.switch:
		beq	$v0, '1', case1
		beq 	$v0, '2', case2
		beq 	$v0, '3', case3
		beq 	$v0, '4', case4
		beq 	$v0, '5', case5
		beq 	$v0, '6', case6
		j 	default
		case1:
			la	$a0, a
			lw	$a1, size
			jal	OutputArray
			j	Process.loop
		case2:
			la	$a0, a
			lw	$a1, size
			jal	ComputeSum
			
			move	$s0, $v0
			li	$v0, 4
			la	$a0, msg_printSum
			syscall
			li	$v0, 1
			move	$a0, $s0
			syscall
			j	Process.loop
		case3:
			la	$a0, a
			lw	$a1, size
			jal	PrimeElement
			j	Process.loop
		case4:
			la	$a0, a
			lw	$a1, size
			jal	ComputeMax
			
			move	$s0, $v0
			li	$v0, 4
			la	$a0, msg_printMax
			syscall
			li	$v0, 1
			move	$a0, $s0
			syscall
			j	Process.loop
		case5:
			li	$v0, 4
			la	$a0, msg_inputX
			syscall
			li	$v0, 5
			syscall
			
			move	$a2, $v0
			la	$a0, a
			lw	$a1,size
			jal	XElement
			j 	Process.loop
		case6:
			#restore
			lw	$ra, ($sp)
			addi	$sp, $sp, 4
			jr	$ra
		default:
			li	$v0, 4
			la	$a0, msg_reCommand
			syscall
			li	$v0, 8
			la	$a0, cmd
			li	$a1, 2
			syscall
			lb	$v0, cmd
			j	Process.loop.switch
#-----------------------------------------
#Menu of choice
#output: $v0 is choice
PrintMenu:
	#backup
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	#process
	li	$v0, 4
	la	$a0, msg_menu1
	syscall
	li	$v0, 4
	la	$a0, msg_menu2
	syscall
	li	$v0, 4
	la	$a0, msg_menu3
	syscall
	li	$v0, 4
	la	$a0, msg_menu4 
	syscall
	li	$v0, 4
	la	$a0, msg_menu5
	syscall
	li	$v0, 4
	la	$a0, msg_menu6
	syscall
	li	$v0, 4
	la	$a0, msg_menuChoice
	syscall
	li	$v0, 8
	la	$a0, cmd
	li	$a1, 2
	syscall	
	lb	$v0, cmd
PrintMenu.return:
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
#-----------------------------------------------
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
#----------------------------------------
#Find sum of all element in a integer array
#input: $a0: base address of array
#	$a1: size
#output: $v0: sum 
ComputeSum:
#backup
	addi	$sp, $sp, -28
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$t0, 20($sp)
	sw	$t1, 24($sp)
	#process
	move	$s0, $a0
	move	$s1, $a1
	
	li	$s2, 0
	li	$t0, 0
	ComputeSum.loop:
		lw	$s3, ($s0)
		add	$s2, $s2, $s3
		
		addi	$s0, $s0, 4
		addi 	$t0, $t0, 1
		slt	$t1, $t0, $s1
		beq	$t1, 1, ComputeSum.loop
	move	$v0, $s2
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$t0, 20($sp)
	lw	$t1, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
#--------------------------------
#Check if an integer is a prime number or not
#input:	$a0 is the number
#output: $v0 = 1 if $a0 is a prime number, otherwise $v0 = 0
IsPrime:
	#backup
	addi	$sp, $sp, -28
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$t0, 16($sp)
	sw	$t1, 20($sp)
	sw	$t2, 24($sp)
	#process
	move	$s0, $a0
	
	li	$v0, 0
	slti	$t1, $s0, 2
	beq	$t1, 1, IsPrime.Return 
	
	li	$t0, 0
	srl	$s1, $s0, 1
	li	$t2, 0
	IsPrime.loop:
		addi	$t0, $t0, 1
		slt	$t1, $s1, $t0
		beq	$t1, 1, IsPrime.check
		div	$s0, $t0
		mfhi	$s2
		bne	$s2, 0, IsPrime.loop
		addi	$t2, $t2, 1
		j	IsPrime.loop
IsPrime.check:
	slti	$t1, $t2, 2
	beq	$t1, 0, IsPrime.Return 
	li	$v0, 1
	#restore
IsPrime.Return:
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$t0, 16($sp)
	lw	$t1, 20($sp)
	lw	$t2, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
#----------------------------------------
#Print all Prime element in an array
#input: $a0: base address of array
#	$a1: size 
PrimeElement:
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
	la	$a0, msg_printPrime
	syscall
	li	$t0, 0
	PrimeElement.loop:
		li	$v0, 1
		lw	$a0, ($s0)
		jal	IsPrime
		beq	$v0, 0, PrimeElement.next
		syscall
		
		li	$v0, 4
		la	$a0, msg_space
		syscall
	PrimeElement.next:	
		addi	$s0, $s0, 4
		addi 	$t0, $t0, 1
		slt	$t1, $t0, $s1
		beq	$t1, 1, PrimeElement.loop
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$t0, 12($sp)
	lw	$t1, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#-------------------------------------------
#Find max element of an integer array
#input: $a0: base address of array
#	$a1: size
#output: $v0: max 
ComputeMax:
#backup
	addi	$sp, $sp, -28
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$t0, 20($sp)
	sw	$t1, 24($sp)
	#process
	move	$s0, $a0
	move	$s1, $a1
	
	lw	$s2, ($s0)
	li	$t0, 1
	addi	$s0, $s0, 4
	ComputeMax.loop:
		lw	$s3, ($s0)
		slt	$t1, $s2, $s3
		beq	$t1, 0, ComputeMax.loop.next
		move	$s2, $s3
	ComputeMax.loop.next:
		addi	$s0, $s0, 4
		addi 	$t0, $t0, 1
		slt	$t1, $t0, $s1
		beq	$t1, 1, ComputeMax.loop
	move	$v0, $s2
	#restore
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$t0, 20($sp)
	lw	$t1, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
#-----------------------------------------
#Find position of an element that equal x
#input: $a0: base address of array
#	$a1: size
#	$a2: x
XElement:
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
	move	$s2, $a2
	
	li	$v0, 4
	la	$a0, msg_printX
	syscall
	li	$t0, 0
	li	$t2, 0
	XElement.loop:
		lw	$s3, ($s0)
		bne	$s3, $s2, XElement.next
		li	$t2, 1
		li	$v0, 1
		move	$a0, $t0
		syscall
		
		li	$v0, 4
		la	$a0, msg_space
		syscall
	XElement.next:	
		addi	$s0, $s0, 4
		addi 	$t0, $t0, 1
		slt	$t1, $t0, $s1
		beq	$t1, 1, XElement.loop
	
	beq	$t2, 1, XElement.return
	li	$v0, 4
	la	$a0, msg_printX_f
	syscall
	#restore
XElement.return:
	lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$t0, 12($sp)
	lw	$t1, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#-----------------------------------------
