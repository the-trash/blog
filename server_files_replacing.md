#### Tar and save file on local machine

**server:**

Files

> /usr/bin/tar -cf folder_name.tar ./folder_name

> pwd # => /home/USR/PATH/TO/DIR

Database

> mysqldump -u root -pPASSWORD DB_NAME --complete-insert > DB_NAME.sql

**client:**

> scp root@69.100.12.43:/home/USR/PATH/TO/DIR/folder_name.tar .

> scp root@69.100.12.43:/home/USR/PATH/TO/DIR/DB_NAME.sql .

