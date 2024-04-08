
_MSDelay:

;micpros_v3.c,13 :: 		void MSDelay(unsigned char Time){ // Delay Function
;micpros_v3.c,15 :: 		for(y=0; y<Time; y++) // For loop delay
	CLRF       R1+0
L_MSDelay0:
	MOVF       FARG_MSDelay_Time+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_MSDelay1
;micpros_v3.c,16 :: 		for(z=0; z<254; z++); // for looop delay
	CLRF       R2+0
L_MSDelay3:
	MOVLW      254
	SUBWF      R2+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_MSDelay4
	INCF       R2+0, 1
	GOTO       L_MSDelay3
L_MSDelay4:
;micpros_v3.c,15 :: 		for(y=0; y<Time; y++) // For loop delay
	INCF       R1+0, 1
;micpros_v3.c,16 :: 		for(z=0; z<254; z++); // for looop delay
	GOTO       L_MSDelay0
L_MSDelay1:
;micpros_v3.c,17 :: 		}
L_end_MSDelay:
	RETURN
; end of _MSDelay

_Delay:

;micpros_v3.c,18 :: 		void Delay(unsigned char Time){   //delay function
;micpros_v3.c,20 :: 		for(m=0;m<Time;m++);  //for loop for delay
	CLRF       R1+0
L_Delay6:
	MOVF       FARG_Delay_Time+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Delay7
	INCF       R1+0, 1
	GOTO       L_Delay6
L_Delay7:
;micpros_v3.c,21 :: 		}
L_end_Delay:
	RETURN
; end of _Delay

_LCD_CMD:

;micpros_v3.c,22 :: 		void LCD_CMD(unsigned char x){
;micpros_v3.c,23 :: 		LCD=x;  // send data to LCD
	MOVF       FARG_LCD_CMD_x+0, 0
	MOVWF      PORTC+0
;micpros_v3.c,24 :: 		RS=0;
	BCF        PORTD+0, 2
;micpros_v3.c,25 :: 		RW=0;
	BCF        PORTD+0, 1
;micpros_v3.c,26 :: 		EN=1;
	BSF        PORTD+0, 0
;micpros_v3.c,27 :: 		MSDelay(5);
	MOVLW      5
	MOVWF      FARG_MSDelay_Time+0
	CALL       _MSDelay+0
;micpros_v3.c,28 :: 		EN=0;
	BCF        PORTD+0, 0
;micpros_v3.c,29 :: 		}
L_end_LCD_CMD:
	RETURN
; end of _LCD_CMD

_LCD_DATA:

;micpros_v3.c,30 :: 		void LCD_DATA(unsigned char x){ //data in lcd display
;micpros_v3.c,31 :: 		LCD=x;
	MOVF       FARG_LCD_DATA_x+0, 0
	MOVWF      PORTC+0
;micpros_v3.c,32 :: 		RS=1;
	BSF        PORTD+0, 2
;micpros_v3.c,33 :: 		RW=0;
	BCF        PORTD+0, 1
;micpros_v3.c,34 :: 		EN=1;
	BSF        PORTD+0, 0
;micpros_v3.c,35 :: 		MSDelay(5);
	MOVLW      5
	MOVWF      FARG_MSDelay_Time+0
	CALL       _MSDelay+0
;micpros_v3.c,36 :: 		EN=0;
	BCF        PORTD+0, 0
;micpros_v3.c,37 :: 		}
L_end_LCD_DATA:
	RETURN
; end of _LCD_DATA

_LCD_INI:

;micpros_v3.c,38 :: 		void LCD_INI(void){ //initialize the lcd display
;micpros_v3.c,39 :: 		MSDelay(250);
	MOVLW      250
	MOVWF      FARG_MSDelay_Time+0
	CALL       _MSDelay+0
;micpros_v3.c,40 :: 		LCD_CMD(0x38);
	MOVLW      56
	MOVWF      FARG_LCD_CMD_x+0
	CALL       _LCD_CMD+0
;micpros_v3.c,41 :: 		LCD_CMD(0x0E);
	MOVLW      14
	MOVWF      FARG_LCD_CMD_x+0
	CALL       _LCD_CMD+0
;micpros_v3.c,42 :: 		LCD_CMD(0x01);
	MOVLW      1
	MOVWF      FARG_LCD_CMD_x+0
	CALL       _LCD_CMD+0
;micpros_v3.c,43 :: 		}
L_end_LCD_INI:
	RETURN
; end of _LCD_INI

_FindKey:

;micpros_v3.c,53 :: 		unsigned char FindKey(){
;micpros_v3.c,54 :: 		KeyPad = 0xF0;
	MOVLW      240
	MOVWF      PORTB+0
;micpros_v3.c,55 :: 		do{
L_FindKey9:
;micpros_v3.c,56 :: 		KeyPad = 0xF0;
	MOVLW      240
	MOVWF      PORTB+0
;micpros_v3.c,57 :: 		COLloc=(KeyPad & 0xF0); // masked keypad with 0xf0 and copy result
	MOVLW      240
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _COLloc+0
;micpros_v3.c,58 :: 		}while(COLloc !=0xF0); //stay in this loop until all keys release
	MOVF       R1+0, 0
	XORLW      240
	BTFSS      STATUS+0, 2
	GOTO       L_FindKey9
;micpros_v3.c,59 :: 		while(1){
L_FindKey12:
;micpros_v3.c,60 :: 		KeyPad = 0xFE; // ground row 0
	MOVLW      254
	MOVWF      PORTB+0
;micpros_v3.c,61 :: 		COLloc = (KeyPad & 0xF0);  // masked keypad with 0xf0 and copy result
	MOVLW      240
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _COLloc+0
;micpros_v3.c,62 :: 		if (COLloc != 0xF0){
	MOVF       R1+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_FindKey14
;micpros_v3.c,63 :: 		ROWloc = 0;  // save row 0
	CLRF       _ROWloc+0
;micpros_v3.c,64 :: 		break;   //exit loop
	GOTO       L_FindKey13
;micpros_v3.c,65 :: 		}
L_FindKey14:
;micpros_v3.c,66 :: 		KeyPad = 0xFD;  // ground row 1
	MOVLW      253
	MOVWF      PORTB+0
;micpros_v3.c,67 :: 		COLloc = (KeyPad & 0xF0);
	MOVLW      240
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _COLloc+0
;micpros_v3.c,68 :: 		if (COLloc != 0xF0){
	MOVF       R1+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_FindKey15
;micpros_v3.c,69 :: 		ROWloc = 1;
	MOVLW      1
	MOVWF      _ROWloc+0
;micpros_v3.c,70 :: 		break;
	GOTO       L_FindKey13
;micpros_v3.c,71 :: 		}
L_FindKey15:
;micpros_v3.c,72 :: 		KeyPad = 0xFB; // ground row 2
	MOVLW      251
	MOVWF      PORTB+0
;micpros_v3.c,73 :: 		COLloc = (KeyPad & 0xF0);
	MOVLW      240
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _COLloc+0
;micpros_v3.c,74 :: 		if (COLloc != 0xF0){
	MOVF       R1+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_FindKey16
;micpros_v3.c,75 :: 		ROWloc = 2;
	MOVLW      2
	MOVWF      _ROWloc+0
;micpros_v3.c,76 :: 		break;
	GOTO       L_FindKey13
;micpros_v3.c,77 :: 		}
L_FindKey16:
;micpros_v3.c,78 :: 		KeyPad = 0xF7; // ground row 3
	MOVLW      247
	MOVWF      PORTB+0
;micpros_v3.c,79 :: 		COLloc = (KeyPad & 0xF0);
	MOVLW      240
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _COLloc+0
;micpros_v3.c,80 :: 		if (COLloc != 0xF0){
	MOVF       R1+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_FindKey17
;micpros_v3.c,81 :: 		ROWloc = 3;
	MOVLW      3
	MOVWF      _ROWloc+0
;micpros_v3.c,82 :: 		break;
	GOTO       L_FindKey13
;micpros_v3.c,83 :: 		}
L_FindKey17:
;micpros_v3.c,84 :: 		}
	GOTO       L_FindKey12
L_FindKey13:
;micpros_v3.c,85 :: 		if (COLloc == 0xE0){
	MOVF       _COLloc+0, 0
	XORLW      224
	BTFSS      STATUS+0, 2
	GOTO       L_FindKey18
;micpros_v3.c,86 :: 		return (KeyPress[ROWloc][0]);
	MOVF       _ROWloc+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _KeyPress+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	GOTO       L_end_FindKey
;micpros_v3.c,87 :: 		} else if (COLloc == 0xD0){
L_FindKey18:
	MOVF       _COLloc+0, 0
	XORLW      208
	BTFSS      STATUS+0, 2
	GOTO       L_FindKey20
;micpros_v3.c,88 :: 		return (KeyPress[ROWloc][1]);
	MOVF       _ROWloc+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVLW      _KeyPress+0
	ADDWF      R0+0, 1
	INCF       R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	GOTO       L_end_FindKey
;micpros_v3.c,89 :: 		} else if (COLloc == 0xB0){
L_FindKey20:
	MOVF       _COLloc+0, 0
	XORLW      176
	BTFSS      STATUS+0, 2
	GOTO       L_FindKey22
;micpros_v3.c,90 :: 		return (KeyPress[ROWloc][2]);
	MOVF       _ROWloc+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVLW      _KeyPress+0
	ADDWF      R0+0, 1
	MOVLW      2
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	GOTO       L_end_FindKey
;micpros_v3.c,91 :: 		} else if (COLloc == 0x70){
L_FindKey22:
	MOVF       _COLloc+0, 0
	XORLW      112
	BTFSS      STATUS+0, 2
	GOTO       L_FindKey24
;micpros_v3.c,92 :: 		return (KeyPress[ROWloc][3]);
	MOVF       _ROWloc+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVLW      _KeyPress+0
	ADDWF      R0+0, 1
	MOVLW      3
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	GOTO       L_end_FindKey
;micpros_v3.c,93 :: 		}
L_FindKey24:
;micpros_v3.c,94 :: 		}
L_end_FindKey:
	RETURN
; end of _FindKey

_main:

;micpros_v3.c,100 :: 		void main()
;micpros_v3.c,107 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;micpros_v3.c,108 :: 		TRISD.RD0 = 0;
	BCF        TRISD+0, 0
;micpros_v3.c,109 :: 		TRISD.RD1 = 0;
	BCF        TRISD+0, 1
;micpros_v3.c,110 :: 		TRISD.RD2 = 0;
	BCF        TRISD+0, 2
;micpros_v3.c,111 :: 		TRISB = 0xF0;
	MOVLW      240
	MOVWF      TRISB+0
;micpros_v3.c,112 :: 		OPTION_REG = 0x00;
	CLRF       OPTION_REG+0
;micpros_v3.c,113 :: 		LCD_INI();
	CALL       _LCD_INI+0
;micpros_v3.c,114 :: 		MSDelay(200);
	MOVLW      200
	MOVWF      FARG_MSDelay_Time+0
	CALL       _MSDelay+0
;micpros_v3.c,115 :: 		sw1=0; sw2=0;
	CLRF       _sw1+0
	CLRF       _sw1+1
	CLRF       _sw2+0
	CLRF       _sw2+1
;micpros_v3.c,116 :: 		while(1){
L_main25:
;micpros_v3.c,117 :: 		click=FindKey();
	CALL       _FindKey+0
	MOVF       R0+0, 0
	MOVWF      _click+0
;micpros_v3.c,118 :: 		if(click==' '){
	MOVF       R0+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_main27
;micpros_v3.c,119 :: 		LCD_INI(); //clear
	CALL       _LCD_INI+0
;micpros_v3.c,120 :: 		sw1=0; sw2=0;
	CLRF       _sw1+0
	CLRF       _sw1+1
	CLRF       _sw2+0
	CLRF       _sw2+1
;micpros_v3.c,121 :: 		} else if (click=='='){
	GOTO       L_main28
L_main27:
	MOVF       _click+0, 0
	XORLW      61
	BTFSS      STATUS+0, 2
	GOTO       L_main29
;micpros_v3.c,123 :: 		switch (sign) {
	GOTO       L_main30
;micpros_v3.c,124 :: 		case 1:
L_main32:
;micpros_v3.c,125 :: 		ans = op1 + op2;
	MOVF       _op2+0, 0
	ADDWF      _op1+0, 0
	MOVWF      _ans+0
	MOVF       _op1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _op2+1, 0
	MOVWF      _ans+1
;micpros_v3.c,126 :: 		break;
	GOTO       L_main31
;micpros_v3.c,127 :: 		case 2:
L_main33:
;micpros_v3.c,128 :: 		ans = op1 - op2;
	MOVF       _op2+0, 0
	SUBWF      _op1+0, 0
	MOVWF      _ans+0
	MOVF       _op2+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _op1+1, 0
	MOVWF      _ans+1
;micpros_v3.c,129 :: 		break;
	GOTO       L_main31
;micpros_v3.c,130 :: 		case 3:
L_main34:
;micpros_v3.c,131 :: 		ans = op1 * op2;
	MOVF       _op1+0, 0
	MOVWF      R0+0
	MOVF       _op1+1, 0
	MOVWF      R0+1
	MOVF       _op2+0, 0
	MOVWF      R4+0
	MOVF       _op2+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _ans+0
	MOVF       R0+1, 0
	MOVWF      _ans+1
;micpros_v3.c,132 :: 		break;
	GOTO       L_main31
;micpros_v3.c,133 :: 		case 4:
L_main35:
;micpros_v3.c,134 :: 		ans = op1 / op2;
	MOVF       _op2+0, 0
	MOVWF      R4+0
	MOVF       _op2+1, 0
	MOVWF      R4+1
	MOVF       _op1+0, 0
	MOVWF      R0+0
	MOVF       _op1+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _ans+0
	MOVF       R0+1, 0
	MOVWF      _ans+1
;micpros_v3.c,135 :: 		break;
	GOTO       L_main31
;micpros_v3.c,137 :: 		}
L_main30:
	MOVLW      0
	XORWF      _sign+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      1
	XORWF      _sign+0, 0
L__main66:
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	MOVLW      0
	XORWF      _sign+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      2
	XORWF      _sign+0, 0
L__main67:
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	MOVLW      0
	XORWF      _sign+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      3
	XORWF      _sign+0, 0
L__main68:
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	MOVLW      0
	XORWF      _sign+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVLW      4
	XORWF      _sign+0, 0
L__main69:
	BTFSC      STATUS+0, 2
	GOTO       L_main35
L_main31:
;micpros_v3.c,138 :: 		LCD_DATA('=');
	MOVLW      61
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,139 :: 		if (sign==1){
	MOVLW      0
	XORWF      _sign+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      1
	XORWF      _sign+0, 0
L__main70:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
;micpros_v3.c,140 :: 		ch=ans-'0';
	MOVLW      48
	SUBWF      _ans+0, 0
	MOVWF      _ch+0
;micpros_v3.c,141 :: 		} else {
	GOTO       L_main37
L_main36:
;micpros_v3.c,142 :: 		ch=ans+'0';
	MOVLW      48
	ADDWF      _ans+0, 0
	MOVWF      _ch+0
;micpros_v3.c,143 :: 		}
L_main37:
;micpros_v3.c,144 :: 		LCD_DATA(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,145 :: 		sw1=0; sw2=0;
	CLRF       _sw1+0
	CLRF       _sw1+1
	CLRF       _sw2+0
	CLRF       _sw2+1
;micpros_v3.c,146 :: 		}else{
	GOTO       L_main38
L_main29:
;micpros_v3.c,148 :: 		if (click=='+'||click=='x'||click=='/'||click=='-'){
	MOVF       _click+0, 0
	XORLW      43
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	MOVF       _click+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	MOVF       _click+0, 0
	XORLW      47
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	MOVF       _click+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	GOTO       L_main41
L__main58:
;micpros_v3.c,149 :: 		switch (click) {
	GOTO       L_main42
;micpros_v3.c,150 :: 		case '+':
L_main44:
;micpros_v3.c,151 :: 		sign = 1; LCD_DATA(click);
	MOVLW      1
	MOVWF      _sign+0
	MOVLW      0
	MOVWF      _sign+1
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,152 :: 		break;
	GOTO       L_main43
;micpros_v3.c,153 :: 		case '-':
L_main45:
;micpros_v3.c,154 :: 		sign = 2; LCD_DATA(click);
	MOVLW      2
	MOVWF      _sign+0
	MOVLW      0
	MOVWF      _sign+1
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,155 :: 		break;
	GOTO       L_main43
;micpros_v3.c,156 :: 		case 'x':
L_main46:
;micpros_v3.c,157 :: 		sign = 3; LCD_DATA(click);
	MOVLW      3
	MOVWF      _sign+0
	MOVLW      0
	MOVWF      _sign+1
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,158 :: 		break;
	GOTO       L_main43
;micpros_v3.c,159 :: 		case '/':
L_main47:
;micpros_v3.c,160 :: 		sign = 4; LCD_DATA(click);
	MOVLW      4
	MOVWF      _sign+0
	MOVLW      0
	MOVWF      _sign+1
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,161 :: 		break;
	GOTO       L_main43
;micpros_v3.c,163 :: 		}
L_main42:
	MOVF       _click+0, 0
	XORLW      43
	BTFSC      STATUS+0, 2
	GOTO       L_main44
	MOVF       _click+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L_main45
	MOVF       _click+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_main46
	MOVF       _click+0, 0
	XORLW      47
	BTFSC      STATUS+0, 2
	GOTO       L_main47
L_main43:
;micpros_v3.c,164 :: 		} else {
	GOTO       L_main48
L_main41:
;micpros_v3.c,165 :: 		if(sw1==0 && sw2==0){
	MOVLW      0
	XORWF      _sw1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      0
	XORWF      _sw1+0, 0
L__main71:
	BTFSS      STATUS+0, 2
	GOTO       L_main51
	MOVLW      0
	XORWF      _sw2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVLW      0
	XORWF      _sw2+0, 0
L__main72:
	BTFSS      STATUS+0, 2
	GOTO       L_main51
L__main57:
;micpros_v3.c,166 :: 		op1 = (int) click ;
	MOVF       _click+0, 0
	MOVWF      _op1+0
	CLRF       _op1+1
;micpros_v3.c,167 :: 		LCD_DATA(click);
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,168 :: 		sw1=1;
	MOVLW      1
	MOVWF      _sw1+0
	MOVLW      0
	MOVWF      _sw1+1
;micpros_v3.c,169 :: 		} else if (sw1==1 && sw2==0){
	GOTO       L_main52
L_main51:
	MOVLW      0
	XORWF      _sw1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVLW      1
	XORWF      _sw1+0, 0
L__main73:
	BTFSS      STATUS+0, 2
	GOTO       L_main55
	MOVLW      0
	XORWF      _sw2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVLW      0
	XORWF      _sw2+0, 0
L__main74:
	BTFSS      STATUS+0, 2
	GOTO       L_main55
L__main56:
;micpros_v3.c,170 :: 		op2 = (int) click ;
	MOVF       _click+0, 0
	MOVWF      _op2+0
	CLRF       _op2+1
;micpros_v3.c,171 :: 		LCD_DATA(click);
	MOVF       _click+0, 0
	MOVWF      FARG_LCD_DATA_x+0
	CALL       _LCD_DATA+0
;micpros_v3.c,172 :: 		sw2=1;
	MOVLW      1
	MOVWF      _sw2+0
	MOVLW      0
	MOVWF      _sw2+1
;micpros_v3.c,173 :: 		}
L_main55:
L_main52:
;micpros_v3.c,174 :: 		}
L_main48:
;micpros_v3.c,176 :: 		}
L_main38:
L_main28:
;micpros_v3.c,177 :: 		}
	GOTO       L_main25
;micpros_v3.c,178 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
