REPORT z_iterations_1 .

TABLES zemployeestest.

SELECT * FROM zemployeestest.
  WRITE / zemployeestest.
ENDSELECT.

ULINE.

SELECT * FROM zemployeestest WHERE surname = 'ELSA'.
  WRITE / zemployeestest.
  ULINE.
ENDSELECT.

DATA: aa TYPE n.
DATA: bb TYPE n.

WHILE aa < 5.
  WRITE: / 'In the first while'.
  aa = aa + 1.
  WHILE bb < 3.
    bb = bb + 1.
    WRITE: 'In the second while'.
    ENDWHILE.
  ENDWHILE.

  ULINE.

  DO 15 TIMES.
    WRITE: 'Hello'.
    DO 10 TIMES.
      WRITE: 'From the inside'.
      ULINE.
    ENDDO.
    ULINE.
  ENDDO.
  
** You can end an iteration by using CONTINUE
** You can review if a condition is met in an iteration with the check statement
** You can exit a Loop by using Exit