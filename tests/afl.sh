#! /bin/sh
#
# Copyright 2018 Gavin D. Howard
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

script="$0"

testdir=$(dirname "$script")

if [ "$#" -lt 1 ]; then
	bc="$testdir/../bc"
else
	bc="$1"
	shift
fi

if [ "$#" -lt 1 ]; then
	resultsdir="$testdir/../../results"
else
	resultsdir="$1"
	shift
fi

out="$testdir/../.test.txt"

for d in $resultsdir/*; do

	echo "$d"

	for f in $d/crashes/*; do

		echo "    $f"

		base=$(basename "$f")

		[ -e "$f" ] || continue
		[ "$base" != "README.txt" ] || continue

		while read line; do

			echo "$line" | "$bc" "$@" -lq > /dev/null 2>&1
			error="$?"

			if [ "$error" -gt 127 ]; then

				echo "\nbc crashed on test:\n"
				echo "    $line"

				echo "\nCopying to \"$out\""
				cp "$f" "$out"

				echo "\nexiting..."
				exit "$error"

			fi

		done < "$f"

		echo "    Running whole file..."

		echo "halt" | "$bc" "$@" -lq "$f" > /dev/null 2>&1
		error="$?"

		if [ "$error" -gt 127 ]; then

			echo "\nbc crashed on file:\n"
			echo "    $f"

			echo "\nCopying to \"$out\""
			cp "$f" "$out"

			echo "\nexiting..."
			exit "$error"

		fi

	done

done
