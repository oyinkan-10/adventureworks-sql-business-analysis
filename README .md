# AdventureWorks SQL Business Analysis

## Project overview

This project uses SQL to investigate business performance in the AdventureWorks database. It explores sales revenue, customer behaviour, sales territories, inventory, suppliers, purchasing quality, and workforce information.

The analysis consists of 15 business questions answered with MySQL queries.

## Objectives

- Identify products and subcategories contributing most to sales.
- Examine customer spending and order frequency.
- Compare revenue across territories and salespeople.
- Identify inactive store accounts and inventory risks.
- Assess vendor availability and delivery lead times.
- Review workforce distribution, pay rates, and internal mobility.
- Identify products with above-average purchase rejection rates.

## Tools and techniques

- MySQL
- MySQL Workbench
- INNER JOIN and LEFT JOIN
- Subqueries and correlated subqueries
- Aggregations: SUM, AVG, COUNT
- GROUP BY and HAVING
- EXISTS / NOT EXISTS
- CASE expressions
- Sorting and filtering

## Business questions

1. Which five product subcategories generated the most sales revenue after discounts?
2. Which products generated more sales revenue than the average revenue per product sold?
3. Which products marked for sale have never appeared in a sales order?
4. Which customers spent more than the average customer's total spending?
5. Which customers placed at least five orders, and what was their total spending?
6. Which sales territories generated the most revenue, and how many customers placed orders in each?
7. Which salespeople generated more revenue than the average salesperson?
8. Which stores have customer accounts but no recorded sales orders?
9. Which products have total inventory below their reorder point?
10. Which products can be purchased from more than one vendor?
11. Which vendors have an average delivery lead time above the average across all product-vendor records?
12. Which departments currently have the most employees?
13. Which current employees earn an hourly rate above their department's average?
14. Which current employees have changed departments at least once?
15. Which products have a higher rejection rate than the overall rejection rate on received purchase orders?

## Selected findings

The findings below are based on query outputs recorded during the project.

### Sales and customers

- Road Bikes was the highest-revenue product subcategory at **43,909,437.51**, followed by Mountain Bikes at **36,445,443.94**.
- The highest-revenue products in the above-average product group were Mountain-200 variants.
- The analysis identified **28 products** marked for sale with no recorded sales order activity.
- The above-average customer spending query returned **1,927 customers**.
- The highest order frequency in the at-least-five-orders analysis was **28 orders**.
- The Southwest territory led the territory comparison with revenue of **27,150,594.59** and **4,565** ordering customers.
- Seven salespeople generated revenue above the average salesperson revenue. Linda Mitchell led this group at **11,695,019.06**.

### Stores, inventory, and suppliers

- The store-account analysis returned **701 stores** with customer accounts but no recorded sales orders.
- Seven products had inventory below their reorder points. Four of those products had zero inventory.
- **145 products** were linked to more than one vendor: 43 had three vendors and 102 had two.
- Six vendors had average lead times above the overall product-vendor average. Fitness Association had the highest average lead time at **55 days**.

### Workforce

- Production had the largest current workforce, with **179 employees**, followed by Sales with **18**.
- The above-department-average pay analysis identified employees across multiple departments. Ken Sánchez had the highest hourly rate in the returned results at **125.50**.
- Five current employees had worked in more than one department. Sheela Word had worked in three departments.

### Purchasing quality

- Metal Sheet 1 had the highest rejection rate in the returned above-average list at **9.36%**, followed by Paint - Black at **8.19%**.
- LL Crankarm had **3,102 rejected units** and a rejection rate of **6.69%**.

## Methodology and metric notes

- **Q1 revenue:** Uses `Sales_SalesOrderDetail.LineTotal`, which reflects line-level discounts and excludes tax and freight.
- **Order/customer spending and territory revenue:** Uses `Sales_SalesOrderHeader.TotalDue`.
- **Q13 pay rate:** Uses each employee's most recent recorded rate in `HumanResources_EmployeePayHistory`.
- **Q14 department history:** Counts distinct departments across an employee's history, while retaining employees with a current department assignment.
- **Q15 rejection rate:** Calculated as:

  `RejectedQty / (ReceivedQty + RejectedQty) * 100`

  This measures rejected units as a share of total received plus rejected units.

## Repository contents

- `AdventureWorks_SQL_Analysis.sql`  all 15 SQL queries.
- `README.md`  project description, business questions, selected findings, and methodology notes.

## How to use

1. Load the AdventureWorks database into MySQL.
2. Open `AdventureWorks_SQL_Analysis.sql` in MySQL Workbench.
3. Confirm that the table names match your imported schema.
4. Execute each query separately to review its result set.
5. Use the findings in this README as a summary of the analysis.

## Limitations

The analysis reflects the records available in the supplied AdventureWorks database. A lack of recorded sales does not necessarily prove that a product or store has no market demand. Likewise, above-average rejection rates identify products for further supplier and quality investigation; they do not establish the cause of rejection.

## Author

**Oyinkansola**

SQL Portfolio Project | MySQL | AdventureWorks
