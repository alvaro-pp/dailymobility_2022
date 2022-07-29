***************************
***VARIABLE CONSTRUCTION***
***************************

*weights
encode(fep), gen(fep2)

*COVID-19 related variables
**Lockdown phase
gen fecha2 = date(fecha, "YMD")
tab fecha fecha2, m
gen fase = .
gen prov = .
replace prov = 1 if cpro == 4
replace prov = 2 if cpro == 11
replace prov = 3 if cpro == 14
replace prov = 4 if cpro == 18
replace prov = 5 if cpro == 21
replace prov = 6 if cpro == 23
replace prov = 7 if cpro == 29
replace prov = 8 if cpro == 41
label define provl 1 "almeria" 2 "cadiz" 3 "cordoba" 4 "granada" 5 "huelva" 6 "jaen" 7 "malaga" 8 "sevilla"
label values prov provl
tab prov cpro, m
gen prov2 = .
replace prov2 = 0 if cpro == 4 |cpro == 11 | cpro == 14 | cpro == 21 | cpro == 23 | cpro == 41
replace prov2 = 1 if cpro == 18 | cpro == 29
tab cpro prov2, m
replace fase = 0 if prov2 == 0 & fecha2 <= 22044 | prov2 == 1 & fecha2 <=22053
replace fase = 1 if prov2 == 0 & fecha2 >= 22046 & fecha2 <=22058 | prov2 == 1 & fecha2 >22053
replace fase = 2 if prov2 == 0 & fecha2 > 22058
tab fase, m

**Kith & kin's exposure to covid
gen covidentorno = entornob35
recode covidentorno (0=1) (1=0)
label values covidentorno covidl 
tab covidentorno entornob35, m

**Poor or very poor self-rated health (during lockdown)
recode saludb3 (99=.) (6=.)
gen malasalud = .
replace malasalud = 1 if saludb3 == 4 | saludb3 == 5
replace malasalud = 0 if saludb3 <4
tab malasalud saludb3, m
label define malasaludl 1 "salud regular/mala" 0"salud buena"
label values malasalud malasaludl

*Socio-demographic variables
**Sex
gen sex = .
replace sex = 0 if sexo == 1
replace sex = 1 if sexo == 6
label define sexl 0 "hombre" 1 "mujer"
label values sex sexl
tab sexo sex, m

**Age groups
gen edadg = .
replace edadg = 1 if edad < 30
replace edadg = 2 if edad >= 30 & edad < 40
replace edadg = 3 if edad >= 40 & edad < 65
replace edadg = 4 if edad >= 65
label define edadgl 1 "16-29" 2 "30-39" 3 "40-64" 4 "65+"
label values edadg edadgl
tab edadg, m

**Age squared
gen edadsq = edad^2

**Foreign nationality (vs. Spanish)
label define nacionalidadl 1 "española" 2 "europea" 3 "otra"
label values nacionalidad nacionalidadl
tab nacionalidad, m
recode nacionalidad (1=0) (2/3=1), gen (_ext)

**Socioeconomic position
gen sactualb4_r = sactualb4
recode sactualb4_r(1/5=1) (7=2) (8=6) (9/10=3) (12=4) (6=5) (11=5) (13=5) (98/99=5), gen (rela2)
label define rela2 1"ocupado" 2"parado" 3"pensionista" 4"mislabores" 5"otros inactivos" 6"estudiantes"
label values rela2 rela2
recode cnob4 (1/3=1) (4=2) (5=3) (6/8=4) (9=5) (0=6) (-1=6) (-9=.), gen (ocup)
label define ocup 1"profesional" 2"administra" 3"tr_serv" 4"tr_manual" 5"no_cualif" 6"otros_ocup" 
label values ocup ocup
gen sociolab2=.
replace sociolab2=1 if rela2==1 & ocup==1
replace sociolab2=2 if rela2==1 & ocup==2
replace sociolab2=3 if rela2==1 & ocup==3
replace sociolab2=4 if rela2==1 & ocup==4
replace sociolab2=5 if rela2==1 & ocup==5
replace sociolab2=6 if rela2==1 & ocup==6
replace sociolab2=7 if rela2==2 
replace sociolab2=8 if rela2==3 
replace sociolab2=9 if rela2==4 
replace sociolab2=10 if rela2==5 
replace sociolab2=11 if rela2==6
label define soclab2 1"profesional" 2"administra" 3"tr_serv" 4"tr_manual" 5"no_cualif" 6"otros_ocup" 7"parados" 8"pensionistas" 9"mislabores" 10"otros_inact" 11"estudiantes"
label values sociolab2 soclab2
drop if sociolab2 == 6
drop if sociolab2 == .
recode sociolab2 (7 = 6) (8 = 7) (9 = 7) (10 = 7) (11 = 7)
label define sociolab2l 1 "profesional" 2 "admin" 3 "serv" 4 "manual" 5 "no_cualif" 6 "paradxs" 7 "inactivs"
label values sociolab2 sociolab2l
tab sociolab2 

*Household composition
**Household structure
gen hogar = tiphb1
label define hogarl 1 "unipersonal" 2 "Padre/madre solterx" 3 "pareja sin hijos" 4 "pareja con hijos" 5 "Otro tipo"
label values hogar hogarl
tab hogar tiphb1, m

**Main responsible for housework
recode accionb21 (1=1) (2=1) (3=0) (4=0) (5=0)(6=0) (7=0) (8=0) (9=0) (10=0) (11=0), gen(domesticas)
label define domesticasl 0 "No es el/la responsable principal" 1 "Principal responsable de tareas domesticas" 
label values domesticas domesticasl
tab domesticas

*Housing characteristics
**Flat or other (Vs. House)
gen vivienda = .
replace vivienda = 0 if tvivb1 == 1
replace vivienda = 1 if tvivb1 == 2 | tvivb1 == 3 | tvivb1 == 4
label define viviendal 0 "unifamiliar" 1 "piso/otro"
label values vivienda viviendal
tab vivienda tvivb1, m

**Availability of outdoor space in the household
gen outdoor = .
replace outdoor = 1 if disfb11 == 1 | disfb12 == 1 | disfb13 == 1 | disfb14 == 1 | disfb15 == 1
replace outdoor = 0 if outdoor == .
label define outdoorl 0 "no" 1 "si"
label values outdoor outdoorl
tab outdoor, m

**Residential environment
gen urb = grurba
label define urbl 1 "ciudades" 2 "densidad intermedia" 3 "rural"
label values urb urbl
tab urb grurba, m
recode urb (2=1) (3=2)
label define urbll 1"urban" 2"rural"
label values urb urbll
tab urb, m

**Square meter per resident
gen npershogar = npb1
gen sup = .
replace sup = 37.94349655 if svivb1== 1
replace sup = 53.5 if svivb1== 2
replace sup = 68 if svivb1== 3				
replace sup = 83 if svivb1== 4				
replace sup = 105.5 if svivb1== 5				
replace sup = 175.3573508 if svivb1== 6				
replace sup = 99.44712793 if sup == . & grurba == 1
replace sup = 111.8189421 if sup == . & grurba == 2
replace sup = 123.2376612 if sup == . & grurba == 3
gen m2r = sup / npershogar

*Some independent variable preparation for logit models
recode fase (0=1) (else=0), gen (_fase0)
recode fase (1=1) (else=0), gen (_fase1)
recode fase (2=1) (else=0), gen (_fase2)
rename covidentorno _covidentorno
rename sex _mujer
recode sociolab (1=1) (else=0), gen (_prof)
recode sociolab (2=1) (else=0), gen (_admin)
recode sociolab (3=1) (else=0), gen (_serv)
recode sociolab (4=1) (else=0), gen (_manual)
recode sociolab (5=1) (else=0), gen (_nocualif)
recode sociolab (6=1) (else=0), gen (_parad)
recode sociolab (7=1) (else=0), gen (_inact2)
rename malasalud _malasalud
recode grurba (1=1) (else=0), gen (_urb)
recode grurba (2=1) (else=0), gen (_medium)
recode grurba (3=1) (else=0), gen (_rural)
recode vivienda (1=0) (0=1), gen (_casa)
recode hogar (1=1) (else=0), gen (_unip)
recode hogar (2=1) (else=0), gen (_monop)
recode hogar (3=1) (else=0), gen (_parsin)
recode hogar (4=1) (else=0), gen (_parcon)
recode hogar (5=1) (else=0), gen (_otrohog)
rename outdoor _outdoor

*Dependent varaibles
*For descriptive analysis
**Going to work		
gen trabajar = tareab21
label define indepvarl 1 "diario" 2 "varios dias" 3 "una vez" 4 "menos de una vez" 5 "nunca"
label values trabajar indepvarl
tab trabajar tareab21, m
gen trabajar_i = .
replace trabajar_i = 7 if trabajar == 1
replace trabajar_i = 3 if trabajar == 2
replace trabajar_i = 1 if trabajar == 3
replace trabajar_i = 0.5 if trabajar == 4
replace trabajar_i = 0 if trabajar == 5
tab trabajar_i trabajar

**Grocery shoping
gen comprarcomida = tareab23
label values comprarcomida indepvarl
tab comprarcomida tareab23, m
gen comprarcomida_i = .
replace comprarcomida_i = 7 if comprarcomida == 1
replace comprarcomida_i = 3 if comprarcomida == 2
replace comprarcomida_i = 1 if comprarcomida == 3
replace comprarcomida_i = 0.5 if comprarcomida == 4
replace comprarcomida_i = 0 if comprarcomida == 5
tab comprarcomida_i comprarcomida

**Buying medecine
gen medicamentos = tareab24
label values medicamentos indepvarl
tab medicamentos tareab24, m
gen medicamentos_i = .
replace medicamentos_i = 7 if medicamentos == 1
replace medicamentos_i = 3 if medicamentos == 2
replace medicamentos_i = 1 if medicamentos == 3
replace medicamentos_i = 0.5 if medicamentos == 4
replace medicamentos_i = 0 if medicamentos == 5
tab medicamentos_i medicamentos


**Bring food or medecine to others
gen salircomed = tareab26
label values salircomed indepvarl
tab salircomed tareab26, m
gen salircomed_i = .
replace salircomed_i = 7 if salircomed == 1
replace salircomed_i = 3 if salircomed == 2
replace salircomed_i = 1 if salircomed == 3
replace salircomed_i = 0.5 if salircomed == 4
replace salircomed_i = 0 if salircomed == 5
tab salircomed_i salircomed

**Take out the trash
gen basura = tareab27
label values basura indepvarl
tab basura tareab27, m
gen basura_i = .
replace basura_i = 7 if basura == 1
replace basura_i = 3 if basura == 2
replace basura_i = 1 if basura == 3
replace basura_i = 0.5 if basura == 4
replace basura_i = 0 if basura == 5
tab basura_i basura

**Exercise
gen deporte = tareab28
label values deporte indepvarl
tab deporte tareab28, m
gen deporte_i = .
replace deporte_i = 7 if deporte == 1
replace deporte_i = 3 if deporte == 2
replace deporte_i = 1 if deporte == 3
replace deporte_i = 0.5 if deporte == 4
replace deporte_i = 0 if deporte == 5
tab deporte_i deporte

**Going to the doctor
gen medico = tareab29
label values medico indepvarl
tab medico tareab29, m
gen medico_i = .
replace medico_i = 7 if medico == 1
replace medico_i = 3 if medico == 2
replace medico_i = 1 if medico == 3
replace medico_i = 0.5 if medico == 4
replace medico_i = 0 if medico == 5
tab medico_i medico

**Visit family, neighbours or friends
gen social = tareab210
label values social indepvarl,
tab social tareab210, m
gen social_i = .
replace social_i = 7 if social == 1
replace social_i = 3 if social == 2
replace social_i = 1 if social == 3
replace social_i = 0.5 if social == 4
replace social_i = 0 if social == 5
tab social_i social

**Going shopping
gen compras = tareab212
label values compras indepvarl
tab compras tareab212, m
gen compras_i = .
replace compras_i = 7 if compras == 1
replace compras_i = 3 if compras == 2
replace compras_i = 1 if compras == 3
replace compras_i = 0.5 if compras == 4
replace compras_i = 0 if compras == 5
tab compras_i compras

*For logits
**Comuting
gen laboralog = .
replace laboralog = 1 if trabajar_i >0
replace laboralog = 0 if trabajar_i ==0

**Self-realization
gen deportelog = .
replace deportelog = 1 if deporte_i >0
replace deportelog = 0 if deporte_i ==0
gen socialog = .
replace socialog = 1 if social_i >0
replace socialog = 0 if social_i ==0
gen realizacion2 = socialog + deportelog
gen realizacion = .
replace realizacion = 1 if realizacion2 > 0
replace realizacion = 0 if realizacion2 == 0
drop realizacion2

**Care tasks
gen comprarcomidalog = .
replace comprarcomidalog = 1  if comprarcomida_i >0
replace comprarcomidalog = 0  if comprarcomida_i ==0
gen medicamentoslog = .
replace medicamentoslog = 1 if medicamentos_i >0
replace medicamentoslog = 0 if medicamentos_i ==0
gen salircomedlog = .
replace salircomedlog = 1 if salircomed_i >0
replace salircomedlog = 0 if salircomed_i ==0
gen basuralog = .
replace basuralog = 1 if basura_i >0
replace basuralog = 0 if basura_i ==0
gen medicolog = .
replace medicolog = 1 if medico_i >0
replace medicolog = 0 if medico_i ==0
gen compraslog = .
replace compraslog = 1 if compras_i >0
replace compraslog = 0 if compras_i ==0
gen cuidados2 = comprarcomidalog + medicamentoslog + salircomedlog + basuralog + medicolog + compraslog
gen cuidados = .
replace cuidados = 1 if cuidados2 > 0
replace cuidados = 0 if cuidados2 == 0
drop cuidados2

**Inmobility
gen movilidad =  trabajar_i + comprarcomida_i + medicamentos_i + salircomed_i + basura_i + deporte_i + medico_i + social_i + compras_i
*inmov = 1 "immobile", 0 = person who left their house
gen inmov = .
replace inmov = 1 if movilidad == 0
replace inmov = 0 if movilidad >0

**High mobility
*Hipermov = 1 "hipermobile", 0 = non-hipermobile
gen hipermov2 = .
replace hipermov2 = 1 if movilidad >= 8
replace hipermov2 = 0 if movilidad < 8

*************
***RESULTS***
*************


**Table 3
sum trabajar_i [aw=fep2] if fase == 0 & laboral == 1
sum trabajar_i [aw=fep2] if fase == 1 & laboral == 1
sum trabajar_i [aw=fep2] if fase == 2 & laboral == 1
sum comprarcomida_i [aw=fep2] if fase == 0
sum comprarcomida_i [aw=fep2] if fase == 1
sum comprarcomida_i [aw=fep2] if fase == 2
sum medicamentos_i [aw=fep2] if fase == 0
sum medicamentos_i [aw=fep2] if fase == 1
sum medicamentos_i [aw=fep2] if fase == 2
sum salircomed_i [aw=fep2] if fase == 0
sum salircomed_i [aw=fep2] if fase == 1
sum salircomed_i [aw=fep2] if fase == 2
sum deporte_i [aw=fep2] if fase == 0
sum deporte_i [aw=fep2] if fase == 1
sum deporte_i [aw=fep2] if fase == 2
sum medico_i [aw=fep2] if fase == 0
sum medico_i [aw=fep2] if fase == 1
sum medico_i [aw=fep2] if fase == 2
sum social_i [aw=fep2] if fase == 0
sum social_i [aw=fep2] if fase == 1
sum social_i [aw=fep2] if fase == 2
sum basura_i [aw=fep2] if fase == 0
sum basura_i [aw=fep2] if fase == 1
sum basura_i [aw=fep2] if fase == 2
sum compras_i [aw=fep2] if fase == 0
sum compras_i [aw=fep2] if fase == 1
sum compras_i [aw=fep2] if fase == 2

**Pearson correlation analysis (commented in text)
cls
pwcorr movilidad trabajar_i comprarcomida_i medicamentos_i salircomed_i deporte_i medico_i social_i compras_i if fase == 0
pwcorr movilidad trabajar_i comprarcomida_i medicamentos_i salircomed_i deporte_i medico_i social_i compras_i if fase == 1
pwcorr movilidad trabajar_i comprarcomida_i medicamentos_i salircomed_i deporte_i medico_i social_i compras_i if fase == 2

**Figure 1 (Calculations)
cls
sum movilidad [aw=fep2] if inmov == 0 & fase == 0, d
sum movilidad [aw=fep2] if inmov == 0 & fase == 1, d
sum movilidad [aw=fep2] if inmov == 0 & fase == 2, d


**Table 4 (models for commuting, self-realization and care tasks)
*Commuting
logit laboralog _fase1 _fase2 _covidentorno _malasalud [pw=fep2] if sociolab<=5, vce(robust)
fitstat
logit laboralog _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 [pw=fep2] if sociolab<=5, vce(robust)
fitstat
logit laboralog _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas [pw=fep2] if sociolab<=5, vce(robust)
fitstat
logit laboralog _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] if sociolab<=5, vce(robust)
fitstat
margins, dydx (_fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r)

*Self-realization
logit realizacion _fase1 _fase2 _covidentorno _malasalud [pw=fep2], vce(robust) or
fitstat
logit realizacion _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 [pw=fep2], vce(robust) 
fitstat
logit realizacion _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas [pw=fep2], vce(robust)
fitstat
logit realizacion _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2], vce(robust)
fitstat
margins, dydx (_fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r)

*Care tasks
logit cuidados _fase1 _fase2 _covidentorno _malasalud [pw=fep2], vce(robust)
fitstat
logit cuidados _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 [pw=fep2], vce(robust) 
fitstat
logit cuidados _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas [pw=fep2], vce(robust)
fitstat
logit cuidados _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2], vce(robust)
fitstat
margins, dydx (_fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r)

**Table 5 (models for inmobility and high mobility)
*Inmobility
logit inmov _fase1 _fase2 _covidentorno _malasalud [pw=fep2], vce(robust)
fitstat
logit inmov _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 [pw=fep2], vce(robust) 
fitstat
logit inmov _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas [pw=fep2], vce(robust)
fitstat
logit inmov _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2], vce(robust)
fitstat
margins, dydx (_fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r)

*High mobility
logit hipermov2 _fase1 _fase2 _covidentorno _malasalud [pw=fep2] if inmov==0, vce(robust)
fitstat
logit hipermov2 _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 [pw=fep2] if inmov==0, vce(robust) 
fitstat
logit hipermov2 _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas [pw=fep2] if inmov==0, vce(robust)
fitstat
logit hipermov2 _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] if inmov==0, vce(robust)
fitstat
margins, dydx (_fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r)



***********
***ANNEX***
***********

***1.
tab movilidad

***2.
**Figure 
*sex
cls
tab sex comprarcomidalog  [aw=fep2], row nof
tab sex comprarcomidalog ,chi
cls
tab sex medicamentoslog  [aw=fep2], row nof
tab sex medicamentoslog, chi
cls
tab sex salircomedlog  [aw=fep2], row nof
tab sex salircomedlog, chi
cls
tab sex deportelog  [aw=fep2], row nof
tab sex deportelog, chi
cls
tab sex medicolog  [aw=fep2], row nof
tab sex medicolog, chi
cls
tab sex socialog  [aw=fep2], row nof
tab sex socialog, chi
cls
tab sex basuralog  [aw=fep2], row nof
tab sex basuralog, chi
cls
tab sex compraslog  [aw=fep2], row nof
tab sex compraslog, chi
cls
tab sex laboralog  [aw=fep2], row nof
tab sex laboralog, chi

*age groups
cls
tab edadg comprarcomidalog  [aw=fep2], row nof
tab edadg comprarcomidalog ,chi
cls
tab edadg medicamentoslog  [aw=fep2], row nof
tab edadg medicamentoslog, chi
cls
tab edadg salircomedlog  [aw=fep2], row nof
tab edadg salircomedlog, chi
cls
tab edadg deportelog  [aw=fep2], row nof
tab edadg deportelog, chi
cls
tab edadg medicolog  [aw=fep2], row nof
tab edadg medicolog, chi
cls
tab edadg socialog  [aw=fep2], row nof
tab edadg socialog, chi
cls
tab edadg basuralog  [aw=fep2], row nof
tab edadg basuralog, chi
cls
tab edadg compraslog  [aw=fep2], row nof
tab edadg compraslog, chi
cls
tab edadg laboralog  [aw=fep2], row nof
tab edadg laboralog, chi

*Kith and kin's
cls
tab _covidentorno comprarcomidalog  [aw=fep2], row nof
tab _covidentorno comprarcomidalog ,chi
cls
tab _covidentorno medicamentoslog  [aw=fep2], row nof
tab _covidentorno medicamentoslog, chi
cls
tab _covidentorno salircomedlog  [aw=fep2], row nof
tab _covidentorno salircomedlog, chi
cls
tab _covidentorno deportelog  [aw=fep2], row nof
tab _covidentorno deportelog, chi
cls
tab _covidentorno medicolog  [aw=fep2], row nof
tab _covidentorno medicolog, chi
cls
tab _covidentorno socialog  [aw=fep2], row nof
tab _covidentorno socialog, chi
cls
tab _covidentorno basuralog  [aw=fep2], row nof
tab _covidentorno basuralog, chi
cls
tab _covidentorno compraslog  [aw=fep2], row nof
tab _covidentorno compraslog, chi
cls
tab _covidentorno laboralog  [aw=fep2], row nof
tab _covidentorno laboralog, chi

*Self-rated health
cls
tab _malasalud comprarcomidalog  [aw=fep2], row nof
tab _malasalud comprarcomidalog ,chi
cls
tab _malasalud medicamentoslog  [aw=fep2], row nof
tab _malasalud medicamentoslog, chi
cls
tab _malasalud salircomedlog  [aw=fep2], row nof
tab _malasalud salircomedlog, chi
cls
tab _malasalud deportelog  [aw=fep2], row nof
tab _malasalud deportelog, chi
cls
tab _malasalud medicolog  [aw=fep2], row nof
tab _malasalud medicolog, chi
cls
tab _malasalud socialog  [aw=fep2], row nof
tab _malasalud socialog, chi
cls
tab _malasalud basuralog  [aw=fep2], row nof
tab _malasalud basuralog, chi
cls
tab _malasalud compraslog  [aw=fep2], row nof
tab _malasalud compraslog, chi

**Descriptive analysis about who moves commented in text
*socio-economic position
cls
tab sociolab2 comprarcomidalog  [aw=fep2], row nof
tab sociolab2 comprarcomidalog ,chi
cls
tab sociolab2 medicamentoslog  [aw=fep2], row nof
tab sociolab2 medicamentoslog, chi
cls
tab sociolab2 salircomedlog  [aw=fep2], row nof
tab sociolab2 salircomedlog, chi
cls
tab sociolab2 deportelog  [aw=fep2], row nof
tab sociolab2 deportelog, chi
cls
tab sociolab2 medicolog  [aw=fep2], row nof
tab sociolab2 medicolog, chi
cls
tab sociolab2 socialog  [aw=fep2], row nof
tab sociolab2 socialog, chi
cls
tab sociolab2 basuralog  [aw=fep2], row nof
tab sociolab2 basuralog, chi
cls
tab sociolab2 compraslog  [aw=fep2], row nof
tab sociolab2 compraslog, chi
cls
tab sociolab2 laboralog  [aw=fep2], row nof
tab sociolab2 laboralog, chi

*foreginers
cls
tab nacionalidad comprarcomidalog  [aw=fep2], row nof
tab nacionalidad comprarcomidalog ,chi
cls
tab nacionalidad medicamentoslog  [aw=fep2], row nof
tab nacionalidad medicamentoslog, chi
cls
tab nacionalidad salircomedlog  [aw=fep2], row nof
tab nacionalidad salircomedlog, chi
cls
tab nacionalidad deportelog  [aw=fep2], row nof
tab nacionalidad deportelog, chi
cls
tab nacionalidad medicolog  [aw=fep2], row nof
tab nacionalidad medicolog, chi
cls
tab nacionalidad socialog  [aw=fep2], row nof
tab nacionalidad socialog, chi
cls
tab nacionalidad basuralog  [aw=fep2], row nof
tab nacionalidad basuralog, chi
cls
tab nacionalidad compraslog  [aw=fep2], row nof
tab nacionalidad compraslog, chi

*household structure
cls
tab hogar comprarcomidalog  [aw=fep2], row nof
tab hogar comprarcomidalog ,chi
cls
tab hogar medicamentoslog  [aw=fep2], row nof
tab hogar medicamentoslog, chi
cls
tab hogar salircomedlog  [aw=fep2], row nof
tab hogar salircomedlog, chi
cls
tab hogar deportelog  [aw=fep2], row nof
tab hogar deportelog, chi
cls
tab hogar medicolog  [aw=fep2], row nof
tab hogar medicolog, chi
cls
tab hogar socialog  [aw=fep2], row nof
tab hogar socialog, chi
cls
tab hogar basuralog  [aw=fep2], row nof
tab hogar basuralog, chi
cls
tab hogar compraslog  [aw=fep2], row nof
tab hogar compraslog, chi
cls
tab hogar laboralog  [aw=fep2], row nof
tab hogar laboralog ,chi

*Main responsible for housework
cls
tab domesticas comprarcomidalog  [aw=fep2], row nof
tab domesticas comprarcomidalog ,chi
cls
tab domesticas medicamentoslog  [aw=fep2], row nof
tab domesticas medicamentoslog, chi
cls
tab domesticas salircomedlog  [aw=fep2], row nof
tab domesticas salircomedlog, chi
cls
tab domesticas deportelog  [aw=fep2], row nof
tab domesticas deportelog, chi
cls
tab domesticas medicolog  [aw=fep2], row nof
tab domesticas medicolog, chi
cls
tab domesticas socialog  [aw=fep2], row nof
tab domesticas socialog, chi
cls
tab domesticas basuralog  [aw=fep2], row nof
tab domesticas basuralog, chi
cls
tab domesticas compraslog  [aw=fep2], row nof
tab domesticas compraslog, chi
cls
tab domesticas laboralog  [aw=fep2], row nof
tab domesticas laboralog, chi

*Flat or other (vs.House)
cls
tab vivienda comprarcomidalog  [aw=fep2], row nof
tab vivienda comprarcomidalog ,chi
cls
tab vivienda medicamentoslog  [aw=fep2], row nof
tab vivienda medicamentoslog, chi
cls
tab vivienda salircomedlog  [aw=fep2], row nof
tab vivienda salircomedlog, chi
cls
tab vivienda deportelog  [aw=fep2], row nof
tab vivienda deportelog, chi
cls
tab vivienda medicolog  [aw=fep2], row nof
tab vivienda medicolog, chi
cls
tab vivienda socialog  [aw=fep2], row nof
tab vivienda socialog, chi
cls
tab vivienda basuralog  [aw=fep2], row nof
tab vivienda basuralog, chi
cls
tab vivienda compraslog  [aw=fep2], row nof
tab vivienda compraslog, chi
cls
tab vivienda laboralog  [aw=fep2], row nof
tab vivienda laboralog, chi

*Availability of outdoor space 
cls
tab _outdoor comprarcomidalog  [aw=fep2], row nof
tab _outdoor comprarcomidalog ,chi
cls
tab _outdoor medicamentoslog  [aw=fep2], row nof
tab _outdoor medicamentoslog, chi
cls
tab _outdoor salircomedlog  [aw=fep2], row nof
tab _outdoor salircomedlog, chi
cls
tab _outdoor deportelog  [aw=fep2], row nof
tab _outdoor deportelog, chi
cls
tab _outdoor medicolog  [aw=fep2], row nof
tab _outdoor medicolog, chi
cls
tab _outdoor socialog  [aw=fep2], row nof
tab _outdoor socialog, chi
cls
tab _outdoor basuralog  [aw=fep2], row nof
tab _outdoor basuralog, chi
cls
tab _outdoor compraslog  [aw=fep2], row nof
tab _outdoor compraslog, chi

*Residential environment
cls
tab urb comprarcomidalog  [aw=fep2], row nof
tab urb comprarcomidalog ,chi
cls
tab urb medicamentoslog  [aw=fep2], row nof
tab urb medicamentoslog, chi
cls
tab urb salircomedlog  [aw=fep2], row nof
tab urb salircomedlog, chi
cls
tab urb deportelog  [aw=fep2], row nof
tab urb deportelog, chi
cls
tab urb medicolog  [aw=fep2], row nof
tab urb medicolog, chi
cls
tab urb socialog  [aw=fep2], row nof
tab urb socialog, chi
cls
tab urb basuralog  [aw=fep2], row nof
tab urb basuralog, chi
cls
tab urb compraslog  [aw=fep2], row nof
tab urb compraslog, chi
cls
tab urb laboralog  [aw=fep2], row nof
tab urb laboralog, chi

*Square meters per resident
cls
by comprarcomidalog, sort: sum m2r [aw=fep2]
ttest m2r, by(comprarcomidalog) unequal
by medicamentoslog, sort: sum m2r [aw=fep2]
ttest m2r, by(medicamentoslog) unequal
by salircomedlog, sort: sum m2r [aw=fep2]
ttest m2r, by(salircomedlog) unequal
by basuralog, sort: sum m2r [aw=fep2]
ttest m2r, by(basuralog) unequal
by deportelog, sort: sum m2r [aw=fep2]
ttest m2r, by(deportelog) unequal
by medicolog, sort: sum m2r [aw=fep2]
ttest m2r, by(medicolog) unequal
by socialog, sort: sum m2r [aw=fep2]
ttest m2r, by(socialog) unequal
by compraslog, sort: sum m2r [aw=fep2]
ttest m2r, by(compraslog) unequal

***3.
logit laboralog  _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] if  sociolab<=5, vce(robust)
fitstat
logit deportelog   _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit socialog    _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit comprarcomidalog     _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit medicamentoslog      _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit salircomedlog       _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit basuralog        _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit medicolog         _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
logit compraslog         _fase1 _fase2 _covidentorno _malasalud _mujer edad edadsq _ext _prof _serv _manual _nocualif _parad _inact2 _monop _parsin _parcon _otrohog domesticas _casa _outdoor _urb _rural m2r [pw=fep2] , vce(robust)
fitstat
