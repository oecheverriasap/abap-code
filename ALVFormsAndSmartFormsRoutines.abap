*    &---------------------------------------------------------------------*
*    &  Include           ZI_HRPY_DO_DIS_BAN_RUT
*    &---------------------------------------------------------------------*
*    &---------------------------------------------------------------------*
*    &      Form  OBT_DAT_GEN
*    &---------------------------------------------------------------------*
*           text
*    ----------------------------------------------------------------------*
*      -->  p1        text
*      <--  p2        text
*    ----------------------------------------------------------------------*
FORM obt_dat_gen.

    *     Obtener molga a partir de los parámetros de usuario
          CLEAR: w_t_usr05,
                 w_mol,
                 w_mon.
    
          MOVE 'DO' TO w_mol.
    
    *     Obtener denominación del motivo de nómina
          SELECT SINGLE * FROM t52ocrt WHERE molga EQ w_mol AND
                                             sprsl EQ sy-langu.
    
    
    *     Obtener código de la empresa para el banco.
          SELECT SINGLE * FROM  zthr_cod_emp_ban
                          WHERE bukrs EQ pnpbukrs-low.
          IF sy-subrc EQ 0.
            MOVE   zthr_cod_emp_ban-codem TO w_cod_ban.
            UNPACK zthr_cod_emp_ban-nuemp TO w_num_emp.
          ENDIF.
    
    
    *     Obtener nombre de la sociedad
          SELECT SINGLE butxt INTO w_nom_soc FROM t001 WHERE bukrs EQ pnpbukrs-low.
    
          MOVE 'IMPLEMENTOS Y MAQUINARIAS (IMCA) S.' TO w_nom_soc.
    
          IF pnptimr9 IS NOT INITIAL.
            CONCATENATE pnpdispj pnpdispp  INTO w_periodo.
          ELSE.
            CONCATENATE pnppabrj pnppabrp  INTO w_periodo.
          ENDIF.
    
    
        ENDFORM.                    "OBT_DAT_GEN
    
    *    &---------------------------------------------------------------------*
    *    &      Form  OBT_DAT
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
        FORM obt_dat.
    
          LOOP AT pernr.
          ENDLOOP.
          MOVE-CORRESPONDING pernr TO w_t_dat.
    
          LOOP AT p0001 WHERE begda LE pn-endda
                        AND   endda GE pn-begda.
          ENDLOOP.
          PERFORM get_field_names.
          PERFORM get_net_payment.
    
          MOVE-CORRESPONDING p0001 TO w_t_dat.
    
          LOOP AT p0002 WHERE begda LE pn-endda
                   AND   endda GE pn-begda.
          ENDLOOP.
          MOVE-CORRESPONDING p0002 TO w_t_dat.
    
          LOOP AT p0008 INTO DATA(ls_p0008) WHERE begda LE pn-endda
                    AND   endda GE pn-begda.
            IF ls_p0008-infty = '0008'.
              w_t_dat-basepay = ls_p0008-bet01.
              EXIT.
            ENDIF.
          ENDLOOP.
          MOVE-CORRESPONDING p0008 TO w_t_dat.
    
    
          LOOP AT p0185 WHERE begda LE pn-endda
                     AND   endda GE pn-begda.
          ENDLOOP.
          MOVE-CORRESPONDING p0185 TO w_t_dat.
    
    
          APPEND w_t_dat.
          MOVE-CORRESPONDING w_t_dat TO w_t_for.
          APPEND w_t_for.
    
          APPEND w_t_dat.
          MOVE-CORRESPONDING w_t_dat TO w_t_for_2.
          APPEND w_t_for_2.
    
        ENDFORM.                    "OBT_DAT_GEN
    
    
        FORM get_field_names.
    
          DATA: lv_plans TYPE p0001-plans,
                lv_werks TYPE p0001-werks,
                lt_t528t TYPE TABLE OF t528t,
                lt_t500p TYPE TABLE OF t500p,
                ls_t528t TYPE t528t,
                ls_t500p TYPE t500p.
    
          LOOP AT p0001 INTO DATA(ls_p0001) WHERE pernr = w_t_dat-pernr.
            lv_plans = ls_p0001-plans.
            lv_werks = ls_p0001-werks.
            EXIT.
          ENDLOOP.
    
          IF lv_plans IS NOT INITIAL.
    
            SELECT * FROM t528t INTO TABLE lt_t528t
                   WHERE plans = lv_plans
                     AND sprsl = sy-langu.
    
            READ TABLE lt_t528t INTO ls_t528t INDEX 1.
    
            IF sy-subrc = 0.
              w_t_dat-posname = ls_t528t-plstx.
            ENDIF.
    
            SELECT SINGLE name1 FROM t500p INTO ls_t500p-name1
                   WHERE persa = lv_werks.
    
            IF sy-subrc = 0.
    
              w_t_dat-paname = ls_t500p-name1.
              w_t_dat-posname = ls_t528t-plstx.
    
            ENDIF.
    
          ENDIF.
    
    
        ENDFORM.
    
    * Obtener monto del pago
    
        FORM get_net_payment.
    
    
          IF NOT p0009-bankn IS INITIAL.
            CALL FUNCTION 'CU_READ_RGDIR'
              EXPORTING
                persnr          = pernr-pernr
              IMPORTING
                molga           = w_mol
              TABLES
                in_rgdir        = rgdir
              EXCEPTIONS
                no_record_found = 1
                OTHERS          = 2.
            CHECK sy-subrc EQ 0.
    
            LOOP AT rgdir WHERE fpbeg GE pn-begda     AND
                                fpend LE pn-endda     AND
                                payty EQ cd_c-regular AND
                                srtza EQ cd_c-actual  AND
                                ocrsn IS INITIAL.
            ENDLOOP.
    
          ENDIF.
          CHECK sy-subrc EQ 0.
          rx-key-pernr = pernr-pernr.
          rx-key-seqno = rgdir-seqnr.
          rp-imp-c2-rx.
    
          CHECK rp-imp-rx-subrc EQ 0.
          LOOP AT rt WHERE lgart EQ c_pag_nom.
            w_t_dat-totalpay = rt-betrg.
    
          ENDLOOP.
    
        ENDFORM.
    
    *    &---------------------------------------------------------------------*
    *    &      Form  EMI_REP
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->P_FONDO    text
    *          -->P_TOTAL    text
    *          -->P_CONT     text
    *    ----------------------------------------------------------------------*
        FORM emi_rep.
    
    *     Ordenar tabla interna
          SORT w_t_dat BY pernr.
    
    *     Establecer encabezado
    
          WRITE w_mon_lot TO w_str_15.
          CONCATENATE text-203 w_str_15 w_mon      INTO w_hdr_2 SEPARATED BY space.
    
          CLEAR: w_t_nom_cam[],
                 w_t_nom_cam.
    
          PERFORM ini_nom_cam USING:
                  'N° personal'          space  space  space,
                  'Apellido y Nombre'    space  space  space,
                  'Cedula'               space  space  space,
                  'Codigo Area Personal' space  space  space,
                  'Nombre Area Personal' space  space  space,
                  'Codigo Posicion'      space  space  space,
                  'Nombre Posicion'      space  space  space,
                  'Salario'              space  space  space,
                  'Neto a pagar'         space  space  space.
    
    *     Emitir reporte
          CALL FUNCTION 'HR_DISPLAY_BASIC_LIST'
            EXPORTING
              basic_list_title     = sy-title
              file_name            = w_nom_pro
              head_line1           = w_hdr_1
              head_line2           = w_hdr_2
              head_line3           = w_hdr_3
              head_line4           = w_hdr_4
              foot_note1           = w_foot_1
              foot_note2           = w_foot_2
              foot_note3           = w_foot_3
              lay_out              = 3
              current_report       = w_nom_pro
              list_level           = '02'
            IMPORTING
              return_code          = w_cod_ret
            TABLES
              data_tab             = w_t_dat
              fieldname_tab        = w_t_nom_cam
              error_tab            = w_t_err
    
    
            EXCEPTIONS
              download_problem     = 1
              no_data_tab_entries  = 2
              table_mismatch       = 3
              print_problems       = 4
              OTHERS               = 5.
    
        ENDFORM.                    "EMI_REP
    
    *    &---------------------------------------------------------------------*
    *    &      Form  GEN_ARC
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *      -->  p1        text
    *      <--  p2        text
    *    ----------------------------------------------------------------------*
        FORM gen_arc.
    
          CLEAR: w_contador,
                 w_t_reg_arc,
                 w_t_reg_arc[].
    
          w_space = cl_abap_conv_in_ce=>uccp( c_space ).
    
    *     Move tipo de servicio
          MOVE: '01' TO w_t_cab-tip_ser,
                'H'  TO w_t_cab-tip_reg,
                w_cod_ban TO w_t_cab-cod_soc,
                sy-datlo TO w_t_cab-fec_env,
                sy-timlo(4) TO w_t_cab-hor_env,
                w_nom_soc   TO w_t_cab-nom_soc.
    
    *     Completar datos de cabecera
          UNPACK w_can_lot TO w_t_cab-can_cre.
          PERFORM fill_num_zero USING    w_mon_lot
                                CHANGING w_t_cab-mon_cre.
    
          PERFORM fill_num_zero USING    0
                              CHANGING w_t_cab-can_deb.
    
          PERFORM fill_num_zero USING    0
                              CHANGING w_t_cab-mon_deb.
    
          PERFORM fill_num_zero USING    0
                              CHANGING w_t_cab-num_mid.
    
    *     Generar filler
          DO 136 TIMES.
            CONCATENATE '&' w_t_cab-espacio INTO w_t_cab-espacio.
          ENDDO.
    
          REPLACE ALL OCCURRENCES OF '&' IN w_t_cab-espacio WITH w_space.
    
    *     Generar registro de encabezado
          CONCATENATE
                  w_t_cab-tip_reg
                  w_t_cab-cod_soc
                  w_t_cab-nom_soc
                  w_t_cab-num_sec
                  w_t_cab-tip_ser
                  w_t_cab-fec_efc
                  w_t_cab-can_deb
                  w_t_cab-mon_deb
                  w_t_cab-can_cre
                  w_t_cab-mon_cre
                  w_t_cab-num_mid
                  w_t_cab-fec_env
                  w_t_cab-hor_env
                  w_t_cab-cor_emp
                  w_t_cab-cod_sta
                  w_t_cab-espacio
                  INTO w_t_reg_arc RESPECTING BLANKS.
          APPEND w_t_reg_arc.
    
          CLEAR w_t_reg_arc.
    
    *     Generar detalle
          LOOP AT  w_t_dat.
    
            ADD 1 TO w_contador.
    
            MOVE-CORRESPONDING w_t_dat TO w_t_det.
            MOVE w_cod_ban TO w_t_det-cod_soc.
            MOVE 'N' TO w_t_det-tip_reg.
            UNPACK w_contador TO w_t_det-num_tra.
    
            PERFORM fill_num_zero USING w_t_det-num_ref
                               CHANGING w_t_det-num_ref.
    
    
            MOVE w_t_dat-icnum TO w_t_det-num_doc.
    
            w_len_text = strlen( w_t_det-num_doc ).
    
            DO 11 - w_len_text TIMES.
              CONCATENATE '0' w_t_det-num_doc INTO w_t_det-num_doc.
            ENDDO.
    
            MOVE w_t_dat-ename TO w_t_det-nom_tra.
            MOVE '00'          TO w_t_det-pro_pag.
    
    
    
    *       Generar filler:
            DO 52 TIMES.
              CONCATENATE '&' w_t_det-espacio INTO w_t_det-espacio.
            ENDDO.
    
            REPLACE ALL OCCURRENCES OF '&' IN w_t_det-espacio WITH w_space.
    
            CONCATENATE
                    w_t_det-tip_reg
                    w_t_det-cod_soc
                    w_t_det-num_sec
                    w_t_det-num_tra
                    w_t_det-cta_des
                    w_t_det-tip_cta
                    w_t_det-mon_pag
                    w_t_det-cod_ban
                    w_t_det-dig_ver
                    w_t_det-cod_ope
                    w_t_det-mon_tra
                    w_t_det-tip_doc
                    w_t_det-num_doc
                    w_t_det-nom_tra
                    w_t_det-num_ref
                    w_t_det-num_ref
                    w_t_det-des_pag
                    w_t_det-fec_ven
                    w_t_det-tip_con
                    w_t_det-cor_tra
                    w_t_det-fax_tra
                    w_t_det-pro_pag
                    w_t_det-num_aut
                    w_t_det-cod_ret
                    w_t_det-cod_rzr
                    w_t_det-cod_rzi
                    w_t_det-pro_tra
                    w_t_det-est_tra
                    w_t_det-espacio
                    INTO w_t_reg_arc RESPECTING BLANKS.
    
            APPEND w_t_reg_arc.
          ENDLOOP.
    
    *     Generar archivo
          CHECK NOT w_t_reg_arc[] IS INITIAL.
    
          CONCATENATE 'pe' w_num_emp '01' sy-datum+4(4) w_t_cab-num_sec 'e' INTO w_nom_arc.
    
          CALL FUNCTION 'GUI_DOWNLOAD'
            EXPORTING
              filename                = w_nom_arc
    *         filetype                = 'ASC'
    *         codepage                = '4110'
    *         trunc_trailing_blanks   = 'X'
            TABLES
              data_tab                = w_t_reg_arc
            EXCEPTIONS
              file_write_error        = 1
              no_batch                = 2
              gui_refuse_filetransfer = 3
              invalid_type            = 4
              no_authority            = 5
              unknown_error           = 6
              header_not_allowed      = 7
              separator_not_allowed   = 8
              filesize_not_allowed    = 9
              header_too_long         = 10
              dp_error_create         = 11
              dp_error_send           = 12
              dp_error_write          = 13
              unknown_dp_error        = 14
              access_denied           = 15
              dp_out_of_memory        = 16
              disk_full               = 17
              dp_timeout              = 18
              file_not_found          = 19
              dataprovider_exception  = 20
              control_flush_error     = 21
              OTHERS                  = 22.
    
    
    *     Emitir reporte
          PERFORM emi_rep.
    
        ENDFORM.                    " GEN_ARC
    
    *    &---------------------------------------------------------------------*
    *    &      Form  ini_nom_cam
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
        FORM ini_nom_cam USING    p_v1
                                  p_v2
                                  p_v3
                                  p_v4.
          w_t_nom_cam-title = p_v1.
          w_t_nom_cam-table = p_v2.
          w_t_nom_cam-field = p_v3.
          w_t_nom_cam-type  = p_v4.
          APPEND w_t_nom_cam.
          CLEAR  w_t_nom_cam.
        ENDFORM.                    "INI_NOM_CAM
    
    *    &---------------------------------------------------------------------*
    *    &      Form  ELI_CAR
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(CEDULA)  text
    *    ----------------------------------------------------------------------*
        FORM eli_car CHANGING VALUE(cedula).
    
          DATA: indice                TYPE i,
                caracter              TYPE c,
                longitud              TYPE i,
                longitud_completa(30).
    
          longitud = strlen( cedula ).
          indice = 0.
          CLEAR longitud_completa.
          WHILE longitud > indice.
            caracter = cedula+indice(1).
            IF caracter CA '1234567890'.
              CONCATENATE longitud_completa caracter INTO longitud_completa.
            ENDIF.
            indice = indice + 1.
          ENDWHILE.
          cedula = longitud_completa.
    
        ENDFORM.                    "ELI_CAR
    
    *    &---------------------------------------------------------------------*
    *    &      Form  CON_TEX
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(P_INPUT)   text
    *          -->VALUE(P_OUTPUT)  text
    *    ----------------------------------------------------------------------*
        FORM con_tex  USING    VALUE(p_input)
                               CHANGING VALUE(p_output).
    
          p_output = p_input.
    
          REPLACE ALL OCCURRENCES OF '.' IN p_output WITH space.
          REPLACE ALL OCCURRENCES OF ',' IN p_output WITH space.
    
        ENDFORM.                    " CON_TEX
    
    *    &---------------------------------------------------------------------*
    *    &      Form  CON_TEX
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(P_INPUT)   text
    *          -->VALUE(P_OUTPUT)  text
    *    ----------------------------------------------------------------------*
        FORM con_tex_mon  USING    VALUE(p_input)
                          CHANGING VALUE(p_output).
    
          p_output = p_input.
    
          SHIFT p_output RIGHT.
    
          REPLACE ALL OCCURRENCES OF '.' IN p_output WITH space.
          REPLACE ALL OCCURRENCES OF ',' IN p_output WITH space.
    
          SHIFT p_output RIGHT.
    
        ENDFORM.                    " CON_TEX
    
    *    &---------------------------------------------------------------------*
    *    &      Form  TRA_STR
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(EXP_REGULAR)  text
    *          -->VALUE(P_INPUT)      text
    *    ----------------------------------------------------------------------*
        FORM tra_str   USING     VALUE(exp_regular)
                       CHANGING VALUE(p_input).
          TRANSLATE p_input TO UPPER CASE.
          TRANSLATE p_input USING exp_regular.
    
        ENDFORM.                    "TRA_STR
    *    &---------------------------------------------------------------------*
    *    &      Form  fill_num_zero
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(P_INPUT)   text
    *          -->VALUE(P_OUTPUT)  text
    *    ----------------------------------------------------------------------*
        FORM fill_num_zero  USING   p_input
                           CHANGING p_output.
    
          DATA: w_valor TYPE string,
                w_input TYPE string.
    
          IF p_input GT 0.
            MULTIPLY p_input BY 100.
          ENDIF.
          MOVE p_input TO w_input.
          SPLIT w_input AT '.' INTO w_mon_1 w_mon_2.
          MOVE w_mon_1 TO w_valor.
    
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = w_valor
            IMPORTING
              output = p_output.
    
        ENDFORM.                    "fill_num_zero
    *    &---------------------------------------------------------------------*
    *    &      Form  fill_text_zero
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->VALUE(P_INPUT)   text
    *          -->VALUE(P_OUTPUT)  text
    *    ----------------------------------------------------------------------*
        FORM fill_text_zero  USING    VALUE(p_input)
                           CHANGING VALUE(p_output).
    
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = p_input
            IMPORTING
              output = p_output.
    
        ENDFORM.                    "fill_text_zero
    *    &---------------------------------------------------------------------*
    *    &      Form  OBT_DAT_BANCO
    *    &---------------------------------------------------------------------*
    *           text
    *    ----------------------------------------------------------------------*
    *          -->P_PERNR_BUKRS  text
    *          <--P_W_T_DAT_STCD1  text
    *    ----------------------------------------------------------------------*
        FORM obt_dat_banco  USING    p_bukrs
                                     p_bankl
                            CHANGING p_cod_ban.
    
          DATA w_bankid LIKE t012_l_bf-hbkid.
    
          MOVE p_bankl TO w_bankid.
    
          CALL FUNCTION 'FI_HOUSEBANK_GET_LIST'
            EXPORTING
              company   = p_bukrs
            TABLES
              t012_list = w_t012
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.
    
          LOOP AT w_t012 WHERE banks EQ w_mol AND
                               bankl EQ p_bankl.
          ENDLOOP.
    
          CALL FUNCTION 'FI_HOUSEBANK_GET_DETAIL'
            EXPORTING
              company   = p_bukrs
              bankid    = w_t012-hbkid
            IMPORTING
              t012_data = w_t012_d
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.
          IF sy-subrc EQ 0.
            READ TABLE w_t012_d INDEX 1.
            MOVE w_t012_d-stcd1 TO p_cod_ban.
          ENDIF.
    
    
    
        ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  GEN_FOR
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
        FORM gen_for using formName.
    
        MOVE formName TO w_for.
    
    * Obtener módulo de función asociado al formulario
          CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
            EXPORTING
              formname           = w_for
              variant            = ' '
              direct_call        = ' '
            IMPORTING
              fm_name            = w_nom_mod_fun
            EXCEPTIONS
              no_form            = 1
              no_function_module = 2
              OTHERS             = 3.
    
          CHECK sy-subrc EQ 0.
    
          CALL FUNCTION w_nom_mod_fun
            EXPORTING
              control_parameters = w_t_par_imp
              user_settings      = 'X'
              fecha              = sy-datum
            IMPORTING
              job_out_into       = w_job_output
            TABLES
              DATOS_EMP          = w_t_for
              DATOS_EMP2         = w_t_for_2.
    
        ENDFORM.