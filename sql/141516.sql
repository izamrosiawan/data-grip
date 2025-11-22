SELECT c.customerNumber, c.customerName, SUM(p.amount) AS totalPayments
FROM customers c
LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY c.customerNumber;

SELECT customerNumber, customerName
FROM customers
WHERE creditLimit > 50000 OR customerNumber IN (SELECT DISTINCT customerNumber FROM payments);

SELECT DISTINCT p.productCode, p.productName
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.quantityOrdered>20;
