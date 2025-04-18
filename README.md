# 📊 TEA Strategic Compensation Grant Program Analysis

## 1. **Project Overview**
This project analyzes the effectiveness of the **Texas Education Agency's (TEA) Strategic Compensation Grant Program** in improving math performance among students in **grades 3 through 5**.

**🎯 Key Objective:**  
Determine whether grant-receiving districts outperformed non-participating districts in the **2022–2023 STAAR assessments**.

**🛠 Tools Used:**  
- **SAS**: Data cleaning, transformation, statistical analysis, and Data Visualization
- **Power BI**: Visualizations and interactive dashboards  
- **Narrative Report**: Full documentation of methodology and findings  

🗂 **Primary Files**:  
- `district_staar_22-23.csv` – STAAR performance data  
- `grant_district_list.xlsx` – Grant participation list  
- `All_districts_info_22-23.xlsx` – District demographics  
- `Final_Analysis_Cleaned.csv` – Final dataset for visuals  
- `TEA_Narrative_Analysis.pdf` – Full narrative analysis  
- `Power BI Dashboard.pbix` – Power BI dashboard  
- `TEA_SAS_Code.sas` – Reproducible SAS code  
- `district_staar_22-23_dictionary.xlsx` – Variable reference dictionary  

---

## 2. **Data Analysis Summary**

### **🧼 Data Cleaning and Preparation**
- Imported three datasets using `PROC IMPORT`:
  - **STAAR scores** (`district_staar_22-23.csv`)
  - **Grant list** (`grant_district_list.xlsx`)
  - **District demographics** (`All_districts_info_22-23.xlsx`)

- Key cleaning/transformation steps:
  - Filtered to **grades 3–5 math scores (2022–2023)**
  - Excluded records with missing/0 values in `m_docs`, `m_all_meetsgl_nm`
  - Created:  
    ```sas
    percent_meets_math = (m_all_meetsgl_nm / m_docs) * 100;
    ```
  - Aggregated to district level using `PROC SQL`
  - Standardized `district` ID as `district_char` using `put(district, z6.)`
  - Merged with grant and demographic data
  - Dropped incomplete records
  - Rounded `avg_percent_meets` to **1 decimal**
  - Labeled fields for clarity

### **📊 Statistical Analysis**
- Conducted **two-sample t-test**:
  - 🟩 **Non-grant districts scored 3.4 percentage points higher**
  - 📉 p-value < 0.01 → **statistically significant**
- Verified assumptions:
  - **Histograms and Q-Q plots** confirm normality
- Descriptive statistics via `PROC MEANS` showed:
  - Avg performance: Grant = 37.5%, Non-Grant = 40.9%
  - Higher std dev among non-grant districts

---

## 3. **Data Communication & Visualizations**

### **📌 SAS Visuals (from TEA_SAS_Code.sas)**
- 📊 **Histogram** – `avg_percent_meets` across all districts  
- 📦 **Boxplot** – Grant vs. Non-grant performance  
- 📈 **Bar Chart** – Mean performance by grant status  
- 📋 **PROC MEANS Table** – Summary statistics  

### **📊 Power BI Dashboard** (`Power BI Dashboard.pbix`)
- **KPI Cards** – Grant: 37.5%, Non-Grant: 40.9%, Difference: +3.4%
- **Pie Chart** – Distribution across performance bands:
  - High ≥ 60%
  - Medium: 40–59%
  - Low: < 40%
- **Line Chart** – Avg performance by ESC Region
- **Interactive Table** – View by district, demographics, grant flag
- **Slicer Filters** – ESC Region, District Type
- **Icons & Tooltips** – Enhance user navigation and explanations

📥 Visuals Created in Power BI Dashboard: Power BI Dashboard.pbix

---

## 4. **📁 File Inventory**

| File Name                               | Description                                                                 |
|----------------------------------------|-----------------------------------------------------------------------------|
| `district_staar_22-23.csv`             | Raw STAAR performance (math/reading by grade and district)                 |
| `grant_district_list.xlsx`             | Districts receiving TEA grant funding                                      |
| `All_districts_info_22-23.xlsx`        | Demographic data (economically disadvantaged, emergent bilingual)         |
| `Final_Analysis_Cleaned.csv`           | Final cleaned dataset for visuals                                          |
| `TEA_Narrative_Analysis.pdf`           | Full narrative analysis (includes visuals + findings)                      |
| `Power BI Dashboard.pbix`            | Power BI dashboard (interactive)                                           |
| `district_staar_22-23_dictionary.xlsx` | Data dictionary for variable references                                    |
| `TEA_SAS_Code.sas`                     | Complete SAS script (import, transform, analyze, export)                  |

---

## 5. **⚙️ Reproduction Instructions**

### 🔷 In SAS (`TEA_SAS_Code.sas`):
1. Import files: `district_staar_22-23.csv`, `grant_district_list.xlsx`, `All_districts_info_22-23.xlsx`
2. Filter for 3rd–5th grade math records
3. Create `% Meets` metric → `percent_meets_math`
4. Aggregate district averages with `PROC SQL`
5. Convert district ID to `district_char` format
6. Merge grant list and demographics
7. Drop missing records
8. Run:
   - `PROC TTEST`  
   - `PROC MEANS`  
   - SAS Visuals: `PROC SGPLOT`  
9. Export final dataset: `Final_Analysis_Cleaned.csv`

### 🔶 In Power BI (`Power BI Dashboard.pbix`):
1. Import `Final_Analysis_Cleaned.csv`
2. Create DAX measures for:
   - Avg % Meets (Grant/Non-Grant)
   - Difference
3. Build visuals:
   - KPI Cards
   - Pie Chart (Performance Bands)
   - Line Chart (ESC Region)
   - Table with slicers
4. Add tooltips, conditional formatting, slicers for interactivity

---

## 6. **✅ Best Practices Demonstrated**

| Category                | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| 🧱 **Modular Coding**     | SAS code separated by steps: import, transform, merge, analyze              |
| 🧾 **Documentation**     | Inline comments, variable labels, labeled Power BI fields                  |
| 📈 **Statistical Analysis** | Use of t-test, distribution checks, descriptive stats                    |
| 🧠 **Insight Communication** | Visual + narrative alignment in both SAS & Power BI                     |
| 🤝 **Collaboration-Ready** | Structured outputs, organized file names, README & Narrative files         |

---

### Additional Regression Analysis (Accuracy Check)
To validate our findings and adjust for potential confounders, we ran a **Multiple Linear Regression (MLR)** model with:

- Grant Participation (binary)
- Percent Economically Disadvantaged
- Percent Emergent Bilingual

🔍 **Findings**:
- **Grant status** was **not statistically significant** after adjusting for demographics.
- **Percent Economically Disadvantaged** was highly significant (p < 0.0001).
- R-squared ≈ **0.30**, suggesting good model fit for education data.

---

## ✅ Conclusion

This project provides a comprehensive evaluation of TEA’s Strategic Compensation Grant using SAS and Power BI. While initial t-tests indicated that non-grant districts performed better in 3rd–5th grade STAAR math outcomes, further regression analysis suggested that this performance gap may be more strongly associated with socioeconomic factors particularly economic disadvantage than with grant participation itself.

📌 These findings reinforce the importance of **contextual program evaluation**, and the need to control for demographic factors when interpreting the effectiveness of education policy initiatives.

- Interpretation: Differences in performance may be more driven by socioeconomic factors than grant participation itself.


> 📌 *For detailed analysis, visual explanation, and documentation of methodology, please refer to* `TEA_Narrative_Analysis.pdf`.

---
