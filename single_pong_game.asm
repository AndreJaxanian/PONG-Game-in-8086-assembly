
.model small 

.stack 64 

.data


     ;playground   
     X1 dw 5
     Y1 dw 5      
     X2 dw 150
     Y2 dw 150
    
     ;BALL COORDS FOR MOVMENTS 
     start_col_ball          dw   100 ;x1
     start_row_ball          dw   100 ;y1
     finish_col_ball         dw   105 ;x2
     finish_row_ball         dw   105 ;y2
     
     ;BALL COORDS FOR SHIFRING MOVMENTS   
     start_col_Plus_ball     dw   101
     start_col_Plus2_ball    dw   99      
     start_row_Plus_ball     dw   99
     start_row_Plus2_ball    dw   101     
     finish_col_Plus_ball    dw   106
     finish_row_Plus2_ball   dw   106     
     finish_row_Plus_ball    dw   104
     finish_col_Plus1_ball   dw   104
     ball_width              dw   5 
     
       
     ;PADDLE COORDS
     
     start_col_paddle   dw  155
     start_row_paddle   dw  30
     finish_col_paddle  dw  160
     finish_row_paddle  dw  70
     
     TEMP1   dw 0
     TEMP2   dw 0
	 
	 ;To change Direction of movments also initiaize movment
	 Vy dw  -1
	 Vx dw  +1
	  
	 Ball_Color 	db 1h 
	 
     ;SCORE INFO AND COORDS.   
     SCORE          Dw  1d
     SCORE_COL      Db  30
     SCORE_ROW      Db  21
     SCORESTR   DW '============U LOST THE GAME=============$'
     
	;BOOLEAN FOR CHEKING LAST DIRECTION OF MOVMENT OF BALL TO GUESS THE NEXT REFLECTION
     UPR     DW  'F'      
     UPL     DW  'T'
     DOR     DW  'F'         
     DOL     DW  'F'
    

.code 

;-------------------MAIN------------------------
 
main proc far
	
	mov ax ,@data
	mov ds , ax
	
	
	call clear_scr
	call graphic_mode
    call make_playground
    call draw_ball
    call draw_Paddle
    
    
	
MainLoop:
	 call Paddle_Movment
	 call move_ball	 
	 call make_delay
	 call Chech_Hit 	 
	 jmp MainLoop
	
	LoseSide:
	mov ax , 4c00h
	int 21h

main endp




;-------------CLEAR SCREEN---------------------

clear_scr proc
    
    mov al, 06h
    mov bh, 00h
    mov cx, 0000h
    mov dx, 184fh
    int 10h
                 
    ret
endp clear_scr
 
 
;----------GAME GROUND---------------------- 

    
make_playground proc
    
    mov dx , X1 ;50
    mov cx , Y1 ;50    
    mov ah, 0ch 
   
loop:
    mov al, 5 
    int 10h
                        ;------------------------------------------              
    inc cx              ;             
    cmp cx , X2 ;100    ;                                          _
    jnz loop            ;                                         | |
                        ;                                         | |
    mov dx , X1 ;50     ;                                         | |
    mov cx , Y1 ;50     ;                                         | |
                        ;                                         | |
                        ;                                         | |
                        ;                                         | |
                        ;                                         |_|
loop2:                  ;             
    mov al, 5           ;              _
    int 10h             ;             |_|
                        ;             
    inc dx              ;            
    cmp dx , X2 ;100    ;--------------------------------------------             
    jnz Loop2        



    mov dx , X2 ;100
    mov cx , Y1 ;50
    
loop3:

    mov al, 5 
    int 10h
     
    inc cx
    cmp cx , X2 ;100
    jnz loop3
   
  ret  
    
 
endp make_playground
 
;---------------DRAW BALL-------------------

draw_ball proc
     
    mov ah, 0ch 
    mov al, 4
      
    mov dx, start_row_ball
Dloop1:
    mov cx, start_col_ball

Dloop2:
    int 10h
    inc cx
    cmp cx, finish_col_ball
    jnz Dloop2
    
    inc dx
    cmp dx, finish_row_ball
    jnz Dloop1
    
    ret
    
endp draw_ball         



;------------CLEAR BALL-----------------------


clr_ball proc
     
    mov ah, 0ch 
    mov al, 0
      
    mov dx, start_row_ball
clr1:
    mov cx, start_col_ball

clr2:
    int 10h
    inc cx
    cmp cx, finish_col_ball
    jnz clr2
    
    inc dx
    cmp dx, finish_row_ball
    jnz clr1
    
    ret
    
endp clr_ball 


;------------------PADDLE DRAW-------------------------- 
draw_Paddle proc
         
    mov ah, 0ch 
    mov al, Ball_Color
      
    mov dx, start_row_paddle
label1:
    mov cx, start_col_paddle
label2:
    int 10h
    inc cx
    cmp cx, finish_col_paddle
    jnz label2
    inc dx
    cmp dx, finish_row_paddle
    jnz label1

 ret
endp draw_Paddle 
 
 
 
      
;----------------SHOW SCORE ------------------------  
SHOW_SCORE  PROC   
	mov  dl, 20      
	mov  dh, 46       
	mov  ah, 02h             
	int  10h 
	mov ax,SCORE	 
	mov cx,0       
	mov dx,0 
	SLOOP: 
		cmp ax,0 
		je PrLOOP	 
		mov bx,10		 	
		div bx				  
		push dx			       
		inc cx			  
		xor dx,dx       
		jmp SLOOP 
	PrLOOP: 
		cmp cx,0          
		je exit
		pop dx 
		add dx,48              
		mov ah,02h         
		int 21h 
		 
		dec cx 
		jmp PrLOOP 
exit: 
	RET
SHOW_SCORE ENDP	



;----------------MSG-------------------------------
msg proc
 
mov  dl, 10       
mov  dh, 10      
mov  bh, 0             
mov  ah, 02h             
int  10h
MOV  AH,09H
LEA  DX,SCORESTR
INT  21H
        
 ret
endp msg        
 
;----------------BALL RIGHT MOVE -------SHIFTING------

move_right_ball proc
    mov ah, 0ch 
    mov al, 0
    mov dx, start_row_ball
    mov cx, start_col_ball 
L1: 
    int 10h 
    inc dx
    cmp dx, finish_row_ball
    jnz L1
              
              
    mov al, 4
    mov dx, start_row_ball
    mov cx, finish_col_ball 
L2: 
    int 10h   
    inc dx
    cmp dx, finish_row_ball
    jnz L2 
    
    inc start_col_ball
    inc finish_col_ball    
    
    ret                        
endp move_right_ball 
 

;------------------BALL DOWN MOVE-----USING SHIFTING------------ 

 move_down_ball proc 
    
    mov ah, 0ch 
    mov al, 0
    mov dx, start_row_ball
    mov cx, start_col_ball
LD1:  
    int 10h
    inc cx
    cmp cx , finish_col_ball
    jnz  LD1 
    
    mov ah, 0ch 
    mov al, 4
    mov dx, finish_row_ball
    mov cx, start_col_ball
LD2:  
    int 10h
    inc cx
    cmp cx , finish_row_Plus2_ball ;or finish_col_ball
    jnz  LU2
    
    inc start_row_ball
    inc finish_row_ball

              
    
    
    ret                      
                      
 endp move_down_ball
 
;-----------------BALL LEFT MOVE------SHIFTING------------------ 
 
 move_left_ball proc
    
    mov ah, 0ch 
    mov al, 0
    mov dx, start_row_ball
    mov cx, finish_col_ball
LL1:
    int 10h                 
    inc dx
    cmp dx , finish_row_ball
    jnz LL1
    
    mov ah, 0ch 
    mov al, 4
    mov dx, start_row_ball
    mov cx, start_col_ball
LL2:
    int 10h
    inc dx
    cmp dx , finish_row_ball
    jnz LL2 
    
    dec start_col_ball
    dec finish_col_ball
      
    
    ret                        
 endp move_left_ball
 

;-----------------BALL UP MOVE------SHIFTING-------------- 


move_up_ball proc 
    
    mov ah, 0ch 
    mov al, 0
    mov dx, finish_row_ball
    mov cx, start_col_ball
LU1:  
    int 10h
    inc cx
    cmp cx , finish_col_ball
    jnz  LU1 
    
    mov dx, start_row_Plus_ball
    mov cx, start_col_ball
    mov ah, 0ch 
    mov al, 4

LU2:  
    int 10h
    inc cx
    cmp cx , finish_col_ball
    jnz  LU2
    
    dec start_row_ball
    dec start_row_Plus_ball
    dec finish_row_ball
   
    ret                      
                      
endp move_up_ball 


;--------------------------MOVE UP RIGHT--_using shift not clear screen_----------------------
move_UR_ball proc
                                    ;Ball Coord : 100 100 105 105
    
    mov dx, finish_row_ball ;105   
    mov cx, start_col_ball  ;100
    mov ah, 0ch 
    mov al, 0

LUR1:
    int 10h
    dec dx
    cmp dx , start_row_ball  ;100
    jnz LUR1
    
    mov dx, start_row_ball   ;100
    mov cx, start_col_ball   ;100
    mov ah, 0ch 
    mov al, 0
    int 10h
    
    mov ah, 0ch 
    mov al, 0
    mov dx, finish_row_ball       ;105
    mov cx, start_col_Plus_ball   ;101
    
LUR2:
    int 10h
    inc cx
    cmp cx ,finish_col_ball
    jnz LUR2

    mov ah, 0ch 
    mov al, 4
    mov dx, start_row_Plus_ball
    mov cx, start_col_Plus_ball
       
LUR3: 

    int 10h
    inc cx
    cmp  cx , finish_col_Plus_ball
    jnz LUR3
    
    mov ah, 0ch 
    mov al, 4
    mov dx, start_row_Plus_ball
    mov cx, finish_col_Plus_ball
    
LUR4: 

    int 10h
    inc dx
    cmp  dx , finish_row_Plus_ball
    jnz LUR4   
       
       
    ;update base coordinates
    dec start_row_ball
    inc start_col_ball
    inc finish_col_ball
    dec finish_row_ball
    inc start_col_Plus_ball
    dec finish_row_Plus_ball
    inc finish_col_Plus_ball
    dec start_row_Plus_ball
    ret     
                      
endp move_UR_ball 
    
;--------------------------MOVE DownLeft-----_using shift, not clear screen_-----(works well(but has bug in game idk why but it works))--------------
move_DL_ball proc
                                    ;Ball Coord : 100 100 105 105
    
    mov dx, start_row_ball  ;100   
    mov cx, start_col_ball  ;100
    mov ah, 0ch 
    mov al, 0

LDL1:
    int 10h
    inc cx
    cmp cx , finish_col_ball  ;105
    jnz LDL1
    

    mov dx, start_row_ball    ;100
    mov cx, finish_col_ball   ;105
    mov ah, 0ch 
    mov al, 0
      
LDL2:
    int 10h
    inc dx
    cmp dx ,finish_row_ball
    jnz LDL2
  
     mov ah, 0ch 
    mov al, 4
    mov dx, start_row_Plus2_ball ;101
    mov cx, start_col_Plus2_ball  ;99 
LDL3: 

    int 10h
    inc dx
    cmp  dx , finish_row_Plus2_ball
    jnz LDL3
    
    mov ah, 0ch 
    mov al, 4
    mov dx, finish_row_Plus2_ball
    mov cx, start_col_Plus2_ball
    
LDL4: 

    int 10h
    inc cx
    cmp  cx , finish_col_Plus1_ball
    jnz LDL4   
       
       
    ;update base coordinates
    dec start_col_ball          
                                                          
    dec start_col_Plus2_ball          
    inc start_row_ball          
    
    inc start_row_Plus2_ball    
    dec finish_col_ball         
   
    inc finish_row_Plus2_ball   
  
    inc finish_row_ball    
    dec finish_col_Plus1_ball    
  
    ret     
                      
endp move_DL_ball 


;---------------------------------ONE  MOVING_BALL PROC ALL DIRECRION-------------------------------

move_ball proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball 
 
 
 mov cx , Vx
 mov bx , Vy
 
 add start_col_ball , cx   ;y sutun       
 add start_row_ball , bx
 add finish_col_ball, cx
 add finish_row_ball, bx
 call draw_ball     

ret     
                      
endp move_ball
                                             
;--------------------------MOVE UP-----_using clear screen_----------------------
MOVE_BALL_UP proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 dec start_row_ball
 dec finish_row_ball
 call draw_ball     

ret     
                      
endp MOVE_BALL_UP


;--------------------------MOVE DOWN-----_using clear screen_----------------------
MOVE_BALL_DOWN proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 inc start_row_ball
 inc finish_row_ball
 call draw_ball     

ret     
                      
endp MOVE_BALL_DOWN


;--------------------------MOVE LEFT-----_using clear screen_----------------------
MOVE_BALL_LEFT proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 dec start_col_ball
 dec finish_col_ball
 call draw_ball     

ret     
                      
endp MOVE_BALL_LEFT 

;--------------------------MOVE RIGHT-----_using clear screen_----------------------
MOVE_BALL_RIGHT proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball 
 inc start_col_ball
 inc finish_col_ball
 call draw_ball     

ret     
                      
endp MOVE_BALL_RIGHT
;--------------------------MOVE UP-LEFT-----_using clear screen_----------------------
move_LU_ball proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 dec start_col_ball          
 dec start_row_ball
 dec finish_col_ball
 dec finish_row_ball
 call draw_ball     

ret     
                      
endp move_LU_ball 

;..........................MOVE Down-LEFT-----_using clear screen_
move_DLL_ball proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 dec start_col_ball          
 inc start_row_ball
 dec finish_col_ball
 inc finish_row_ball
 call draw_ball     

ret     
                      
   endp move_DLL_ball   
   
;..........................MOVE UP-RIGHT -----_using clear screen_
 move_URR_ball proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 inc start_col_ball          
 dec start_row_ball
 inc finish_col_ball
 dec finish_row_ball
 call draw_ball     

ret     
                      
endp move_URR_ball 
;--------------------------MOVE DOWN-RIGHT-----_using clear screen_----------------------
move_DR_ball proc
                                    ;Ball Coord : 100 100 105 105
 call clr_ball
 inc  start_col_ball          
 inc  start_row_ball
 inc  finish_col_ball
 inc  finish_row_ball
 call draw_ball     

ret     
                      
endp move_DR_ball    

;----------------move ball and hit 1-------------


chk_hit_handller proc
;CHECK WHAT WAS THE LAST MOVMENT DIRECTION , FIND ONE IF EQ 'T'
CLOOP:
    cmp UPR , 'T'                 ;UPR,UPL,DOR,DOL  
    je UPRIGHT 
    cmp UPL , 'T'
    je UPLEFT
    cmp DOR , 'T'
    je DOWNR
    cmp DOL , 'T'
    je DOWNL
    ret


;##################UPRIGHT############################
    
UPRIGHT:
    
UPRIGHT1:
    mov dx , start_col_paddle
    cmp start_row_ball , 10
    je UPR1    
    cmp dx , finish_col_ball 
    je UPR2
    jmp UPRIGHT1

UPR1:
    call  move_DR_ball
    call  make_delay
    cmp start_row_ball , 10    
    jnz UPR1
    mov DOR , 'T'
    mov UPR , 'F'
    jmp CLOOP
    
    
UPR2:
    mov dx , start_col_paddle
    call move_LU_ball
    call make_delay
    cmp dx , finish_col_ball
    jnz UPR2
    mov UPL , 'T'
    mov UPR , 'F'
    jmp CLOOP    
    
 
;##################UPLEFT############################

UPLEFT:           ;upleft

UPLEFT1:

    cmp start_row_ball , 10
    je UPL1
    
    
    
    
    cmp start_col_ball , 10
    je UPL2
    jmp UPLEFT1 
   
UPL1:
                                                              ;Upright True
    call move_DLL_ball
    call make_delay
    cmp start_col_ball , 10
    jnz UPL1
    mov DOL , 'T'
    mov UPL , 'F'
    jmp CLOOP
 
UPL2:

    call move_URR_ball
    call make_delay
    cmp start_row_ball ,10
    jnz UPL2
    mov UPR , 'T'
    mov UPL , 'F'
    jmp CLOOP

;####################DOWNRIGHT###########################

DOWNR:

DOWNR1:
    mov dx , start_col_paddle       ;155
    cmp finish_row_ball , 150
    je DOR1
    cmp dx , finish_col_ball
    je DOR2
    jmp DOWNR1
    
DOR1:

    mov ax ,    start_col_paddle         ;paddle
    sub ax ,    finish_col_ball
    
    
    mov bx , start_row_ball              ;saghf
    sub bx , 10
    
    cmp bx , ax
    JL DORLOOP
DORLOOP2:
    call move_URR_ball
    call make_delay
    cmp dx , finish_col_ball                                  
    jnz DORLOOP2
    
    mov DOR , 'F'
    mov UPR , 'T'
    jmp CLOOP
    
DORLOOP:
    call move_URR_ball
    call make_delay
    cmp start_row_ball , 10
    jnz DORLOOP 
    
    mov DOR , 'F'
    mov UPR , 'T'
    jmp CLOOP  
DOR2:
    call move_DLL_ball
    call make_delay
    cmp finish_row_ball , 150
    jnz DOR2
    
    mov DOR , 'F'
    mov DOL , 'T'
    jmp CLOOP 
    

;####################DOWNLEFT###########################


DOWNL:


DOWNL1:

    cmp start_col_ball  , 10
    je DOL1
    cmp finish_row_ball , 150
    je DOL2
    jmp DOWNL1
    
DOL1:

    call move_DR_ball
    call make_delay
    cmp finish_row_ball , 150                                  ; upleft true
    jnz DOL1
    
    mov DOL , 'F'
    mov DOR , 'T'
    jmp CLOOP
    
DOL2:

    call move_LU_ball
    call make_delay
    cmp start_col_ball , 10
    jnz DOL2
    
    mov DOL , 'F'
    mov UPL , 'T'       
  
    jmp CLOOP


    
ret
endp chk_hit_handller




;-------------------------PADDLE_CHECK-------------------

    
Paddle_Movment PROC
    
    MOV AH,01H
    INT 16H
    JZ rxit
    
    
    MOV AH,00H
    INT 16H
    
    CMP AL,119    	;ASCI CODE 'W'
    JNE LBL
    CALL move_UPP_paddle
    
    LBL:
    CMP AL,115	;'S'
    JNE QUIT
    CALL move_Down_paddle
    
    QUIT:
    CMP AL,113		;'Q' TO EX
    JNE rxit
    mov ax, 4c00h 
    int 21h

    rxit:
    RET
Paddle_Movment ENDP

     
;-----------------------move_UP_paddle----------------------------
move_UPP_paddle proc
                                    ;paddle Coord : 155 30 160 70
 call clr_paddle
 add  start_row_paddle  ,-8
 add  finish_row_paddle ,-8
 call draw_Paddle     
 
ret     
                      
endp move_UPP_paddle

;-----------------------move_DOWN_paddle----------------------------
move_Down_paddle proc 
                                    ;paddle Coord : 155 30 160 70
 call clr_paddle
 add  start_row_paddle  ,8
 add  finish_row_paddle ,8
 call draw_Paddle      

ret     
                      
endp move_Down_paddle 

;-----------------------CLEAR PADDLE----------------------------

 clr_paddle proc
     
    mov ah, 0ch 
    mov al, 0
      
    mov dx, start_row_paddle
clear1:
    mov cx, start_col_paddle

clear2:
    int 10h
    inc cx
    cmp cx, finish_col_paddle
    jnz clear2
    
    inc dx
    cmp dx, finish_row_paddle
    jnz clear1
    
    ret
    
endp clr_paddle 
                                              
;-----------------SET CGH MODE--------------------  

graphic_mode proc
    mov ah, 00h
    mov al, 13h
    int 10h     
    ret
endp graphic_mode



;---------------RANDOM BALL COLOR ---------------------------

RANDOM_BALL_COLOR PROC

    
    MOV AH, 00h          
    INT 1AH
    
    MOV AL, DL
    MOV CX, 7
    SUB DX,DX
    DIV CX
    
    CMP DX,1H
    JE BLUE
    CMP DX,2H
    JE GREEN
    CMP DX,3H
    JE CYAN
    CMP DX,4H
    JE RED
    CMP DX,5H
    JE YELLOW
    CMP DX,6H
    JE WHITE
    CMP DX,7H
    JE WHITE1
    CMP DX,8H
    JE WHITE2
    CMP DX,8H
    JE WHITE3
    CMP DX,8H
    JE WHITE4
    CMP DX,8H
    JE WHITE5
    CMP DX,8H
    JE WHITE6
    
    BLUE:
    MOV Ball_Color,01H
    JMP GRC_END
    
    GREEN:
    MOV Ball_Color,2H
    JMP GRC_END
    CYAN:
    MOV Ball_Color,3H
    JMP GRC_END
     
    RED:
    MOV Ball_Color,4H
    JMP GRC_END
    
    YELLOW:
    MOV Ball_Color,0EH
    JMP GRC_END
    
    WHITE:
    MOV Ball_Color,1FH
    JMP GRC_END
    
    WHITE1:
    MOV Ball_Color,4FH
    JMP GRC_END
    
    WHITE2:
    MOV Ball_Color,4BH
    JMP GRC_END 
    WHITE3:
    MOV Ball_Color,04H
    JMP GRC_END
    WHITE4:
    MOV Ball_Color,3BH
    JMP GRC_END
    WHITE5:
    MOV Ball_Color,7DH
    JMP GRC_END
    WHITE6:
    MOV Ball_Color,5CH
    JMP GRC_END
    
    GRC_END:
    
    RET

RANDOM_BALL_COLOR ENDP 

;--------------  -DELAY---------------------------


make_delay proc
    
    mov cx , 4f87h
L5:

    loop L5 
    
    ret 
make_delay endp

;---------------  check hit---------------------------

Chech_Hit PROC
	
	CMP start_row_ball,15
	JBE HIT_UP_WALL

	CMP start_col_ball,15
	JBE HIT_WEST_WALL
	
	CMP finish_row_ball,145
	JAE HIT_SOUTH_WALL
	
	mov dx , start_col_paddle
	mov bx , start_row_paddle
	mov ax , finish_row_paddle
	CMP finish_col_ball , dx
	Jne Paddle_HIT_tmp
	CMP finish_row_ball , bx
	JB   FINISHING
	cmp start_row_ball , ax
	JA   FINISHING
	Jmp PADDLE_HIT
	
	
	FINISHING:
	CALL clear_scr
	call msg
	jmp LoseSide
	jmp Paddle_HIT_tmp 
	Paddle_HIT_tmp:
	jmp EX
	
	
HIT_UP_WALL:
		MOV Vy,1
		CMP Vx,-1	
		JNE HIT_UR	
		MOV Vx,-1
		JMP EX
	HIT_UR: 	
			MOV Vx,1
			JMP EX
			
HIT_WEST_WALL:
		MOV Vx,1
		CMP Vy,-1
		JNE HIT_UL
		MOV Vy,-1
		JMP EX
	HIT_UL:
		MOV Vy,1
		JMP EX
			
		
HIT_SOUTH_WALL:

		add Vy,-1
		CMP Vx,-1
		JNE HIT_DR
		MOV Vx,-1
		JMP EX
	HIT_DR:
		MOV Vx,1
		JMP EX
PADDLE_HIT:
	    call show_score
	    call RANDOM_BALL_COLOR
	    ADD SCORE , 1
	     
	    MOV Vx,-1
		CMP Vy,-1
		JNE HIT_P
		MOV Vy,-1
		JMP EX
	HIT_P:
		MOV Vy,1
		JMP EX	
	
	EX:
	RET
ENDP


end main


