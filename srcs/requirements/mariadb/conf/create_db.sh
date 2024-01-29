#!bin/sh

# Initialize and set up a MySQL database for WordPress

# Check if mysql is running

if [ ! -d "/var/lib/mysql/mysql" ]; then

	# Changing the ownership of /var/lib/mysql dir to the user mysql and group mysql
        chown -R mysql:mysql /var/lib/mysql

        # init database
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

	# Creates a temporary file named tfile
        tfile=`mktemp`
        if [ ! -f "$tfile" ]; then
                return 1
        fi
fi


# Check if a wordpress database exists
if [ ! -d "/var/lib/mysql/wordpress" ]; then
	# Create a script with mysql commands to create a wordpress database
	echo -e "\nDB_USER = ${DB_USER}\n DB_NAME = ${DB_NAME}\nDB_PASS = ${DB_PASS}\nDB_ROOT = ${DB_ROOT}\n"
	cat << EOF > /tmp/create_db.sql
# define context for next commands
USE mysql;
# make sure that changes will take  effect immediately thanks to enhancing user privileges
FLUSH PRIVILEGES;
# remove any empty user from mysql.user table
DELETE FROM     mysql.user WHERE User='';
# remove test database, which is created by default
DROP DATABASE test;
# delete entries of mysql.db table related to test database
DELETE FROM mysql.db WHERE Db='test';
# retrict root access to a specific host
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# changes de password for the root user
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
# create a new database 
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
# create a new user, which can be connected from any host
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
# grant all privileges on wordpress database to previously created user
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
# reload priviliges again to apply changes made by GRANT statement
FLUSH PRIVILEGES;
EOF
        # run init.sql in bootstrap mode, which means it will execute a script to config when running
        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
        # removes the tmp script file
        rm -f /tmp/create_db.sql
fi
