FROM alpine:3.18.5

ARG	DB_NAME \
	DB_USER \
	DB_PASS \
	DB_ROOT

# Install MariaDB
RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client

# Creating a dir to store runtime info such as daemon PID, tmp files or sockets
RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
# Changing Docker configuration
    { echo '[mysqld]'; \
        # It tells not to cache hostnames to improve performance when hostnames are frequently changing
      echo 'skip-host-cache'; \
        # Avoids DNS and it only trust connections from certain IPs
      echo 'skip-name-resolve'; \
        # Allow to listen for any external network connection
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
# Setting Skip-networking to false in order to listen TCP/IP connections in mariadb
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh

# Switch to myqsl user in order to execute following commands
USER mysql
CMD ["/usr/bin/mysqld", "--skip-log-error"]
