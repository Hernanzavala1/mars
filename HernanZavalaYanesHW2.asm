#############################################################
# Homework #2
# name: Hernan J Zavala Yanes
# sccc id:01167391
##############################################################
.text


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
	
	
		

##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	
	

	
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
	#save to the stack
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2 8($sp)
	
	
	getLenghtOfString($a0) #get lenght of first string
	move $s0, $v0
	getLenghtOfString($a1) #get the lenght of the second string
	move $s1, $v0
	move $s2, $a2 #gets the lenght argument passed to function
	
	#test if lenght arguement is valid
	
	bltz  $s2, returnZero
	beqz  $s2, DoEntireString
	bgt $s2, $s0, returnZero #check if the lenght arguement is greater then the lenght of the first or second string
	bgt $s2, $s1, returnZero
	
	# if this point is reached then it is because lenght is less than the lenght of both strings and it is not negative
	li $t1, 0 #counter of the loop
	li $t2, 0 #counter for equal characters
	
	lenghtBasedLoop:
		beq $t1, $s2, doneStrcmp
                lb      $t3,($a0)                   # get next char from str1
  	  	lb      $t4,($a1)                   # get next char from str2
  	  	addi    $a0,$a0,1                   # increase address
  	 	addi    $a1,$a1,1                   # increase address
  	 	
  	 	addi $t1, $t1, 1 #increment the counter
  	 	
  	 	bne $t3, $t4, lenghtBasedLoop #if the 2 characters are not the same continue will following characters
  	 	addi $t2, $t2, 1 # otherwise increment the counter for equal characters
  	 	j lenghtBasedLoop # continue the loop until the counter reaches the lenght arguement
  	 	
  	 	DoEntireString:

  	 	addi $t1, $zero, 0 #counter for same characters in both strings
  	 	
  	 	InsideLoop: 
  	 	#load the two characters from both strings
  	 	lb $t2, 0($a0)
  	 	lb $t3, 0($a1)
  	 	
  	 	#increment the address 
  	 	addi $a0, $a0, 1
  	 	addi $a1, $a1, 1
  	 	
  	 	beq $t2, $0, Finished1 #if either character is a 0 it ends the loop
  	 	beq $t3, $0, Finished1
  	 	bne $t3, $t2, InsideLoop # if the two characters are not the same then continue the loop
  	 	addi $t1, $t1, 1 #otherwise increment the number of equal characters counter
  	 	j InsideLoop #continue the loop until a 0 is reached
  	 	
  	 	Finished1:
  	 	beq $s0, $s1, checkIfSame #if both strings have the same lenght check if all their characters were equal
		
		checkIfSame:
		beq $s1, $t1 changeSameCharValue #if the lenght of either string is equal to the counter of same characters then change retun value
		j return
		changeSameCharValue: 
		addi $t4, $t4, 1
		j return
			
		return:	
		#restore the stack
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
  	 		
  	 	#move the results to return registers			
		move $v0, $t1	
		move $v1, $t4
		cleanStrcmpRegister
		jr $ra

  	 	doneStrcmp:
  	 	#restore the stack
  	 	lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
	
		
		seq $t5, $t2, $a2#check if the number of characters matched equal the lenght passed in
		
		move $v0, $t2
		move $v1, $t5
		cleanStrcmpRegister
		jr $ra
  	 	
  	 	 returnZero:
  	 	 #restore the stack
  	 	 lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12
		
		addi $v0, $0, 0
		addi $v1, $0, 0
		cleanStrcmpRegister
		jr $ra
	 
	 
	
	
	


##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
 
	blt $a2, 1, returnZeros # if the lenght that is entered is less than 1 it will return 0, 0
	addi $a2, $a2, -1	#otherwise decrease it by 1 because of the null character
	
	la $s0, ($a0)	#text to be encoded($t4)
	la $s2, ($a1)   #load address of ToMorse_mcmsg($s3)
	la $s3, ($a2)   # this will be the limit for the amount of space allocated 
	move $t0, $0		# t0 will be the counter which will be used to check if there is still space left

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
 			
		
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
		
					
			jr $ra
		doneNull:
			
			sb $0, 0($a1)
			
			getLenghtOfString($s2)
			addi $t1, $v0, 1 #include \0 in length
			move $v0, $t1
			addi $v1, $0, 1
			clearAllTRegister
 			clearAllSRegister
 			
					
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
			jr $ra	
			
		doneToMorseNoMoreSpace:
			sb $0, 0($a1)
			
			getLenghtOfString($s2)
			addi $t1, $v0, 1 #include \0 in length
			move $v0, $t1
			move $v1, $0
			clearAllTRegister
 			clearAllSRegister
 			
		
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
								
			jr $ra	
		returnZeros:
			move $v0, $0
			move $v1, $0
			#restore the stack
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
			
			jr $ra
		
		printSpace:
			lb $t2, dividerCharToMorse
			sb $t2, 0($a1)
			addi $a1, $a1, 1
			addi $t0, $t0, 1
			j loopMorse
createKey:
#Define your code here
			#store to the stack
 			addi $sp, $sp, -24
 			sw $ra, 0($sp)
 			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12($sp)
			sw $s4, 16($sp)
			sw $s5, 20($sp)
	
			move $s0, $a0	#save first arguement to $s0
	
			jal toUpper #jump to make it all upper case
			move $a0, $s0			#get the original value of $a0 from $s0 after toUpper call
			move $t0, $a1 # move $a1, to $t0 register
			la $s5, CopyLoop			#load address of method
			jalr $s4, $s5 						# jump to method which the address is saved above
	
			la $a0, alphabet					#load address of alphabet to a0
			la $s5, CopyLoop			#load address of method
			jalr $s4, $s5 						# jump to method 
		
			sb $0, 0($a1)	
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24					#make the last in result as null
	
			clearAllTRegister
 			clearAllSRegister
  			jr $ra
   
    			CopyLoop:  
   	
   			move $t1, $t0 #move $a1 to $t1
			lb $s0, ($a0)			#load first charater from the input
			addi $a0, $a0, 1		#increment the address of the string passed in
			beq $s0, $0, jumpS4	#if the character loaded is a null(0) jump register $s4 to go back to the above code
	 
	
			bltu $s0, 65, CopyLoop		# following 2 lines checks if its a letter in the alphabet and upper case
			bgtu $s0, 90, CopyLoop 		
	
			jal AlreadyCopy		#check if in result exist the same letter
			beq $s2, 1, CopyLoop		#if both characters are the same then it continues with the loop
			sb $s0, ($a1)						#if this is reached it is because the characters were not the same and need to be stored in key
			addi $a1, $a1, 1					#increase address of the key
			j CopyLoop
		
			jumpS4: # this jumps resgister $s4 to go back to the main code in create key
			jr $s4
		
			AlreadyCopy:

			lb $s1, ($t1) # loads a character from the key that is passed in $a1
			addi $t1, $t1, 1 #increments the address of the key
			beq $s1, $0, jumpRA # if the character that is loaded is a 0 it goes back to the previous loop.
			seq $s2, $s1, $s0 # it checks if both the characters are the same
			beq $s2, 0, AlreadyCopy #if they are not equal then continue to check the rest of the key
			j jumpRA #if they are the same go back to previous loop
			
			jumpRA: # it goes back to the previous loop
			jr $ra
keyIndex:
		#Define your code here
		# save registers to the stack
			addi $sp, $sp ,-20
			sw $ra, 0($sp)
			sw $s3, 4($sp)
			sw $s4, 8($sp)
			sw $s5, 12($sp)
			sw $s6, 16($sp)
	
			la $a1, FMorseCipherArray #load the address of the array into $a1 which is one of the strings that will be compared to the $a0
			addi $a2, $0, 3 # set the the lenght for strcmp to 3 in $a2
			la $s3 ($a0)   # save the original arguement @a0
	
			move $s4, $0 			#counter for the loop below 
			move $s5, $0			#offset for the morsecipherArray
	  
	 
			la $t6, IndexKeyLoop # load the address of the method to $t6 
				
			jalr $s6, $t6 	# jump to the above method
				 	
			move $v0, $s4 # move the result into return register $v0	
	
			#restore the stack
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s4, 8($sp)
			lw $s5, 12($sp)
			lw $s6, 16($sp)
			addi $sp, $sp, 20
	
	 		#clean all registers 
			clearAllTRegister
 			clearAllSRegister
			jr $ra
	
			IndexKeyLoop:
			
			bgt $s4, 25, NotFoundIndex # index was not be able to found
			
			add $a0, $0, $s3 # reload the original $a0 
			la $a1, FMorseCipherArray
			add $a1, $a1, $s5 # set $a1, to morsecipher arry with an offset of multiple of 3
			
			jal strcmp # jump to strcmp 
			beq $v1, $at, jumpS6 
		
	                
			addi $s4, $s4, 1 #increment the loop counter
			addi $s5, $s5, 3 #increment the offset by 3
			j IndexKeyLoop
			
			jumpS6:# return to the main code up in the key index (line 494)
			jr $s6
			NotFoundIndex: 
	
			addi $v0, $zero, -1 # the index was not found so return a negative 1
			#restore the stack
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s4, 8($sp)
			lw $s5, 12($sp)
			lw $s6, 16($sp)
			addi $sp, $sp, 20
	
			clearAllTRegister
 			clearAllSRegister
	
			jr $ra	

FMCEncrypt:
	#Define your code here
	############################################
			la $t1, ($a1)			#phrase 
			la $t2, ($a2)			#buffer
			la $t3, ($a3)			# number of bytes that will be available in the buffer 
	
			addi $t3, $t3, -1
			add $s7, $0, $t1		
	
			#save to the stack
			addi $sp, $sp, -20
			sw $t1, 0($sp)	
			sw $t2, 4($sp)			
			sw $t3, 8($sp)
			sw $ra, 12($sp)		
			sw $t2, 16($sp)			
	


			la $a1, tempMorse	#load the address of allocated space
			addi $a2, $0, 100 #this is the size allocated 
			jal toMorse			#jump to toMorse code method above and convert the text to morse	
	
			lw $t1, 0($sp) # reload the phrase so it can be passed to the create key method
			la $a0, ($t1)
			la $a1, tempKey	# pass the memory address for the result space			
			jal createKey			#create a key with the 

			la $a0, tempMorse 
			sw $a0, 0($sp)
			la $a1, tempKey
	
			EncryptPhrase:
			lw $t3, 8($sp) #;load the number of bytes in the buffer
			beq $t3, $0, NextMethod # if the number is equal to 0 then jump to NextMethod
			
			lw $t1, ($sp) # reload the phrase arguement and load it to $a0 to get keyIndex
			la $a0, ($t1)
		
			jal keyIndex
		
			lw $a0, 0($sp)
			addi $a0, $a0, 3
			sw $a0, 0($sp)
		
			bge $v0, $0, includeMethod
					
			j NextMethod
			
			NextMethod:
	
			lw $t3, 8($sp)
			sne $v1, $t3, $0
			lw $t2, 0($sp)		
			sb $0 ($t2)		#add a zero to the end to make it null terminated
	
			lw $t2, 16($sp)		#address of buffer			
			la $v0, ($t2)		#load $t2 into return register
			
			#restore the stack
			lw $ra, 12($sp)	
			addi $sp, $sp, 20
	
			jr $ra

			includeMethod:#this method adds characters to the result string
			la $a1, tempKey
			add $a1, $a1, $v0		
			lb $t9 ($a1)
			
			lw $t2, 4($sp)
			sb $t9 ($t2)		
			addi $t2, $t2,1  #it includes the $t9 in the result $t2
			sw $t2, 4($sp)
			
			lw $t3, 8($sp)
			addi $t3, $t3, -1	#decrements the counter fo the loop
			sw $t3, 8($sp)
			j EncryptPhrase

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



FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"
