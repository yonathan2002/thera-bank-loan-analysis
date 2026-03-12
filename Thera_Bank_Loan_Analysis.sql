-- ================================================
-- Thera Bank Personal Loan Campaign Analysis
-- Analyst: Yonathan Garcia
-- Date: March 2026
-- Description: Analyzing customer segments to identify
-- high conversion targets for personal loan campaign
-- ================================================

/*
Business Goal:
The bank ran a personal loan campaign last year and achieved a 9% conversion rate.
Leadership wants to double that rate without increasing the budget.
This analysis identifies which customer segments are most likely to accept a personal loan
so the bank can target them more effectively in the next campaign.

Queries:
1. Overall conversion rate
2. Loan acceptance by income group
3. Loan acceptance by education level
4. Loan acceptance by family size
5. Average income and CC spending — accepted vs did not accept
6. CD Account holders — do they accept loans more?
*/


-- ================================================
-- 1. Overall Conversion Rate
-- ================================================

SELECT 
    SUM(CAST(Personal_Loan AS INT)) AS Total_People_With_Loan,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Personal_Loan AS INT)) * 100.0 / COUNT(*) AS Conversion_Rate
FROM dbo.Bank_Loans AS a

/*
FINDING:
480 out of 5000 customers accepted the loan = 9.6% conversion rate.
This is the baseline we are trying to beat.
*/


-- ================================================
-- 2. Loan Acceptance by Income Group
-- ================================================

SELECT
    CASE 
        WHEN Income < 60 THEN 'Low (under 60k)'
        WHEN Income BETWEEN 60 AND 120 THEN 'Medium (60k-120k)'
        ELSE 'High (above 120k)'
    END AS Income_Group,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Personal_Loan AS INT)) AS Accepted_Loan,
    SUM(CAST(Personal_Loan AS INT)) * 100.0 / COUNT(*) AS Conversion_Rate
FROM dbo.Bank_Loans AS a
GROUP BY  
    CASE 
        WHEN Income < 60 THEN 'Low (under 60k)'
        WHEN Income BETWEEN 60 AND 120 THEN 'Medium (60k-120k)'
        ELSE 'High (above 120k)'
    END

/*
FINDING:
- High income (120k+):     41.9% conversion
- Medium income (60-120k):  6.3% conversion
- Low income (under 60k):   0.0% conversion

Low income customers accepted zero loans.
High income customers convert at almost 42% — nearly 6x the overall average.
Focus the campaign on high income customers only.
*/


-- ================================================
-- 3. Loan Acceptance by Education Level
-- ================================================

SELECT 
    CASE
        WHEN Education = 1 THEN 'Undergraduate'
        WHEN Education = 2 THEN 'Graduate' 
        ELSE 'Advanced'
    END AS Education,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Personal_Loan AS INT)) AS Accepted_Loan,
    SUM(CAST(Personal_Loan AS INT)) * 100.0 / COUNT(*) AS Conversion_Rate
FROM dbo.Bank_Loans AS a
GROUP BY
    CASE
        WHEN Education = 1 THEN 'Undergraduate'
        WHEN Education = 2 THEN 'Graduate' 
        ELSE 'Advanced'
    END 

/*
FINDING:
- Advanced degree: 13.7% conversion
- Graduate degree: 13.0% conversion
- Undergraduate:    4.4% conversion

Graduate and Advanced customers convert 3x more than undergraduates.
Target higher educated customers.
*/


-- ================================================
-- 4. Loan Acceptance by Family Size
-- ================================================

SELECT 
    CASE
        WHEN Family = 1 THEN 'Single (1)'
        WHEN Family = 2 THEN 'Couple (2)'
        WHEN Family = 3 THEN 'Three (3)'
        ELSE 'Four (4)'
    END AS Family_Group,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Personal_Loan AS INT)) AS Accepted_Loan,
    SUM(CAST(Personal_Loan AS INT)) * 100.0 / COUNT(*) AS Conversion_Rate
FROM dbo.Bank_Loans AS a
GROUP BY
    CASE
        WHEN Family = 1 THEN 'Single (1)'
        WHEN Family = 2 THEN 'Couple (2)'
        WHEN Family = 3 THEN 'Three (3)'
        ELSE 'Four (4)'
    END

/*
FINDING:
- Family of 3: 13.2% conversion
- Family of 4: 11.0% conversion
- Couple:       8.2% conversion
- Single:       7.3% conversion

Bigger families convert more — likely because they have more expenses and need loans more.
Target families of 3 or more.
*/


-- ================================================
-- 5. Financial Profile — Accepted vs Did Not Accept
-- ================================================

SELECT 
    CASE
        WHEN Personal_Loan = 0 THEN 'Did Not Accept'
        ELSE 'Accepted Loan'
    END AS Loan_Decision,
    COUNT(*) AS Total_Customers,
    AVG(Income) AS Avg_Annual_Income,
    AVG(CCAvg) AS Avg_Monthly_CC_Spending
FROM dbo.Bank_Loans AS a
GROUP BY
    CASE
        WHEN Personal_Loan = 0 THEN 'Did Not Accept'
        ELSE 'Accepted Loan'
    END

/*
FINDING:
- Accepted:        Avg income $144k | Avg CC spending $3,905/month
- Did Not Accept:  Avg income $66k  | Avg CC spending $1,729/month

Customers who said yes earn 2x more and spend 2x more on credit cards.
High income + high CC spending = strong loan candidate.
*/


-- ================================================
-- 6. CD Account Holders — Do They Accept Loans More?
-- ================================================

SELECT 
    CASE
        WHEN CD_Account = 0 THEN 'No CD Account'
        ELSE 'Has CD Account'
    END AS CD_Account_Status,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Personal_Loan AS INT)) AS Accepted_Loan,
    SUM(CAST(Personal_Loan AS INT)) * 100.0 / COUNT(*) AS Conversion_Rate
FROM dbo.Bank_Loans AS a
GROUP BY
    CASE
        WHEN CD_Account = 0 THEN 'No CD Account'
        ELSE 'Has CD Account'
    END

/*
FINDING:
- Has CD Account:  46.4% conversion
- No CD Account:    7.2% conversion

CD account holders are 6x more likely to accept a loan.
They already trust the bank — easiest group to convert.
Make this the #1 target group for the next campaign.
*/


-- ================================================
-- SUMMARY
-- ================================================

/*
Ideal target customer for next campaign:
- Income:      above 120k
- Education:   Graduate or Advanced degree
- Family size: 3 or more
- CD Account:  Yes

These customers convert at 40-46% vs the current 9.6% overall average.
Same budget, smarter targeting = doubled conversion rate.
*/