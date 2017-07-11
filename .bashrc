# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#############
#DEBUT CUSTO#
#############

alias tmux="TERM=xterm-256color tmux -2"
export DEBFULLNAME="Yoan Lecoq"
export DEBEMAIL="yoanlecoq.io@gmail.com"
#export LIBRARY_PATH=/usr/lib/nvidia-352/
#export LD_LIBRARY_PATH=/usr/lib/nvidia-352/
PATH=$PATH:/usr/local/cross/bin:/usr/local/jdk/bin:/usr/local/android-studio/bin:/usr/local/android-ndk-r12
NORM="\033[0;00m" GREY="\033[0;37m"
RED="\033[0;31m"; B_RED="\033[1;31m"
YELLOW="\033[0;33m"; B_YELLOW="\033[1;33m"
GREEN="\033[0;32m"; B_GREEN="\033[1;32m"
CYAN="\033[0;36m"; B_CYAN="\033[1;36m"
BLUE="\033[0;34m"; B_BLUE="\033[1;34m"
MAGENTA="\033[0;35m"; B_MAGENTA="\033[1;35m"

r(){
    printf "\033c";
    . ~/.bashrc;
    rm ~/.bash_history -f;
    rm ~/.bashrc~ -f;
}
ct(){
    c=0
    if [[ "$1" != "" ]]; then lim=$1; else lim=12; fi
    while [[ c -le 255 ]]; do
	i=0;
	while [[ i -lt $lim ]]; do
	    if [[ `expr length "$c"` -lt 2 ]]; then echo -n " "; fi
	    if [[ `expr length "$c"` -lt 3 ]]; then echo -n " "; fi
	    echo -e -n "\e[38;05;${c}m ${c}"
	    c=$(($c + 1))
	    i=$(($i + 1))
	done
	echo;
    done
    echo -e -n "\e[38;05;196m196 "
    echo -e -n "\e[38;05;226m226 "
    echo -e -n "\e[38;05;46m 46 "
    echo -e -n "\e[38;05;51m 51 "
    echo -e -n "\e[38;05;21m 21 "
    echo -e -n "\e[38;05;201m201 "
    echo -e $NORM;
}
prisma(){
    x=2;n=0;r=0;y=0;g=0;c=0;b=0;m=0
    #DETECTION ET EVALUATION DES ARGUMENTS
    if [[ `expr substr "$1" 1 1` == '-' ]]; then
	i=2
	counter=1
	while [[ $i -le `expr length "$1"` ]]; do
	    if [[ `expr substr "$1" $i 1` == 'h' ]]; then
		echo "Help :"
		echo "En premier argument, sous réserve qu'il commence par un '-', ces caractères ont la signification suivante :"
		echo "1 - Version 6 couleurs (Valeur par défaut si omis)."
		echo "2 - Version 12 couleurs."
		echo "3 - Version 30 couleurs."
		echo "n - Ne pas faire le saut de ligne à la fin."
		echo "rygcbm - Red, Yellow, Green, Cyan, Blue, Magenta."
		echo "         Limite le nombre de teintes aux teintes choisies."
		echo "         Changer l'ordre des lettres change l'ordre de l'emploi des teintes."
		return 0;
	    fi
	    if [[ `expr substr "$1" $i 1` == 'n' ]]; then n=1;fi
	    if [[ `expr substr "$1" $i 1` == '2' ]]; then x=1;fi
	    if [[ `expr substr "$1" $i 1` == '3' ]]; then x=0;fi
	    if [[ `expr substr "$1" $i 1` == 'r' ]]; then
		r=$counter
		counter=$(($counter + 1))
	    fi
	    if [[ `expr substr "$1" $i 1` == 'y' ]]; then
		y=$counter
		counter=$(($counter + 1))
	    fi
	    if [[ `expr substr "$1" $i 1` == 'g' ]]; then
		g=$counter
		counter=$(($counter + 1))
	    fi
	    if [[ `expr substr "$1" $i 1` == 'c' ]]; then
		c=$counter
		counter=$(($counter + 1))
	    fi
	    if [[ `expr substr "$1" $i 1` == 'b' ]]; then
		b=$counter
		counter=$(($counter + 1))
	    fi
	    if [[ `expr substr "$1" $i 1` == 'm' ]]; then
		m=$counter
		counter=$(($counter + 1))
	    fi
	    i=$(($i + 1))
	done
	shift
    fi
    #En l'absence d'arguments, on active toutes les couleurs dans l'ordre de l'arc-en-ciel.
    if [[ $(($r+$y+$g+$c+$b+$m)) -eq 0 ]];then r=1;y=2;g=3;c=4;b=5;m=6; fi

    for arg; do
	arg="$1"
	j=1
	active=1
	#Déterminer le nombre maximal de teintes ($max).
	for (( i=6; i>0 ; i=$(($i - 1)) ));do
	    if [[ $i -eq $r ]] || [[ $i -eq $y ]] || [[ $i -eq $g ]] || [[ $i -eq $c ]] || [[ $i -eq $b ]] || [[ $i -eq $m ]]; 
	    then max=$i; break;
	    fi
	done
        #BOUCLE D'AFFICHAGE DE LA CHAINE
	while [[ $j -le `expr length "$arg"` ]]; do
	    if [[ $r -gt 0 ]]; then
                #R to Y-1
		if [[ $r -eq $active ]] && [[ $y -eq `echo $active%$max+1|bc` || $(($y+$g+$c+$b+$m)) -eq 0 ]]; then
		    for (( i=196 ; i<=220 ; i=$(($i + 6)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*6+$i))
			j=$(($j + 1))
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #R to G-1
		if [[ $r -eq $active ]] && [[ $g -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=196 ; i>=76 ; i=$(($i - 30)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-30+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #R to C-1
		if [[ $r -eq $active ]] && [[ $c -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=196 ; i>=80 ; i=$(($i - 29)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-29+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #R to B-1
		if [[ $r -eq $active ]] && [[ $b -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=196 ; i>=56 ; i=$(($i - 35)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-35+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #R to M-1
		if [[ $r -eq $active ]] && [[ $m -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=196 ; i<=200 ; i=$(($i + 1)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi

	    if [[ $y -gt 0 ]]; then
                #Y to G-1
		if [[ $y -eq $active ]] && [[ $g -eq `echo $active%$max+1|bc` || $(($r+$g+$c+$b+$m)) -eq 0 ]]; then
		    for (( i=226 ; i>=82 ; i=$(($i - 36)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-36+$i))
			j=$(($j + 1))
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #Y to C-1
		if [[ $y -eq $active ]] && [[ $c -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=226 ; i>=86 ; i=$(($i - 35)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-35+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #Y to B-1
		if [[ $y -eq $active ]] && [[ $b -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=226 ; i>=62 ; i=$(($i - 41)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-41+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #Y to M-1
		if [[ $y -eq $active ]] && [[ $m -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=226 ; i>=206 ; i=$(($i - 5)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-5+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #Y to R-1
		if [[ $y -eq $active ]] && [[ $r -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=226 ; i>=202 ; i=$(($i - 6)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-6+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi

	    if [[ $g -gt 0 ]]; then
                #G to C-1
		if [[ $g -eq $active ]] && [[ $c -eq `echo $active%$max+1|bc` || $(($r+$y+$c+$b+$m)) -eq 0 ]]; then
		    for (( i=46 ; i<=50 ; i=$(($i + 1)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))+$i))
			j=$(($j + 1))
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #G to B-1
		if [[ $g -eq $active ]] && [[ $b -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=46 ; i>=26 ; i=$(($i - 5)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-5+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #G to M-1
		if [[ $g -eq $active ]] && [[ $m -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=46 ; i<=170 ; i=$(($i + 31)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*31+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #G to R-1
		if [[ $g -eq $active ]] && [[ $r -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=46 ; i<=176 ; i=$(($i + 30)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*30+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #G to Y-1
		if [[ $g -eq $active ]] && [[ $y -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=46 ; i<=190 ; i=$(($i + 36)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*190+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi

	    if [[ $c -gt 0 ]]; then
                #C to B-1
		if [[ $c -eq $active ]] && [[ $b -eq `echo $active%$max+1|bc` || $(($r+$y+$g+$b+$m)) -eq 0 ]]; then
		    for (( i=51 ; i>=27 ; i=$(($i - 6)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-6+$i))
			j=$(($j + 1)) 
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #C to M-1
		if [[ $c -eq $active ]] && [[ $m -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=51 ; i<=171 ; i=$(($i + 30)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*30+$i))
			j=$(($j + 1)) 
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #C to R-1
		if [[ $c -eq $active ]] && [[ $r -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=51 ; i<=170 ; i=$(($i + 29)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*29+$i))
			j=$(($j + 1)) 
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #C to Y-1
		if [[ $c -eq $active ]] && [[ $y -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=51 ; i<=191 ; i=$(($i + 35)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*35+$i))
			j=$(($j + 1)) 
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #C to G-1
		if [[ $c -eq $active ]] && [[ $g -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=51 ; i>=47 ; i=$(($i - 1)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-1+$i))
			j=$(($j + 1)) 
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi

	    if [[ $b -gt 0 ]]; then
                #B to M-1
		if [[ $b -eq $active ]] && [[ $m -eq `echo $active%$max+1|bc` || $(($r+$y+$g+$c+$m)) -eq 0 ]]; then
		    for (( i=21 ; i<=165 ; i=$(($i + 36)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*36+$i))
			j=$(($j + 1))
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #B to R-1
		if [[ $b -eq $active ]] && [[ $r -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=21 ; i<=161 ; i=$(($i + 35)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*35+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #B to Y-1
		if [[ $b -eq $active ]] && [[ $y -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=21 ; i<=185 ; i=$(($i + 41)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*41+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #B to G-1
		if [[ $b -eq $active ]] && [[ $g -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=21 ; i<=41 ; i=$(($i + 5)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*5+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #B to C-1
		if [[ $b -eq $active ]] && [[ $c -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=21 ; i<=45 ; i=$(($i + 6)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*6+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi

	    if [[ $m -gt 0 ]]; then
                #M to R-1
		if [[ $m -eq $active ]] && [[ $r -eq `echo $active%$max+1|bc` || $(($r+$y+$g+$c+$b)) -eq 0 ]]; then
		    for (( i=201 ; i>=197 ; i=$(($i - 1)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-1+$i))
			j=$(($j + 1))
			if [[ $x -eq 2 ]]; then break;fi
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #M to Y-1
		if [[ $m -eq $active ]] && [[ $y -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=201 ; i<=221 ; i=$(($i + 5)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*5+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #M to G-1
		if [[ $m -eq $active ]] && [[ $g -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=201 ; i>=77 ; i=$(($i - 31)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-31+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #M to C-1
		if [[ $m -eq $active ]] && [[ $c -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=201 ; i>=81 ; i=$(($i - 30)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-30+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
                #M to B-1
		if [[ $m -eq $active ]] && [[ $b -eq `echo $active%$max+1|bc` ]]; then
		    for (( i=201 ; i>=57 ; i=$(($i - 36)) )); do
			echo -e -n "\e[38;05;${i}m"`expr substr "$arg" $j 1 2> /dev/null`
			i=$(($((2*$x))*-36+$i))
			j=$(($j + 1))
		    done
		    active=$((`echo $active%$max+1|bc`))
		fi
	    fi
	done
	echo -n ' ';
	shift
    done
    echo -e -n '\b''\033[0;00m'
    if [[ $n -eq 0 ]]; then echo; fi
}

cx(){
    farg=0; cx_verbose=0; farg=0; fargs=""; cargs=""
    for arg; do
	if [[ $farg -eq 1 ]]; then fargs="$fargs $1"; 
	elif [[ `expr substr "$1" 1 1` == '+' ]]; then
	    for (( i=2 ; i<=`expr length "$1"` ; i++ )); do 
		char=`expr substr "$1" $i 1`
		if [[ $char == 'v' ]]; then cx_verbose=1;
		elif [[ $char == 'h' ]]; then
		    echo "Usage : cx [+<cxArgs>] [<compilerArgs>] <file> <executableArgs>"
		    return 0;
		fi
	    done
	elif [[ `expr substr "$1" 1 1` == '-' ]]; then cargs="$cargs $1";
	elif [[ -f $1 ]]; then
	    ind=`expr index "$1" '.'`
	    len=`expr length "$1"`
	    extension=`expr substr "$1" "$ind" $(($len-$ind+1))`
	    fichier=$1
	    nom=`expr substr "$1" 1 $(($ind-1))`
	    farg=1
	fi
	shift
    done

    if [[ $farg -eq 0 ]]; then echo "cx: erreur: Pas de fichier." 1>&2; return 1;
    elif [[ $extension == ".c" ]] || [[ $extension == ".C" ]]; then 
	if [[ $cx_verbose -eq 1 ]]; then 
	    echo "cx: Fichier source C."
	    echo "cx: Compilation de $fichier... (gcc $fichier -o $nom $cargs)"
	fi
	gcc "$fichier" -o "$nom" $cargs;
	if [[ $? -eq 0 ]]; then
	    rm -f "$fichier~";
	    if [[ $cx_verbose -eq 1 ]]; then echo "cx: Execution de $nom... (./$nom $fargs)"; fi
	    ./"$nom" $fargs;
	fi
	return 0;
    elif [[ $extension == ".sh" ]] && ![[-x $fichier]]; then chmod "$fichier" -+x; ./"$fichier" $fargs;
    else echo "cx: erreur: Extension non reconnue." 1>&2; return 1;
    fi
}

ceb(){
    #TODO :
    #Tolérance des bases réelles

    #Ce code source est vachement plus compliqué que prévu, mais tout y est indispensable.
    #Convention :
    #val1 est la partie entière de la valeur à convertir.
    #val1d est sa partie décimale si elle existe.
    #val2 est la base de départ.
    #val3 est la base de destination.
    
    #resultat est le résultat de la conversion base M -> base 10.
    #resultatd est sa partie décimale si elle existe.
    #res est le résultat de la conversion base 10 -> base N.
    #resd est sa partie décimale si elle existe.

    #EVALUATION DES ARGUMENTS
    opt_v=0; opt_p=0; opt_e=0; opt_n=0; opt_s=0;
    etape=1; val1=0; val1d=0; val2=0; val3=0; 
    resultat=0; resultatd=0; res=; resd=;
    for arg; do
	if [[ `expr index "$1" v` -ne 0 ]]; then opt_v=1; opt=1; fi
	if [[ `expr index "$1" p` -ne 0 ]]; then opt_p=1; opt=1; fi
	if [[ `expr index "$1" e` -ne 0 ]]; then opt_e=1; opt=1; fi
	if [[ `expr index "$1" n` -ne 0 ]]; then opt_n=1; opt=1; fi
	if [[ `expr index "$1" s` -ne 0 ]]; then opt_s=1; opt=1; fi
	if [[ `expr index "$1" h` -ne 0 ]]; then 
	    echo "NOM"
	    echo "ceb - Conversion Entre Bases v.0.9"
	    echo "SYNOPSIS"
	    echo "ceb [opts] <valeur> [opts] <baseM> [opts] <baseN> [opts]"
	    echo "DESCRIPTION"
	    echo "Script avancé de conversion d'un entier ou réel, d'une base M à une base N."
	    echo "<valeur> peut être composée de chiffres et de lettres MAJUSCULES."
	    echo "M doit être écrite en base 10 et être entière."
	    echo "N doit être écrite en base 10 et être entière, différente de -1, 0, et 1."
	    echo "(Si N est négative, le résultat peut, selon les cas, ne pas être correct)"
	    echo "OPTIONS"
	    echo "Les lettres minuscules sont réservées pour les options (à écarter des valeurs) que voici :"
	    echo "v - Verbose. Détaille les étapes de la conversion;"
	    echo "p - Préfixer. Préfixe le résultat d'un 0 ou 0x selon qu'il soit en base 8 ou 16;"
	    echo "e - Entier. Ignore les parties décimales lors des calculs;"
	    echo "s - Stopper. Intercepte arbitrairement les boucles vraiment trop longues."
	    echo "n - No Newline. Ne pas mettre de saut de ligne après le résultat;"
	    echo "h - Help. Affiche cette aide et quitte."
	    return 0;
	fi
	if [[ $opt -eq 0 ]]; then
	    point=`expr index "$1" .`
	    len=`expr length "$1"`
	    if [[ $point -eq 0 ]]; then
		if [[ $etape -eq 1 ]]; then val1=$1; etape=$((etape+1));
		elif [[ $etape -eq 2 ]]; then val2=$1; etape=$((etape+1));
		elif [[ $etape -eq 3 ]]; then val3=$1;
		fi
	    else 	
		if [[ $etape -eq 1 ]]; then 
		    val1=`expr substr "$1" 1 $(($point-1))`; 
		    val1d=0.`expr substr "$1" $(($point+1)) $len`; 
		    etape=$((etape+1));
		elif [[ $etape -eq 2 ]]; then 
		    val2=`expr substr "$1" 1 $(($point-1))`; 
		    etape=$((etape+1));
		elif [[ $etape -eq 3 ]]; then 
		    val3=`expr substr "$1" 1 $(($point-1))`;  
		fi
	    fi
	fi
	opt=0;
	shift
    done
    #AFFICHAGE DES ERREURS
    if [[ $val3 -ge -1 && $val3 -le 1 ]];then 
	echo "ceb: Usage : conv <valeur> <base> <base>" 1>&2
	echo "ceb: Tapez 'ceb h' pour plus d'informations." 1>&2
	return 1;
    fi
    symb="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    #CONVERSION DE BASE DONNEE VERS LA BASE 10
    puissance=$((`expr length "$val1"` - 1));
    if [[ $val2 -ne 10 ]]; then
	if [[ $opt_v -eq 1 ]]; then
	    echo -e "\n--> Sémantique de base $val2 vers la base 10 <--";
	    echo -n "($val1)$val2 = "
	fi
	#TRAITEMENT DE LA PARTIE ENTIERE
	for(( i=1 ; i<=`expr length "$val1"` ; i++ )); do
	    pos=`expr substr "$val1" $i 1`;
	    basepuissance=$(($val2**$puissance));
	    if [[ `expr index "$symb" $pos` -ne 0 ]]; then pos=$((`expr index "$symb" $pos` + 9)); fi
	    if [[ $opt_v -eq 1 ]]; then 
		echo -n "$pos*$val2^$puissance";
		if [[ $i -ne $((`expr length "$val1"`)) ]];then echo -n " + "; fi
	    fi
	    puissance=$(($puissance - 1));
	    resultat=$(($pos * $basepuissance + $resultat));
	done
	#TRAITEMENT DE LA PARTIE DECIMALE
	if [[ `echo $val1d | bc 2>/dev/null` != '0' && $opt_e -ne 1 ]]; then
	    if [[ $opt_v -eq 1 ]]; then echo -n " + "; fi
	    for (( i=1 ; i<=`expr length "$val1d"`-2 ; i++ )); do
		pos=`expr substr "$val1d" $(($i+2)) 1`;
		basepuissance=`echo $val2^$puissance | bc -l`;
		if [[ `expr index "$symb" $pos` -ne 0 ]]; then pos=$((`expr index "$symb" $pos` + 9)); fi
		if [[ $opt_v -eq 1 ]]; then 
		    echo -n "$pos*$val2^$puissance";
		    if [[ $i -ne $((`expr length "$val1d"`-2)) ]];then echo -n " + "; fi
		fi
		puissance=$(($puissance - 1));
		resultatd=`echo $pos*$basepuissance+$resultatd | bc -l`;
	    done
	    resultat=`echo $resultat+$resultatd | bc`
	    #On enlève les zéros inutiles
	    i=`expr length "$resultat"`
	    while [[ `expr substr "$resultat" $i 1` -eq 0 ]]; do
		i=$(($i-1))
		resultat=`expr substr "$resultat" 1 $i`
	    done
	fi
        if [[ $opt_v -eq 1 ]]; then echo " = ($resultat)10"; fi
    else resultat=$val1; resultatd=$val1d #NECESSAIRE POUR LA PROCHAINE CONVERSION
    fi

    #CONVERSION DE BASE 10 VERS LA BASE DESIREE
    if [[ $val3 -ne 10 ]]; then
	#TRAITEMENT DE LA PARTIE ENTIERE
	if [[ $opt_v -eq 1 ]]; then echo -e "\n--> Division euclidienne de base 10 vers base $val3 <--"; fi
	nb=$resultat #nb sert à ne pas affecter resultat dont on aura besoin pour l'affichage.
	while [[ $nb -ne 0 ]]; do
	    reste=$(($nb % $val3));
	    if [[ $reste -gt 9 ]]; then reste=`expr substr $symb $(($reste-9)) 1`; fi
	    if [[ $opt_v -eq 1 ]]; then echo "$nb/$val3=$(($nb/$val3)) reste $reste"; fi
	    res=$reste$res
	    nb=$(($nb / $val3))
	done
	#TRAITEMENT DE LA PARTIE DECIMALE
	resultatdbackup=$resultatd #Pour l'affichage final, car resultatd va être réduit à 0
	if [[ `echo $resultatd | bc` != '0' && $opt_e -ne 1 ]]; then 
	    if [[ $opt_v -eq 1 ]]; then echo '.'; fi
	    sentcount=0;
	    len=`expr length "$resultatd"`
	    while [[ `echo $resultatd | bc` != '0' ]]; do 
		if [[ $opt_v -eq 1 ]]; then echo -n "$resultatd*$val3 = ";fi
		resultatd=`echo $resultatd*$val3 | bc -l`
		#Bloqueur de boucles infinies !
		if [[ $opt_s -ge 1 ]]; then opt_s=$(($opt_s+1))
		    if [[ $opt_s -eq 50 ]];then echo "ceb: Boucle stoppée." 1>&2; return 1; fi 
		fi
		if [[ $sentcount -eq 2 && $resultatd == $sentinelle ]]; then
		    if [[ $opt_v -eq 1 ]]; then echo "... (Boucle infinie)"; fi
		    sentinelle=; sentcount=;
		    break;
		elif [[ $sentcount -eq 1 ]]; then 
		    sentinelle=$resultatd;
		    sentcount=$(($sentcount+1)); 
		elif [[ $sentcount -eq 0 ]]; then sentcount=$(($sentcount+1))
		fi
		#bc est un sacré enfoiré, demande-lui 0.n, il te répondra .n 
		if [[ `expr substr "$resultatd" 1 1` == '.' ]]; then resultatd=0$resultatd; fi
		if [[ $opt_v -eq 1 ]]; then echo -n "$resultatd; ";fi
		#On repère le point.
		point=`expr index "$resultatd" .`
		#On attrape la partie entière.
		nb=`expr substr "$resultatd" 1 $(($point-1))`
		#Est-ce une lettre ?
		if [[ $nb -gt 9 ]]; then nb=`expr substr $symb $(($nb-9)) 1`; fi
		if [[ $opt_v -eq 1 ]]; then echo "entier $nb";fi
		#On peut la stocker maintenant.
		resd=$resd$nb
		#On prépare le prochain calcul.
		resultatd=0.`expr substr "$resultatd" $(($point+1)) $len`;
	    done
	    res=$res.$resd
	fi
    else res=$resultat
    fi
    
    #AFFICHAGE DU RESULTAT
    val1=`echo $val1+$val1d | bc`
    if [[ -n $resultatdbackup ]]; then 
	resultat=`echo $resultat+$resultatdbackup | bc`; 
	resultatdbackup=;
    fi
    #bc est un sacré enfoiré, demande-lui 0.n, il te répondra .n 
    if [[ `expr substr "$val1" 1 1` == '.' ]]; then val1=0$val1; fi
    if [[ `expr substr "$resultat" 1 1` == '.' ]]; then resultat=0$resultat; fi
    if [[ `expr substr "$res" 1 1` == '.' ]]; then res=0$res; fi
    #PREFIXAGE
    if [[ $opt_p -eq 1 ]]; then
	if [[ $val3 -eq 8 ]]; then res=0$res
	elif [[ $val3 -eq 16 ]]; then res=0x$res; fi
    fi
    #VERBOSE
    if [[ $opt_v -eq 1 ]]; then 
	echo -e "\n--> Résultat final <--";
	if [[ $val2 -eq 10 || $val3 -eq 10 ]]; then echo -n "($val1)$val2 = ($res)$val3";
	else echo -n "($val1)$val2 = ($resultat)10 = ($res)$val3";
	fi
    else echo -n $res; #NON-VERBOSE
    fi
    if [[ $opt_n -ne 1 ]];then echo; fi
}

ta(){
    opt_i=0; dir=;
    for arg; do
	if [[ `expr substr "$1" 1 1` == '-' ]]; then
	    if [[ `expr index "$1" i` -ne 0 ]]; then opt_i=1; fi
	elif [[ -d $1 ]]; then 
	    if [[ `expr index "$1" '/'` -ne `expr length "$1"` ]]; then dir=$1/;
	    else dir=$1; 
	    fi
	fi
	shift
    done
    if [[ -z $dir ]]; then dir=./; fi
    if [[ $opt_i -eq 1 ]]; then 
	find $dir -name '*~' -print
        find $dir -name '\#*\#' -print
	echo;
	read -p "Delete ? (y/n) " reponse
	if [[ $reponse == 'y' ]]; then 
	    find $dir -name '*~' -exec rm '{}' \; -or -name ".*~" -exec rm {} \;
	    find $dir -name '\#*\#' -exec rm '{}' \; -or -name "\#.*\#" -exec rm {} \;
	    echo "Done.";
	else echo "Done nothing."; fi
    else
	find $dir -name '*~' -exec rm '{}' \; -or -name ".*~" -exec rm {} \;
	find $dir -name '\#*\#' -exec rm '{}' \; -or -name "\#.*\#" -exec rm {} \;
    fi
}

alias Chrono='~/.Chrono'

LEAF='\[\e[38;05;112m\]\u\[\e[38;05;76m\]@\h \[\e[38;05;40m\]\w\n\[\e[38;05;120m\]> '
SEA='\[\e[38;05;45m\]\u\[\e[38;05;39m\]@\h \[\e[38;05;33m\]\w\n\[\e[38;05;51m\]> '
BLOOD='\[\e[38;05;124m\]\u\[\e[38;05;160m\]@\h \[\e[38;05;196m\]\w\n\[\e[38;05;9m\]> '
ORANGE='\[\e[38;05;142m\]\u\[\e[38;05;136m\]@\h \[\e[38;05;178m\]\w\n\[\e[38;05;228m\]> '
STEEL='\[\e[38;05;240m\]\u\[\e[38;05;242m\]@\h \[\e[38;05;245m\]\w\n\[\e[38;05;250m\]> \[\e[38;05;7m\]'
LIGHT='\[\e[38;05;221m\]\u\[\e[38;05;227m\]@\h \[\e[38;05;228m\]\w\n> '

if [[ $TERM == "linux" ]]; then 
    PS1='\u@\h \w\n> ';
else
    case `id -un` in
	lecoqy)    PS1=$LEAF ;;
	yoon)      PS1=$STEEL ;;
	carre)     PS1=$ORANGE ;;
	bourdins)  PS1=$SEA ;;
	marchandd) PS1=$BLOOD ;;
	root)      PS1=$LIGHT ;;
    esac
fi
###########
#FIN CUSTO#
###########

export FE_PATH=/home/yoon/git/FATE
export PATH=$FE_PATH/bin/bash:$PATH
PATH=$PATH:/usr/local/emsdk-portable/emscripten/1.37.9
