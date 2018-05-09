```bash
[root@localhost ~]# ps f -U postgres
   PID TTY      STAT   TIME COMMAND
  4802 ?        Ss     0:00 /usr/pgsql-10/bin/postmaster -D /var/lib/pgsql/10/data/
  4826 ?        Ss     0:00  \_ postgres: logger process
  4849 ?        Ss     0:00  \_ postgres: checkpointer process
  4850 ?        Ss     0:00  \_ postgres: writer process
  4851 ?        Ss     0:00  \_ postgres: wal writer process
  4852 ?        Ss     0:00  \_ postgres: autovacuum launcher process
  4853 ?        Ss     0:00  \_ postgres: stats collector process
  4854 ?        Ss     0:00  \_ postgres: bgworker: logical replication launcher
  ```
  
