## Making Backups with RMAN
> 备份数据库在归档模式下在open或mount状态
> 备份数据库在非归档模式下在mount状态

### Backup Sets and Image Copies
### RMAN Backup Modes
### Types of Files That RMAN Can Back Up
### RMAN Backup Destinations
### 7-1. Specifying Backup Options
```bash
# 备份整个数据库
RMAN > backup database;
```
#### Specifying Channels
> allocate channel 如果备份至 DISK 不需要手工分配通道， 如果备份至 TAPE 需要手工分配一个通道
```bash
run{
   allocate channel c1 device type sbt;
   backup database;
}
```

#### Specifying the Output Device Type
> device type 定义备份文件的类型
```bash
RMAN> backup device type sbt database;
```
#### Specifying Image Copy or Backup Set Output

#### 7-10. Performing Incremental Backups
##### Differential Incremental Backups
> RMAN first looks for a level 1 backup and, in its absence, looks for a level 0 backup and backs up all changes since that level 0 backup.
```bash
RMAN> backup incremental level 0 database;
```
> Incremental level 0 backups can be made as image copies or backup sets
```bash
RMAN> backup incremental level 1 database;
```
> 只备份 level 0 以来所有的进行修改过后的数据


#####


#### 7-11. Reducing Incremental Backup Time



#### 7-12. Creating Multiple Backup Sets

#### 7-13. Making Copies of Backup Sets

#### 7-14. Making Copies of Image Copy Backups

#### 7-15. Making Tape Copies of Disk-Based Image Copies

#### 7-16. Excluding a Tablespace from a Backup

#### 7-18. Encrypting RMAN Backups


#### 7-19. Making a Compressed Backup


#### 7-20. Parallelizing Backups

#### 7-21. Making Faster Backups of Large Files


#### 7-22. Specifying Backup Windows

#### 7-23. Reusing RMAN Backup Files


#### 7-25. Backing Up Only Those Files Previously Not Backed Up


#### 7-26. Restarting Backups After a Crash
>  not backed up since time
> 如果没有since time子句，那么 RMAN 只备份那些从来没有备份过的文件
```bash

```


#### 7-27. Updating Image Copies
>  backup ... for recover of copy  进行增量备份
```bash
run{
   recover copy of database with tag 'incr_update';
   backup incremental level 1 for recover pf copy with tag 'incr_update'
   database;
}
```




## Maintaining RMAN Backups and the Repository
### 8-1. Adding User-Made Backups to the Repository


## Scripting RMAN
### Approaches to Scripting
#### Command File
```bash
rman target / << EOF
   rman commands come here
   more rman commands
EOF
```

> 可以创建普通的 RMAN 脚本，调用RMAN脚本可以放一个 @ 符号在执行的脚本之前
```bash
RMAN>@cmd.rman
```
> rman 脚本的后缀并没有限制
#### The cmdfile Option
> 使用 cmdfile 参数调用rman脚本
```bash
rman target=/ catalog=u/p@catalog cmdfile cmd.rman

rman target=/ catalog=u/p@catalog cmdfile=cmd.rman

rman target=/ catalog=u/p@catalog @cmd.rman
```
#### Stored Scripts
```bash
RMAN> run { execute script stored_script; }
```
#### Stored Scripts on the Command Line
```bash
rman target=/ catalog=u/p@catalog script stored_script
```
### 9-1. Developing a Unix Shell Script for RMAN
```bash
# Beginning of Script
# Start of Configurable Section
export ORACLE_HOME=/opt/oracle/10.2/db_1
export ORACLE_SID=PRODB1
export TOOLHOME=/opt/oracle/tools
export BACKUP_MEDIA=DISK
export BACKUP_TYPE=FULL_DB_BKUP
export MAXPIECESIZE=16G
# End of Configurable Section
# Start of site specific parameters
export BACK_MOUNTPOINT=/oraback
export DBAEMAIL="dba@proligence.com"
export DBAPAGER="dba.ops@proligence.com"
export LOG_SERVER=prolin2
export LOG_USER=oracle
export LOG_DIR=/dbalogs
export CATALOG_CONN=${ORACLE_SID}/${ORACLE_SID}@catalog
# End of site specific parameters

export LOG_PREFIX=${BACK_MOUNTPOINT}/loc
export TMPDIR=/tmp
export NLS_DATE_FORMAT="MM/DD/YY HH24:MI:SS"
export TIMESTAMP=`date +%T-%m-%d-%Y`
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib:/lib
export LIBPATH=${ORACLE_HOME}/lib:/usr/lib:/lib
export SHLIB_PATH=${ORACLE_HOME}/lib:/usr/lib:/lib
export LOG=${TOOLHOME}/log
LOG=${LOG}/log/${ORACLE_SID}_${BACKUP_TYPE}_${BACKUP_MEDIA}_${TIMESTAMP}.log
export TMPLOG=$TOOLHOME/log/tmplog.$$
echo `date` "Starting $BACKUP_TYPE Backup of $ORACLE_SID to $BACKUP_MEDIA" > $LOG
export LOCKFILE=$TOOLHOME/${ORACLE_SID}_${BACKUP_TYPE}_${BACKUP_MEDIA}.lock
if [ -f $LOCKFILE ]
then
   echo `date` "Script running. Exiting ..." >> $LOG
else
   echo "Do NOT delete this file. Used for RMAN locking" > $LOCKFILE
   $ORACLE_HOME/bin/rman log=$TMPLOG <<EOF
connect target /
connect catalog $CATALOG_CONN
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '${ORACLE_HOME}/dbs/SNAPSHOT_${ORACLE_SID}_${TIMESTAMP}_CTL';
run {
   allocate channel c1 type disk
   format '${LOC_PREFIX}1/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c2 type disk
   format '${LOC_PREFIX}2/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c3 type disk
   format '${LOC_PREFIX}3/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c4 type disk
   format '${LOC_PREFIX}4/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c5 type disk
   format '${LOC_PREFIX}5/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c6 type disk
   format '${LOC_PREFIX}6/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c7 type disk
   format '${LOC_PREFIX}7/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   allocate channel c8 type disk
   format '${LOC_PREFIX}8/${ORACLE_SID}_${BACKUP_TYPE}_${TIMESTAMP}_%p_%s.rman' maxpiecesize ${MAXPIECESIZE};
   backup
   incremental level 0
   tag = 'LVL0_DB_BKP'
   database
   include current controlfile;
   release channel c1;
   release channel c2;
   release channel c3;
   release channel c4;
   release channel c5;
   release channel c6;
   release channel c7;
   release channel c8;
   allocate channel d2 type disk format '${LOC_PREFIX}8/CTLBKP_${ORACLE_SID}_${TIMESTAMP}.CTL';
   backup current controlfile;
   release channel d2;
}
exit
EOF
   RC=$?
   cat $TMPLOG >> $LOG
   rm $LOCKFILE
   echo `date` "Script lock file removed" >> $LOG
   if [ $RC -ne "0" ]
   then
      mailx -s "RMAN $BACKUP_TYPE $ORACLE_SID $BACKUP_MEDIA Failed" $DBAEMAIL,$DBAPAGER < $LOG
   else
      cp $LOG ${LOC_PREFIX}1
      mailx -s "RMAN $BACKUP_TYPE $ORACLE_SID $BACKUP_MEDIA Successful" $DBAEMAIL < $LOG
   if

   scp $LOG ${LOG_USER}@${LOG_SERVER}:${LOG_DIR}/${ORACLE_SID}/
   rm $TMPLOG
fi
```
### 9-2. Scheduling a Unix Shell File
```bash
<minute> <hour> <date> <month> <weekday> <program>
```
#### Direct Editing of Crontab
> 直接修改脚本
```bash
# 修改脚本
crontab -e

# 查看脚本
crontab -l
```
#### Updating Crontab
> 更新脚本清单

#### Examples of Crontab Schedules
