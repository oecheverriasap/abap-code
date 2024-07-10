*&---------------------------------------------------------------------*
*&  Include  Z_ADV_FORMS_EXERCISE_DEF
*&---------------------------------------------------------------------*
CONSTANTS: c_cod_ban TYPE c LENGTH 4  VALUE '29',
           c_cd_ban2 TYPE c LENGTH 3  VALUE '101',
           c_space   TYPE   syhex02   VALUE '00a0',
           c_pag_nom LIKE t512t-lgart VALUE '/559',
           c_pag_usd LIKE t512t-lgart VALUE '901I'.


TABLES: pernr,
        pcl1,
        pcl2,
        t52occ,
        t52ocr,
        t52ocrt,
        t52bx,
        t001,
        t500t,
        usr05,
        t500c,
        zthr_cod_emp_ban.

INFOTYPES: 0001,
           0002,
           0008,
           0009,
           0105,
           0185.

*----------------------------------------------------------------------
*                        C L U S T E R
*----------------------------------------------------------------------
INCLUDE rpc2cd00.
INCLUDE rpc2ca00.

INCLUDE rpc2rxx0.     "Include de cluster internacional
INCLUDE h99paymacro.  "Include macro internacional
INCLUDE rpcxb200.     "Include macros de evaluación de tiempos.

INCLUDE rpc2rx00.

INCLUDE rpppxd00.

DATA: BEGIN OF COMMON PART buffer.
INCLUDE rpppxd10.
DATA END OF COMMON PART buffer.

*----------------------------------------------------------------------
*                     V A R I A B L E S
*----------------------------------------------------------------------
DATA: w_mol         TYPE molga,
      w_mon         TYPE waers,
      w_str_15(15)  TYPE c,
      w_str_fec(10) TYPE c,
      w_t_usr05     TYPE TABLE OF usr05 WITH HEADER LINE,
      w_t012        TYPE TABLE OF t012_l_bf WITH HEADER LINE,
      w_t012_d      TYPE TABLE OF t012_d_bf WITH HEADER LINE,
      w_tvarvc      TYPE tvarvc,
      w_can_lot     TYPE i,
      w_contador    TYPE i,
      w_mon_lot     TYPE maxbt,
      w_len_text    TYPE i,
      w_space(1)    TYPE c,
      w_nom_soc     TYPE c LENGTH 35,
      w_cod_ban     TYPE c LENGTH 15,
      w_num_emp     TYPE n LENGTH 5,
      w_periodo     TYPE c LENGTH 6,
      w_mon_1       TYPE c LENGTH 15,
      w_mon_2       TYPE c LENGTH 15.

*----------------------------------------------------------------------
*                    F O R M U L A R I O
*----------------------------------------------------------------------

DATA: BEGIN OF w_t_for OCCURS 0.
        INCLUDE STRUCTURE ZTEHR_DAT_EMP.
      DATA: END OF w_t_for.

DATA: BEGIN OF w_t_for_2 OCCURS 0.
        INCLUDE STRUCTURE ZTEHR_DAT_EMP2.
      DATA: END OF w_t_for_2.


DATA: w_for         TYPE rs38l_fnam,
      w_nom_mod_fun TYPE rs38l_fnam,
      options       TYPE ssfcompop,
      parameters    TYPE ssfctrlop,
      errortab      TYPE tsferror,
      it_ssfcompop  TYPE ssfcompop,
      w_t_par_imp   TYPE ssfctrlop,
      w_job_output  TYPE ssfcrescl,
      w_ssfcompop   TYPE ssfcompop,
      w_control     TYPE ssfctrlop,
      w_devtype     TYPE rspoptype.




DATA: BEGIN OF w_t_dat OCCURS 0,
**** Personal Number
        pernr    TYPE persno,
**** Formatted name
        ename    TYPE cname,
**** ID
        icnum    TYPE icnum,
**** Personnel Area Code
        werks    TYPE werks,
**** Personnel Area name
        paname   TYPE t500p-name1,
**** Position
        plans    TYPE plans,
**** Position Name
        posname  LIKE t528t-plstx,
**** Base Salary per working period
        basepay  LIKE p0008-bet01,
**** Total to be paid
        totalpay TYPE betrg,

      END OF w_t_dat.

*----------------------------------------------------------------------
*                     P A R A M E T E R S
*----------------------------------------------------------------------

  SELECTION-SCREEN BEGIN OF BLOCK typeBlock WITH FRAME TITLE text-200.
PARAMETERS: p_alv  RADIOBUTTON GROUP con DEFAULT 'X',
            p_smartF  RADIOBUTTON GROUP con.
SELECTION-SCREEN END OF BLOCK typeBlock.

*----------------------------------------------------------------------
*                         S A L I D A
*----------------------------------------------------------------------

DATA: BEGIN OF w_t_cab,
        tip_reg TYPE c LENGTH 1,
        cod_soc TYPE c LENGTH 15,
        nom_soc TYPE c LENGTH 35,
        num_sec TYPE c LENGTH 7,
        tip_ser TYPE c LENGTH 2,
        fec_efc TYPE c LENGTH 8,
        can_deb TYPE c LENGTH 11,
        mon_deb TYPE c LENGTH 13,
        can_cre TYPE c LENGTH 11,
        mon_cre TYPE c LENGTH 13,
        num_mid TYPE c LENGTH 15,
        fec_env TYPE c LENGTH 8,
        hor_env TYPE c LENGTH 4,
        cor_emp TYPE c LENGTH 40,
        cod_sta TYPE c LENGTH 1,
        espacio TYPE c LENGTH 136,
      END OF w_t_cab.

DATA: BEGIN OF w_t_det,
        tip_reg TYPE c LENGTH 1,
        cod_soc TYPE c LENGTH 15,
        num_sec TYPE c LENGTH 7,
        num_tra TYPE c LENGTH 7,
        tip_cta TYPE c LENGTH 1,
        cta_des TYPE c LENGTH 20,
        mon_pag TYPE c LENGTH 3,
        cod_ban TYPE c LENGTH 8,
        dig_ver TYPE c LENGTH 1,
        cod_ope TYPE c LENGTH 2,
        mon_tra TYPE c LENGTH 13,
        tip_doc TYPE c LENGTH 2,
        num_doc TYPE c LENGTH 15,
        nom_tra TYPE c LENGTH 35,
        num_ref TYPE c LENGTH 12,
        des_pag TYPE c LENGTH 40,
        fec_ven TYPE c LENGTH 4,
        tip_con TYPE c LENGTH 1,
        cor_tra TYPE c LENGTH 40,
        fax_tra TYPE c LENGTH 12,
        pro_pag TYPE c LENGTH 2,
        num_aut TYPE c LENGTH 15,
        cod_ret TYPE c LENGTH 3,
        cod_rzr TYPE c LENGTH 3,
        cod_rzi TYPE c LENGTH 3,
        pro_tra TYPE c LENGTH 2,
        est_tra TYPE c LENGTH 2,
        espacio TYPE c LENGTH 52,
      END OF w_t_det.

DATA:  w_nom_arc TYPE string.

DATA: BEGIN OF w_t_reg_arc OCCURS 5,
        reg(1000),
      END OF w_t_reg_arc.

DATA: BEGIN OF w_t_arc OCCURS 0,
        col1(60),
        col2(60),
        col3(60),
        col4(60),
        col5(60),
        col6(60),
        col7(60),
        col8(60),
        col9(60),
        col10(60),
        col11(60),
      END OF w_t_arc.

*----------------------------------------------------------------------
*                           R E P O R T E
*----------------------------------------------------------------------
DATA: BEGIN OF w_t_nom_cam OCCURS 20,
        title(60),
        table(20),
        field(20),
        type,
      END OF w_t_nom_cam.

DATA: w_hdr_1(132),
      w_hdr_2(132),
      w_hdr_3(132),
      w_hdr_4(132),
      w_foot_1(132),
      w_foot_2(132),
      w_foot_3(132),
      w_nom_pro     LIKE sy-repid,
      w_cod_ret     TYPE sy-subrc,
      w_t_err       TYPE hrerror OCCURS 0 WITH HEADER LINE.


*----------------------------------------------------------------------
*                  A J U S T E S   A   P A N T A L L A
*----------------------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-name.
      WHEN '%_PNPBUKRS_%_APP_%-VALU_PUSH'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN '%_PNPXBWBK_%_APP_%-TEXT'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN 'PNPXBWBK-LOW'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN '%_PNPXBWBK_%_APP_%-VALU_PUSH'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN '%_PNPXPGPK_%_APP_%-TEXT'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN 'PNPXPGPK-LOW'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
      WHEN '%_PNPXPGPK_%_APP_%-VALU_PUSH'.
        MOVE 0 TO screen-active.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
