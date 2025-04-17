**TEA Strategic Compensation Performance Task**

README: TEA Strategic Compensation Performance Task
Project Title:
Evaluating Grant Impact on 3rd–5th Grade Math Performance (SY 2022–2023)

🔍 1. Project Overview
This project analyzes the effectiveness of the Texas Education Agency's (TEA) Strategic Compensation Grant Program in improving math performance among students in grades 3–5. The goal is to assess whether grant-participating districts performed better than non-grant districts in the 2022–2023 STAAR assessments.

Tool Used for Analysis: SAS (data cleaning, analysis)

Tool Used for Visualization: Power BI

Deliverables: Clean dataset, statistical summary, visual dashboards, and narrative report

🧹 2. Data Analysis Summary
🔧 Data Cleaning and Preparation
Imported 3 datasets using PROC IMPORT:
district_staar_22-23.csv, grant_district_list.xlsx, All_districts_info_22-23.xlsx

Filtered records:

Grades 3–5

Subject: Math

Year: 2022–2023

Removed rows with missing or zero values in m_docs or m_all_meetsgl_nm

Created new variable:
➤ percent_meets_math = (m_all_meetsgl_nm / m_docs) * 100

Aggregated to district-level using PROC SQL

Converted numeric district ID to character format (put(district, z6.))

Merged in grant participation and demographic data via district_char

Dropped rows with missing values in key fields

Rounded performance metric to 1 decimal point

Added clear labels to variables
