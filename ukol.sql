

/*
1. Otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */ 

SELECT 
	*
FROM czechia_payroll ;

-- kontrola kolik let se v datech vyskytuje

SELECT 
	DISTINCT cp.payroll_year
FROM czechia_payroll cp
ORDER BY cp.payroll_year ; 


-- dotaz na zobrazení kód odvětví, název odvětví, rok a průměrnou mzdu,
-- sežareno podle roku a kódu

SELECT 
	cpib.code AS branch_code,
	cpib.name AS branch_name,
	cp.payroll_year AS year_wage,
	AVG (cp.value) AS average_wage
FROM czechia_payroll_industry_branch AS cpib
JOIN czechia_payroll AS cp
	ON cp.industry_branch_code = cpib.code 
GROUP BY cp.payroll_year, cpib.code
ORDER BY cp.payroll_year, branch_code ;


-- zobrazení odvětví, kde mzdy v průběhu let rostou

SELECT 
	cpib.code,
	cpib.name,
	cp.payroll_year,
	AVG (cp.value)  
FROM czechia_payroll_industry_branch AS cpib
JOIN czechia_payroll AS cp
	ON cp.industry_branch_code = cpib.code 
ORDER BY payroll_year ASC ;


SELECT 
	branch_code,
	branch_name,
	year_wage,
	ROUND (average_wage)  
FROM t_Nikola_Vitova_project_SQL_primary_final 
ORDER BY branch_code, year_wage ASC ;


-- vytvoření tabulky pro úkol 1 a 2 

CREATE TABLE t_Nikola_Vitova_project_SQL_primary_final
	SELECT 
		cp2.value AS cena_potraviny,
		cp2.category_code AS kategorie_potravin, 
		cp2.date_from AS datum,
		cpc.code AS kod_potraviny,
		cpc.name AS nazev_potraviny, 
		cpc.price_value AS mnozstvi_potraviny,
		cpc.price_unit AS jednotka_potraviny,
		cp.payroll_year AS rok_mzdy,
		cp.value AS mzda
FROM czechia_price AS cp2 
INNER JOIN czechia_payroll AS cp 
	ON YEAR(cp2.date_from) = cp.payroll_year 
INNER JOIN czechia_price_category AS cpc 
	ON cp2.category_code = cpc.code
GROUP BY cp2.value;

-- zobrazení vytvořené tabulky

SELECT 
	*  
FROM t_Nikola_Vitova_project_SQL_primary_final ;




/*

Odpověď: Mzdy ve většině případů každoročně rostou. Největší výkyvy a poklesy byly v těchto letech.

A - 2003, 2011, 2017, 2021
B - 2001, 2007, 2009, 2014,2015, 2018, 2019
C - 2001, 2006, 2009, 2010, 2013, 2019, 
D - 2002, 2003, 2005, 2007, 2011, 2013, 2015, 2017, 2018 
E - 2001, 2007, 2009, 2012, 2013, 2017
F - 2001, 2004, 2005, 2010, 2012, 2013, 2015, 2021
G - 2001, 2003, 2008, 2011, 2014, 2017, 2021
H - 2004, 2008, 2011, 2017, 2019
I - 2008, 2010, 2012, 2014, 2018, 2020
J - 2002, 2004, 2008, 2010, 2013, 2016, 2019
K - 2001, 2008, 2009, 2013, 2014, 2021
L - 2001, 2005, 2008, 2013, 2017, 2020
M - 2010, 2013, 2015, 2017, 2020
N - 2004, 2006, 2009, 2011, 2013, 2014, 2015, 2017
O - 2003, 2005, 2010, 2011, 2015, 2019, 2021
P - 2002, 2005, 2007, 2009, 2012, 2017, 2020
Q - 2005, 2006, 2008, 2010, 2012, 2016
R - 2001, 2004, 2005, 2007, 2011, 2013, 2016, 2017, 2019, 2021
S - 2003, 2006, 2013, 2017, 2020
*/ 

/*
2. Otázka: Kolik je možné si koupit litrů mléka a kilogramů chleba 
za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */

SELECT 
	*
FROM czechia_price ;


SELECT 
	*
FROM czechia_price 
ORDER BY date_from ASC;

-- data od ledna 2006 

SELECT 
	*
FROM czechia_price 
ORDER BY date_from DESC;

-- data do prosince 2018
-- budu srovnávat rok 2006 s rokem 2018

SELECT 
	cp.date_from,
	cp2.payroll_year
FROM czechia_price AS cp
JOIN czechia_payroll AS cp2 ON YEAR (cp.date_from) = cp2.payroll_year
WHERE cp2.payroll_year = 2006 ;


SELECT 
	cp2.value AS cena_potraviny,
	cp2.category_code AS kategorie_potravin, 
	cp2.date_from AS datum,
	cpc.code AS kod_potraviny,
	cpc.name AS nazev_potraviny, 
	cpc.price_value AS mnozstvi_potraviny,
	cpc.price_unit AS jednotka_potraviny,
	cp.payroll_year AS rok_mzdy,
	cp.value AS mzda
FROM czechia_price AS cp2 
INNER JOIN czechia_payroll AS cp 
	ON YEAR(cp2.date_from) = cp.payroll_year 
INNER JOIN czechia_price_category AS cpc 
	ON cp2.category_code = cpc.code
WHERE cpc.code IN ('111301', '114201')
GROUP BY cp2.value, cp2.category_code, cp2.date_from, cpc.code, cpc.name, cpc.price_value, cpc.price_unit, cp.payroll_year, cp.value
HAVING AVG(cpc.price_value) > 0 ;


-- dva výpočty kolik l mléka a kg chleba si mohli lidé koupit za rok 2006 a 2018

SELECT 
	cpc.code AS kod_potraviny,
	cpc.name AS nazev_potraviny,
	ROUND(AVG(cp2.value)) AS prumerna_cena,
	ROUND(AVG(cp.value)) AS prumerna_mzda,
	ROUND(AVG(cp.value) / AVG(cp2.value)) AS prumerny_pocet
FROM czechia_price AS cp2 
INNER JOIN czechia_payroll AS cp 
	ON YEAR(cp2.date_from) = cp.payroll_year 
INNER JOIN czechia_price_category AS cpc 
	ON cp2.category_code = cpc.code
WHERE cpc.code IN ('111301', '114201') AND cp.payroll_year IN (2006)
GROUP BY cpc.code, cpc.name 
HAVING AVG(cp.value / cp2.value) IS NOT NULL ;

-- Odpověď: V roce 2006 si mohli lidé koupit 1.176 kg chleba a 1.313 litrů mléka 

SELECT 
	cpc.code AS kod_potraviny,
	cpc.name AS nazev_potraviny,
	ROUND(AVG(cp2.value)) AS prumerna_cena,
	ROUND(AVG(cp.value)) AS prumerna_mzda,
	ROUND(AVG(cp.value) / AVG(cp2.value)) AS prumerny_pocet
FROM czechia_price AS cp2 
INNER JOIN czechia_payroll AS cp 
	ON YEAR(cp2.date_from) = cp.payroll_year 
INNER JOIN czechia_price_category AS cpc 
	ON cp2.category_code = cpc.code
WHERE cpc.code IN ('111301', '114201') AND cp.payroll_year IN (2018)
GROUP BY cpc.code, cpc.name 
HAVING AVG(cp.value / cp2.value) IS NOT NULL ;

-- Odpověď: V roce 2018 si mohli lidé koupit 1.233 kg chleba a 1.508 litrů mléka

/*
3. Otázka: Která kategorie potravin zdražuje nejpomaleji
(je u ní nejnižší percentuální meziroční nárůst)?
*/

SELECT 
	cp2.value,
	cpc.name AS potravina,
       ((MAX(cp2.value) - MIN(cp2.value)) / MIN(cp2.value)) * 100 AS Procentualni_Zdrazovani
FROM czechia_price AS cp2 
INNER JOIN czechia_price_category AS cpc 
	ON cp2.category_code = cpc.code
GROUP BY potravina
ORDER BY Procentualni_Zdrazovani ASC;

-- Odpověď, nejpomaleji zdražuje Vepřová pečeně s kostí

/*
4. Otázka: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
(je u ní nejnižší percentuální meziroční nárůst)?
*/

SELECT 
	cpc.name,
	cp2.value,
	cp.payroll_year,
	cp.value,
	AVG(cp2.value) AS average_value,
	AVG(cp.value) AS average_payroll
	-- ROUND(average_value, 2)
	-- cpc.price_value,
	-- LAG(cp2.value) OVER 
	-- (PARTITION BY cp2.category_code ORDER BY 'YEAR') AS lag_value
	-- COUNT(cp2.value - LAG(cp2.value) OVER (PARTITION BY cp2.category_code ORDER BY cp.payroll_year)) AS diff
	FROM czechia_price cp2
	JOIN czechia_payroll AS cp 
		ON YEAR(cp2.date_from) = cp.payroll_year 
	INNER JOIN czechia_price_category AS cpc 
		ON cp2.category_code = cpc.code	
	WHERE 1=1
	GROUP BY cp2.category_code, cp.payroll_year ASC ;


SELECT 
	cp2.category_code,
	cp2.value,
	cp.payroll_year,
	cp.value
	LAG(cp2.value) OVER 
	(PARTITION BY cp2.category_code ORDER BY 'YEAR') AS lag_value
	lag_value
	-- cp2.value - lag_value AS diff
	-- COUNT (cp2.value - lag_value) AS diff
	(cp2.value - lag_value)/cp2.value  AS growth_perc
FROM czechia_price cp2
	JOIN czechia_payroll AS cp 
		ON YEAR(cp2.date_from) = cp.payroll_year 
	INNER JOIN czechia_price_category AS cpc 
		ON cp2.category_code = cpc.code ;

	
SELECT 
	cp2.category_code,
	cp2.value,
	cp.payroll_year,
	cp.value
	LAG(cp2.value) OVER 
	(PARTITION BY cp2.category_code ORDER BY 'YEAR') AS lag_value
	lag_value
	cp2.value - lag_value AS diff
	(cp2.value - lag_value)/cp2.value  AS growth_perc
FROM czechia_price cp2
	JOIN czechia_payroll AS cp 
		ON YEAR(cp2.date_from) = cp.payroll_year 
	INNER JOIN czechia_price_category AS cpc 
		ON cp2.category_code = cpc.code 
	WHERE 1=1
	GROUP BY cp2.category_code, cp.payroll_year DESC ;


/*
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/

CREATE TABLE t_Nikola_Vitova_project_SQL_secondary_final
	SELECT 
		ec.country AS stat,
		ec.GDP AS HDP, 
		ec.year AS rok,
		ec.gini AS gini_koef,
		co.population AS populace
FROM economies AS ec
	INNER JOIN countries AS co ON ec.country = co.country 
GROUP BY ec.country;

-- zobrazení vytvořené tabulky

SELECT 
	*  
FROM t_Nikola_Vitova_project_SQL_secondary_final ; 

-- seřazení dat 

SELECT 
	HDP,
	stat
FROM t_Nikola_Vitova_project_SQL_secondary_final 
ORDER BY HDP DESC;

-- dotaz k 5 úkolu
		
SELECT 
    stat = 'Czech Republic',
    HDP,
    rok,
    AVG(t2.cena_potraviny) AS PrumernaCenaPotravin,
    AVG(t2.Mzda) AS PrumernaMzda,
    t1.HDP  AS HDP_Hodnota
FROM 
    t_Nikola_Vitova_project_SQL_secondary_final AS t1
INNER JOIN t_Nikola_Vitova_project_SQL_primary_final AS t2 ON YEAR(t1.rok) = t2.rok_mzdy 
GROUP BY 
    YEAR(t1.rok), t1.HDP
ORDER BY 
    YYEAR(t1.rok) ;
    
   