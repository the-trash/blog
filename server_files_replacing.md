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

**new server:**

> scp ./DB_NAME.sql UserName@MyNewServer.com:/home/USR/PATH/TO/DIR/DB_NAME.sql

> scp ./folder_name.tar UserName@MyNewServer.com:/home/USR/PATH/TO/DIR/folder_name.tar

> mysql -u root -pPASSWORD DATEBASE_NAME < ./DB_NAME.sql


> tar -xvf folder_name.tar


