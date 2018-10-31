#############################################################
# Homework #2
# name: MY_NAME
# sbuid: MY_SBU_ID
##############################################################
.text

.macro clearRegister(%register)
addi %register, %register, 0
.end_macro


.macro getLenghtOfString(%string)
	move $t1, $zero
	la $t6, (%string)  #load address of a string
	loopCount: 
		lb $t5, 0($t6)		#load byte to s5
		addi $t6, $t6, 1 	#increase address by one
		beq $t5, $zero, doneCount    #if equal to 0(end of a string), break		
		addi $t1, $t1, 1	#increase counter by 1
		j loopCount		#back in counter loop
 	doneCount: 
 		move $t5, $0		
 		move $t6, $0	
 		move $v0, $t1		#move counter to v0
 		

.end_macro 
.macro saveSRegisterToStack
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)
	.end_macro 
.macro clearAllTRegister
move $t0, $zero
move $t1, $zero
move $t2, $zero
move $t3, $zero
move $t4, $zero
move $t5, $zero
move $t6, $zero
.end_macro

.macro clearAllSRegister
move $s0, $0 
move $s1, $0
move $s2, $0
move $s3, $0
move $s4, $0
move $s5, $0
move $s6, $0
move $s7, $0
.end_macro 
.macro cleanStrcmpRegister
move $s0, $zero
move $s1, $zero
move $s2, $zero
move $t1, $zero
move $t2, $zero
move $t3, $zero
move $t4, $zero
move $t5, $zero
.end_macro 
jumpToRegisterS4:
jr $s4 
jumpToRegisterS6:
 			
			jr $s6
jumpToRegister:
	jr $ra
	

##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	
	
	#addi $sp, $sp, -4
	#sw $a0, 0($sp)
	
	la $s0, ($a0)
	li $t3, 32  #will be used to convert to upper
	Upperloop: 
		lb $t1, 0($a0)
		addi $a0, $a0, 1 #increase address by one
		beq $t1, $0, done		#branch if null reached
		blt $t1, 'a', Upperloop		#if the character is not in range just return to beggining and increment the character
		bgt $t1, 'z', Upperloop 		
		
		subu $t2, $t1, $t3   #make in upperCase
		sb $t2, -1($a0)		#store changed character in previous position
	
		j Upperloop
 	done: 
 		#print a0 to see what value it has at this point
 		#lw $a0, 0($sp)
 		#addi $sp, $sp, 4
 		move $v0, $s0
 		clearAllTRegister
 		

	
		jr $ra

	length2Char:
	#no need to save arguement a0 and a1 since the following few instructions dont operate on them
		addi $sp $sp -4
		sw $ra, 0($sp) # store the return address before calling the next label
		
		lb $t4, ($a1) #character for search 
		move $t8, $zero  #initialize the counter for the characters.
		jal getLenghtLoop
		
	getLenghtLoop: 
		
		
		lb $t1, ($a0)
		addi $a0, $a0, 1 	#increase address by one
		beq $t1, $zero, done2    #if equal to 0, break
		beq $t1, $t4, done2 	#if equal to key, break
		
		addi $t8, $t8, 1	#increase counter by 1
	
		j getLenghtLoop


 	done2: 
 		lw $ra, 0($sp) #RESTORE THE RETURN ADDRESS 
 		addi $sp, $sp, 4#restore the stack
 		
 		move $v0, $t8 		#move counter to v0
 		clearAllTRegister
 		clearAllSRegister
 		
		jr $ra	
	



strcmp:
	#Define your code here
	#addi $sp, $sp, -8
	#sw $ra,0($sp)
	#sw $a2, 4($sp) #save the lenght arguement
	
	getLenghtOfString($a0) #get lenght of first string
	move $s0, $v0
	getLenghtOfString($a1) #get the lenght of the second string
	move $s1, $v0
	move $s2, $a2 #gets the lenght argument passed to function
	
	#test if lenght arguement is valid
	bltz  $s2, returnZero
	beqz  $s2, GoThroughString
	bgt $s2, $s0, returnZero
	bgt $s2, $s1, returnZero
	
	# if this point is reached then it is because lenght is less than the lenght of both strings and it is not negative
	li $t1, 0 #counter of the loop
	li $t2, 0 #number of characters that are the same
	
	lenghtBasedLoop:
	beq $t1, $s2, doneStrcmp2
                lb      $t3,($a0)                   # get next char from str1
  	  	lb      $t4,($a1)                   # get next char from str2
  	  	addi    $a0,$a0,1                   # increase address
  	 	addi    $a1,$a1,1                   # increase addres
  	 	addi $t1, $t1, 1 #increment the counter
  	 	
  	 	bne $t3, $t4, lenghtBasedLoop
  	 	addi $t2, $t2, 1
  	 	j lenghtBasedLoop
  	 	
  	 	GoThroughString:
  	 	
  	 	addi $t1, $t1, 0 #counter for same characters in both strings
  	 	
  	 	InsideLoop: 
  	 	lb $t2, 0($a0)
  	 	lb $t3, 0($a1)
  	 	
  	 	addi $a0, $a0, 1
  	 	addi $a1, $a1, 1
  	 	beq $t2, $0, doneSTRCMP
  	 	beq $t3, $0, doneSTRCMP
  	 	bne $t3, $t2, InsideLoop
  	 	addi $t1, $t1, 1
  	 	j InsideLoop
  	 	
  	 	doneSTRCMP:
  	 	beq $s0, $s1, checkCharacters #if both strings have the same lenght check if all their characters were equal
		
			checkCharacters:
				beq $s1, $t1 updateReturnValue
					j return
					updateReturnValue: 
					addi $t4, $t4, 1
					j return
			
		return:	
		#lw $ra, 0($sp)
  	 	#lw $a2, 4($sp)
  	 	#addi $sp, $sp, 8
  	 			
		move $v0, $t1	
		move $v1, $t4
		cleanStrcmpRegister
		jr $ra

  	 	
  	
  	 	
  	 	
  	 	
  	 	
  	 	
  	 	doneStrcmp2:
  	 	#lw $ra, 0($sp)
  	 	#lw $a2, 4($sp)
  	 	#addi $sp, $sp, 8
	
		
		seq $t5, $t2, $a2
		
		move $v0, $t2
		move $v1, $t5
		cleanStrcmpRegister
		jr $ra
  	 	
  	 	 returnZero:
  	 	 #restore the stack
 		# lw $ra, 0($sp)
  	 	# lw $a2, 4($sp)
  	 	#addi $sp, $sp, 8
		
		addi $v0, $0, 0
		addi $v1, $0, 0
		cleanStrcmpRegister
		jr $ra
	 
	 
	
	
	


##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	blt $a2, 1, returnZeros # if the lenght that is entered is less than 1 it will return 0, 0
	addi $a2, $a2, -1	#otherwise decrease it by 1 because of the null character
	
	la $s0, ($a0)	#text to be encoded($t4)
	la $s2, ($a1)   #load address of ToMorse_mcmsg($s3)
	la $s3, ($a2)   # this will be the limit for the amount of space allocated 
	move $t0, $0		# t0 will be the counter which will be used to check if there is still space left
	 
	saveSRegisterToStack


	
	lb $s1, ($s0)
	beq $s1, $zero, doneNull
	loopMorse:
		lb $s1, ($s0)		#load char from address    s1 - char from plainText 	t4 -address of plaintext
		addi $s0, $s0, 1 	#increase address of plain text
		beq $t0, $s3, doneToMorseNoMoreSpace
		beq $s1, $zero, doneToMorse
		bgt $s1, 90, loopMorse
		blt $s1, 32, loopMorse
		beq $s1, 32, printSpace		#print Space if s1 = space
			
		addi $s1, $s1, -33	
		
		la $t5, MorseCode	
		addi $t6, $s1, 0     #t6 index of MorseCode
		add $t6, $t6, $t6    # double the index
		add $t6, $t6, $t6    # double the index
   		add $t7, $t6, $t5    #combine indexies	
		lw $t8, 0($t7)	     #get value from morce code array
		
		
		getLenghtOfString($t8)		#count length of morse equivalent
		move $s6, $v0			# length of morse equivalent
		move $s5, $zero			# counter for a loop converting char to morse equivalent
		
		loopCharToMorse:
			
			beq $s2, $s3, doneToMorseNoMoreSpace

			lb $t5, ($t8)
			addi $t8, $t8, 1
			addi $s5, $s5, 1
			sb $t5, ($a1)
			addi $a1, $a1, 1
			addi $t0, $t0, 1
			beq $s5, $s6, endOfChar
			j loopCharToMorse
		
		endOfChar:
			
		
			lb $t2, dividerCharToMorse
			sb $t2, 0($a1)
			addi $a1, $a1, 1
			addi $t0, $t0, 1
			
			j loopMorse
		
		doneToMorse:
			lb $t2, dividerCharToMorse
			sb $t2, 0($a1)
			addi $a1, $a1, 1
			sb $0, 0($a1)
			
			getLenghtOfString($s2)
			addi $t1, $v0, 1 #include \0 in length
			move $v0, $t1
			addi $v1, $0, 1
			clearAllTRegister
 			clearAllSRegister
 			
			addi $sp, $sp, 12
			lw $s0, 0($sp)
			lw $s2, 4($sp)
			lw $s3, 8($sp)
		
					
			jr $ra
		doneNull:
			
			sb $0, 0($a1)
			
			getLenghtOfString($s2)
			addi $t1, $v0, 1 #include \0 in length
			move $v0, $t1
			addi $v1, $0, 1
			clearAllTRegister
 			clearAllSRegister
 			
			addi $sp, $sp, 12
			lw $s0, 0($sp)
			lw $s2, 4($sp)
			lw $s3, 8($sp)		
				
			jr $ra	
			
		doneToMorseNoMoreSpace:
			sb $0, 0($a1)
			
			getLenghtOfString($s2)
			addi $t1, $v0, 1 #include \0 in length
			move $v0, $t1
			move $v1, $0
			clearAllTRegister
 			clearAllSRegister
 			
			
			addi $sp, $sp, 12
			lw $s0, 0($sp)
			lw $s2, 4($sp)
			lw $s3, 8($sp)
								
			jr $ra	
		returnZeros:
			move $v0, $0
			move $v1, $0
			
			jr $ra
		
		printSpace:
			lb $t2, dividerCharToMorse
			sb $t2, 0($a1)
			addi $a1, $a1, 1
			addi $t0, $t0, 1
			j loopMorse
createKey:
#Define your code here
	la $s6, ($ra)		#save main return address for next 
	
	add $s0, $a0, $0	#save input address before making it uppercase
	jal toUpper
	move $a0, $s0			#a0 - input address after uppercase method
	
	
	add $t0, $a1, $0		#t0 - result address, will not be changed
	
	la $s5, loopForCopyingWithoutRepetition			#load address of method
	jalr $s4, $s5 						# jump to method and save return address
	
	la $a0, alphabet					#load address of alphabet to a0, will be used is follow method as input string
	la $s5, loopForCopyingWithoutRepetition			#load address of method
	jalr $s4, $s5 						# jump to method and save return address
		
	sb $0, 0($a1)						#make the last in result as null
	la $ra, ($s6)
	clearAllTRegister
 	clearAllSRegister
  	jr $ra
   
    	loopForCopyingWithoutRepetition:
   	add $t1, $t0, $0		#address of the result string, used for checking existing char
   
	lb $s0, ($a0)			#load byte from input
	addi $a0, $a0, 1		#increase input address by one
	beq $s0, $0, jumpToRegisterS4	#stop funcrion if null is reached
	
	bltu $s0, 65, loopForCopyingWithoutRepetition		# check if character is in a range
	bgtu $s0, 90, loopForCopyingWithoutRepetition 		# check if character is in a range
	
	jal checkIfExist					#check if in result exist the same letter
	beq $s2, 1, loopForCopyingWithoutRepetition		#if in result exist the same letter, go to loop
	sb $s0, ($a1)						#add to result
	addi $a1, $a1, 1					#increase address for saving in result
	j loopForCopyingWithoutRepetition
		
		
		checkIfExist:
			lb $s1, ($t1)
			addi $t1, $t1, 1
			beq $s1, $0, jumpToRegister
			seq $s2, $s1, $s0
			beq $s2, 0, checkIfExist
			j jumpToRegister



keyIndex:
		#Define your code here
	addi $sp, $sp ,-4
	sw $ra, 0($sp)
	
	la $a1, FMorseCipherArray
	addi $a2, $0, 3
	la $s3 ($a0)
	move $s4, $0 			#counter for a loop	(s0)
	move $s5, $0			#counter for offset from beggining (s1)
	  
	 
	la $t6, loopfForKeyIndex
				#load address of method
	jalr $s6, $t6 				 	
	move $v0, $s4	
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	clearAllTRegister
 	clearAllSRegister
	jr $ra
	
	loopfForKeyIndex:
	                
	                #sw $s0, 4($sp)
	                #sw $s1, 8($sp) 
	               # sw $s4, 12($sp)
			
			bgt $s4, 25, keyIndexNotFound # $s0 will never reach 25 since it is ecoming 0 every time
			
			add $a0, $0, $s3 # here is the problem after the first loop it will become a zero 
			la $a1, FMorseCipherArray
			add $a1, $a1, $s5
			
			jal strcmp
			beq $v1, $1, jumpToRegisterS6
		
	                
			addi $s4, $s4, 1
			addi $s5, $s5, 3
			j loopfForKeyIndex
	keyIndexNotFound: 
	
	addi $v0, $zero, -1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	clearAllTRegister
 	clearAllSRegister
	
	jr $ra	

FMCEncrypt:
	#Define your code here
	############################################
	clearAllTRegister
 	clearAllSRegister
	la $t1, ($a1)			#phrase for key
	la $t2, ($a2)			#buffer
	la $t3, ($a3)			#limit
	addi $t3, $t3, -1
	addi $sp, $sp, -20		#stack
	sw $t1, 0($sp)			#store for key
	add $s7, $0, $t1		
	sw $t2, 4($sp)			#	
	sw $t3, 8($sp)			#
	
	la $s5, ($ra)			#save RA for future
	sw $s5, 12($sp)			#save RA	
	
	sw $t2, 16($sp)			#store buffer, no change to it
	la $a1, tempMorse		
	addi $a2, $0, 100
	jal toMorse			#plaintext to Morse	
	
	lw $t1, 0($sp)
	la $a0, ($s7)
	la $a1, tempKey				
	jal createKey			#createKey
	
	
	
	la $a0, tempMorse
	sw $a0, 0($sp)
	la $a1, tempKey
	
		loopEncrypt:
		lw $t3, 8($sp)
		beq $t3, $0, goNext
		lw $a0, ($sp)
		la $a0, ($a0)
		
		jal keyIndex
		
		lw $a0, 0($sp)
		addi $a0, $a0, 3
		sw $a0, 0($sp)
		
		bge $v0, $0, addToResult
					
		j goNext
	goNext:
	#addi $v1, $0, 1
	lw $t3, 8($sp)
	sne $v1, $t3, $0
	lw $t2, 0($sp)		#	make result null terminated
	sb $0 ($t2)		#
	
	lw $t2, 16($sp)		#address of buffer			
	la $v0, ($t2)		#for output
	#addi $v1, $0, 1		
	
	lw $s5, 12($sp)	
	addi $sp, $sp, 20
	la $ra, ($s5)
	jr $ra

		addToResult:
			la $a1, tempKey
			add $a1, $a1, $v0		#v0 - offset
			lb $t9 ($a1)
			
			lw $t2, 4($sp)
			sb $t9 ($t2)		#t2 - result	
			addi $t2, $t2,1
			sw $t2, 4($sp)
			
			lw $t3, 8($sp)
			addi $t3, $t3, -1	#	decrease loop counter	
			sw $t3, 8($sp)
			j loopEncrypt

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra



.data
tempMorse: .space 100
tempKey: .space 26

alphabet: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 
dividerCharToMorse: .asciiz "x"
MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."
test: .asciiz  "hello"


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"
