
drop procedure p3.cust_crt@
drop procedure p3.fetchID@
drop procedure p3.fetchNum@
drop procedure p3.cust_login@
drop procedure p3.ACCT_OPN@
drop procedure p3.ACCT_CLS@
drop procedure p3.ACCT_DEP@
drop procedure p3.ACCT_WTH@
drop procedure p3.ACCT_TRX@
drop procedure p3.ADD_INTEREST@

--
-- procedure that fetch ID for customer create
--
CREATE PROCEDURE p3.fetchID
(IN Name_input varchar(15), IN Gender_input char, IN Age_input int, IN Pin_input int, OUT ID int)
LANGUAGE SQL
  BEGIN
    declare c1 cursor for select id from p3.CUSTOMER
    where name = name_input AND gender = Gender_input AND age = age_input AND pin = p3.encrypt(Pin_input);
    open c1;
    fetch c1 into ID;
    close c1;
END @

--
-- procedure that fetch account number for account created
--
CREATE PROCEDURE p3.fetchNum
(IN id_input int, IN balance_input int, IN type_input char, OUT number int)
LANGUAGE SQL
  BEGIN
    declare c1 cursor for select number from p3.ACCOUNT
    where id = id_input AND balance = balance_input AND type = type_input;
    open c1;
    fetch c1 into number;
    close c1;
END @

--
-- creating customer
--
CREATE PROCEDURE p3.CUST_CRT
(IN Name_input varchar(15), IN Gender_input char, IN Age_input int, IN Pin_input int, OUT ID int, OUT sql_code int, OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN 
    DECLARE id_input int;
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
      SET sql_code = SQLCODE, err_msg = 'input error';
    IF (age_input < 0 OR age_input > 100) THEN
      SET err_msg = 'Invalid age error';
    ELSEIF (pin_input < 0 OR pin_input > 9999) THEN
      SET err_msg = 'Invalid pin error';
    ELSE
  	 INSERT INTO P3.CUSTOMER(Name, Gender, Age, Pin) VALUES(Name_input, Gender_input, Age_input, p3.encrypt(Pin_input));
      set id_input = -1;
      CALL p3.fetchID(name_input, gender_input, age_input, pin_input, id_input);
      set ID = id_input;
    END IF;
END @

--
-- customer login
--
CREATE PROCEDURE p3.CUST_LOGIN
(IN Id_input int, IN pin_input int, out valid int, out sql_code int, out err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE VAR INT;
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE c_name cursor for select id from p3.CUSTOMER
    where id = Id_input AND p3.decrypt(pin) = pin_input;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE, err_msg = 'error', valid = 0;
     SET sql_code = SQLCODE;
    open c_name;
    FETCH c_name into VAR;
    IF (sql_code = '000') THEN
      SET valid = 1;
    ELSE
      SET valid = 0, err_msg ='fail to authenticate';
      close c_name;
    END IF;
END @

--
-- open an account
--
CREATE PROCEDURE p3.ACCT_OPN
(IN id_input int, IN balance_input int, IN type_input char, OUT number int, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE status_input char;
    DECLARE number_output int;
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE,err_msg = 'input error';
    set status_input = 'A';
    IF (balance_input < 0 ) THEN
      set err_msg = 'Invalid balance';
    ELSEIF ( type_input != 'C' AND type_input != 'S') THEN
      set err_msg = 'Invalid account type';
    ELSE
      INSERT INTO P3.ACCOUNT(ID, BALANCE, TYPE, STATUS) VALUES(id_input, balance_input, type_input, status_input);
    END IF;
    CALL p3.fetchNum(id_input, balance_input, type_input, number_output);
    set number = number_output;
END @

--
-- close an account
--
CREATE PROCEDURE p3.ACCT_CLS
(IN number_input int, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
    SET sql_code = SQLCODE, err_msg = 'ID does not exist';
    UPDATE P3.ACCOUNT SET balance = 0, status = 'I' where number = number_input;
END @

--
-- deposit money
--
CREATE PROCEDURE p3.ACCT_DEP
(IN number_input int, IN amount_input int, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE money int;
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE c1 CURSOR FOR SELECT BALANCE FROM P3.ACCOUNT
      WHERE Number = number_input;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE, err_msg = 'Invalid input';
    OPEN c1;
    FETCH c1 into money;
    CLOSE c1;
    IF (amount_input < 0) THEN
      SET err_msg = 'Negative balance';
    ELSE
      SET money = money + amount_input;
      UPDATE P3.ACCOUNT SET balance = money WHERE number = number_input;
    END IF;
END @

--
-- withdraw money
--
CREATE PROCEDURE p3.ACCT_WTH
(IN number_input int, IN amount_input int, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE money int;
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE c1 CURSOR FOR SELECT BALANCE FROM P3.ACCOUNT
      WHERE Number = number_input;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE, err_msg = 'invalid input';
    OPEN c1;
    FETCH c1 into money;
    CLOSE c1;
    SET money = money - amount_input;
    IF ( amount_input < 0 ) THEN
      set err_msg = 'Negative balance';
    ELSEIF ( money < 0 ) THEN
      set err_msg = 'Overdrawn.';
    ELSE
      UPDATE P3.ACCOUNT SET balance = money WHERE number = number_input;
    END IF;
END @

--
-- transfer money
--
CREATE PROCEDURE p3.ACCT_TRX
(IN src_acct int, IN dest_acct int, IN amount_input int, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE, err_msg = 'input error';
    CALL p3.ACCT_DEP(dest_acct, amount_input, sql_code, err_msg);
    CALL p3.ACCT_WTH(src_acct, amount_input, sql_code, err_msg);
END @

--
-- add interest
--
CREATE PROCEDURE p3.ADD_INTEREST
(IN savin float, IN checkin float, OUT sql_code int , OUT err_msg varchar(30))
LANGUAGE SQL
  BEGIN
    DECLARE SQLCODE INTEGER DEFAULT 0;
    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET sql_code = SQLCODE;
    IF ( savin > 1.0 OR savin < 0.0) THEN
      set err_msg = 'Invalid saving rate';
    ELSEIF ( checkin > 1.0 OR checkin < 0.0) THEN
      set err_msg = 'Invalid checking rate';
    ELSE
      UPDATE P3.ACCOUNT SET balance = balance + (balance * savin) WHERE type = 'S';
      UPDATE P3.ACCOUNT SET balance = balance + (balance * checkin) WHERE type = 'C';
    END IF;
END @

