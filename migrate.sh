#!/bin/bash

migrateOneRepo() {
	echo "Migrate GIT repo from " $1 " to " $2
	randDir=/tmp/migrate-git-repos/$(openssl rand -hex 8)
	mkdir -p $randDir
	git clone $1 --mirror $randDir
	cd $randDir
	git remote set-url origin $2
	git push
	rm -rf $randDir 
	cd $OLDPWD
	return 0
}

migrateSeveralRepos() {
	cat $1 | while read line           
	do           
	   echo $line 
	   from=$(echo $line | cut -d \| -f1)
	   to=$(echo $line | cut -d \| -f2)
	   migrateOneRepo $from $to
	done
}

if [ $# -eq 1 ] 
then
	migrateSeveralRepos $1
elif [ $# -eq 2 ]
then
	migrateOneRepo $1 $2
else
	echo "Usage: " $0 "file"
	echo "       " $0 "fromUrl toUrl"
fi

