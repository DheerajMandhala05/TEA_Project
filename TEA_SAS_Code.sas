/* =============================================
   TEA Strategic Compensation Task - SAS Script
   Author: Dheeraj
   ============================================= */

/* =======================
   STEP 1: Import Datasets
   ======================= */
proc import datafile="/home/u63048832/TEA Task/district_staar_22-23.csv"
    out=work.staar 
    dbms=csv 
    replace;
    getnames=yes;
run;

proc import datafile="/home/u63048832/TEA Task/grant_district_list.xlsx"
    out=work.grant_list 
    dbms=xlsx 
    replace;
    getnames=yes;
run;

proc import datafile="/home/u63048832/TEA Task/All_districts_info_22-23.xlsx"
    out=work.district_info 
    dbms=xlsx 
    replace;
    getnames=yes;
run;

/* Inspect structure of the imported datasets */
proc contents data=work.staar; run;
proc contents data=work.grant_list; run;
proc contents data=work.district_info; run;


/* ========================
   STEP 2: Clean STAAR Data
   ======================== */
data work.staar_math_clean;
    set work.staar;
    /* Filter to 2022–23 Math scores for grades 3 to 5, exclude missing or invalid counts */
    where year = 23 and GRADE in (3, 4, 5) and 
    not missing(m_docs) and m_docs > 0 and not missing(m_all_meetsgl_nm);
	
    /* Calculate % Meets Grade Level or better in Math */
    percent_meets_math = (m_all_meetsgl_nm / m_docs) * 100;
    /* Convert district ID to character data type for proper joining */
    length district_char $6; 
    district_char = put(district, z6.);
run;

proc print data=work.staar_math_clean (obs=10); run;


/* ==============================
   STEP 3: Aggregate by District
   ============================== */
proc sql;
    create table work.math_avg_by_district as
    select district_char as district,
           mean(percent_meets_math) as avg_percent_meets
    from work.staar_math_clean
    group by district_char;
quit;

proc print data=work.math_avg_by_district (obs=10); run;


/* ==========================================
   STEP 4: Flag Grant Participation Status
   ========================================== */
proc sort data=work.math_avg_by_district; by district; run;
proc sort data=work.grant_list; by District; run;

/* Merge to flag districts that participated in the grant */
data work.math_grant_flagged;
    merge work.math_avg_by_district(in=a rename=(district=district_char))
          work.grant_list(in=b rename=(District=district_char));
    by district_char;
    grant_participant = b;
run;

proc freq data=work.math_grant_flagged;
    tables grant_participant;
run;

proc print data=work.math_grant_flagged (obs=10); run;


/* =====================================
   STEP 5: Join With District Info File
   ===================================== */
proc sort data=work.math_grant_flagged; by district_char; run;
proc sort data=work.district_info; by District; run;

/* Prepare district info for merge */
data work.district_info_clean;
    set work.district_info;
    rename District = district_char;
run;

/* Merge grant + STAAR results with district characteristics */
data work.math_final;
    merge work.math_grant_flagged(in=a)
          work.district_info_clean(in=b);
    by district_char;
    if a; /* keep only districts with STAAR results */
run;

proc print data=work.math_final (obs=10); run;
proc contents data=work.math_final; run;


/* =========================
   STEP 6: Clean Final Data
   ========================= */
data work.math_final_clean;
    set work.math_final;
    if missing(avg_percent_meets) then delete;
    if missing('Percent Economically Disadvantag'n) 
        or missing('Percent Emergent Bilingual'n) then delete;
    avg_percent_meets = round(avg_percent_meets, 0.1);
    /* Round the average % Meets to 1 decimal place */

    label
        avg_percent_meets = "Average % Meets Grade Level"
        grant_participant = "Grant Participant Flag"
        'Percent Economically Disadvantag'n = "Economically Disadvantaged (%)"
        'Percent Emergent Bilingual'n = "Emergent Bilingual (%)";
run;

proc print data=work.math_final_clean (obs=10); run;
proc freq data=work.math_final_clean; tables grant_participant; run;



/* ===============================
   STEP 7: T-Test Statistical Comparison
   =============================== */
proc ttest data=work.math_final_clean;
    class grant_participant;
    var avg_percent_meets;
    title 'T-Test: Math % Meets Grade Level - Grant vs Non-Grant Districts';
run;


/* ===============================
   STEP 8: Boxplot Visualization
   =============================== */
proc sgplot data=work.math_final_clean;
    vbox avg_percent_meets / category=grant_participant;
    title "Boxplot: Math % Meets by Grant Participation";
    title2 "Grades 3–5 STAAR Math Results, SY 2022–23";
    xaxis label="Grant Participation (0 = No, 1 = Yes)";
    yaxis label="Average % Meets Grade Level";
run;


/* ===============================
   STEP 9: Summary Table (Extra Insight)
   =============================== */
proc means data=work.math_final_clean mean std n maxdec=1;
    class grant_participant;
    var avg_percent_meets;
    title "Summary Stats: Math % Meets by Grant Participation";
    title2 "Grades 3–5 STAAR Math Results, SY 2022–23";
run;


/* ADDITIONAL VISUALIZATIONS to find key insights to make proper decisions 
-- Histogram of avg_percent_meets
Shows the overall distribution of math performance across all districts.*/

proc sgplot data=work.math_final_clean;
    histogram avg_percent_meets / binwidth=5;
    density avg_percent_meets / type=normal;
    title "Distribution of Avg % Meets Across All Districts";
    title2 "Grades 3–5 STAAR Math Results, SY 2022–23";
    xaxis label="Average % Meets Grade Level";
    yaxis label="Number of Districts";
run;

/*
--> Most districts have an average math performance between 30% and 50%.
--> A few districts are doing exceptionally well, with performance above 60%, but they are in the minority.
--> Some districts are significantly underperforming, scoring below 20%, which pulls the overall distribution slightly to the left.
--> The performance results are spread out, showing a wide gap between the highest and lowest performing districts.-
--> Overall, district math scores form a pattern that's close to a bell curve, but it's not perfectly even — more districts are performing just below average than above.
*/

/*  SIDE BY SIDE BAR PLOT: Mean Performance by Grant Status
This is a great complement to the T-Test: */

proc sgplot data=work.math_final_clean;
    vbar grant_participant / response=avg_percent_meets stat=mean datalabel;
    title "Mean Math % Meets by Grant Participation";
    title2 "Grades 3–5 STAAR Math Results, SY 2022–23";
    xaxis display=(nolabel) values=(0 1) valuesdisplay=("Non-Grant" "Grant");
    yaxis label="Average % Meets";
run;
/*Key findings from the above plot:
--> Non-grant districts have a higher average math performance than grant districts.
--> The bar for non-grant districts is around 41%, while grant districts are closer to 38%.
--> This matches the earlier T-Test results, which showed a statistically significant difference in performance.
--> The chart clearly communicates that, on average, grant-funded districts 
performed slightly lower in terms of 3rd–5th grade math outcomes in 2022–23. */

/*EXPORTING FINAL CLEANED DATASETS */

proc export data=work.math_final_clean
    outfile="/home/u63048832/TEA Task/Final_Analysis_Cleaned.csv"
    dbms=csv
    replace;
run;

/*
Key Takeaways:
1. We selected 'm_all_meetsgl_nm' as the performance metric
   because it represents students who Met Grade Level or better —
   a standard benchmark used to evaluate student proficiency.

2. The analysis included only grades 3–5 in Math for 2022–2023,
   as per the scenario instruction.

3. The cleaned, merged dataset (math_final_clean) enables
   district-level comparison between grant and non-grant participants.
*/
