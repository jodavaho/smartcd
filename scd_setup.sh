

scd(){
  if [[ $# == 1 ]]; then
    cd $1 
    return;
  fi
  echo "$1/$2"

  if [ -d "$1/$2" ]; then
    echo "Found"
    cd "$1/$2"
    return;
  fi

	ostring="Searching: $1 for ${@:2}"
	lostring=${#ostring}
	echo "$ostring"
	tput cuu1
	#for pdir in `find $1 -maxdepth 3 -type d -path "*/.git" -prune -o -printf "%d\t%P\n" | sort -r -nk1 | cut -f2- `; do
	for pdir in `find $1 -maxdepth 3 -type d -printf "%d\t%P\n" | sort | cut -f2- `; do
		fnd="yes"
		shopt -s nocasematch
		for tomatch in ${@:2}
		do
      #printf "%s vs %s\n" $pdir $tomatch
			if [[ "$pdir" != *$tomatch* ]]
			then
				fnd="no"
				break
			fi
		done
		#if [[ $pdir =~ .*$2.*  && -d "$pdir" ]] 
		#then
		shopt -u nocasematch
		if [[ $fnd == "yes" ]]
		then
			cd "$1/$pdir"
			printf "\r"
			printf "Found: %s" $pdir
			for i in $(seq 1 $lostring)
			do
				printf " "
			done
			printf "\n"
			return;
		fi
	done
	printf "\r"
	printf "Not found!"
	for i in $(seq 1 $lostring)
	do
		printf " "
	done
	printf "\n"
}
gcomp()
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="none"

	#oh cool you are working on something here. Let's dump that guys contents
	if [ -d $prev ];then
		local tt="";
		for pdir in $(ls $prev); do
			tt=$(echo -e "$tt\n${pdir#$prev}")
		done
		COMPREPLY=($(compgen -W "$tt"))
		return
	fi

	#no args? return root's contents
	if [ -z $cur ];then
		COMPREPLY=($(compgen -W "`ls $1`"))
		return
	fi

	#oh you are looking in a specific directory? Then let's return that dir's contents
	if [ -d $cur ];then
		COMPREPLY=($(compgen -W "`ls $cur`"))
		return
	fi

	#oh wait, you want a directory by name from the root. ok, lets return that guys contents
	if [ -d $1/$cur ];then
		local tt=""
		for ent in $(ls $1/$cur); do
			tt=$(echo -e "$tt\n$cur/$ent")
		done
		COMPREPLY=($(compgen -W "$tt"))
		return
	fi
	
	#wait, you want us to look for a keyword? ok, I'll try. First, how many matches are there?
	local numfound=$(find -L $1 -maxdepth 10 -type d | grep -c $cur);
	if (( $numfound > 0 ));then
		#lets just return the shortest one and start from there
		COMPREPLY=($(compgen -W "`find -L $1 -maxdepth 3 -type d -printf "%d\t%P\n" | sort | cut -f2- | grep $cur | sed -e 's/ //g'`/"))
		#COMPREPLY=($(compgen -W "`find -L $1 -maxdepth 3 -type d -printf "%d\t%P\n" | sort | cut -f2- | grep $cur -m 1 | sed -e 's/ //g'`/"))
		return
	fi
	echo ""
	echo "nf:$numfound"
	echo "ldir:$ldir"
	echo "pdir:$pdir"
	echo "cur:$cur"
	#tt=`find $pdir/ -maxdepth 10 -type d | grep $cur`
	COMPREPLY=( $(compgen -W "$tt"))
}


