*------------------------------------------------------------------------------
* Programa:    Z_ADV_FORMS_EXERCISE
* Descripción: Ejercicio para el testing de los ADV Forms
*------------------------------------------------------------------------------
* Simbolos de texto
*------------------------------------------------------------------------------
*101  Datos para la transferencia
*102  Nómina especial
*109  Datos del archivo
*116  Datos del depósito
*200  Periodo:
*201  Nómina de
*202  del
*203  Total
*204  Pesos.
*205  Generar archivo
*300  Indique código de la sociedad
*301  No existen datos para la selección
*------------------------------------------------------------------------------
* Textos de selección
*------------------------------------------------------------------------------
*BONDT  ?...
*DES_PAG  Descripción Pago
*LGART  Concepto
*NOM_ARC  Nombre archivo
*OCRSN  Motivo de nómina
*PAYID  ?...
*PAYTY  Tipo y fecha
*RUT_DES  Ruta de descarga
*------------------------------------------------------------------------------
REPORT z_adv_forms_exercise MESSAGE-ID hrpadve
                              LINE-SIZE 90
                              LINE-COUNT 65
                              NO STANDARD PAGE HEADING.

* Definición de datos
INCLUDE z_adv_forms_exercise_def.
* Rutinas
INCLUDE z_adv_forms_exercise_rut.

*------------------------------------------------------------------------------
*                        I N I C I A L I Z A C I O N
*------------------------------------------------------------------------------


*---------------------------------------------------------------------------
*                                I N I C I O
*------------------------------------------------------------------------------
START-OF-SELECTION.

  IF pnpbukrs-low IS INITIAL.
    MESSAGE text-306 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

* Blanquear variables
  REFRESH: w_t_dat[].

  CLEAR: w_t_cab,
         w_can_lot,
         w_mon_lot,
         w_len_text.

* Obtener datos generales
  PERFORM obt_dat_gen.

*------------------------------------------------------------------------------
*                               P R O C E S O
*------------------------------------------------------------------------------

GET pernr.

  CLEAR: w_t_dat.

  PERFORM obt_dat.  

* Validar existencia de datos
  IF w_t_dat[] IS INITIAL.
    MESSAGE text-301 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.
  CHECK NOT w_t_dat[] IS INITIAL.

  IF p_alv IS NOT INITIAL.
    PERFORM emi_rep.
  ELSEIF p_smartf IS NOT INITIAL.
    PERFORM gen_for USING 'Z_SMARTFORMS_TEST'.
  ENDIF.

  INCLUDE rpppxm00.