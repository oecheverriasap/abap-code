*&---------------------------------------------------------------------*
*& Report  Z_MOD_2
*30
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_mod_2.

DATA result LIKE SPELL.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(30) text-001.
PARAMETER mynum TYPE i.
SELECTION-SCREEN END OF LINE.

CALL FUNCTION 'SPELL_AMOUNT'
  EXPORTING
    AMOUNT   = mynum
    IMPORTING
    IN_WORDS = result.

IF sy-subrc <> 0.
  WRITE: 'The function returned a value of ', sy-subrc.
ELSE.
  WRITE: 'The amount in words is:  ', result-word.
ENDIF.