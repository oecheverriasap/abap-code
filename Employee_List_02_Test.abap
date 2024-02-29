*&---------------------------------------------------------------------*
*& Report  Z_EPLOYEE_LIST_01
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_eployee_list_01 LINE-SIZE 132.

TABLES zemployeestest .

*SELECT * FROM zemployeestest.
*  WRITE zemployeestest.
*ENDSELECT.
*
*ULINE.
*
*SELECT * FROM zemployeestest.
*  WRITE / zemployeestest.
*ENDSELECT.

ULINE.

DATA int01 TYPE i VALUE 22.
DATA packed_decimal01 TYPE p DECIMALS 2 VALUE '-5.53'.

DATA packed_decimal02 like packed_decimal01.

DATA new_surname LIKE zemployeestest-surname.
      
CONSTANTS myconstant01 type p DECIMALS 1 value '6.6'.
CONSTANTS myconstant02 type i value 6.