.data
	true: .asciiz "True"
	false: .asciiz "False"
	A: .word 1,2,3
	Aend: .word 
	B: .word 1,2,4
	Bend: .word
	
.text
# load address of array A and B
main: 
	la $s0, A	# $s0 = Address(A[0])
	la $a1, Aend
	la $s1, B	# $s1 = Address(B[0])
	la $a2, Bend
	
# Compare the length of array A and B. If length A != length B then return false; else we continue
	sub $s4, $a1, $s0
	sub $s5, $a2, $s1
	bne $s4, $s5, print_false
	
# init countswap = 0: number of swap
	addi $s2, $zero, 0 

# Start loop compare A[i] B[i]
	addi $t1, $s0, 0
	addi $t2, $s1, 0
	j compare_A_and_B
loop:
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	beq  $t1, $a1, compare_countswap
	beq  $t2, $a2, compare_countswap
compare_A_and_B:
	lw   $t3, 0($t1)
	lw   $t4, 0($t2)
	beq  $t3, $t4, loop 	# compare_A_and_B each element in array A and B
	addi $s2, $s2, 1  	# countswap + 1
	j loop
# Return countswap = 2 or countswap = 0
compare_countswap:
	beq $s2, $zero, print_true # compare with 0
	j   else
else:
	bne $s2, 2, print_false	# compare with 2
	
# Loop2: $t5 is h
	addi $t1, $s0, 0
	addi $t2, $s1, 0
	j compare_2
Loop_2:
	addi $t1, $t1, 4
	addi $t2, $t2, 4
compare_2:
	lw  $t3, 0($t1)
	lw  $t4, 0($t2)
	beq $t3, $t4, Loop_2
	add $t5, $zero, $t1
	add $t6, $zero, $t2
	j   final_loop
	
# Start final loop
final_loop: 
	addi $t7, $t5, 4 # $t7 is k
	addi $t6, $t6, 4 # $t6 is k in B
	j  compare_k
loop_3:
	addi $t7, $t7, 4
	addi $t6, $t6, 4
compare_k:
	lw  $t3, 0($t7)
	lw  $t4, 0($t6)
	beq $t3, $t4, loop_3
	j  final_compare
final_compare:
	lw  $t3, 0($t5)
	lw  $t4, 0($t6)
	beq $t3, $t4, set_1
	add $t8, $zero, $zero
	j  con
set_1:
	addi $t8, $zero, 1
con:
	lw  $t3, 0($t7)
	sub $s7, $t7, $t5
	sub $t6, $t6, $s7
	lw  $t4, 0($t6)
	beq $t3, $t4, set_2
	add $t9, $zero, $zero
	j  check
set_2:
	addi $t9, $zero, 1
check:
	mul $s6, $t8, $t9
	beq $s6, $zero, print_false
	j  print_true

print_true:
	li $v0, 4
	la $a0, true
	syscall
	j end
print_false:
	li $v0, 4
	la $a0, false
	syscall
end:

# Code in C++:
# 	int n = sizeof(a) / sizeof(a[0]);
#	int count = 0;
#	for(int i=0; i<n; i++)
#		if(a[i]!=b[i]) count++;
#	if(count==0) return true;
#	else if(count!=2) return false;
#	int h;
#	for(int i=0; i<n; i++)
#		if(a[i]!=b[i])
#		{
#			h=i; 
#			break;
#		}
#	for(int k=h+1; k<n; k++)
#		if(a[k]!= b[k]) return a[h]==b[k] && a[k]==b[h];







