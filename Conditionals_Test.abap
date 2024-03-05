*  &---------------------------------------------------------------------*
*  & Report  Z_LOGIC_1
*  &
*  &---------------------------------------------------------------------*
*  &
*  &
*  &---------------------------------------------------------------------*
REPORT z_logic_1.
TABLES zemployeestest.

DATA: surname(15) TYPE c.

surname = 'TETO'.

IF surname = 'TETO'.
  WRITE 'JUANCITO TETO'.
ENDIF.

ULINE.

surname = 'TETON'.

IF surname = 'TETO'.
  WRITE 'JUANCITO TETO'.
ELSEIF surname = 'TETON'.
  WRITE 'JUANITA TETA'.
ENDIF.

ULINE.

surname = 'TETONA'.

IF surname = 'TETO'.
  WRITE 'JUANCITO TETO'.
ELSE.
  WRITE 'JUANITA TETONA'.
ENDIF.

ULINE.

DATA: forename(15) TYPE c.

**AND - IF surname = 'TETO' AND forename = 'JUAN'
**OR - IF surname = 'TETO' OR forename = 'JUAN'
**NOT - IF surname NOT 'TETO'

*** CASE ***

CASE surname.
  WHEN 'TETO'.
    WRITE 'JUANCITO TETO'.
  WHEN 'TETON'.
    WRITE 'JUANITA TETONA'.
  WHEN OTHERS.
    WRITE 'JUANO'
endcase.