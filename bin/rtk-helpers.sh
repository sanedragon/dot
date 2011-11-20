# Settings
export SERVER_PORT=8080
export RTK_SUBSYSTEM=vod
export EDITOR=vim
export RENTASK_USER=estrickland
export RENTRAK_EMAIL=estrickland@rentrakmail.com
#export CVSWORK=/home/estrickland/work/ondemand/perl_lib
#ssh-agent $SHELL
export PERL5LIB=/usr/local/vod/perl_lib

# Helper functions

cdtr()
{
	pattern=$1
	WORKDIR=$HOME/work

	if [[ -n "$pattern" ]]; then
		if [[ -d "$WORKDIR/$pattern" ]]; then
			work_dir="$WORKDIR/$pattern"
			title $pattern
			cd $work_dir
			export CVSWORK=`pwd`/perl_lib
			export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
			export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
			if [[ $work_dir =~ "([0-9]{6})" ]]; then
				task=${BASH_REMATCH[1]}
				rentask_clock.pl in $task
			fi
		else
			for dir in `find $WORKDIR -follow -maxdepth 1 -type d`; do
				branch_name=$(basename "$dir")
				if [[ $branch_name =~ ".*$pattern.*" ]]; then
					work_dir="$WORKDIR/$branch_name"
					title $branch_name
					cd $work_dir
					export CVSWORK=`pwd`/perl_lib
					export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
					export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
					if [[ $work_dir =~ "([0-9]{6})" ]]; then
						task=${BASH_REMATCH[1]}
						rentask_clock.pl in $task
					fi
					break
				fi
			done
		fi
	fi
}
