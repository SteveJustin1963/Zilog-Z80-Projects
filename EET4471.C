#include <stdio.h>
#include <math.h>
void introduction()
{
  printf("浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�\n");
  printf("� Duane Attaway      | Transfer Functions                         �\n");
  printf("� Alan Hansen        |                                            �\n");
  printf("� Control Systems ][ | You will be asked to enter the function    �\n");
  printf("� 9DA-EET447L        | G(s) and the feedback H(s).  The resultant �\n");
  printf("�                    | sensitivity values will be calculated      �\n");
  printf("�                    | and displayed.                             �\n");
  printf("�                    |                                            �\n");
  printf("藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�\n");
}


void main()
{
float g,h,gtemp,gtemp2,t,ttemp,ttemp2,dg,dt,s;
char i;

  introduction();

  for(i='y';i=='y';)
  {
    printf("\n");
    printf("\n");
    printf("ENTER input G-->");
    scanf("%d",&g);
    printf("\n");
    printf("ENTER input H-->");
    scanf("%d",&h);
    printf("\n");

    gtemp=g*1.1;
    gtemp2=g*0.9;
    dg=gtemp-gtemp2;
    t=g/(1+(g*h));
    ttemp=gtemp/(1+(gtemp*h));
    ttemp2=gtemp2/(1+(gtemp2*h));
    dt=ttemp-ttemp2;
    s=(dt*g)/(dg*t);

    printf("The calculated sensitivity values are.\n\n");
    printf("      Delta T = %12e\n\n",dt);
    printf("            T\n");
    printf("           S  = %12e\n",s);
    printf("            G\n\n");
    printf("Another calculation (Y/N)\n");
  }
}
