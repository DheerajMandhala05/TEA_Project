# 📊 TEA Strategic Compensation Grant Program Analysis

## 1. **Project Overview**  
This project analyzes the effectiveness of the **Texas Education Agency's (TEA) Strategic Compensation Grant Program** in improving math performance among students in **grades 3 through 5**.  

**Key Objective**:  
Determine whether grant-receiving districts outperformed non-participating districts in the **2022–2023 STAAR assessments**.

**Tools Used**:  
- **SAS**: Data cleaning, transformation, and statistical analysis  
- **Power BI**: Visualizations and interactive dashboards  
- **Narrative Report**: Full documentation of methodology and findings  

---

## 2. **Data Analysis Summary**  

### **Data Cleaning and Preparation**  
- **Datasets Imported** (via `PROC IMPORT`):  
  - STAAR scores  
  - Grant participation list  
  - District demographics  

- **Key Transformations**:  
  - Filtered to **3rd–5th grade math scores (2022–2023)**  
  - Removed records with missing/zero values in `m_docs`, `m_all_meetsgl_nm`  
  - Created `percent_meets_math = (m_all_meetsgl_nm / m_docs) * 100`  
  - Aggregated math performance to district level (`PROC SQL`)  
  - Standardized district IDs (converted to character format)  
  - Merged grant/demographic data using `district_char`  
  - Dropped incomplete records  
  - Rounded performance metric to **1 decimal place**  

### **Statistical Analysis**  
- **Two-sample t-test**:  
  - 🔍 **Key Finding**: Non-grant districts scored **3.4 percentage points higher** on average (*statistically significant*).  
- **Distribution Checks**:  
  - Histograms & Q-Q plots for performance metrics  
- **Summary Statistics**: Generated via `PROC MEANS`  

---

## 3. **Data Communication & Visualizations**  

### **SAS Visuals**  
- 📊 **Histogram**: Average *% Meets Grade Level* (all districts)  
- 📦 **Boxplot**: Grant vs. non-grant performance comparison  
- 📈 **Bar Chart**: Mean performance by grant status (reinforces t-test)  

### **Power BI Dashboard**  
- **KPI Cards**: Group averages and difference  
- **Pie Chart**: District distribution (High/Medium/Low performance)  
- **Line Chart**: Regional variation by *ESC*  
- **Interactive Table**: Slicers for district-level exploration  
- **UI Enhancements**: Icons, tooltips, conditional formatting  

---

## 4. **Data & File Inventory**  

| File Name                          | Description                                                                 |
|------------------------------------|-----------------------------------------------------------------------------|
| `district_staar_22-23.csv`         | Raw STAAR performance data (math/reading by grade/district)                |
| `grant_district_list.xlsx`         | Districts receiving TEA grant funding                                      |
| `All_districts_info_22-23.xlsx`    | Demographic data (e.g., economically disadvantaged %)                      |
| `Final_Analysis_Cleaned.csv`       | Final cleaned dataset for analysis/dashboards                              |
| `TEA_Narrative_Analysis.docx`      | Step-by-step narrative with visuals & findings                             |
| `Tea_Performance_Task_PowerBI.pdf` | Exported Power BI dashboard (PDF)                                          |
| `tea_strategic_analysis.sas`       | *Optional* SAS code for full reproducibility                               |

---

## 5. **Reproduction Instructions**  

### **In SAS**:  
1. Import datasets (`PROC IMPORT`)  
2. Filter to **3rd–5th grade math**, exclude missing/0 values  
3. Create `% Meets` variable → aggregate to district level  
4. Convert district ID to character format  
5. Merge with grant/demographic data  
6. Drop incomplete records  
7. Run **t-test** and summary stats  
8. Generate visuals (histograms, boxplots, bar plots)  
9. Export cleaned dataset  

### **In Power BI**:  
1. Load `Final_Analysis_Cleaned.csv`  
2. Create **DAX measures** for grant/non-grant KPIs  
3. Build visuals:  
   - KPI Cards  
   - Pie Chart (performance bands)  
   - Line Chart (ESC regions)  
   - Interactive Table  
4. Add slicers (*ESC Region*, *District Type*)  
5. Apply conditional formatting/icons  

---

## 6. **Best Practices Demonstrated**  
✔ **Modular SAS Code**: Clear separation of import/transform/analysis steps  
✔ **Documentation**: Inline comments, labeled variables, dashboard tooltips  
✔ **Statistical Rigor**: t-test + visual validation (Q-Q plots, histograms)  
✔ **Collaboration-Ready**: Structured outputs + README for easy reuse  

---

**📌 Note**: For full details, refer to the `TEA_Narrative_Analysis.docx` or SAS code (if provided).  
