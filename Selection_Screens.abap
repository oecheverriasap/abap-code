*&---------------------------------------------------------------------*
*& Report  Z_SCREENS_1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_screens_1.
TABLES zemployeestest.

DATA: wa_employee LIKE zemployeestest-employee.



PARAMETERS: my_ee   LIKE zemployeestest-employee DEFAULT '12345678' OBLIGATORY.
*            my_dob  LIKE zemployeestest-dob VALUE CHECK,
*           my_num  TYPE i,

SELECTION-SCREEN BEGIN OF BLOCK myblock1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION POS_LOW.
PARAMETERS: abc(5).
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN COMMENT 1(15) text-001.
SELECTION-SCREEN COMMENT 20(10) comm1.
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN ULINE.
*SELECTION-SCREEN ULINE /40(8).
SELECTION-SCREEN END OF BLOCK myblock1.

PARAMETERS:
  my_box  AS CHECKBOX,
  my_nmb1 RADIOBUTTON GROUP gru1,
  my_nmb2 RADIOBUTTON GROUP gru1,
  my_nmb3 RADIOBUTTON GROUP gru1,
  my_sur  LIKE zemployeestest-surname LOWER CASE.

SELECT-OPTIONS my_dob2 FOR zemployeestest-dob OBLIGATORY LOWER CASE NO-EXTENSION.

INITIALIZATION.

  SELECT * FROM zemployeestest.
    wa_employee = zemployeestest.
  ENDSELECT.

  WRITE: wa_employee.

AT SELECTION-SCREEN ON my_ee.
* Check to make sure the employee number is not greater than the
* last employee number in our table.
  IF my_ee > wa_employee.
*    MESSAGE e000(ZMES1).
    MESSAGE e001(zmes1) WITH my_ee.
  ENDIF.

  SELECT * FROM zemployeestest.
    IF zemployeestest-dob IN my_dob2.
      WRITE: / zemployeestest.
    ENDIF.
  ENDSELECT.

  WRITE: / text-001.