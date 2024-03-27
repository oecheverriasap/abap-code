*&---------------------------------------------------------------------*
*& Report  Z_EMPLOYEE_LIST_03
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT Z_EMPLOYEE_LIST_03.

TABLES: ZEMPLOYEESTEST.

*** Old way of defining internal tables
** Declare a Header Line

DATA: BEGIN OF itab01 occurs 0,
      employee LIKE zemployeestest-employee,
      surname like zemployeestest-surname,
      forename like zemployeestest-forename,
      title like zemployeestest-title,
      dob like zemployeestest-dob,
      los TYPE i VALUE 3,
      END OF itab01.
      
DATA: BEGIN OF itab03 occurs 0.
      INCLUDE STRUCTURE itab01.
DATA END OF itab03.

DATA: BEGIN OF itab04 occurs 0.
      INCLUDE STRUCTURE zemployeestest.
DATA END OF itab04.

SELECT * FROM zemployeestest.
*    MOVE zemployeestest-employee TO itab01-employee.
*    MOVE zemployeestest-surname TO itab01-surname.
*    MOVE zemployeestest-forename TO itab01-forename.
*    MOVE zemployeestest-title TO itab01-title.
*    MOVE zemployeestest-dob TO itab01-dob.
MOVE-CORRESPONDING zemployeestest TO itab01.
APPEND itab01.
    ENDSELECT.
    
SELECT * FROM ZEMPLOYEESTEST INTO CORRESPONDING FIELDS OF TABLE itab01.

WRITE itab01-surname.



*** New way of defining internal tables
** Declare a Line type

TYPES: BEGIN OF line01_typ,
      surname like zemployeestest-surname,
      dob like zemployeestest-dob,
      END OF line01_typ.

** Declare the Table Type based on the Line Type

TYPES itab02_typ TYPE STANDARD TABLE OF line01_typ.
*TYPES itab02_typ TYPE SORTED TABLE OF line01_typ WITH UNIQUE KEY surname, dob.

** Declare the table based on the Table type
DATA itab02 TYPE itab02_typ.

*Declare the Work area to use with our internal table
DATA wa_itab02 TYPE line01_typ.

SELECT surname dob FROM ZEMPLOYEESTEST
    INTO wa_itab02.
    APPEND wa_itab02 to itab02.
 ENDSELECT.
 
 SELECT * FROM ZEMPLOYEESTEST INTO CORRESPONDING FIELDS OF TABLE itab02.

 WRITE wa_itab02-surname.

LOOP AT itab01.
WRITE: / itab01-surname, itab01-forename.
ENDLOOP.

LOOP AT itab01.
IF itab01-surname = 'Kosoi'.
 itab01-surname = 'Kaera'.
 MODIFY itab01.
 ENDIF.
ENDLOOP.

CLEAR itab01.
CLEAR wa_itab02.
CLEAR itab01[].

REFRESH itab01.

FREE itab01.
CLEAR itab01[].
 
 
 