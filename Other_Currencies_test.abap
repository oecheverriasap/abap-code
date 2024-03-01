*&---------------------------------------------------------------------*
*& Report  Z_OTHER_DATA_TYPES
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_other_data_types.
TABLES ZEMPLOYEESTEST2.

*TABLES ZEMPLOYEESTEST.
*
*
*DATA mychar(10) type c.
*
*DATA mychar02(2) type c.
*
*DATA zemployees1 like ZEMPLOYEESTEST-forename VALUE 'Esteban'.
*
*DATA zemployees2 like ZEMPLOYEESTEST-surname VALUE 'Dido'.
*
*DATA destination(200) TYPE c.
*
*******************************************************
*DATA znumber1 type n.
*
** Concatenating strings
*
*CONCATENATE zemployees1 zemployees2 INTO destination.
*WRITE destination.
*ULINE.

** Data and time fields


*Date Fields
**Format: YYYYMMDD with initial value of 00000000
DATA my_date TYPE d VALUE '19922205'.
DATA my_date2 TYPE d VALUE '19911306'.
DATA my_date3 LIKE sy-datum VALUE '20230101'.

*Time Fields
**Format: HHMMSS with initial value of 000000
DATA my_time TYPE t VALUE '080000'.
DATA my_time2 TYPE t VALUE '183000'.
DATA my_time3 LIKE sy-uzeit VALUE '220530'.

** TESTING

WRITE: my_date, /
      my_date2, /
      my_date3, /
      my_time, /
      my_time, /
      my_time2, /
      my_time3.
ULINE.

*************************

DATA lv_empl_sdate TYPE d.
DATA lv_todays_date TYPE d.
DATA lv_los TYPE i.

DATA lv_clock_in TYPE t VALUE '080000'.
DATA lv_clock_out TYPE t VALUE '180000'.
DATA seconds_diff TYPE i.
DATA minutes_diff TYPE i.
DATA hours_diff TYPE i.



lv_empl_sdate = '20200215'.
lv_todays_date = sy-datum.


lv_los = lv_todays_date - lv_empl_sdate.

WRITE lv_los.

ULINE.

seconds_diff = lv_clock_out - lv_clock_in.
minutes_diff = seconds_diff / 60.
hours_diff = minutes_diff / 60.

WRITE: 'Seconds diff', seconds_diff, /
       'Minutes diff', minutes_diff, /
       'Hours diff', hours_diff.

**********************

** Working with currencies

DATA my_salary LIKE ZEMPLOYEESTEST2-SALARY.
DATA my_tax LIKE ZEMPLOYEESTEST2-SALARY.
DATA my_net_pay LIKE ZEMPLOYEESTEST2-SALARY.
DATA my_tax_percent TYPE p DECIMALS 2 VALUE 22.

SELECT * FROM ZEMPLOYEESTEST2.
WRITE: / ZEMPLOYEESTEST2-SURNAME, ZEMPLOYEESTEST2-SALARY, ZEMPLOYEESTEST2-ECURRENCY
.
my_tax = my_salary * my_tax_percent.
my_net_pay = ZEMPLOYEESTEST2-SALARY - my_tax.

WRITE: / my_tax, ZEMPLOYEESTEST2-ECURRENCY,
          my_net_pay, ZEMPLOYEESTEST2-ECURRENCY.

ENDSELECT.
