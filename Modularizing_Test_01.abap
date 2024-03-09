*&---------------------------------------------------------------------*
*& Report  Z_MOD_1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_mod_1.

INCLUDE z_employee_definitions.

TABLES: zemployeestest.


*** New way of defining internal tables
** Declare a Line type

*TYPES: BEGIN OF line01_typ,
*      surname like zemployeestest-surname,
*      dob like zemployeestest-dob,
*      END OF line01_typ.

** Declare the Table Type based on the Line Type

TYPES itab02_typ TYPE STANDARD TABLE OF line01_typ.
*TYPES itab02_typ TYPE SORTED TABLE OF line01_typ WITH UNIQUE KEY surname, dob.

** Declare the table based on the Table type
DATA itab02 TYPE itab02_typ.

*Declare the Work area to use with our internal table
DATA wa_itab02 TYPE line01_typ.

DATA line_cnt TYPE i.

DATA z_field1 LIKE zemployeestest-surname.
DATA z_field2 LIKE zemployeestest-forename.

SELECT surname dob FROM zemployeestest
    INTO wa_itab02.
  APPEND wa_itab02 TO itab02.
ENDSELECT.


PERFORM itab02_write TABLES itab02.

PERFORM itab02_fill.
z_field1 = 'Aquiles'.
z_field2 = 'Vailo'.

PERFORM itab02_fill_again USING z_field1 z_field2.

PERFORM itab02_multi TABLES itab02 USING z_field1 z_field2..



* SELECT * FROM ZEMPLOYEESTEST INTO CORRESPONDING FIELDS OF TABLE itab02.

WRITE wa_itab02-surname.

LOOP AT itab02 INTO wa_itab02.
  WRITE: wa_itab02-surname.
ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  ITAB02_FILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM itab02_fill.

PERFORM sub_1 IN PROGRAM z_employee_hire USING z_field1.
*PERFORM sub_1 (z_employee_hire) TABLES itab02 USING z_field1.


  DATA zempl LIKE zemployeestest-surname.

  SELECT * FROM zemployeestest INTO CORRESPONDING FIELDS OF TABLE itab02.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ITAB02_FILL_AGAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM itab02_fill_again USING p_zsurname
                             p_zforename.


  DATA zempl LIKE zemployeestest-surname.

  WRITE / p_zsurname.

  WRITE / p_zforename.

  p_zsurname = 'Yoshi'.

  WRITE / p_zsurname.


ENDFORM.

FORM itab02_write TABLES p_itab02.

  DATA wa_tmp TYPE line01_typ.
  LOOP AT p_itab02 INTO wa_tmp.
    WRITE wa_tmp-surname.
  ENDLOOP.


ENDFORM.

FORM itab02_multi TABLES p_itab02 USING p_zsurname
                                        p_zforename..

  DATA wa_tmp TYPE line01_typ.
  LOOP AT p_itab02 INTO wa_tmp.
    WRITE wa_tmp-surname.
  ENDLOOP.
  
    DATA zempl LIKE zemployeestest-surname.

  WRITE / p_zsurname.

  WRITE / p_zforename.

  p_zsurname = 'Yoshi'.

  WRITE / p_zsurname.


ENDFORM.