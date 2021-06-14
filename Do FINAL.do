cap log close 
	set more off
	clear all 
	cd "/Users/delfisshit/Desktop/UTDT/TESIS/Guardados "
	log using "LogFinal.log" , replace
	
	use BASEENBRUTO in 1/10000
	
	keep ide_trabajador relacion letra r32 rt*
	
	gen line = [_n]
	reshape long rt, i(line) j(mes)
		
	gen Construcción=0
	replace Construcción=1 if letra=="F"
	replace Construcción=1 if r32 == 45
	drop if Construcción==1
	
	label define Rama 1 "Agricultura, ganadería y caza" 2 "Silvicultura" 5 "Pesca" 10 "Carbón y lignito" 11 "Petróleo y gas natural" 12 "extracción de uranio y torio" 13 "Minerales metalíferos" 14 "Minas y canteras" 15 "Alimentos y bebeidas" 16 "Tabaco" 17 " Textiles" 18 "Prendas de vestir" 19 "Curtido, marroquinería, talabarteria y calzado" 20 "Madera y corcho" 21 "Papel" 22 "Edición e impresión" 23 "Refinación de petroleo y combustible" 24 "Sustancias y productos químicos" 25 "Caucho y plástico" 26 "Minerales no metálicos" 27 "Metales comunes" 28 "Productos de metal, excepto maquinaria" 29 "Fabricación de maquinaria y equipo" 30 "Maquinaria de oficina" 31 "Aparatos electrónicos" 32 "Radio, televisi´pon y comunicaciones" 33 "Intrumentos médicos y relojes" 34 "Vehículos" 35 "Equipo de transporte" 36 "Muebvles y colchones, industria manufacturera" 37 "Reciclamiento" 40 "Gas, electricidad y vapor" 41 "Agua" 45 "Construcción" 50 "Vta y reparación de vehiculos y motos" 51 "Comercio al por mayor" 52 "Comercio al por menor" 55 "Hotelería y restaurantes" 60 "Servicios de transporte terrestre" 61 "Servicio de transporte acuático" 62 "Servicio de transporte aéreo" 63 "Agencias de viajes"  64 "Correo y telecomunicaciones" 65 "Servicios financieros" 66 "Seguros y admin. de jubilaciones y pensiones" 67 "Servicios auxiliares a la actividad financiera" 70 "Servicios inmobiliarios" 71 "Alquileres" 72 "Servicios informáticos" 73 "Investigación y desarollo" 74 "Servicios empresariales" 75 "Administración pública" 80 "enseñanza" 85 "servicios sociales y de salud" 90 "Eliminación de desperdicios" 91 "Servicios de asociaciones" 92 "Servicios culturales y deportivos" 93 "Servicios" 95 "Servicios de horares privados" 99 "Organizaciones y organos extraterritoriales"  
	label values r32 Rama
	
	replace rt=-9 if rt==.
	
	global condicion1 "mes >= 200001 & mes <= 200312"
	gen condicion=0
	replace condicion=1 if $condicion1
	egen condtot = sum(condicion), by(ide_trabajador)
	egen condtott = sum(condicion), by(line)
	
	gen anio = floor(mes/100)
	gen mm = mes-anio*100
	gen t = ym(anio,mm)
	format t %tmCCYY!mnn
	
	xtset line t, monthly
	
	gen TmenosUno = l.rt
	gen Estado=.
	replace Estado=4 if (rt==-9 & TmenosUno>=0)
	replace Estado=2 if (rt>=0 & TmenosUno==-9)
	replace Estado=1 if (rt==-9 & TmenosUno==-9)
	replace Estado=3 if (rt>=0 & TmenosUno>=0)
	replace Estado=0 if mes==199601
	
	label define Estado 1 "C.Desempleado" 2 "Creación" 3 "C.Empleado" 4 "Separación" 0 "Inicio"
	label values Estado Estado
		
	egen TotEmp = sum(rt>0), by (mes)
	egen TotSep = sum(Estado == 4), by (mes)
	egen TotCre = sum(Estado == 2), by (mes) 
	
	gen TasaSep=. 
	replace TasaSep = F.TotSep/TotEmp
	
	gen TasaCre=.
	replace TasaCre = TotCre/TotEmp
	
	
	label var TasaSep "Tasa de separacion"
	label var TasaCre "Tasa de Creación"
	label var t "tiempo en meses"
	
	
	**********************************
	save BEBE_modifDelfi.dta, replace
	********************************** 
	
	forvalues jj = 1/5{
	local ini=`jj'*10000+1
	local fin=`jj'*10000+10000
	disp "Abriendo observaciones desde la `ini' hasta la `fin'"
	use BASEENBRUTO in `ini'/`fin'
	
	keep ide_trabajador relacion rt*
	
	gen line = [_n]
	reshape long rt, i(line) j(mes)
	
	gen Construcción=0
	replace Construcción=1 if letra=="F"
	replace Construcción=1 if r32 == 45
	drop if Construcción==1
	
	label define Rama 1 "Agricultura, ganadería y caza" 2 "Silvicultura" 5 "Pesca" 10 "Carbón y lignito" 11 "Petróleo y gas natural" 12 "extracción de uranio y torio" 13 "Minerales metalíferos" 14 "Minas y canteras" 15 "Alimentos y bebeidas" 16 "Tabaco" 17 " Textiles" 18 "Prendas de vestir" 19 "Curtido, marroquinería, talabarteria y calzado" 20 "Madera y corcho" 21 "Papel" 22 "Edición e impresión" 23 "Refinación de petroleo y combustible" 24 "Sustancias y productos químicos" 25 "Caucho y plástico" 26 "Minerales no metálicos" 27 "Metales comunes" 28 "Productos de metal, excepto maquinaria" 29 "Fabricación de maquinaria y equipo" 30 "Maquinaria de oficina" 31 "Aparatos electrónicos" 32 "Radio, televisi´pon y comunicaciones" 33 "Intrumentos médicos y relojes" 34 "Vehículos" 35 "Equipo de transporte" 36 "Muebvles y colchones, industria manufacturera" 37 "Reciclamiento" 40 "Gas, electricidad y vapor" 41 "Agua" 45 "Construcción" 50 "Vta y reparación de vehiculos y motos" 51 "Comercio al por mayor" 52 "Comercio al por menor" 55 "Hotelería y restaurantes" 60 "Servicios de transporte terrestre" 61 "Servicio de transporte acuático" 62 "Servicio de transporte aéreo" 63 "Agencias de viajes"  64 "Correo y telecomunicaciones" 65 "Servicios financieros" 66 "Seguros y admin. de jubilaciones y pensiones" 67 "Servicios auxiliares a la actividad financiera" 70 "Servicios inmobiliarios" 71 "Alquileres" 72 "Servicios informáticos" 73 "Investigación y desarollo" 74 "Servicios empresariales" 75 "Administración pública" 80 "enseñanza" 85 "servicios sociales y de salud" 90 "Eliminación de desperdicios" 91 "Servicios de asociaciones" 92 "Servicios culturales y deportivos" 93 "Servicios" 95 "Servicios de horares privados" 99 "Organizaciones y organos extraterritoriales"  
	label values r32 Rama
		
	replace rt=-9 if rt==.
	
	global condicion1 "mes >= 200001 & mes <= 200312"
	gen condicion=0
	replace condicion=1 if $condicion1
	egen condtot = sum(condicion), by(ide_trabajador)
	egen condtott = sum(condicion), by(line)
	
	gen anio = floor(mes/100)
	gen mm = mes-anio*100
	gen t = ym(anio,mm)
	format t %tmCCYY!mnn
	
	xtset line t, monthly
	
	gen TmenosUno = l.rt
	gen Estado=.
	replace Estado=4 if (rt==-9 & TmenosUno>=0)
	replace Estado=2 if (rt>=0 & TmenosUno==-9)
	replace Estado=1 if (rt==-9 & TmenosUno==-9)
	replace Estado=3 if (rt>=0 & TmenosUno>=0)
	replace Estado=0 if mes==199601

	
	label define Estado 1 "C.Desempleado" 2 "Creación" 3 "C.Empleado" 4 "Separación" 0 "Inicio"
	label values Estado Estado
		
	egen TotEmp = sum(rt>0), by (mes)
	egen TotSep = sum(Estado == 4), by (mes)
	egen TotCre = sum(Estado == 2), by (mes) 
	
	gen TasaSep=. 
	replace TasaSep = F.TotSep/TotEmp
	
	gen TasaCre=.
	replace TasaCre = TotCre/TotEmp
	
	
	label var TasaSep "Tasa de separacion"
	label var TasaCre "Tasa de Creación"
	label var t "tiempo en meses"
	
	
	save BEBDelfi_Modif_`jj'.dta, replace
	}
	
	use BEBE_modifDelfi.dta,clear
	forvalues jj = 1/5{
	append using BEBDelfi_Modif_`jj'.dta
	}
	
	**GRÁFICO 1: Separación y Creación
	cap drop dd
	gen dd = 0.1 if mes==200201
	gen dd2 = 0.1 if mes==200407
	gen dd3 = 0.1 if mes==200512 
	gen dd4 = 0.1 if mes==200709 
	gen dd5=0.1 if mes==200301
	label var dd "inicio doble indem."
	label var dd2 "Reducción doble indem"
	label var dd3 "Reducción doble indem"
	label var dd4 "fin doble indem"
	label var dd5 "Corte de la asignación"
	
	twoway line TasaSep t if ide_trabajador==10000141 & mes>199601 
	
	twoway line TasaCre t if ide_trabajador==10000141 & mes>199601 
	
	twoway line TasaSep TasaCre t if ide_trabajador==10000141 & mes>199601 
	
	**GRÁFICO 2: Desestacionalizado
		sum TasaSep if mes>199601 & mes<201512
	global meantasa=r(mean)
	reg TasaSep i.mm if ide_trabajador==10000141 & mes>199601
	predict tasasepres, residual
	replace tasasepres = tasasepres+$meantasa 
	label var tasasepres "separacion (ajust)"
	
		sum TasaCre if mes>199601 & mes<201512
	global meantasa2=r(mean)
	reg TasaCre i.mm if ide_trabajador==10000141 & mes>199601
	predict tasacreres, residual
	replace tasacreres = tasacreres+$meantasa 
	label var tasacreres "creación (ajust)"
	
	twoway line tasasepres t if ide_trabajador==10000141 & mes>199601

	twoway line tasacreres t if ide_trabajador==10000141 & mes>199601
	
	twoway line tasasepres tasacreres t if ide_trabajador==10000141 & mes>199601 
	
	
	**GRÁFCIO 3: Separación 2002 s/ desestacionalizar
	preserve 
	collapse (mean) TasaSep, by(t mes) 
	gen A= TasaSep if mes<200201
	gen B= TasaSep if mes>=200201
	gen dd = 0.1 if mes==200201
	label var A "Anterior a la ley 2002"
	label var B "Posterior a la ley 2002"
	label var dd "inicio doble indem."
	twoway line A B t if mes>=200101 & mes<200301 || dropline dd t if mes>200101 & mes<200301 , vertical
	restore
	
	**GRÁFICO 4: Separación 2002 desestacionalizada
	gen C = tasasepres if mes<200201
	gen D = tasasepres if mes>=200201
	label var C "Anterior de la ley 2002"
	label var D "Posterior a la ley 2002"
	twoway line C D t if ide_trabajador==10000141 & mes>=200101 & mes<200301 || dropline dd t if mes>200101 & mes<200301 , vertical
	drop C D 

	**GRÁFICO 5: Creación 2002 s/desestacionalizar
	preserve 
	collapse (mean) TasaCre, by(t mes) 
	gen A= TasaCre if mes<200201
	gen B= TasaCre if mes>=200201
	gen dd = 0.1 if mes==200201
	label var A "Anterior a la ley 2002"
	label var B "Posterior a la ley 2002"
	label var dd "inicio doble indem."
	twoway line A B t if mes>=200101 & mes<200301 || dropline dd t if mes>200101 & mes<200301 , vertical
	restore
	
	**GRÁFICO 6: Creación 2002 desestacionalizada
	gen E = tasacreres if mes<200201
	gen F = tasacreres if mes>=200201
	label var E "Anterior de la ley 2002"
	label var F "Posterior a la ley 2002"
	twoway line E F t if ide_trabajador==10000141 & mes>=200101 & mes<200301 || dropline dd t if mes>200101 & mes<200301 , vertical
	drop E F  
	
	******************************
	save BASE2_Delfi.dta, replace 
	******************************
	
	use BASEENBRUTO in 1/60000
	drop rt* pondera tr_* r34 
	sort ide_trabajador relacion 
	save CARACT_Delfi.dta, replace
	 
	use BASE2_Delfi, clear
	contract ide_trabajador relacion 
	drop _freq
	sort ide_trabajador relacion 
	merge 1:1 ide_trabajador relacion using CARACT_Delfi
	drop if _merge!=3
	drop _merge
	sort ide_trabajador relacion

	merge 1:m ide_trabajador relacion using BASE2_Delfi
	drop _merge
	save BASE2_Delfi, replace
	
	drop TotEmp TotCre TmenosUno
	
	sort ide_trabajador line mes
	**
	cap drop line
	drop if rt==-9 & Estado==1
	
	egen line = group(ide_ relacion) 
	
	xtset line t, monthly
	
	gen mesi = mes if rt>0
	egen ini = min(mesi), by(line)  
	egen fin = max(mesi), by(line) 
	
	gen Trat=.
	replace Trat=1 if ini>=200201 & ini<200301 
	replace Trat=0 if ini>=200301 & ini<200401
	
	gen EmpTrat=.
	replace EmpTrat=0 if rt>0 & Trat==0
	replace EmpTrat=1 if rt>0 & Trat==1
	
	egen TotEmpTrat = sum (EmpTrat==1), by (mes)
	egen TotEmpNoTrat = sum(EmpTrat==0), by (mes) 
	
	egen TotSepNoTrat = sum(Estado == 4 & Trat==0), by (mes) 
	egen TotSepTrat   = sum(Estado == 4 & Trat==1), by (mes)
	
	xtset line t, monthly
	
	gen TasaSepNoTrat=.
	replace TasaSepNoTrat = f.TotSepNoTrat/TotEmpNoTrat

	gen TasaSepTrat=.
	replace TasaSepTrat = f.TotSepTrat/TotEmpTrat
	
	***
	preserve 
	collapse (mean) TasaSepTrat TasaSepNoTrat, by(t mes) 
	twoway line TasaSepTrat TasaSepNoTrat t if mes>=200301 & mes<200709
	restore
	
	**REGRESIONES**
	
	*Quiero incluir la edad
	gen Edad=anio-fnac_anu
	
	*Incluyo el sexo
	gen hombre = sexo==2
	
	*Quiero incluir la an Antiguedad 
	gen Empleado=. 
	replace Empleado=1 if rt>0 
	gen t_ = t if Empleado==1
	egen init = min(t_), by(line)
	gen Antiguedad = t-init + 1
	replace Antiguedad = . if Empleado!=1
	
	*Divido Antiguedad y Edad por grupos
	generate ant1=recode(Antiguedad,3,6,12,24,36,120,240)
		tab ant1
	gen ant3 = ant1==3
	gen ant6 = ant1==6
	gen ant12 = ant1==12
    generate edgrupos=recode(Edad,18,25,35,45,55,65,109)
	tab edgrupos
	replace edgrupos=. if edgrupos==18 | edgrupos==109 
	
	*Quiero incluir la Rama 
	tab r32, gen (rama)
	tab provi, gen (P)
	
	gen T=0 if mes<200201
	replace T=1 if mes>=200201
	
	*Genero una variablñe que me dice si estoy antes o después del tratamiento
	gen Ley2004=.
	replace Ley2004=0 if mes<200407
	replace Ley2004=1 if mes>=200407
	
	gen Ley2005=.
	replace Ley2005=0 if mes<200512
	replace Ley2005=1 if mes>=200512
	
	gen Ley2007=.
	replace Ley2007=0 if mes<200709
	replace Ley2007=1 if mes>=200709
	
	*Dummy de separación en t
	cap drop sepa
	gen sepa = f.Estado==4 & fin==mes
	replace sepa = . if Estado!=3&Estado!=2 & sepa==0

	*Genero la interración entre ser Tratado y si se sancionó la ley
	gen interaccion1= Tra*Ley2004
	gen interaccion2= Tra*Ley2005
	gen interaccion3= Tra*Ley2007

	
	*Reg 1998 a 2000
		* El objetivo de estas regresiones sería analizar las correlaciones entre observables y separación
	reg sepa hombre i.mm P* rama* i.ant1 i.edgrupos if mes>199801 & mes<200001
	outreg2 using Tabla1998.doc 
	reg sepa hombre i.mes P* rama* i.ant1 i.edgrupos if mes>199801 & mes<200001 
	reg sepa i.Antiguedad
	reg sepa i.mes if mes>199701 & mes<201511 
	reg sepa i.anio i.mm if mes>199606 & mes<201511 
	
	
	*LEY 2002/01
		*El objetivo de estas regresiones sería el ver si la separación se redujo después de la introducción de la doble indemnización, controlando por observables. 
	reg sepa T hombre P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301
	reg sepa T hombre i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301
	
	reg sepa T hombre i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	reg sepa T  i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	outreg2 using Tabla2002.doc
	
	probit sepa T i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	outreg2 using Tabla2002-P.doc
	probit sepa T i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	margins , dydx(T) atmeans
	
	
	probit sepa T i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	outreg2 using Tabla2002-L.doc
	logit sepa T i.mm P* rama* i.ant1 i.edgrupos if mes>200101 & mes<200301 & ini>=200001 & ini<200301
	margins , dydx(T) atmeans
	
	
	*Antes del 2004
		* El objetivo es ver si los tratados (con doble indemnización) tienen menos separación qeu los no tratados
	sum i.ant1 Antiguedad if Trat==0 & mes>200202 & mes<200407
	sum i.ant1 Antiguedad if Trat==1 & mes>200202 & mes<200407 
	sum i.ant1 Antiguedad if Trat==1 & mes>200202 & mes<200407 & Antiguedad<=18 
	reg sepa Trat if mes>200202 & mes<200407
	reg sepa Trat i.ant1 if mes>200206 & mes<200407 & Antiguedad<=18
	reg sepa Trat ant3 ant6 ant12 if mes>200206 & mes<200407 
	reg sepa Trat ant3 ant6 ant12 hombre P* rama* i.edgrupos if mes>200206 & mes<200407 
	probit sepa Trat ant3 ant6 ant12 hombre P* rama* i.edgrupos if mes>200206 & mes<200407 
	logit sepa Trat ant3 ant6 ant12 hombre P* rama* i.edgrupos if mes>200206 & mes<200407
	
	
	*LEY 2004/07
		**3 meses posteriores 
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<2004010 
	outreg2 using Tabla2004-3.doc
	
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200410
	outreg2 using Tabla2004-3P.doc 
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200410
	margins , dydx(interaccion1 Trat Ley2004) atmeans
	
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200410
	outreg2 using Tabla2004-3L.doc 
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200410
	margins , dydx(interaccion1 Trat Ley2004) atmeans
	
	
		**6 meses posteriores 
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200501
	outreg2 using Tabla2004-6.doc
	
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200501
	outreg2 using Tabla2004-6P.doc 
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200501
	margins , dydx(interaccion1 Trat Ley2004) atmeans
	
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200501
	outreg2 using Tabla2004-6L.doc
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200501
	margins , dydx(interaccion1 Trat Ley2004) atmeans
	
	
		**12 meses posteriores
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200507 
	outreg2 using Tabla2004-12.doc
	
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200507
	outreg2 using Tabla2004-12P.doc
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200507
	margins , dydx(interaccion1 Trat Ley2004) atmeans
	
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200507
	outreg2 using Tabla2004-12L.doc
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200507
	margins , dydx(interaccion1 Trat Ley2004) atmeans

		**Rango máximo
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200512 
	probit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos if mes>200201 & mes<200512
	logit sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupo if mes>200201 & mes<200512
	
	preserve
	collapse (mean) sepa if mes>200301 & mes<200512, by(mes Trat t) 
	list
	gen dd2 = 0.1 if mes==200407
	label var dd2 "Reducción doble indem"
	sort Trat mes 
	twoway line sepa t if Trat==0 || line sepa t if Trat==1 || dropline dd2 t if mes>200201 & mes<200512 , vertical
	restore
	

	*LEY 2005/12.  
	sum i.ant1 Antiguedad if Trat==0 & mes>200407 & mes<200709
	sum i.ant1 Antiguedad if Trat==1 & mes>200407 & mes<200709
	
		**3 meses posteriores
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200603 
	outreg2 using Tabla2005-3.doc
	
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200603
	outreg2 using Tabla2005-3P.doc
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200603
	margins , dydx(interaccion2 Trat Ley2005) atmeans
	
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200603
	outreg2 using Tabla2005-3L.doc
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200603
	margins , dydx(interaccion2 Trat Ley2005) atmeans
	
		**6 meses posteriores
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200606
	outreg2 using Tabla2005-6.doc
	
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200606
	outreg2 using Tabla2005-6P.doc
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200606
	margins , dydx(interaccion2 Trat Ley2005) atmeans
	
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200606
	outreg2 using Tabla2005-6L.doc
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200606
	margins , dydx(interaccion2 Trat Ley2005) atmeans
	
		**12 meses posteriores
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200612
	outreg2 using Tabla2005-12.doc
	
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200612
	outreg2 using Tabla2005-12P.doc
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200612
	margins , dydx(interaccion2 Trat Ley2005) atmens
	
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200247 & mes<200612
	outreg2 using Tabla2005-12L.doc
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>200247 & mes<200612
	margins , dydx(interaccion2 Trat Ley2005) atmeans
	
		**Rango máximo
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200709
	probit sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos if mes>200407 & mes<200709
	logit sepa Trat Ley2005 interaccion2 hombre P* rama* i.ant1 i.edgrupos if mes>204207 & mes<200709
	
	preserve
	collapse (mean) sepa if mes>200407 & mes<200709, by(mes Trat t) 
	list
	gen dd = 0.1 if mes==2005012
	label var dd "Segunda reducción doble indem"
	sort Trat mes 
	twoway line sepa t if Trat==0 || line sepa t if Trat==1 || dropline dd t if mes>200407 & mes<200709 , vertical
	restore 
	
	*LEY 2007/09.
	replace Trat=0 if mes>200709
	sum i.ant1 Antiguedad if Trat==0 & mes>200512 & mes<200712
	sum i.ant1 Antiguedad if Trat==1 & mes>200512 & mes<200712
	
		**3 meses posteriores
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200712
	outreg2 using Tabla2007-3.doc
	
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200712
	outreg2 using Tabla2007-3P.doc
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200712
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200712
	outreg2 using Tabla2007-3L.doc
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200712
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
		**6 meses posteriores
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200803
	outreg2 using Tabla2007-6.doc
	
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200803
	outreg2 using Tabla2007-6P.doc
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200803
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200803
	outreg2 using Tabla2007-6L.doc
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200803
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
		**12 meses posteriores
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200809
	outreg2 using Tabla2007-12.doc
	
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200809
	outreg2 using Tabla2007-12P.doc
	probit sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200809
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200809
	outreg2 using Tabla2007-12L.doc
	logit sepa Trat Ley2007 interaccion3 hombre P* rama* i.ant1 i.edgrupos if mes>200512 & mes<200809
	margins , dydx(interaccion3 Trat Ley2007) atmeans
	
	preserve
	collapse (mean) sepa if mes>200512 & mes<200809, by(mes Trat t) 
	list
	gen dd4 = 0.04 if mes==200709 
	label var dd4 "fin doble indem"
	sort Trat mes 
	twoway line sepa t if Trat==0 || line sepa t if Trat==1 || dropline dd4 t if mes>200512 & mes<201009 , vertical
	restore


	**ELASTICIDAD**
	
	*LEY 2004/07
		
	****A 3 MESES****
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos Edad2  if mes>200201 & mes<2004010
		*Coef. Interacción =  -.0001843 
	disp -.0001843
		*Promedio de sep 3 meses antes
	disp .0417084
		*Efecto proporcional al cambio
	disp -.0001843/ .0417084
	disp -.00441877
		*Cambio proporcional de la indemnización: pasa de 200 a 180, luego el cambio es:
	disp -20/200 
	disp .1 	
		*Elasticidad: Var de la separación / Var. de la asignación
	disp -.00441877/-.1
	disp .0441877
	
	****A 6 MESES****
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200201 & mes<200501
		*Interaccion: .0043707
	disp .0043707
		*Promedio de sep 3 meses antes 
	disp .0417084
		*Efecto proporcional al cambio
	disp .0043707/ .0417084
	disp .10479184
		*Cambio proporcional de la indemnización: pasa de 200 a 180, luego el cambio es:
	disp -20/200 
	disp -.1 	
		*Elasticidad: Var de la separación / Var. de la asignación
	disp .10479184/-.1
	disp -1.0479184
	
	****12 MESES****
	reg sepa interaccion1 Trat Ley2004 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200201 & mes<200507 
		*Interacción: .0055703 
	disp .0055703 
		*Promedio de sep 3 meses antes 
	disp .0417084
		*Efecto proporcional al cambio
	disp .0055703/.0417084
	disp .13355343
		*Cambio proporcional de la indemnización: pasa de 200 a 180, luego el cambio es:
	disp -20/200 
	disp -.1 	
		*Elasticidad: Var de la separación / Var. de la asignación
	disp .13355343/-.1
	disp -1.3355343

	
	**
	
	*LEY 2005/12
	
	**** 3 MESES ****
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200407 & mes<200603 
		*Interacción: .0096834
	disp .0096834
		*Promedio de sep 3 meses antes
	disp .0246198
		*Efecto proporcional al cambio
	disp .0096834/.0246198
	disp .39331757
		*Cambio proporcional de la indemnización: pasa de 180 a 150, luego el cambio es:
	disp -30/180
	disp -.16666667
		*Elasticidad
	disp .39331757/-.16666667
	disp -2.3599054
	
	**** 6 MESES ****
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200407 & mes<200606
		*Interacción: .0029597
	disp .0029597
		*Promedio de sep 3 meses antes
	disp .0246198
	disp .0029597/.0246198
	disp .12021625
		*Cambio proporcional de la indemnización: pasa de 180 a 150, luego el cambio es:
	disp -30/180
	disp -.16666667
		*Elasticidad
	disp .12021625/-.16666667
	disp -.72129749
	
	**** 12 MESES ****
	reg sepa interaccion2 Trat Ley2005 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200407 & mes<200612
		*Interacción: .0009272
	disp .0009272
		**Promedio de sep 3 meses antes
	disp .0246198
	disp .0009272/.0246198
	disp .03766074
		*Cambio proporcional de la indemnización: pasa de 180 a 150, luego el cambio es:
	disp -30/180
	disp -.16666667
		*Elasticidad
	disp .03766074/-.16666667
	disp -.22596444

		
	**
	
	*LEY 2007/09
	
	**** 3 MESES ****
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200512 & mes<200712
		*Interacción: .0142297
	disp .0142297
		*Promedio de sep 3 meses antes
	disp .0322252
	disp .0142297/.0322252
	disp .44157057
		*Cambio proporcional en la indemnizacion: pasa de 150 a 100, luego el cambio es:
	disp -50/150
	disp -.33333333
		*Elasticidad
	disp .44157057/-.33333333
	disp -1.3247117
	
	**** 6 MESES ****
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200512 & mes<200803
		*Interraccion: .0124398
	disp .0124398
		*Promedio de sep 3 meses antes
	disp .0322252
	disp .0124398/.0322252
	disp .38602708
		*Cambio proporcional en la indemnizacion: pasa de 150 a 100, luego el cambio es:
	disp -50/150
	disp -.33333333
		*Elasticidad
	disp  .38602708/-.33333333
	disp -1.1580813
	
	**** 12 MESES ****
	reg sepa interaccion3 Trat Ley2007 hombre P* rama* i.ant1 i.edgrupos Edad2 if mes>200512 & mes<200803
		*Interraccion: .0036261
	disp .0036261
		*Promedio de sep 3 meses antes
	disp .0322252
	disp .0036261/.0322252
	disp .11252374
		*Cambio proporcional en la indemnizacion: pasa de 150 a 100, luego el cambio es:
	disp -50/150
	disp -.33333333
		*Elasticidad
	disp .11252374/-.33333333
	disp -.33757122
	
	cap log close
	
	
