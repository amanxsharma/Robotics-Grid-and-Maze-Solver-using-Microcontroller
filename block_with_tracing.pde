/*
 *  Program: line_following_black
 *  
 *  Reads an input from the line following sensors panel connected at pins A1,A2,A3
 *  and drives the left and right motor to trace the line 
 *  Background Color: White
 *  Line Color: Black
 *  Sensor sequence -->  Sensor orientation: LED's facing forward
                         |----------------------------------------------|
                         |---A4----------A3-----A2-----A1----------A0---|
                         |----------------------------------------------|
                                      sensors utilised A4-A0
 *  
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Technido Indore for Workshop at Truba Indore
*/

//#include <LiquidCrystal.h>
//LiquidCrystal LCD(13, 11, 10, 9, 3, 2);

// Grid Parameters
#define north  0
#define east   1
#define south  2
#define west   3
//
# define Lp  4    // ip B
# define Ln  7    // ip A
# define El  5

// Right Motor Controls
# define Rp  8    // ip A
# define Rn  12   // ip B
# define Er  6

// Grid Sensors // holding the bot with gripper oriented outwards
# define ERs   A0
# define Rs   A1
# define Ms   A2
# define Ls   A3
# define ELs   A4

int myDir = 0,dir=0;
boolean scan = false;
unsigned int x=0,y=0, Lx=0, Ly=0, node=0,X,Y;
unsigned int block_place=1,IR1,IR2,sense,sense1,Lsense;
void setup()
{  
 // put your setup code here, to run once:
 // LCD.begin(16, 2);
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);
  
  analogWrite (El,225);
  analogWrite (Er,225);
  
  pinMode (ERs, INPUT);
  pinMode (Rs, INPUT);
  pinMode (Ms, INPUT);
  pinMode (Ls, INPUT);
  pinMode (ELs, INPUT);
  pinMode (2, INPUT);
  pinMode (3, INPUT);
  pinMode (9, OUTPUT);
  pinMode (10, OUTPUT);
 // LCD.print("Testing");
 // indication of code start
  for(int i=0; i<20; i++)
  {
    digitalWrite(13,LOW);
    delay(50);
    digitalWrite(13,HIGH);
    delay(50);
  }
  delay(2500);    // 2.5sec delay

}

void loop()
{ X=x;
  Y=y;
  scanning(X,Y);
  IR1 = digitalRead(2);
  IR2 = digitalRead(3);
  while(1)
  {
    if((IR1 || IR2) == 0)
    { X=Lx;
      Y=Ly;
      
      MotorControl(1,1);
      delay(200);
      MotorControl(0,0);
      delay(40);
      digitalWrite(9,1);
      digitalWrite(10,0);
      delay(2000);
      digitalWrite(9,0);
      digitalWrite(10,0);
      MotorControl(0,0);
      block_pick();
    }
    break;
  }
}


void scanning(int x,int y)
{
  if((!digitalRead(ERs) && !digitalRead(Rs)) ^ (!digitalRead(ELs) && !digitalRead(Ls)))
  {
     if(!digitalRead(ERs) && !digitalRead(Rs))
     {
       MotorControl(1,0); while(digitalRead(Rs));
     }
     if(!digitalRead(ELs) && !digitalRead(Ls))
     {
       MotorControl(0,1); while(digitalRead(Ls));
     }
  } 
  while((digitalRead(ELs)) && (digitalRead(ERs)))
  {
     digitalWrite(13, LOW);
     line_following();
  }
  if ((!digitalRead(ELs)) && (!digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)) && (!digitalRead(ERs)))
  {
     MotorControl(0,0);
     delay(10);
     Lx = x;
     Ly = y;
     node = node+1;
     if (x==0 && y==7)
     {
              MotorControl(0,0);
              delay(10);
              scan =true;
     }
     else
     {
       if (y==0)
       {
         if(x==0)
         {
         x=x+1;
         y=y;
         while((!digitalRead(ELs)) && (!digitalRead(ERs)))
               { MotorControl(1,1); } 
         MotorControl(0,0);
         delay(40);               
         if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
         {
           if((!digitalRead(ELs)))
             {MotorControl(1,0);  while(digitalRead(Rs));}
           if ((!digitalRead(ERs)))
              {MotorControl(0,1);  while(digitalRead(Ls));}                    
         }
         MotorControl(0,0);
         delay(40);
       }
       else
       {
                        if(x>0 && x<7)
                        {
                            x=x+1;
                            y=y;
                            while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                              { MotorControl(1,1); }
                            MotorControl(0,0);
                            delay(40);                
                            if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                            {
                                if((!digitalRead(ELs)))
                                {MotorControl(1,0);  while(digitalRead(Rs));}
                                if ((!digitalRead(ERs)))
                                {MotorControl(0,1);  while(digitalRead(Ls));}                    
                            }
                            MotorControl(0,0);
                            delay(40);
                        }
                        else
                        {
                           y=y+1;
                           x=x;
                           MotorControl(1,1);	delay(150);
                           dir = change_Dir(myDir, west);
                           myDir =dir;
                           MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                        }
                    }
                }
                else
                {
                    if(y==1 || y == 3 || y==5 || y==7 )
                    {
                        if(x==7)
                        {
                            x=x-1;
                            y=y;
                            MotorControl(1,1);	delay(150);
                            dir = change_Dir(myDir, south);
                            myDir =dir;
                            MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                        }
                        else
                        {
                            if(x<7 && x>0)
                            {
                                x=x-1;
                                y=y;
                                while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                  { MotorControl(1,1); }
                                MotorControl(0,0);
                                delay(40);                
                                if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                {
                                    if((!digitalRead(ELs)))
                                    {MotorControl(1,0);  while(digitalRead(Rs));}
                                    if ((!digitalRead(ERs)))
                                    {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                }
                                MotorControl(0,0);
                                delay(40);
                            }
                            else
                            {
                               y=y+1;
                               x=x;
                               MotorControl(1,1);	delay(150);
                               dir = change_Dir(myDir, west);
                               myDir =dir;
                               MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                            }
                        }
                    }
                    else    // y==2,4,6,8,10
                    {
                          if(x==0)
                          {
                              x=x+1;
                              y=y;
                              MotorControl(1,1);	delay(150);
                              dir = change_Dir(myDir, north);
                              myDir =dir;
                              MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                          }
                          else
                          {
                              if(x>0 && x<7)
                              {
                                  x=x+1;
                                  y=y;
                                  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                              }
                              else
                               {
                                   y=y+1;
                                   x=x;
                                   MotorControl(1,1);	delay(150);
                                   dir = change_Dir(myDir, west);
                                   myDir =dir;
                                   MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                               }
                          }
                    }
                }
          }
    }
}

int change_Dir (int my_Dir, int next_dir)
{
	if (my_Dir == north)
	{
////////////////////////////
			switch (next_dir)
			{
				case (east):
					MotorControl(1,2);	//delay(400);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while black pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				case (south):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
					
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				case (west):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Rs));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
					
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == east)
	{
			switch (next_dir)
			{
				case (south):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;

				case (west):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (north):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Rs));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == south)
	{
			switch (next_dir)
			{
				case (west):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (north):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (east):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Rs));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;	
                                        
				default: break;
			}
	}
////////////////////////////
	if (my_Dir == west)
	{
			switch (next_dir)
			{
				case (north):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;
                                        
				case (east):
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					delay(70);    MotorControl(0,0);	delay(90);
                                        
					MotorControl(1,2);	//delay(600);	//turn right ...blind turn
					while(digitalRead(ERs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Ls));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;

				case (south):
					MotorControl(2,1);	//delay(600);	//turn left ...blind turn
					while(digitalRead(ELs));   		//while middle pin is not on white...turn right
					while(!digitalRead(Rs));   		//while middle pin is not on white...turn right
					my_Dir = next_dir;  // update current Dir
					delay(70);    MotorControl(0,0);	delay(90);
					break;	
	
				default: break;
			}
	}
        
	return (my_Dir); // return updated direction to calling function
}

void line_following ()
{
    if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))         // if all black // s3, s2, s1 on black
     MotorControl(1,1);
  else if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)))    // if Right on white // S1 out
     MotorControl(0,1);
  else if ((!digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))  // if Right & Middle on white // S1 & s2 out
     MotorControl(0,1);
  else if ((digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))    // if Left on white // s2 out
     MotorControl(1,0);
  else if ((digitalRead(Ls)) && (digitalRead(Ms)) && (!digitalRead(Rs)))  // if Left & Middle on white // S3 & s2 out
     MotorControl(1,0);
  
}

void MotorControl(int driveL, int driveR)
{
switch (driveL) {
      
    case 0:                  // lft STOP
      digitalWrite (Lp,LOW);
      digitalWrite (Ln,LOW);
      break;
      
    case 1:                  // lft FORWARD
      digitalWrite (Lp,HIGH);
      digitalWrite (Ln,LOW);
      break;
      
    case 2:                  // lft REVERSE
      digitalWrite (Lp,LOW);
      digitalWrite (Ln,HIGH);
      break;
      
    default:break;
  } 
  
switch (driveR) {
      
    case 0:                  // rgt STOP
      digitalWrite (Rp,LOW);
      digitalWrite (Rn,LOW);
      break;
      
    case 1:                  // rgt FORWARD
      digitalWrite (Rp,HIGH);
      digitalWrite (Rn,LOW);
      break;
      
    case 2:                  // rgt REVERSE
      digitalWrite (Rp,LOW);
      digitalWrite (Rn,HIGH);
      break;
      
    default:break;
  }  
}

void block_pick()
{
  if(x>1&& dir==0)  //first itiration
  {
    dir = change_Dir(myDir, east);
    myDir =dir;
    while(y!=0)
    {
      MotorControl(1,1);
      y--;
      while((!digitalRead(ELs)) && (!digitalRead(ERs)))
      { MotorControl(1,1);}
      MotorControl(0,0);
      delay(40);                
      if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
      {
        if((!digitalRead(ELs)))
          {MotorControl(1,0);  while(digitalRead(Rs));}
        if ((!digitalRead(ERs)))
          {MotorControl(0,1);  while(digitalRead(Ls));}                    
      }
      MotorControl(0,0);
      delay(40);
      MotorControl(1,1);
    }
    if(y==0)
    {
      dir = change_Dir(myDir, south);
      myDir =dir;
      while(x!=1)
      {
         MotorControl(1,1);
         x--;
         while((!digitalRead(ELs)) && (!digitalRead(ERs)))
              { MotorControl(1,1);}
         MotorControl(0,0);
         delay(40);                
         if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
         {
            if((!digitalRead(ELs)))
              {MotorControl(1,0);  while(digitalRead(Rs));}
            if((!digitalRead(ERs)))
              {MotorControl(0,1);  while(digitalRead(Ls));}                    
         }
         MotorControl(0,0);
         delay(40);
         MotorControl(1,1);
      }
      dir = change_Dir(myDir, east);
      myDir =dir;
      line_follower();
    }
  }
  if(x>1&& dir==2) //second itiration
  {
    dir = change_Dir(myDir, east);
    myDir =dir;
    while(y!=0)
    {
       MotorControl(1,1);
       y--;
       while((!digitalRead(ELs)) && (!digitalRead(ERs)))
       { MotorControl(1,1); }
       MotorControl(0,0);
       delay(40);                
       if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
       {
         if((!digitalRead(ELs)))
           {MotorControl(1,0);  while(digitalRead(Rs));}
         if((!digitalRead(ERs)))
           {MotorControl(0,1);  while(digitalRead(Ls));}                    
       }
       MotorControl(0,0);
       delay(40);
       MotorControl(1,1);
    }
    if(y==0)
    {
       dir = change_Dir(myDir, south);
       myDir =dir;
       while(x!=1)
       {
          MotorControl(1,1);
          x--;
          while((!digitalRead(ELs)) && (!digitalRead(ERs)))
          { MotorControl(1,1);}
          MotorControl(0,0);
          delay(40);                
          if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
          {
            if((!digitalRead(ELs)))
              {MotorControl(1,0);  while(digitalRead(Rs));}
            if((!digitalRead(ERs)))
              {MotorControl(0,1);  while(digitalRead(Ls));}                    
          }
          MotorControl(0,0);
          delay(40);
          MotorControl(1,1);
       }
       dir = change_Dir(myDir, east);
       myDir =dir;
       line_follower ();
    }
 }
 if(y==0 && dir==0) //third itiration
 {
  dir = change_Dir(myDir, east);
  myDir =dir;
  dir = change_Dir(myDir, south);
  myDir =dir;
  while(x!=1)
  {
    MotorControl(1,1);
    x--;
    while((!digitalRead(ELs)) && (!digitalRead(ERs)))
    { MotorControl(1,1);}
    MotorControl(0,0);
    delay(40);                
    if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
      {
        if((!digitalRead(ELs)))
        {MotorControl(1,0);  while(digitalRead(Rs));}
        if ((!digitalRead(ERs)))
        {MotorControl(0,1);  while(digitalRead(Ls));}                    
      }
      MotorControl(0,0);
      delay(40);
      MotorControl(1,1); 
  }
  dir = change_Dir(myDir, east);
  myDir =dir;
  line_follower ();

 }
 if(x==0 && dir==3) //fourth itiration
 {
  dir = change_Dir(myDir, north);
  myDir =dir;
  dir = change_Dir(myDir, east);
  myDir =dir;
  while(y!=0)
  {
    MotorControl(1,1);
    y--;
    while((!digitalRead(ELs)) && (!digitalRead(ERs)))
    { MotorControl(1,1);}
    MotorControl(0,0);
    delay(40);                
    if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
    {
      if((!digitalRead(ELs)))
      {MotorControl(1,0);  while(digitalRead(Rs));}
      if ((!digitalRead(ERs)))
      {MotorControl(0,1);  while(digitalRead(Ls));}                    
    }
    MotorControl(0,0);
    delay(40);
    MotorControl(1,1);
  }
  if(y==0)
  {
   dir = change_Dir(myDir, north);
   myDir =dir;
   while(x!=1)
   {
   MotorControl(1,1);
   x++;
   while((!digitalRead(ELs)) && (!digitalRead(ERs)))
   { MotorControl(1,1);}
   MotorControl(0,0);
   delay(40);                
   if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
   {
     if((!digitalRead(ELs)))
     {MotorControl(1,0);  while(digitalRead(Rs));}
     if ((!digitalRead(ERs)))
     {MotorControl(0,1);  while(digitalRead(Ls));}                    
   }
   MotorControl(0,0);
   delay(40);
   MotorControl(1,1);
   }
  }
  dir = change_Dir(myDir, east);
  myDir =dir;
  line_follower ();
//  line_follower();
}
 if(x==7 && dir==3) //fifth itiration
{
  dir = change_Dir(myDir, south);
  myDir =dir;
  dir = change_Dir(myDir, east);
  myDir =dir;
  while(y!=0)
  {
    MotorControl(1,1);
y--;
  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
  }
   if(y==0)
  {
    dir = change_Dir(myDir, south);
    myDir =dir;
    while(x!=1)
    {
      MotorControl(1,1);
      x--;
      while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
    }
    dir = change_Dir(myDir, east);
    myDir =dir;
    line_follower ();
//    line_follower();
  }

}


if (x==0 && dir==2) //sixth itiration
{
  dir = change_Dir(myDir, east);
  myDir =dir;
  while(y!=0)
  {
    MotorControl(1,1);
    y--;
    while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
  }
   if(y==0)
  {
dir = change_Dir(myDir, north);
myDir =dir;
while(x!=1)
{
MotorControl(1,1);
x++;  
while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                   MotorControl(1,1);
  
}
  }
  dir = change_Dir(myDir, east);
  myDir =dir;
  line_follower ();
  //line_follower();
}

if(x==1 && dir==0)  //seventh itiration
{
  dir = change_Dir(myDir, east);
  myDir =dir;

 while(y!=0)
{
  MotorControl(1,1);
  y--;
  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
}
  if(y==0)
{
//  line_follower();
line_follower ();
}
}
 if(x==1 && dir==2) //eighth itiration
{
  dir = change_Dir(myDir, east);
  myDir =dir;

  while(y!=0)
{
  MotorControl(1,1);
  y--;
  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
}
   if(y==0)
{
  // line_follower();
 line_follower ();
}

}
}
void line_follower ()
{
  sense = sensor_value();
  while (sense == 5)
  {   MotorControl(1,1); sense = sensor_value(); }
  
  while ( (sense >=0) && (sense < 5)  )
  {   MotorControl(0,1); sense = sensor_value(); }  
  
  while ((sense > 5) && (sense <=10) )
  {   MotorControl(1,0);  sense = sensor_value();}  
  if (sense==12)
  {
    MotorControl(2,2);
    delay(200);
    digitalWrite(9,0);
    digitalWrite(10,1);
    delay(2000);
    MotorControl(1,2);
    delay(200);
    MotorControl(2,1);
    delay (50);
    back_path();
  }  
    
}


int sensor_value(void)
{
  while(1)
  {   
  if ((digitalRead(ELs)) && (digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)) && (digitalRead(ERs)))
    {
       if (Lsense >= 6)
       {
           Lsense = 10;
           return Lsense;
       }
       else // (Lsense < 4)
       {
           Lsense = 0;
           return Lsense;
       }
    }
    if ((!digitalRead(ELs)) && (digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 1;
      return Lsense;
    }
    if ((!digitalRead(ELs)) && (!digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 2;
      return Lsense;
    }
    if ((!digitalRead(ELs)) && (!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 3;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 4;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (!digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 5;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)) && (digitalRead(ERs)))
    {
      Lsense = 6;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)) && (!digitalRead(ERs)))
    {
      Lsense = 7;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (digitalRead(Ls)) && (digitalRead(Ms)) && (!digitalRead(Rs)) && (!digitalRead(ERs)))
    {
      Lsense = 8;
      return Lsense;
    }
    if ((digitalRead(ELs)) && (digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)) && (!digitalRead(ERs)))
    {
      Lsense = 9;
      return Lsense;
    }
    
    if ((!digitalRead(ELs)) && (!digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)) && (!digitalRead(ERs)))
    {
      Lsense = 12;
      return 12;
    }
  }  
}

void back_path()
{
 
  sense1 = sensor_value();
  while (sense1 == 5)
  {   MotorControl(1,1); 
sense1 = sensor_value(); }
  
  while ( (sense1 >=0) && (sense1 < 5)  )
  {   MotorControl(0,1);
  sense = sensor_value(); }  
  
  while ((sense1 > 5) && (sense1 <=10) )
  {   MotorControl(1,0); 
  sense1 = sensor_value();}  
  if (sense1==12)
  {
    last_position();
    
}
}



void last_position()  //return path function
{
 x=1;
 y=0;
Lx=X;
Ly=Y;
  if((Lx>1) && (Lx!=7) && (Ly!=0))  //first itiration
  {
    if(Ly%2==0)
    {
      
    while(y!=Ly)
    {
      MotorControl(1,1); //forward
      y++;
      while((!digitalRead(ELs)) && (!digitalRead(ERs)))
      { MotorControl(1,1);}
      MotorControl(0,0);
      delay(40);                
      if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
      {
        if((!digitalRead(ELs)))
          {MotorControl(1,0);  while(digitalRead(Rs));}
        if ((!digitalRead(ERs)))
          {MotorControl(0,1);  while(digitalRead(Ls));}                    
      }
      MotorControl(0,0);
      delay(40);
      MotorControl(1,1);
    }
    
      dir = change_Dir(myDir, north);
      myDir =dir;
      while(x!=Lx)
      {
         MotorControl(1,1);
         x++;
         while((!digitalRead(ELs)) && (!digitalRead(ERs)))
              { MotorControl(1,1);}
         MotorControl(0,0);
         delay(40);                
         if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
         {
            if((!digitalRead(ELs)))
              {MotorControl(1,0);  while(digitalRead(Rs));}
            if((!digitalRead(ERs)))
              {MotorControl(0,1);  while(digitalRead(Ls));}                    
         }
         MotorControl(0,0);
         delay(40);
         MotorControl(1,1);
      }
      scanning(x,y);
    }
    else
  {
    dir = change_Dir(myDir, north);
    myDir =dir;
    while(x!=Lx)
    {
       MotorControl(1,1);
       x++;
       while((!digitalRead(ELs)) && (!digitalRead(ERs)))
       { MotorControl(1,1); }
       MotorControl(0,0);
       delay(40);                
       if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
       {
         if((!digitalRead(ELs)))
           {MotorControl(1,0);  while(digitalRead(Rs));}
         if((!digitalRead(ERs)))
           {MotorControl(0,1);  while(digitalRead(Ls));}                    
       }
       MotorControl(0,0);
       delay(40);
       MotorControl(1,1);
    }
    
    
       dir = change_Dir(myDir, west);
       myDir =dir;
       while(y!=Ly)
       {
          MotorControl(1,1);
          y++;
          while((!digitalRead(ELs)) && (!digitalRead(ERs)))
          { MotorControl(1,1);}
          MotorControl(0,0);
          delay(40);                
          if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
          {
            if((!digitalRead(ELs)))
              {MotorControl(1,0);  while(digitalRead(Rs));}
            if((!digitalRead(ERs)))
              {MotorControl(0,1);  while(digitalRead(Ls));}                    
          }
          MotorControl(0,0);
          delay(40);
          MotorControl(1,1);
       }
       scanning(x,y);
    }
 }
 
 
 
 if((Ly==0) && (Lx>1) && (Lx!=7)) //second itiration
 {
  dir = change_Dir(myDir, north);
  myDir =dir;
  while(x!=Lx)
  {
    MotorControl(1,1);
    x++;
    while((!digitalRead(ELs)) && (!digitalRead(ERs)))
    { MotorControl(1,1);}
    MotorControl(0,0);
    delay(40);                
    if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
      {
        if((!digitalRead(ELs)))
        {MotorControl(1,0);  while(digitalRead(Rs));}
        if ((!digitalRead(ERs)))
        {MotorControl(0,1);  while(digitalRead(Ls));}                    
      }
      MotorControl(0,0);
      delay(40);
      MotorControl(1,1); 
  }
  scanning(x,y);
 }
 
 
 
 if(Lx==0) //third itiration
 {
  dir = change_Dir(myDir, south);
  myDir =dir;
    
  
    MotorControl(1,1);
    x--;
    while((!digitalRead(ELs)) && (!digitalRead(ERs)))
    { MotorControl(1,1);}
    MotorControl(0,0);
    delay(40);                
    if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
    {
      if((!digitalRead(ELs)))
      {MotorControl(1,0);  while(digitalRead(Rs));}
      if ((!digitalRead(ERs)))
      {MotorControl(0,1);  while(digitalRead(Ls));}                    
    }
    MotorControl(0,0);
    delay(40);
    MotorControl(1,1);
  
  
   dir = change_Dir(myDir, west);
   myDir =dir;
   while(y!=Ly)
   {
   MotorControl(1,1);
   y++;
   while((!digitalRead(ELs)) && (!digitalRead(ERs)))
   { MotorControl(1,1);}
   MotorControl(0,0);
   delay(40);                
   if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
   {
     if((!digitalRead(ELs)))
     {MotorControl(1,0);  while(digitalRead(Rs));}
     if ((!digitalRead(ERs)))
     {MotorControl(0,1);  while(digitalRead(Ls));}                    
   }
   MotorControl(0,0);
   delay(40);
   MotorControl(1,1);
   }
  
  if(Ly%2==0)
  {
    dir = change_Dir(myDir, north);
  myDir =dir;
  scanning(x,y);
  }
  else
  {
    scanning(x,y);
  }
}  
 
 
 
 if(Lx==7) //fourth itiration
{
  dir = change_Dir(myDir, north);
  myDir =dir;
  
  while(x!=Lx)
  {
    MotorControl(1,1);
    x++;
  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
  }
  
    dir = change_Dir(myDir, west);
    myDir =dir;
    while(y!=Ly)
    {
      MotorControl(1,1);
      y++;
      while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
    }
    if(Ly%2==0)
    {
      scanning(x,y);
    }
    else
    {
    dir = change_Dir(myDir, south);
    myDir =dir;
    scanning(x,y);
    }
}





if(Lx==1)  //fifth itiration
{
  
 while(y!=Ly)
{
  MotorControl(1,1);
  y++;
  while((!digitalRead(ELs)) && (!digitalRead(ERs)))
                                    { MotorControl(1,1); 
                                  }
                                  MotorControl(0,0);
                                  delay(40);                
                                  if((!digitalRead(ELs)) ^ (!digitalRead(ERs)))
                                  {
                                      if((!digitalRead(ELs)))
                                      {MotorControl(1,0);  while(digitalRead(Rs));}
                                      if ((!digitalRead(ERs)))
                                      {MotorControl(0,1);  while(digitalRead(Ls));}                    
                                  }
                                  MotorControl(0,0);
                                  delay(40);
                                    MotorControl(1,1);
  
}
  if(Ly%2==0)
{
  dir = change_Dir(myDir, north);
  myDir =dir;
  scanning(x,y);
}
else
{
  dir = change_Dir(myDir, south);
  myDir =dir;
  scanning(x,y);
}
 
}

}
 
 



