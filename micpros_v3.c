#define LCD  PORTC
#define KeyPad PORTB

#include <stdio.h>
//#include <stdlib.h> // for atoi()
//#include <string.h> // for strcat()


sbit EN at PORTD.B0; // Define Enable pin at PORT D Pin RD0
sbit RW at PORTD.B1; // Define Read Write pinat PORT D Pin RD1
sbit RS at PORTD.B2; // Define RS pin at PORT D Pin RD2

void MSDelay(unsigned char Time){ // Delay Function
unsigned char y, z; // Define variable
for(y=0; y<Time; y++) // For loop delay
for(z=0; z<254; z++); // for looop delay
}
void Delay(unsigned char Time){   //delay function
unsigned char m;  //delay variable
for(m=0;m<Time;m++);  //for loop for delay
}
void LCD_CMD(unsigned char x){
LCD=x;  // send data to LCD
RS=0;
RW=0;
EN=1;
MSDelay(5);
EN=0;
}
void LCD_DATA(unsigned char x){ //data in lcd display
LCD=x;
RS=1;
RW=0;
EN=1;
MSDelay(5);
EN=0;
}
void LCD_INI(void){ //initialize the lcd display
MSDelay(250);
LCD_CMD(0x38);
LCD_CMD(0x0E);
LCD_CMD(0x01);
}
unsigned char KeyPress[4][4] = {'7', '8', '9', '/', //0,3 = /
                               '4', '5', '6', 'x',  //1,3 = x
                               '1', '2', '3', '-',  //2,3 = -
                               ' ', '0', '=', '+'}; //3,3 = +
                               //3,0 = clear      row,col
//intialize variables
unsigned char COLloc, ROWloc;
unsigned char click;

unsigned char FindKey(){
KeyPad = 0xF0;
do{
  KeyPad = 0xF0;
  COLloc=(KeyPad & 0xF0); // masked keypad with 0xf0 and copy result
}while(COLloc !=0xF0); //stay in this loop until all keys release
while(1){
         KeyPad = 0xFE; // ground row 0
         COLloc = (KeyPad & 0xF0);  // masked keypad with 0xf0 and copy result
         if (COLloc != 0xF0){
         ROWloc = 0;  // save row 0
         break;   //exit loop
         }
         KeyPad = 0xFD;  // ground row 1
         COLloc = (KeyPad & 0xF0);
         if (COLloc != 0xF0){
         ROWloc = 1;
         break;
         }
         KeyPad = 0xFB; // ground row 2
         COLloc = (KeyPad & 0xF0);
         if (COLloc != 0xF0){
         ROWloc = 2;
         break;
         }
         KeyPad = 0xF7; // ground row 3
         COLloc = (KeyPad & 0xF0);
         if (COLloc != 0xF0){
         ROWloc = 3;
         break;
         }
}
if (COLloc == 0xE0){
return (KeyPress[ROWloc][0]);
} else if (COLloc == 0xD0){
return (KeyPress[ROWloc][1]);
} else if (COLloc == 0xB0){
return (KeyPress[ROWloc][2]);
} else if (COLloc == 0x70){
return (KeyPress[ROWloc][3]);
}
}
int op1;
int op2; 
int sign;
int sw1; int sw2; int ans;
char ch;
void main()
{
//char myStack[10];
//char in[10];
//char ch;
//int top; // Index of the top element
//    initStack(myStack, &top);
    TRISC = 0x00;
    TRISD.RD0 = 0;
    TRISD.RD1 = 0;
    TRISD.RD2 = 0;
    TRISB = 0xF0;
    OPTION_REG = 0x00;
    LCD_INI();
    MSDelay(200);
    sw1=0; sw2=0;
    while(1){
    click=FindKey();
    if(click==' '){
      LCD_INI(); //clear
      sw1=0; sw2=0;
    } else if (click=='='){
    // solve the stack
    switch (sign) {
        case 1:
            ans = op1 + op2;
            break;
        case 2:
            ans = op1 - op2;
            break;
        case 3:
            ans = op1 * op2;
            break;
        case 4:
            ans = op1 / op2;
            break;

    }
    LCD_DATA('=');
    if (sign==1){
    ch=ans-'0';
    } else {
    ch=ans+'0';
    }
    LCD_DATA(ch);
    sw1=0; sw2=0;
    }else{
    // push the click to stack
    if (click=='+'||click=='x'||click=='/'||click=='-'){
       switch (click) {
        case '+':
            sign = 1; LCD_DATA(click);
            break;
        case '-':
            sign = 2; LCD_DATA(click);
            break;
        case 'x':
            sign = 3; LCD_DATA(click);
            break;
        case '/':
            sign = 4; LCD_DATA(click);
            break;

    }
    } else {
       if(sw1==0 && sw2==0){
       op1 = (int) click ;
       LCD_DATA(click);
       sw1=1;
       } else if (sw1==1 && sw2==0){
       op2 = (int) click ;
       LCD_DATA(click);
       sw2=1;
       }
    }

    }
    }
}