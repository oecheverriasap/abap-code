*&---------------------------------------------------------------------*
*& Report  Z_CHARACTER_STRINGS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_character_strings.

TABLES zemployeestest.


DATA mychar(10) TYPE c.

DATA mychar02(2) TYPE c.

DATA forename LIKE zemployeestest-forename VALUE 'Esteban'.

DATA surname LIKE zemployeestest-surname VALUE 'Dido'.

DATA destination(200) TYPE c.

******************************************************
DATA znumber1 TYPE n.

* Concatenating strings

CONCATENATE forename surname INTO destination.
WRITE destination.
ULINE.

CONCATENATE forename surname INTO destination SEPARATED BY ' '.
WRITE destination.
ULINE.

** Find the length of a string

DATA len TYPE i.
len = strlen( surname ).
WRITE: 'The length of the surname field is', len.
ULINE.

**Replacing values

surname = "Elvis, Tek'.
REPLACE ',' WITH '.' INTO surname.
WRITE: surname.
ULINE.