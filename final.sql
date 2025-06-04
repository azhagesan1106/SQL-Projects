use ecomm;

select * from customer_churn;
-- MEAN
select round(avg(WarehouseToHome)) as Mean_WarehouseToHome from customer_churn;
select round(avg(HourSpendOnApp)) as Mean_HourSpendOnApp from customer_churn;
select round(avg(OrderAmountHikeFromlastYear)) as Mean_OrderAmountHikeFromlastYear from customer_churn;
select round(avg(DaySinceLastOrder)) as Mean_DaySinceLastOrder from customer_churn;

-- MODE
 select Tenure from customer_churn WHERE Tenure is not null group by Tenure order by count(*) desc limit 1 ;
 select CouponUsed from customer_churn WHERE CouponUsed is not null group by CouponUsed order by count(*) desc limit 1 ;
 select OrderCount from customer_churn WHERE OrderCount is not null group by OrderCount order by count(*) desc limit 1 ;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn 
SET PreferredLoginDevice = REPLACE(PreferredLoginDevice , 'Phone', 'Mobile Phone') 
WHERE PreferredLoginDevice LIKE ('Phone');

UPDATE customer_churn
SET PreferedOrderCat = REPLACE(PreferedOrderCat, 'Mobile', 'Mobile Phone')
WHERE PreferedOrderCat LIKE 'Mobile';

UPDATE customer_churn
SET PreferredPaymentMode = CASE
    WHEN PreferredPaymentMode = 'COD' THEN 'Cash on Delivery'
    WHEN PreferredPaymentMode = 'CC' THEN 'Credit Card'
    ELSE PreferredPaymentMode
END;

ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;
alter table employees
add column Salary_Status varchar(30);
ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);

UPDATE customer_churn
SET ComplaintReceived = CASE
    WHEN Complain = 1 THEN 'Yes'
    ELSE 'No'
END;

ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR (10);

UPDATE customer_churn
SET ChurnStatus = CASE
	WHEN Churn = 1 THEN 'Churned'
    ELSE 'Active'
END;

ALTER TABLE customer_churn
DROP COLUMN Churn ;

ALTER TABLE customer_churn
DROP COLUMN Complain ;

SELECT COUNT(ChurnStatus) As count_Churn from customer_churn where ChurnStatus = 'Active';

SELECT AVG(tenure) AS Avg_tenure , SUM(CashbackAmount) AS Total_caseback FROM customer_churn WHERE ChurnStatus = 'Churned';

SELECT (COUNT(ChurnStatus) / COUNT(*)) * 100 AS  PercentageComplained 
	FROM customer_churn WHERE ChurnStatus = 'Churned' ;

SELECT Gender, COUNT(*) AS CountOfComplaints FROM customer_churn WHERE ComplaintReceived = 'Yes'  GROUP BY Gender;

SELECT CityTier, COUNT(*) AS ChurnedCustomerCount 
	FROM  customer_churn 
		WHERE ChurnStatus = 'Churned' and PreferredOrderCat = 'Laptop & Accessory' 
			GROUP BY CityTier
				ORDER BY ChurnedCustomerCount DESC LIMIT 1;
                
SELECT PreferredPaymentMode , COUNT(*) AS PaymentModeCount 
	FROM customer_churn
		WHERE ChurnStatus = 'Active'
			GROUP BY PreferredPaymentMode
				ORDER BY PaymentModeCount DESC LIMIT 1;
                
SELECT OrderAmountHikeFromlastYear, PreferredOrderCat, SUM(OrderAmountHikeFromlastYear) AS SinglOrderCount 
	FROM customer_churn 
		WHERE PreferredOrderCat = 'Mobile Phones' AND  MaritalStatus = 'Single'
			GROUP BY OrderAmountHikeFromlastYear
				ORDER BY SinglOrderCount DESC LIMIT 0 ; 
                
SELECT AVG(NumberOfDeviceRegistered) AS CustomerAvgPaymentMode  
			FROM customer_churn
				WHERE PreferredPaymentMode = 'UPI';
					
SELECT CityTier , COUNT(*) AS CustomerCount
	FROM customer_churn
		GROUP BY CityTier
			ORDER BY CustomerCount DESC LIMIT 1;

SELECT COUNT(*) AS TotalOrderCount
	FROM customer_churn
		WHERE PreferredPaymentMode = 'Credit Card' 
			AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

SELECT Gender, SUM(CouponUsed) AS TotalCouponsUsed
	FROM customer_churn
		GROUP BY Gender
			ORDER BY TotalCouponsUsed DESC LIMIT 1;
		
SELECT PreferredPaymentMode, MAX(HoursSpentOnApp)
	FROM customer_churn
		GROUP BY PreferredPaymentMode;

SELECT COUNT(*) AS TotalCustomers
	FROM customer_churn
		WHERE HoursSpentOnApp = 1 AND
			DaySinceLastOrder = 5;

SELECT AVG(ComplaintReceived) AS AverageSatisfaction
	FROM customer_churn
		WHERE ComplaintReceived = 'Yes';

SELECT PreferredOrderCat, COUNT(*) AS CustomerCount
	FROM customer_churn
		WHERE CouponUsed > 5
		GROUP BY PreferredOrderCat;
        
SELECT PreferredOrderCat, AVG(CashbackAmount) AS AverageCashback
	FROM customer_churn
		GROUP BY PreferredOrderCat
			ORDER BY AverageCashback DESC LIMIT 3;

SELECT PreferredPaymentMode, COUNT(*) AS CustomerCount
	FROM customer_churn
		WHERE Tenure = 10 AND		
			OrderCount > 500
				GROUP BY PreferredPaymentMode;

SELECT *,ChurnStatus,
	CASE	
		WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
	END AS Distance_Category
FROM customer_churn;

SELECT AVG(OrderCount) AS AverageOrderCount
	FROM  customer_churn 
		WHERE MaritalStatus = 'Married'
		AND CityTier = 1;
        
CREATE TABLE customer_returns (
ReturnID INT,
CustomerID INT,
ReturnDate DATE,
RefundAmount DECIMAL(10,2)
);

INSERT INTO customer_returns VALUES
	(1001, 50022, '2023-01-01', 2130),
	(1002, 50316, '2023-01-23', 2000),
	(1003, 51099, '2023-02-14', 2290),
	(1004, 52321, '2023-03-08', 2510),
	(1005, 52928, '2023-03-20', 3000),
	(1006, 53749, '2023-04-17', 1740),
	(1007, 54206, '2023-04-21', 3250),
	(1008, 54838, '2023-04-30', 1990);
    
SELECT 
    C.CustomerID,C.ChurnStatus,C.ComplaintReceived,R.ReturnID,R.ReturnDate
FROM customer_churn C
JOIN 
    customer_returns R ON C.CustomerID = R.CustomerID
WHERE 
    C.ChurnStatus = 'Churned'
ORDER BY 
    C.CustomerID, R.ReturnDate;

SELECT * FROM customer_returns;
SELECT * FROM customer_churn;
 
 