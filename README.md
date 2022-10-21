# Backup Shell script

#### Overview : 
Shell script that checks a certain directory and if it was
updated, it copies the new version named by current date to a backup directory
specified by the user.
*************************************************************************
#### Inputs :
1. Source directory : It is the directory that the shell script will backup.
2. Backup directory : The folder that will contain the copies.
3. Time in Secs : Time interval between each check.
4. Max number of backups : The max number of recent copies saved in the backup directory.
************************************************************************
#### Procedures : 

##### MakeFile : 
1. It checks if the source directory exists, if it does not exist it will not run 
the shell script to avoid errors.
2. It checks if the destination directory exists, if it does not exist it will make it.
3. It runs the shell script 


##### Shell Script :
1. It takes the inputs passed by the user.
2. decalring the needed variables : current date and counter.
3. creating directory-info.last to save the last modification time of each file
 in the source directory
4. copying the first version of the source files to the backup directory.
5. infinite loop to check if there is anyy updates in the source file : 
by creating directory-info.new of the last modification time of source files then 
comparing it to directory-info.last, if they are not equal then it will update
the directory-info.last and copies a new version to the backup directory.
6. It checks the number of backups if it exceeded the maximum number specified ,
it will delete the oldest backup.

****************************************************************************
#### User Manual : 
1. open the cmd.
2. change directory to the directory containing the shell script and makefile.
3. write the following command : 
make SRC="source-file" DEST="backup-directory" SECS="sleep-time" MAX="max-number-of-backups"

