#!/usr/bin/env sh
# Get current swap usage for all running processes
# Felix Hauri 2016-08-05
# Rewritted without fork. Inspired by first stuff from
# Erik Ljungstrom 27/05/2011
# Modified by Mikko Rantalainen 2012-08-09
# Pipe the output to "sort -nk3" to get sorted output
# Modified by Marc Methot 2014-09-18
# removed the need for sudo

get_swap() {
	OVERALL=0
	rifs=$(printf ': \t')
	for FILE in /proc/[0-9]*/status; do
		SUM=0
		while IFS="$rifs" read FIELD VALUE; do
			case $FIELD in
			Pid) PID=$VALUE ;;
			Name) PROGNAME="$VALUE" ;;
			VmSwap) SUM=$((SUM = ${VALUE% *})) ;;
			esac
		done <"$FILE"
		[ "$SUM" -gt 0 ] &&
			CMDLINE=$(cat /proc/"$PID"/cmdline) &&
			printf "PID: %9d  swapped: %11d KB (%s): [%s]\n" "$PID" "$SUM" "$PROGNAME" "$CMDLINE"
		OVERALL=$((OVERALL + SUM))
	done
	printf "Total swapped memory: %14u KB\n" "$OVERALL"
}

get_swap | sort -r -k4 -n
