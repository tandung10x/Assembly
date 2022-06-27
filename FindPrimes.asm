.data
	inputN: .asciiz "Nhap N:”
	inputM: .asciiz "Nhap M:”
.text
main:
	li $v0, 51 
	la $a0, inputN 
	syscall
	addi $s0, $a0, 0
	
	li $v0, 51 
	la $a0, inputM 
	syscall
	addi $s1, $a0, 0

checkPrime:
	blt  $s0, 2, notPrime
	addi $t0, $zero, 2	# i
loop:
	div  $s0, $t0
	mfhi $t9		# remainder
	beqz $t9, notPrime
	mul  $t8, $t0, $t0
	addi $t0, $t0, 1
	ble  $t8, $s0, loop
	
	li   $a0, 0		#
	li   $v0, 1		# 
	add  $a0, $a0, $s0	# print -1
	syscall			#
	
	li   $v0, 11		#
	la   $a0, ' '		# print ' '
	syscall			#
	
notPrime:
	addi $s0, $s0, 1
	bgt  $s0, $s1, end
	j checkPrime
end:

# Code C++:
#	if (n < 2) return 0;
#   	for(int i=2; i*i<=n; i++)
#      		if (n % i == 0) return 0;
#   	return 1;