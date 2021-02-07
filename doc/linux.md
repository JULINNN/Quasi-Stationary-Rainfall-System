# Linux Tutorial

#### Useful Learning Resources
- [UNIX Tutorial for Beginners](http://www.ee.surrey.ac.uk/Teaching/Unix/)
- [鳥哥的 Linux 私房菜
](https://linux.vbird.org)
#### Basic Linux Command

##### ls
```shell
# list the file
ls -[option]
option : 
  a : all file
  l : long list
  h : with humand readable size
```

##### cd
```shell
# change directory
# change to last directory
cd .. 

# change to home directory
cd ~  

# change to root directory
cd /  

# /work1/summer change to summer directory
cd /work1/summer
```

##### mkdir, rmdir
```Shell
# Create Folder
mkdir #folderName

# delete Folder
rmdir #folderName
```

##### cpm m,
```shell
# Copy
cp -[option] #source #destination
option :
  r : recursive copy

# copy demo.txt to /work1/summer folder
cp demo.txt /work1/summer

# rename, move
mv #source #destination

# move demo.txt to /work1/summer folder
mv demo.txt /work1/summer
```

##### rm
```shell
# Remove
rm -[option] #fileName or folderName
option :
 r : recursive remove
 f : force remove
 i : interactive 
```

##### chmod
```shell
# Change authorization
chmod 
```

##### scp
```shell
# secure copy, remote copy
scp
```

##### ssh
```shell
ssh
```

