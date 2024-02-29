*&---------------------------------------------------------------------*
*& Report  Z_EPLOYEE_LIST_01
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_eployee_list_01 LINE-SIZE 132.

TABLES zemployeestest .

SELECT * FROM zemployeestest.
  WRITE zemployeestest.
ENDSELECT.

ULINE.

SELECT * FROM zemployeestest.
  WRITE / zemployeestest.
ENDSELECT.

ULINE.

SELECT * FROM zemployeestest.
  WRITE zemployeestest.
  WRITE /.
ENDSELECT.

ULINE.

SKIP 2.
SELECT * FROM zemployeestest.
  WRITE zemployeestest.
  WRITE /.
ENDSELECT.

SKIP 2.
SELECT * FROM zemployeestest.
  WRITE / zemployeestest-surname.
  WRITE zemployeestest-forename.
ENDSELECT.

SKIP 2.
SELECT * FROM zemployeestest.
  WRITE: / zemployeestest-surname,
           zemployeestest-forename,
           zemployeestest-dob.
ENDSELECT.