# PeoplePulse: Proactive Workforce Intelligence 🚀

An interactive HR analytics solution designed to detect early signs of disengagement, attrition risk, and performance bottlenecks. 📊

---
## Table of Contents 📑

1. [Project Overview](#project-overview)
2. [Business Problem](#business-problem)
3. [Data Source](#data-source)
4. [Tools & Technologies Used](#tools-technologies-used)
5. [Approach: From Raw Data to Workforce Intelligence](#approach-from-raw-data-to-workforce-intelligence)
    - [Data Validation & Cleansing](#data-validation-cleansing)
    - [Data Preparation in Power Query Editor](#data-preparation-in-power-query-editor)
    - [DAX Modelling for Strategic HR KPIs](#dax-modelling-for-strategic-hr-kpis)
6. [Dashboard Design & Visualization Strategy](#dashboard-design-visualization-strategy)
    - [Workforce Pulse – Early Warning System](#workforce-pulse--early-warning-system)
    - [Attrition Lab – Deep Dive Insights](#attrition-lab--deep-dive-insights)
7. [Key Insights](#key-insights)
    - [Workforce Pulse – Early Warning System](#workforce-pulse--early-warning-system-1)
    - [Attrition Lab – Deep Dive Insights](#attrition-lab--deep-dive-insights-1)
8. [Recommendations](#recommendations)
9. [Conclusion](#conclusion)


---

## Project Overview 🧑‍💼

In today’s fast-paced business environment, HR teams face increasing pressure to address challenges such as employee disengagement, burnout, and high turnover. These issues are often compounded by fragmented workforce data, hindering HR’s ability to intervene proactively.

**PeoplePulse** tackles these challenges by providing an interactive, data-driven solution built in **Power BI**, supported by data validation and architecture in **MySQL**. This project empowers HR teams to monitor and address employee disengagement and turnover risks, turning complex HR data into actionable insights. 📊

The project consists of two expert-level dashboards:
1.	**Workforce Pulse – Early Warning System**: Monitors employee engagement and productivity, flagging early signs of burnout, performance dips, and disengagement.⚠️
2.	**Attrition Lab – Deep Dive Insights**: Analyses resignation trends and uncovers the root causes of turnover, guiding HR teams to improve retention strategies.🔍

---

## Business Problem ❓

The HR department is facing challenges in identifying early signs of employee disengagement, potential attrition risk, and performance bottlenecks due to a lack of unified visibility across workforce demographics, satisfaction, workload, training, and compensation. As a result, HR teams struggle to take proactive measures before issues escalate.

---

## Data Source 📂

The project utilizes a publicly available **HR dataset** from Kaggle, featuring 100,000 employee records. This dataset mirrors real-world corporate environments and includes the following attributes:

| Category                | Fields                                                                 |
|-------------------------|------------------------------------------------------------------------|
| **Demographics**         | Employee ID, Gender, Age, Education Level                              |
| **Job Details**          | Department, Job Title, Hire Date, Tenure                              |
| **Performance & Productivity** | Performance Score, Projects Handled, Training Hours, Sick Days     |
| **Work Conditions**      | Monthly Salary, Work Hours/Week, Overtime Hours, Remote Work Frequency, Team Size |
| **Satisfaction & Retention** | Employee Satisfaction Score, Promotions, Resigned Status           |

---

## Tools & Technologies Used 🛠️

| Tool/Technology          | Purpose                                                                 |
|--------------------------|------------------------------------------------------------------------|
| **Microsoft Excel**       | Data exploration and preliminary analysis                               |
| **MySQL**                 | Data validation and integrity verification                             |
| **Power Query Editor**   | Data transformation and column engineering                              |
| **DAX (Data Analysis Expressions)** | Custom metric and KPI development                               |
| **Power BI**             | Data visualization and dashboard creation                               |

---

## Approach: From Raw Data to Workforce Intelligence 🧠

### 1. Data Validation & Cleansing (MySQL + Power BI) 🔍

Ensuring data accuracy is critical for making informed HR decisions. The validation process involved:

- **Record Count Verification**:
    ```sql
    SELECT COUNT(*) AS Source_Record_Count FROM employee;
    ```

- **Duplicate and Null Checks**:
    - **Duplicate Check**:
        ```sql
        SELECT employee_id, COUNT(*) AS cnt FROM employee GROUP BY employee_id HAVING COUNT(*) > 1;
        ```

    - **Null Value Checks**:
        ```sql
        SELECT SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS null_employee_id,
               SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
               SUM(CASE WHEN hire_date IS NULL THEN 1 ELSE 0 END) AS null_hire_date,
               SUM(CASE WHEN years_at_company IS NULL THEN 1 ELSE 0 END) AS null_years_at_company,
               SUM(CASE WHEN monthly_salary IS NULL THEN 1 ELSE 0 END) AS null_monthly_salary,
               SUM(CASE WHEN performance_score IS NULL THEN 1 ELSE 0 END) AS null_performance_score,
               SUM(CASE WHEN employee_satisfaction_score IS NULL THEN 1 ELSE 0 END) AS null_satisfaction,
               SUM(CASE WHEN resigned IS NULL THEN 1 ELSE 0 END) AS null_resigned
        FROM employee;
        ```

- **Business Logic Validation**:
    ```sql
    SELECT Employee_ID, Job_Title, Performance_Score, Monthly_Salary FROM employee
    WHERE Performance_Score <= 2 AND Monthly_Salary > 8000;
    ```

These checks confirmed data integrity with no null values, duplicates, or logical inconsistencies.

---

### 2. Data Preparation in Power Query Editor ⚙️

Data preparation in Power BI involved:

- **Data Type Validation & Correction** for smooth aggregation and time-based calculations.
- **Segmentation for Analytical Clarity** through categories such as:
    - Team Size Banding: Small, Medium, Large, Very Large
    - Remote Work Mode: Onsite, Hybrid, Mostly Remote, Occasionally Remote, Fully Remote
    - Age Groups: 22-29, 30-37, 38-45, 46-53, 54-60
    - Performance Tiers: Low, Average, High

These transformations set the stage for deeper insights into employee performance and attrition.

---

### 3. DAX Modeling for Strategic HR KPIs 📊

Advanced DAX measures were created to turn raw data into actionable insights, including:

- **Burnout Risk**: Flags employees with excessive workload.
    ```DAX
    Burnout Risk=
    CALCULATE(
        COUNTROWS(Employee),
        Employee[Resigned] = FALSE(),
        Employee[Work_Hours_Per_Week] > 50,
        Employee[Overtime_Hours] > 15
    )
    ```

- **Disengagement Risk**: Identifies employees at risk of disengaging.
    ```DAX
    Disengagement Risk=
    CALCULATE(
        COUNTROWS(Employee),
        Employee[Resigned] = FALSE(),
        Employee[Employee_Satisfaction_Score] <= 2.5
    )
    ```

- **Attrition Rate**: Captures the percentage of employees who resigned.
    ```DAX
    Attrition Rate
    DIVIDE(CALCULATE(COUNTROWS('employee'), 'employee'[Resigned] = "Yes"), COUNTROWS('employee'), 0)
    ```

These KPIs enabled real-time tracking of employee engagement and risk levels.

---

## Dashboard Design & Visualization Strategy 🎨

### Insight Mode Selector – Navigation Panel 🔲

An interactive navigation panel allows users to toggle between the two primary dashboards:
- **Workforce Pulse – Early Warning System**
- **Attrition Lab – Deep Dive Insights**

This simple toggle provides HR teams with easy access to the relevant insights.

---

### Workforce Pulse – Early Warning System 📈

This dashboard helps HR teams detect early signs of disengagement, burnout, and underperformance, enabling proactive intervention.

**Key KPIs**:
- Total Active Employees
- Average Satisfaction Score
- Average Performance Score
- Average Training Hours
- Burnout Risk (%)
- Disengagement Rate (%)

**Visualizations**:
- Satisfaction by Department (Bar Chart): Identifies trends in departmental satisfaction and potential risk areas.
- Workload & Overtime by Role & Team (Stacked Column): Detects excessive strain in teams.
- Remote Work Distribution (Pie Chart): Breaks down employee work modes, helping HR understand remote work’s impact on engagement.
- Training Hours by Performance Tier (Column Chart): Correlates training efforts with performance.
- Performance vs. Satisfaction by Age Group (Clustered Column): Age-based trends in morale & output.

---

### Attrition Lab – Deep Dive Insights 🏊‍♂️

This dashboard analyzes resignation patterns, helping HR identify key drivers of attrition.

**Key KPIs**:
- Attrition Count
- Attrition Rate (%)
- Average Tenure of Resigned Employees
- Average Exit Sentiment
- Low Performance Attrition (%)

**Visualizations**:
- Attrition by Gender (Pie Chart): Identifies gender-based trends in attrition.
- Education Level vs. Resignation (Donut Chart): Examines educational background’s impact on resignation.
- Compensation vs. Attrition (Combo Chart): Shows the relationship between compensation and resignation rates.
- Job Role × Performance Attrition Matrix (Table Matrix): Cross-analyses job roles and performance scores against resignation data.
- Tenure vs. Promotions Impact (Stacked Area): Displays the relationship between employee tenure, promotions, and attrition risk.

---

## Key Insights 💡

### Workforce Pulse – Early Warning System 📉

- **Employee Engagement & Disengagement**: 37.5% of employees exhibit signs of low engagement.
- **Burnout Risk**: 15.2% of employees are at risk, particularly in specific departments.
- **Satisfaction Trends**: Departments like Customer Support, Marketing, and Legal report lower satisfaction.
- **Workload Distribution**: Analysts in small teams report the highest work hours and overtime.
- **Remote Work Effect**: Hybrid and remote employees report higher satisfaction levels.
- **Training & Performance**: Minimal correlation between training hours and performance, indicating the need for tailored programs.
- **Age and Performance**: Employees aged 22-29 report the lowest engagement and performance levels.

### Attrition Lab – Deep Dive Insights 🕵️‍♂️

- **Attrition Overview**: A 10% resignation rate, primarily after 4.5 years of tenure.
- **Exit Sentiment**: Neutral exit sentiment suggests lack of emotional connection at departure.
- **Departmental & Role Insights**: High attrition in Developers, Engineers, Technicians, and Consultants in Finance, HR, and Operations.
- **Tenure & Promotions**: Employees with over 10 years at the company without promotion have higher attrition rates.
- **Gender & Age Trends**: Attrition rates are balanced across genders, with increases in mid-to-late career employees.
- **Education & Satisfaction**: Bachelor's degree holders show the highest attrition.

---

## Recommendations 💼

1. **Address Burnout & Workload Imbalance**: Redistribute workloads and offer stress management support.
2. **Target Gender-Specific Engagement**: Tailor engagement strategies to address gender-related differences.
3. **Focus on Low-Performing Departments**: Investigate leadership and environmental issues in departments with low satisfaction.
4. **Support Younger Employees (22-29)**: Offer tailored onboarding, mentorship, and career development.
5. **Promote Remote Work Flexibility**: Expand hybrid and remote work options to enhance satisfaction.
6. **Tailored Training for Low Performers**: Develop specific programs to improve low performers' outcomes.
7. **Enhance Internal Mobility & Career Development**: Implement promotion frameworks and mentorship for long-tenured employees.
8. **Retain High Performers**: Implement performance-linked incentives to retain top talent.
9. **Reassess Roles with High Attrition Despite Remote Options**: Focus on leadership and role clarity for high-turnover positions.
10. **In-Depth Exit Surveys**: Analyze feedback to identify key attrition drivers.
11. **Monitor Pay-Stress Gaps**: Address compensation misalignments in roles with high attrition.

---

## Conclusion 🌟

**PeoplePulse** transforms raw workforce data into strategic intelligence through meticulous data preparation in MySQL and insightful visualizations in Power BI. Tailored DAX measures and rigorously verified aggregations power interactive dashboards that spotlight early signs of disengagement, attrition risk, and underperformance. This end-to-end solution equips HR leaders with timely, actionable insights—enabling proactive decisions that elevate employee well-being and strengthen organizational outcomes. 🧑‍💻

---

Thank you for checking out this project! For more details, feel free to explore the code, dashboards, and insights directly here on GitHub. 🙌

