CONNECT to CS157a;

-- create customer
CALL P3.CUST_CRT('FIRSTM', 'M', 21, 1111, ?,?,?);
CALL P3.CUST_CRT('SECONDM', 'M', 22, 2222, ?,?,?);
CALL P3.CUST_CRT('THIRDM', 'M', 23, 3333, ?,?,?);
CALL P3.CUST_CRT('FIRSTF', 'F', 24, 4444, ?,?,?);
CALL P3.CUST_CRT('SECONDF', 'F', 25, 5555, ?,?,?);
CALL P3.CUST_CRT('THIRDF', 'F', 26, 6666, ?,?,?);
-- create invalid customer
CALL P3.CUST_CRT('TEST1', 'G', 21, 1111, ?,?,?);
CALL P3.CUST_CRT('TEST2', 'M', ab, 2222, ?,?,?);
CALL P3.CUST_CRT('TEST3', 'F', 23, aaaa, ?,?,?);
CALL P3.CUST_CRT('TEST4', 'F', -45, 4444, ?,?,?);
CALL P3.CUST_CRT('TEST5', 'F', -45, -2123, ?,?,?);

-- customer login
CALL P3.CUST_LOGIN(100, 1111, ?,?,?);
CALL P3.CUST_LOGIN(103, 4444, ?,?,?);
--customer login error cases
CALL P3.CUST_LOGIN(102, 1111, ?,?,?);
CALL P3.CUST_LOGIN(999, 9999, ?,?,?);

-- open account
CALL P3.ACCT_OPN(100, 100, 'C',?,?,?);
CALL P3.ACCT_OPN(100, 200, 'S',?,?,?);
CALL P3.ACCT_OPN(101, 300, 'C',?,?,?);
CALL P3.ACCT_OPN(101, 400, 'S',?,?,?);
CALL P3.ACCT_OPN(102, 500, 'C',?,?,?);
CALL P3.ACCT_OPN(102, 600, 'S',?,?,?);
CALL P3.ACCT_OPN(103, 700, 'C',?,?,?);
CALL P3.ACCT_OPN(104, 800, 'S',?,?,?);
CALL P3.ACCT_OPN(105, 900, 'C',?,?,?);

-- open with invalid id
CALL P3.ACCT_OPN(999, 500, 'C',?,?,?);
-- invalid balance
CALL P3.ACCT_OPN(100, -100, 'C',?,?,?);
-- invalid type
CALL P3.ACCT_OPN(100, 100, 'R',?,?,?);

-- close account
CALL P3.ACCT_CLS(1004,?,?);
SELECT NUMBER, BALANCE, STATUS FROM P3.ACCOUNT WHERE NUMBER = 1004;
CALL P3.ACCT_CLS(1005,?,?);
SELECT NUMBER, BALANCE, STATUS FROM P3.ACCOUNT WHERE NUMBER = 1005;
-- cloase invalid account
CALL P3.ACCT_CLS(9999,?,?);

--deposit into account 
CALL P3.ACCT_DEP(1000, 33, ?,?);
-- deposit into invalid account
CALL P3.ACCT_DEP(9999, 44, ?,?);
--deposit with negative balance
CALL P3.ACCT_DEP(1001, -44, ?,?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1001, 1004);

-- withdraw from account
CALL P3.ACCT_WTH(1000, 22, ?, ?);
-- over drawn
CALL P3.ACCT_WTH(1002, 2000, ?, ?);
-- negative balance
CALL P3.ACCT_WTH(1003, -88, ?, ?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1002);

UPDATE p3.account set Balance = 100 where number = 1000;
UPDATE p3.account set Balance = 200 where number = 1001;
UPDATE p3.account set Balance = 300 where number = 1002;
UPDATE p3.account set Balance = 400 where number = 1003;

--transfeer to another account
CALL P3.ACCT_TRX(1003, 1002, 66, ?,?);
--differnt customer
CALL P3.ACCT_TRX(1005, 1000, 99, ?,?);
SELECT NUMBER, BALANCE FROM p3.account where NUMBER IN(1000, 1002, 1003, 1005);

UPDATE p3.account set Balance = 100 where number = 1000;
UPDATE p3.account set Balance = 200 where number = 1001;
UPDATE p3.account set Balance = 300 where number = 1002;
UPDATE p3.account set Balance = 400 where number = 1003;
UPDATE p3.account set Balance = 500 where number = 1004;
UPDATE p3.account set Balance = 600 where number = 1005;

--interest
SELECT NUMBER, BALANCE FROM p3.account;
CALL P3.ADD_INTEREST (0.5, 0.1,?,?);
SELECT NUMBER, BALANCE FROM p3.account;
-- invalid interest rate
CALL P3.ADD_INTEREST (1.5, 0.1,?,?);
CALL P3.ADD_INTEREST (0.5, -5.0,?,?);
