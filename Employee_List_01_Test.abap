*&---------------------------------------------------------------------*
*& Report  Z_OPEN_SQL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_open_sql.
TABLES zemployeestest.

**** OPEN SQL STATEMENTS ****

*** SELECT Statement ***

SELECT * FROM zemployeestest.
  WRITE zemployeestest.
ENDSELECT.

ULINE.

SELECT * FROM zemployeestest.
  WRITE / zemployeestest.
ENDSELECT.

ULINE.

*** INSERT Statement***

DATA wa_employees LIKE zemployeestest.

wa_employees-employee = '10000013'.
wa_employees-surname = 'KEKO'.
wa_employees-forename = 'JONES'.
wa_employees-dob = '10102010'.

INSERT zemployeestest FROM wa_employees.
**INSERT (table_name) FROM wa_employees.
IF sy-subrc = 0.
  WRITE 'Record inserted successfully'.
ELSE.
  WRITE: 'RETURN CODE OF: ', sy-subrc.


ENDIF.

ULINE.

CLEAR wa_employees-employee.
CLEAR wa_employees.

wa_employees-employee = '10000011'.
wa_employees-surname = 'MARY'.
wa_employees-forename = 'KOSOI'.
wa_employees-dob = '10102011  '.

INSERT zemployeestest FROM wa_employees.
**INSERT (table_name) FROM wa_employees.
IF sy-subrc = 0.
  WRITE 'Record inserted successfully'.
ELSE.
  WRITE: 'RETURN CODE OF: ', sy-subrc.
ENDIF.

ULINE.

*** Update Statement ***

CLEAR wa_employees.

wa_employees-employee = '10000011'.
wa_employees-surname = 'MARYYY'.
wa_employees-forename = 'KOSOIIIII'.
wa_employees-dob = '10102011  '.

UPDATE zemployeestest FROM wa_employees.
IF sy-subrc = 0.
  WRITE 'Record updated successfully'.
ELSE.
  WRITE: 'RETURN CODE OF: ', sy-subrc.
ENDIF.

wa_employees-employee = '10000011'.
wa_employees-surname = 'MARY'.
wa_employees-forename = 'KOSOI'.
wa_employees-dob = '10102011  '.

ULINE.

*** Modify Statement ***
** Updates a record by its PK, if there isn´t any, it creates it.
CLEAR wa_employees.

wa_employees-employee = '10000011'.
wa_employees-surname = 'MARYYY'.
wa_employees-forename = 'KOSOIIIII'.
wa_employees-dob = '10102011  '.

UPDATE zemployeestest FROM wa_employees.

IF sy-subrc = 0.
  WRITE 'Record updated successfully'.
ELSE.
  WRITE: 'RETURN CODE OF: ', sy-subrc.
ENDIF.

wa_employees-employee = '10000011'.
wa_employees-surname = 'MARY'.
wa_employees-forename = 'KOSOI'.
wa_employees-dob = '10102011  '.

ULINE.

*** Delete Statement ***

CLEAR wa_employees.

wa_employees-employee = '10000011'.

DELETE ZEMPLOYEESTEST FROM wa_employees.

IF sy-subrc = 0.
  WRITE 'Record Deleted successfully'.
ELSE.
  WRITE: 'RETURN CODE OF: ', sy-subrc.
ENDIF.

ULINE.

