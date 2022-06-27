.data
	A: .word 160, -1, 190, 180, -1, -1, 150, 170, -1, 200, 140, -1
	B: .word 		# Array B: a copy of A, and storing the result

.text
main: 
	la   $s0, A 		# $s0: Address of A[0]
	la   $a1, B		# $a1: Address of B[0], the next address of the last element of A
	
	sub  $s1, $a1, $s0
	divu $s1, $s1, 4	# Length of A		
	li   $t9, 0		# $t9: number of trees
init1:	
	addu $s5, $s5, $s0	# $s5: Address of A[i]
	addu $a2, $a2, $a1	# $a2: Address of B[i]
copyAtoB:
	lw   $k0, 0($s5)	# load each element of A into $k0
    	sw   $k0, 0($a2)	# store $k0 into each address of B
	addu $s5, $s5, 4	# move to the next address of A
	addu $a2, $a2, 4	# move to the next address of B
	bgtz $k0, not_cnt_tree	# if ($k0>0) it is not a tree
	addi $t9, $t9, 1	# count number of trees
	blt  $s5, $a1, copyAtoB # if not reach the last element of A, go again
not_cnt_tree:
	blt  $s5, $a1, copyAtoB # if not reach the last element of A, go again
	
	addi $t0, $a2, 0	# Array Height, the next address of the last element of B

# Insertion sort in array A:
# $s2: i
# $s3: pos
# $s4: x
# $s6: Address of A[pos]
# $s7: Value of A[pos]
	li   $s2, 1 		
sort_loop1: 
	sll  $s5, $s2, 2 	# Convert i to memory access
	add  $s5, $s5, $s0 	# Add offset i to base A
	lw   $s4, 0($s5) 	# x = A[i]
	addi $s3, $s2, -1 	# pos = i - 1
	sll  $s6, $s3, 2 	# Convert pos to memory access
	add  $s6, $s6, $s0 	# Add offset pos to base A
sort_loop2: 
	lw   $s7, 0($s6) 	# load A[pos]
	blt  $s7, $s4, break 	# Continue looping if A[pos] >= x
	sw   $s7, 4($s6) 	# A[pos+1] = A[pos]
	addi $s3, $s3, -1 	# pos--
	addi $s6, $s6, -4 	# Keep memory access consistent with pos
	bge  $s3, $0, sort_loop2 # Loop if pos >= 0
break: 
	sw   $s4, 4($s6) 	# A[pos+1] = x
	addi $s2, $s2, 1 	# i++
	blt  $s2, $s1, sort_loop1 # i < (length of A) goto Loop1
	
init2:
	sub  $t7, $t9, $s1 	
	sub  $t7, $zero, $t7	# $t7: number of heigths = (length of A) - (number of trees)
	sll  $s5, $t9, 2 	# memory access
	add  $s5, $s5, $s0	# address of the first height (the shortest after sort)
	addi $t1, $t0, 0	# $t1: Address of Height[i], store all heights of A in asc order
copy_height:			# copy all heights in A to array Height
	lw   $at, 0($s5)	# load each height of A into $at
    	sw   $at, 0($t1)	# store $at into each address of B
	addu $s5, $s5, 4	# move to the next address of A
	addu $t1, $t1, 4	# move to the next address of Height
	blt  $s5, $a1, copy_height # if not reach the last height of A, go again

init3:
	addi $t1, $t0, 0	# move to the first address of Height
print_result:
	lw   $t4, 0($a1)	# load each element of B into $t4
	bgtz $t4, isHeight	# if ($t4>0), go to isHeight
	addi $a1, $a1, 4	# else move to the next address of B
	
	li   $a0, 0		#
	li   $v0, 1		# 
	add  $a0, $a0, $t4	# print -1
	syscall			#
	
	li   $v0, 11		#
	la   $a0, ' '		# print ' '
	syscall			#
	
	blt  $a1, $t0, print_result	# if not reach the last element of B, go again
	b exit			# else exit
isHeight:
	lw   $at, 0($t1)	# load each height of A into $at	
    	sw   $at, 0($a1)	# store $at into each address of B in which a height is
    	addi $a1, $a1, 4	# move to the next address of B
  	addi $t1, $t1, 4	# move to the next address of Height
  	
  	li   $a0, 0		#
  	li   $v0, 1		# 
	add  $a0, $a0, $at	# print a height
	syscall			#
	
	li $v0, 11		#
	la $a0, ' '		# print ' '
	syscall			#
	
  	blt  $a1, $t0, print_result	# if not reach the last element of B, go again
exit:
	