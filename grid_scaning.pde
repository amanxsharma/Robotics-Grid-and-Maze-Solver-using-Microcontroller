#define black 0
#define white 1

int L_M_sensor = 0, L_sensor = 0, C_sensor = 0, R_sensor = 0, R_M_sensor = 0;
int L1=7, L2=4, R1=12, R2=8, En1 = 5, En2 = 6;
                                   
int sense = 0, S_last=0;
boolean mappingComplete = false;                              
unsigned int x = 0, y = 0,L_x =0, L_y =0, node = 0;

void setup()
{
  pinMode(14,INPUT);
  pinMode(15,INPUT);
  pinMode(16,INPUT);
  pinMode(17,INPUT);
  pinMode(18,INPUT); 

  pinMode(En1,OUTPUT);
  pinMode(En2,OUTPUT);  

  pinMode(L1,OUTPUT);
  pinMode(L2,OUTPUT);
  pinMode(R1,OUTPUT);
  pinMode(R2,OUTPUT);

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
{
                       L_x=x;
                       L_y=y; 
                     

      Readsensor();
      while(L_M_sensor== white && R_M_sensor== white)
      {
        linefollowing();
        Readsensor();
      }
      if (L_M_sensor== black && L_sensor == black && C_sensor == black && R_sensor == black && R_M_sensor == black)
      {                        node= node+1;
            analogWrite(En1, 0);
            analogWrite(En2, 0);
            Stop();
            delay(50);
                if(y==8 && x==8)
                {
                  analogWrite(En1, 0);
                  analogWrite(En2, 0);
                  Stop();
                  mappingComplete = true;
                }
                else
                {

                       if(y==0)
                       {
                          if (x==0)
                          {
                            x=x+1;
                            y=y;
                            Readsensor();
                            while(L_M_sensor== black && R_M_sensor== black)
                            {
                                analogWrite(En1, 200);
                                analogWrite(En2, 200);  
                                forward();
                                Readsensor();
                            }
                          }
                          else
                          {
                              if (x>0 && x<6)
                              {
                                 x = x+1;
                                 y = y;
                                    Readsensor();
                                    while(L_M_sensor== black && R_M_sensor== black)
                                    {
                                        analogWrite(En1, 200);
                                        analogWrite(En2, 200);  
                                        forward();
                                        Readsensor();
                                    }
                               }
                               else //(x==4)
                               {  
                                   x=x;
                                   y = y+1;
                                   Turn_90_left();          
                               }
                           }  
                       }
                       else
                       {
                             if ( y==1 || y==3 ) // y=1,3,5,7,8 
                             {
                                  if(x==6)
                                  {  
                                       x=x-1;   
                                       Turn_90_left();
                                  }
                                  else 
                                  {
                                      if(x<6 && x>0)
                                      {
                                         x = x-1;
                                            Readsensor();
                                            while(L_M_sensor== black && R_M_sensor== black)
                                            {
                                                analogWrite(En1, 200);
                                                analogWrite(En2, 200);  
                                                forward();
                                                Readsensor();
                                            }
                                       }
                                       else //(x==0), Y==1,y==3, y==5
                                       {
                                          y = y+1;
                                          Turn_90_right();          
                                       }
                                    }
                                    
                              }
                              else    // Y ==2,4,6,8  
                              {
                                      if(x==0)
                                      {  
                                         x = x+1;
                                         Turn_90_right();                          
                                      }
                                      else
                                      {
                                          if (x>0 && x<6)
                                          {
                                          x = x+1;
                                          y = y;
                                          Readsensor();
                                            while(L_M_sensor== black && R_M_sensor== black)
                                            {
                                             analogWrite(En1, 200);
                                             analogWrite(En2, 200);                             
                                             forward();  
                                             Readsensor(); 
                                            }
                                          }
                                          else //(x==4)
                                          {  
                                             x=x;
                                             y = y+1;
                                             Turn_90_left();          
                                          }
                                      }  
                                 }
                                                       
                               
                      }
                }
      }//last bc
}



void Readsensor(void)
{
      R_M_sensor  =   digitalRead(14);
      R_sensor    =   digitalRead(15);
      C_sensor    =   digitalRead(16);    
      L_sensor    =   digitalRead(17);  
      L_M_sensor  =   digitalRead(18); 
}

void linefollowing()
{
  Readsensor();
  if(R_sensor == black && C_sensor == black && L_sensor == black)
  {
    forward();
  }
  else if(R_sensor == white && C_sensor == black && L_sensor == black)
       {right();}
  else if(R_sensor == white && C_sensor == white && L_sensor == black)
       {right();}
  else if(R_sensor == black && C_sensor == black && L_sensor == white)
       {left();}
  else if(R_sensor == black && C_sensor == white && L_sensor == white)
       {left();}  
}

void Turn_90_right(void)
{
    analogWrite(En1, 200);
    analogWrite(En2, 200);
    forward();
    delay(100);
    diff_right();
    delay(300); 
}

void Turn_90_left(void)
{
    analogWrite(En1, 200);
    analogWrite(En2, 200);
    forward();
    delay(100);
    diff_left();
    delay(300);   
}
void forward(void)
{
    digitalWrite(L1,HIGH);
    digitalWrite(L2,LOW);
    digitalWrite(R1,HIGH);
    digitalWrite(R2,LOW); 
}

void backward(void)
{
    digitalWrite(L1,LOW);
    digitalWrite(L2,HIGH);
    digitalWrite(R1,LOW);
    digitalWrite(R2,HIGH); 
}
void diff_right(void)
{
    digitalWrite(L1,HIGH);
    digitalWrite(L2,LOW);
    digitalWrite(R1,LOW);
    digitalWrite(R2,HIGH);   
}
void right(void)
{
    digitalWrite(L1,HIGH);
    digitalWrite(L2,LOW);
    digitalWrite(R1,LOW);
    digitalWrite(R2,LOW);   
}
void diff_left(void)
{
    digitalWrite(L1,LOW);
    digitalWrite(L2,HIGH);
    digitalWrite(R1,HIGH);
    digitalWrite(R2,LOW);   
}

void left(void)
{
    digitalWrite(L1,LOW);
    digitalWrite(L2,LOW);
    digitalWrite(R1,HIGH);
    digitalWrite(R2,LOW);   
}
void Stop(void)
{
    digitalWrite(L1,LOW);
    digitalWrite(L2,LOW);
    digitalWrite(R1,LOW);
    digitalWrite(R2,LOW); 
}



