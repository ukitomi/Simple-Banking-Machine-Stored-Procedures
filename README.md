# Simple Banking Machine Stored Procedures
After several practices with Java and embedded C, my class has finally move on to another SQL topic - stored procedures. In the file name p3.sql, it contains all the stored procedures I had previously used in Simple Banking Machine in Java & in embedded C. The test cases are written in a file name called p3test.sql

## Getting Started
The readme will include step-by-step instructions on how to run and test the files.

### Prerequisites
* Any text editor. ![I used Sublime Text 3](https://www.sublimetext.com/3)
* Any functional Database (I used [IBM DB2](https://www.ibm.com/analytics/us/en/db2/trials/))![](https://cdn.discordapp.com/attachments/316348168465809408/387138474920378368/unknown.png)

### Installing
#### Step 1. 
Log into your database application. In there, create an actual database. I named mine CS157A.  ![It looks like this in IBM DB2](https://cdn.discordapp.com/attachments/316348168465809408/387145801740189696/unknown.png)

#### Step 2.
In your database application, access your database terminal. The command line should be given. ![It looks like this in DB2](https://cdn.discordapp.com/attachments/316348168465809408/387361364622180359/unknown.png)

#### Step 3.
In the terminal, open up the text editor. For me, it's VI text editor. [Check here for command instructions](https://www.cs.colostate.edu/helpdocs/vi.html)

#### Step 4.
For VI text editor, the command is 
```
vi
i
ctrl+v (to paste the code)
esc
:save p3.sql
```
Copy and paste the code in p3.sqc under repository to the text editor in the terminal. Save it as **p3.sqc**
Do the same thing for the rest of the files under the repository.

#### Step 5.
At this point, all the files are ready to go for testing.

## Running the tests
```
(Database application name) Connect to <Your database name>
-- create tables and functions
(Database application name) -tvf p3create.clp
-- compile your stored procedures
(Database application name) -td"@" -f p3.clp
-- test all your procedures
(Database application name) -tvf p3test.clp
```
The output should contain a mix of passing and not passing tests.

## Built with
* SQL 

## Author
* ![Yuki Ou](https://github.com/ukitomi)
