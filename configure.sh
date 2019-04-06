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

usage() {

	if [ $# -gt 0 ]; then

		val=1

		printf "%s\n\n" "$1"

	else
		val=0
	fi

	printf 'usage: %s -h\n' "$script"
	printf '       %s --help\n' "$script"
	printf '       %s [-bD|-dB|-c] [-EgGHMNS] [-O OPT_LEVEL] [-k KARATSUBA_LEN]\n' "$script"
	printf '       %s \\\n' "$script"
	printf '           [--bc-only --disable-dc|--dc-only --disable-bc|--coverage]    \\\n'
	printf '           [--debug --disable-extra-math --disable-generated-tests]      \\\n'
	printf '           [--disable-history --disable-man-pages --disable-nls]         \\\n'
	printf '           [--disable-signal-handling]                                   \\\n'
	printf '           [--opt=OPT_LEVEL] [--karatsuba-len=KARATSUBA_LEN]             \\\n'
	printf '           [--prefix=PREFIX] [--bindir=BINDIR]                           \\\n'
	printf '           [--datarootdir=DATAROOTDIR] [--datadir=DATADIR]               \\\n'
	printf '           [--mandir=MANDIR] [--man1dir=MAN1DIR] [--localedir=LOCALEDIR] \\\n'
	printf '\n'
	printf '    -b, --bc-only\n'
	printf '        Build bc only. It is an error if "-d" or "-B" are specified too.\n'
	printf '    -B, --disable-bc\n'
	printf '        Disable bc. It is an error if "-b", "--bc-only", "-D", or "--disable-dc"\n'
	printf '        are specified too.\n'
	printf '    -c, --coverage\n'
	printf '        Generate test coverage code. Requires gcov and regcovr.\n'
	printf '        It is an error if either "-b" ("-D") or "-d" ("-B") is specified.\n'
	printf '        Requires a compiler that use gcc-compatible coverage options\n'
	printf '    -d, --dc-only\n'
	printf '        Build dc only. It is an error if "-b" is specified too.\n'
	printf '    -D, --disable-dc\n'
	printf '        Disable dc. It is an error if "-d", "--dc-only" "-B", or "--disable-bc"\n'
	printf '        are specified too.\n'
	printf '    -E, --disable-extra-math\n'
	printf '        Disable extra math. This includes: "$" operator (truncate to integer),\n'
	printf '        "@" operator (set number of decimal places), and r(x, p) (rounding\n'
	printf '        function). Additionally, this option disables the extra printing\n'
	printf '        functions in the math library.\n'
	printf '    -g, --debug\n'
	printf '        Build in debug mode. Adds the "-g" flag, and if there are no\n'
	printf '        other CFLAGS, and "-O" was not given, this also adds the "-O0"\n'
	printf '        flag. If this flag is *not* given, "-DNDEBUG" is added to CPPFLAGS\n'
	printf '        and a strip flag is added to the link stage.\n'
	printf '    -G, --disable-generated-tests\n'
	printf '        Disable generating tests. This is for platforms that do not have a\n'
	printf '        GNU bc-compatible bc to generate tests.\n'
	printf '    -h, --help\n'
	printf '        Print this help message and exit.\n'
	printf '    -H, --disable-history\n'
	printf '        Disable history.\n'
	printf '    -k KARATSUBA_LEN, --karatsuba-len KARATSUBA_LEN\n'
	printf '        Set the karatsuba length to KARATSUBA_LEN (default is 64).\n'
	printf '        It is an error if KARATSUBA_LEN is not a number or is less than 16.\n'
	printf '    -M, --disable-man-pages\n'
	printf '        Disable installing manpages.\n'
	printf '    -N, --disable-nls\n'
	printf '        Disable POSIX locale (NLS) support.\n'
	printf '    -O OPT_LEVEL, --opt OPT_LEVEL\n'
	printf '        Set the optimization level. This can also be included in the CFLAGS,\n'
	printf '        but it is provided, so maintainers can build optimized debug builds.\n'
	printf '        This is passed through to the compiler, so it must be supported.\n'
	printf '    -S, --disable-signal-handling\n'
	printf '        Disable signal handling. On by default.\n'
	printf '    --prefix PREFIX\n'
	printf '        The prefix to install to. Overrides "$PREFIX" if it exists.\n'
	printf '        If PREFIX is "/usr", install path will be "/usr/bin".\n'
	printf '        Default is "/usr/local".\n'
	printf '    --bindir BINDIR\n'
	printf '        The directory to install binaries. Overrides "$BINDIR if it exists.\n'
	printf '        Default is "$PREFIX/bin".\n'
	printf '    --datarootdir DATAROOTDIR\n'
	printf '        The root location for data files. Overrides "$DATAROOTDIR" if it exists.\n'
	printf '        Default is "$PREFIX/share".\n'
	printf '    --datadir DATADIR\n'
	printf '        The location for data files. Overrides "$DATADIR" if it exists.\n'
	printf '        Default is "$DATAROOTDIR".\n'
	printf '    --mandir MANDIR\n'
	printf '        The location to install manpages to. Overrides "$MANDIR" if it exists.\n'
	printf '        Default is "$DATADIR/man".\n'
	printf '    --man1dir MAN1DIR\n'
	printf '        The location to install Section 1 manpages to. Overrides "$MAN1DIR if it\n'
	printf '        exists. Default is "$MANDIR/man1".\n'
	printf '    --localedir LOCALEDIR\n'
	printf '        The location to install locale catalogs to. Each locale will then be\n'
	printf '        installed to "$LOCALEDIR/$LOCALE/LC_MESSAGES/$EXEC.cat", where "$LOCALE"\n'
	printf '        is the locale of the catalog and "$EXEC" is the main executable name.\n'
	printf '        Overrides "$LOCALEDIR" if it exists. Defaults to "$DATAROOTDIR/locale".\n'
	printf '\n'
	printf 'In addition, the following environment variables are used:\n'
	printf '\n'
	printf '    CC           C compiler. Must be compatible with POSIX c99.\n'
	printf '                 Default is "c99".\n'
	printf '    HOSTCC       Host C compiler. Must be compatible with POSIX c99.\n'
	printf '                 Default is "$CC".\n'
	printf '    HOST_CC      Same as HOSTCC. If HOSTCC also exists, it is used.\n'
	printf '    CFLAGS       C compiler flags.\n'
	printf '    HOSTCFLAGS   CFLAGS for HOSTCC. Default is "$CFLAGS".\n'
	printf '    HOST_CFLAGS  Same as HOST_CFLAGS. If HOST_CFLAGS also exists, it is used.\n'
	printf '    CPPFLAGS     C preprocessor flags. Default is "".\n'
	printf '    LDFLAGS      Linker flags. Default is "".\n'
	printf '    PREFIX       The prefix to install to. Default is "/usr/local".\n'
	printf '                 If PREFIX is "/usr", install path will be "/usr/bin".\n'
	printf '    BINDIR       The directory to install binaries. Default is "$PREFIX/bin".\n'
	printf '    DATAROOTDIR  The root location for data files. Default is "$PREFIX/share".\n'
	printf '    DATADIR      The location for data files. Default is "$DATAROOTDIR".\n'
	printf '    MANDIR       The location to install manpages to. Default is "$DATADIR/man".\n'
	printf '    MAN1DIR      The location to install Section 1 manpages to. Default is\n'
	printf '                 "$MANDIR/man1".\n'
	printf '    LOCALEDIR    The location to install locale catalogs to. Each locale will\n'
	printf '                 then be installed to "$LOCALEDIR/$LOCALE/LC_MESSAGES/$EXEC.cat"\n'
	printf '                 where "$LOCALE" is the locale of the catalog and "$EXEC" is the\n'
	printf '                 main executable name. Defaults to "$DATAROOTDIR/locale".\n'
	printf '    EXECSUFFIX   The suffix to append to the executable names, used to not\n'
	printf '                 interfere with other installed bc executables. Default is "".\n'
	printf '    EXECPREFIX   The prefix to append to the executable names, used to not\n'
	printf '                 interfere with other installed bc executables. Default is "".\n'
	printf '    DESTDIR      For package creation. Default is "". If it is empty when\n'
	printf '                 %s is run, it can also be passed to `make install`\n' "$script"
	printf '                 later as an environment variable.\n'
	printf '    GEN_EMU      Emulator to run string generator code under\n'
	printf '                 (leave empty if not necessary). Default is "".\n'

	exit "$val"
}

err_exit() {

	if [ "$#" -ne 1 ]; then
		printf 'Invalid number of args to err_exit\n'
		exit 1
	fi

	printf '%s\n' "$1"
	exit 1
}

replace_ext() {

	if [ "$#" -ne 3 ]; then
		err_exit "Invalid number of args to $0"
	fi

	file="$1"
	ext1="$2"
	ext2="$3"

	result=$(printf "$file" | sed -e "s@\.$ext1@\.$ext2@")

	printf '%s\n' "$result"
}

replace_exts() {

	if [ "$#" -ne 3 ]; then
		err_exit "Invalid number of args to $0"
	fi

	files="$1"
	ext1="$2"
	ext2="$3"

	for file in $files; do
		new_name=$(replace_ext "$file" "$ext1" "$ext2")
		result="$result $new_name"
	done

	printf '%s\n' "$result"
}

replace() {

	if [ "$#" -ne 3 ]; then
		err_exit "Invalid number of args to $0"
	fi

	str="$1"
	needle="$2"
	replacement="$3"

	result=$(printf '%s' "$str" | sed -e "s!%%$needle%%!$replacement!g")

	printf '%s\n' "$result"
}

gen_file_lists() {

	if [ "$#" -lt 3 ]; then
		err_exit "Invalid number of args to $0"
	fi

	contents="$1"
	shift

	filedir="$1"
	shift

	typ="$1"
	shift

	# If there is an extra argument, and it
	# is zero, we keep the file lists empty.
	if [ "$#" -gt 0 ]; then
		use="$1"
	else
		use="1"
	fi

	needle_src="${typ}SRC"
	needle_obj="${typ}OBJ"
	needle_gcda="${typ}GCDA"
	needle_gcno="${typ}GCNO"

	if [ "$use" -ne 0 ]; then

		replacement=$(ls $filedir/*.c | tr '\n' ' ')
		contents=$(replace "$contents" "$needle_src" "$replacement")

		replacement=$(replace_exts "$replacement" "c" "o")
		contents=$(replace "$contents" "$needle_obj" "$replacement")

		replacement=$(replace_exts "$replacement" "o" "gcda")
		contents=$(replace "$contents" "$needle_gcda" "$replacement")

		replacement=$(replace_exts "$replacement" "gcda" "gcno")
		contents=$(replace "$contents" "$needle_gcno" "$replacement")

	else
		contents=$(replace "$contents" "$needle_src" "")
		contents=$(replace "$contents" "$needle_obj" "")
		contents=$(replace "$contents" "$needle_gcda" "")
		contents=$(replace "$contents" "$needle_gcno" "")
	fi

	printf '%s\n' "$contents"
}

script="$0"
scriptdir=$(dirname "$script")
script=$(basename "$script")

bc_only=0
dc_only=0
coverage=0
karatsuba_len=64
debug=0
signals=1
hist=1
extra_math=1
optimization=""
generate_tests=1
install_manpages=1
nls=1

while getopts "bBcdDEgGhHk:MNO:S-" opt; do

	case "$opt" in
		b) bc_only=1 ;;
		B) dc_only=1 ;;
		c) coverage=1 ;;
		d) dc_only=1 ;;
		D) bc_only=1 ;;
		E) extra_math=0 ;;
		g) debug=1 ;;
		G) generate_tests=0 ;;
		h) usage ;;
		H) hist=0 ;;
		k) karatsuba_len="$OPTARG" ;;
		M) install_manpages=0 ;;
		N) nls=0 ;;
		O) optimization="$OPTARG" ;;
		S) signals=0 ;;
		-)
			arg="$1"
			arg="${arg#--}"
			LONG_OPTARG="${arg#*=}"
			case $arg in
				help) usage ;;
				bc-only) bc_only=1 ;;
				dc-only) dc_only=1 ;;
				coverage) coverage=1 ;;
				debug) debug=1 ;;
				prefix=?*) PREFIX="$LONG_OPTARG" ;;
				prefix)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					PREFIX="$2"
					shift ;;
				bindir=?*) BINDIR="$LONG_OPTARG" ;;
				bindir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					BINDIR="$2"
					shift ;;
				datarootdir=?*) DATAROOTDIR="$LONG_OPTARG" ;;
				datarootdir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					DATAROOTDIR="$2"
					shift ;;
				datadir=?*) DATADIR="$LONG_OPTARG" ;;
				datadir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					DATADIR="$2"
					shift ;;
				mandir=?*) MANDIR="$LONG_OPTARG" ;;
				mandir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					MANDIR="$2"
					shift ;;
				man1dir=?*) MAN1DIR="$LONG_OPTARG" ;;
				man1dir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					MAN1DIR="$2"
					shift ;;
				localedir=?*) LOCALEDIR="$LONG_OPTARG" ;;
				localedir)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					LOCALEDIR="$2"
					shift ;;
				karatsuba-len=?*) karatsuba_len="$LONG_OPTARG" ;;
				karatsuba-len)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					karatsuba_len="$1"
					shift ;;
				opt=?*) optimization="$LONG_OPTARG" ;;
				opt)
					if [ "$#" -lt 2 ]; then
						usage "No argument given for '--$arg' option"
					fi
					optimization="$1"
					shift ;;
				disable-bc) dc_only=1 ;;
				disable-dc) bc_only=1 ;;
				disable-extra-math) extra_math=0 ;;
				disable-generated-tests) generate_tests=0 ;;
				disable-history) hist=0 ;;
				disable-man-pages) install_manpages=0 ;;
				disable-nls) nls=0 ;;
				disable-signal-handling) signals=0 ;;
				help* | bc-only* | dc-only* | coverage* | debug*)
					usage "No arg allowed for --$arg option" ;;
				disable-bc* | disable-dc* | disable-extra-math*)
					usage "No arg allowed for --$arg option" ;;
				disable-generated-tests* | disable-history*)
					usage "No arg allowed for --$arg option" ;;
				disable-man-pages* | disable-nls* | disable-signal-handling*)
					usage "No arg allowed for --$arg option" ;;
				'') break ;; # "--" terminates argument processing
				* ) usage "Invalid option" ;;
			esac ;;
		?) usage "Invalid option" ;;
	esac

	shift

done

if [ "$bc_only" -eq 1 -a "$dc_only" -eq 1 ]; then
	usage "Can only specify one of -b(-D) or -d(-B)"
fi

case $karatsuba_len in
	(*[!0-9]*|'') usage "KARATSUBA_LEN is not a number" ;;
	(*) ;;
esac

if [ "$karatsuba_len" -lt 16 ]; then
	usage "KARATSUBA_LEN is less than 16"
fi

set -e

link="@printf 'No link necessary\\\\n'"
main_exec="BC"
executable="BC_EXEC"

bc_test="@tests/all.sh bc $extra_math 1 $generate_tests \$(BC_EXEC)"
dc_test="@tests/all.sh dc $extra_math 1 $generate_tests \$(DC_EXEC)"

timeconst="@tests/bc/timeconst.sh tests/bc/scripts/timeconst.bc \$(BC_EXEC)"

# In order to have cleanup at exit, we need to be in
# debug mode, so don't run valgrind without that.
if [ "$debug" -ne 0 ]; then
	vg_bc_test="@tests/all.sh bc $extra_math 1 $generate_tests valgrind \$(VALGRIND_ARGS) \$(BC_EXEC)"
	vg_dc_test="@tests/all.sh dc $extra_math 1 $generate_tests valgrind \$(VALGRIND_ARGS) \$(DC_EXEC)"
else
	vg_bc_test="@printf 'Cannot run valgrind without debug flags\\\\n'"
	vg_dc_test="@printf 'Cannot run valgrind without debug flags\\\\n'"
fi

karatsuba="@printf 'karatsuba cannot be run because one of bc or dc is not built\\\\n'"
karatsuba_test="@printf 'karatsuba cannot be run because one of bc or dc is not built\\\\n'"

bc_lib="\$(GEN_DIR)/lib.o"
bc_help="\$(GEN_DIR)/bc_help.o"
dc_help="\$(GEN_DIR)/dc_help.o"

if [ "$bc_only" -eq 1 ]; then

	bc=1
	dc=0

	dc_help=""

	executables="bc"

	dc_test="@printf 'No dc tests to run\\\\n'"
	vg_dc_test="@printf 'No dc tests to run\\\\n'"

	install_prereqs=" install_bc_manpage"
	uninstall_prereqs=" uninstall_bc"
	uninstall_man_prereqs=" uninstall_bc_manpage"

elif [ "$dc_only" -eq 1 ]; then

	bc=0
	dc=1

	bc_lib=""
	bc_help=""

	executables="dc"

	main_exec="DC"
	executable="DC_EXEC"

	bc_test="@printf 'No bc tests to run\\\\n'"
	vg_bc_test="@printf 'No bc tests to run\\\\n'"

	timeconst="@printf 'timeconst cannot be run because bc is not built\\\\n'"

	install_prereqs=" install_dc_manpage"
	uninstall_prereqs=" uninstall_dc"
	uninstall_man_prereqs=" uninstall_dc_manpage"

else

	bc=1
	dc=1

	executables="bc and dc"

	link="\$(LINK) \$(BIN) \$(EXEC_PREFIX)\$(DC)"

	karatsuba="@\$(KARATSUBA) 0 \$(BC_EXEC)"
	karatsuba_test="@\$(KARATSUBA) 100 \$(BC_EXEC)"

	install_prereqs=" install_bc_manpage install_dc_manpage"
	uninstall_prereqs=" uninstall_bc uninstall_dc"
	uninstall_man_prereqs=" uninstall_bc_manpage uninstall_dc_manpage"

fi

if [ -z "$HOSTCFLAGS" -a -z "$HOST_CFLAGS" ]; then
	HOSTCFLAGS="$CFLAGS"
elif [ -z "$HOSTCFLAGS" ]; then
	HOSTCFLAGS="$HOST_CFLAGS"
fi

if [ "$debug" -eq 1 ]; then

	if [ -z "$CFLAGS" -a -z "$optimization" ]; then
		CFLAGS="-O0"
	fi

	CFLAGS="$CFLAGS -g"

else
	CPPFLAGS="$CPPFLAGS -DNDEBUG"
	LDFLAGS="$LDFLAGS -s"
fi

if [ -n "$optimization" ]; then
	CFLAGS="$CFLAGS -O$optimization"
fi

if [ "$coverage" -eq 1 ]; then

	if [ "$bc_only" -eq 1 -o "$dc_only" -eq 1 ]; then
		usage "Can only specify -c without -b or -d"
	fi

	CFLAGS="$CFLAGS -fprofile-arcs -ftest-coverage -g -O0"
	CPPFLAGS="$CPPFLAGS -DNDEBUG"

	COVERAGE="@gcov -pabcdf \$(GCDA) \$(BC_GCDA) \$(DC_GCDA)"
	COVERAGE="$COVERAGE;\$(RM) -f \$(GEN)*.gc*"
	COVERAGE="$COVERAGE;gcovr --html-details --output index.html"
	COVERAGE_PREREQS=" test"

else
	COVERAGE="@printf 'Coverage not generated\\\\n'"
	COVERAGE_PREREQS=""
fi

if [ -z "${DESTDIR+set}" ]; then
	destdir=""
else
	destdir="DESTDIR = $DESTDIR"
fi

if [ -z "$PREFIX" ]; then
	PREFIX="/usr/local"
fi

if [ -z "$BINDIR" ]; then
	BINDIR="$PREFIX/bin"
fi

if [ "$install_manpages" -ne 0 -o "$nls" -ne 0 ]; then
	if [ -z "$DATAROOTDIR" ]; then
		DATAROOTDIR="$PREFIX/share"
	fi
fi

if [ "$nls" -ne 0 ]; then

	if [ -z "$LOCALEDIR" ]; then
		LOCALEDIR="$DATAROOTDIR/locale"
	fi

	install_locales_prereqs=" install_locales"
	uninstall_locales_prereqs=" uninstall_locales"
else
	install_locales_prereqs=""
	uninstall_locales_prereqs=""
fi

if [ "$install_manpages" -ne 0 ]; then

	if [ -z "$DATADIR" ]; then
		DATADIR="$DATAROOTDIR"
	fi

	if [ -z "$MANDIR" ]; then
		MANDIR="$DATADIR/man"
	fi

	if [ -z "$MAN1DIR" ]; then
		MAN1DIR="$MANDIR/man1"
	fi

else
	install_prereqs=""
	uninstall_man_prereqs=""
fi

if [ -z "$CC" ]; then
	CC="c99"
fi

if [ -z "$HOSTCC" -a -z "$HOST_CC" ]; then
	HOSTCC="$CC"
elif [ -z "$HOSTCC" ]; then
	HOSTCC="$HOST_CC"
fi

if [ "$nls" -eq 1 ]; then

	set +e

	printf 'Testing NLS...\n'

	flags="-DBC_ENABLE_NLS=1 -DBC_ENABLED=$bc -DDC_ENABLED=$dc -DBC_ENABLE_SIGNALS=$signals"
	flags="$flags -DBC_ENABLE_HISTORY=$hist"
	flags="$flags -DBC_ENABLE_EXTRA_MATH=$extra_math -I./include/"
	flags="$flags -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700"

	"$CC" $CFLAGS $flags -c "src/vm.c" -o "$scriptdir/vm.o" > /dev/null 2>&1

	err="$?"

	rm -rf "$scriptdir/vm.o"

	# If this errors, it is probably because of building on Windows,
	# and NLS is not supported on Windows, so disable it.
	if [ "$err" -ne 0 ]; then
		printf 'NLS does not work.\n'
		printf 'Disabling NLS...\n'
		nls=0
	else
		printf 'NLS works.\n\n'

		if [ "$HOSTCC" != "$CC" ]; then
			printf 'Cross-compile detected.\n\n'
			printf 'WARNING: Catalog files generated with gencat may not be portable\n'
			printf '         across different architectures.\n\n'
		fi

		printf 'Testing gencat...\n'
		gencat "$scriptdir/en.cat" "$scriptdir/locales/en.msg" > /dev/null 2>&1

		err="$?"

		rm -rf "$scriptdir/en.cat"

		if [ "$err" -ne 0 ]; then
			printf 'gencat does not work.\n'
			printf 'Disabling NLS...\n\n'
			nls=0
		else
			printf 'gencat works.\n\n'
		fi

	fi

	set -e

fi

if [ "$hist" -eq 1 ]; then

	set +e

	printf 'Testing history...\n'

	flags="-DBC_ENABLE_HISTORY=1 -DBC_ENABLED=$bc -DDC_ENABLED=$dc -DBC_ENABLE_SIGNALS=$signals"
	flags="$flags -DBC_ENABLE_NLS=$nls"
	flags="$flags -DBC_ENABLE_EXTRA_MATH=$extra_math -I./include/"
	flags="$flags -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700"

	"$CC" $CFLAGS $flags -c "src/history/history.c" -o "$scriptdir/vm.o" > /dev/null 2>&1

	err="$?"

	rm -rf "$scriptdir/history.o"

	# If this errors, it is probably because of building on Windows,
	# and history is not supported on Windows, so disable it.
	if [ "$err" -ne 0 ]; then
		printf 'History does not work.\n'
		printf 'Disabling history...\n'
		hist=0
	else
		printf 'History works.\n'
	fi

	set -e

fi

if [ "$extra_math" -eq 1 -a "$bc" -ne 0 ]; then
	BC_LIB2_O="\$(GEN_DIR)/lib2.o"
else
	BC_LIB2_O=""
fi

# Print out the values; this is for debugging.
printf '\n'
if [ "$bc" -ne 0 ]; then
	printf 'Building bc\n'
else
	printf 'Not building bc\n'
fi
if [ "$dc" -ne 0 ]; then
	printf 'Building dc\n'
else
	printf 'Not building dc\n'
fi
printf '\n'
printf 'BC_ENABLE_SIGNALS=%s\n' "$signals"
printf 'BC_ENABLE_HISTORY=%s\n' "$hist"
printf 'BC_ENABLE_EXTRA_MATH=%s\n' "$extra_math"
printf 'BC_ENABLE_NLS=%s\n' "$nls"
printf '\n'
printf 'CC=%s\n' "$CC"
printf 'CFLAGS=%s\n' "$CFLAGS"
printf 'HOSTCC=%s\n' "$HOSTCC"
printf 'HOSTCFLAGS=%s\n' "$HOSTCFLAGS"
printf 'CPPFLAGS=%s\n' "$CPPFLAGS"
printf 'LDFLAGS=%s\n' "$LDFLAGS"
printf 'PREFIX=%s\n' "$PREFIX"
printf 'BINDIR=%s\n' "$BINDIR"
printf 'DATAROOTDIR=%s\n' "$DATAROOTDIR"
printf 'DATADIR=%s\n' "$DATADIR"
printf 'MANDIR=%s\n' "$MANDIR"
printf 'MAN1DIR=%s\n' "$MAN1DIR"
printf 'LOCALEDIR=%s\n' "$LOCALEDIR"
printf 'EXECSUFFIX=%s\n' "$EXECSUFFIX"
printf 'EXECPREFIX=%s\n' "$EXECPREFIX"
printf 'DESTDIR=%s\n' "$DESTDIR"
printf 'GEN_EMU=%s\n' "$GEN_EMU"

contents=$(cat "$scriptdir/Makefile.in")

needle="WARNING"
replacement='*** WARNING: Autogenerated from Makefile.in. DO NOT MODIFY ***'

contents=$(replace "$contents" "$needle" "$replacement")

contents=$(gen_file_lists "$contents" "$scriptdir/src" "")
contents=$(gen_file_lists "$contents" "$scriptdir/src/bc" "BC_" "$bc")
contents=$(gen_file_lists "$contents" "$scriptdir/src/dc" "DC_" "$dc")
contents=$(gen_file_lists "$contents" "$scriptdir/src/history" "HISTORY_" "$hist")

contents=$(replace "$contents" "BC_ENABLED" "$bc")
contents=$(replace "$contents" "DC_ENABLED" "$dc")
contents=$(replace "$contents" "LINK" "$link")

contents=$(replace "$contents" "SIGNALS" "$signals")
contents=$(replace "$contents" "HISTORY" "$hist")
contents=$(replace "$contents" "EXTRA_MATH" "$extra_math")
contents=$(replace "$contents" "NLS" "$nls")
contents=$(replace "$contents" "BC_LIB_O" "$bc_lib")
contents=$(replace "$contents" "BC_HELP_O" "$bc_help")
contents=$(replace "$contents" "DC_HELP_O" "$dc_help")
contents=$(replace "$contents" "BC_LIB2_O" "$BC_LIB2_O")
contents=$(replace "$contents" "KARATSUBA_LEN" "$karatsuba_len")

contents=$(replace "$contents" "LOCALEDIR" "$LOCALEDIR")
contents=$(replace "$contents" "DESTDIR" "$destdir")
contents=$(replace "$contents" "EXECSUFFIX" "$EXECSUFFIX")
contents=$(replace "$contents" "EXECPREFIX" "$EXECPREFIX")
contents=$(replace "$contents" "BINDIR" "$BINDIR")
contents=$(replace "$contents" "MAN1DIR" "$MAN1DIR")
contents=$(replace "$contents" "CFLAGS" "$CFLAGS")
contents=$(replace "$contents" "HOSTCFLAGS" "$HOSTCFLAGS")
contents=$(replace "$contents" "CPPFLAGS" "$CPPFLAGS")
contents=$(replace "$contents" "LDFLAGS" "$LDFLAGS")
contents=$(replace "$contents" "CC" "$CC")
contents=$(replace "$contents" "HOSTCC" "$HOSTCC")
contents=$(replace "$contents" "COVERAGE" "$COVERAGE")
contents=$(replace "$contents" "COVERAGE_PREREQS" "$COVERAGE_PREREQS")
contents=$(replace "$contents" "INSTALL_PREREQS" "$install_prereqs")
contents=$(replace "$contents" "INSTALL_LOCALES_PREREQS" "$install_locales_prereqs")
contents=$(replace "$contents" "UNINSTALL_MAN_PREREQS" "$uninstall_man_prereqs")
contents=$(replace "$contents" "UNINSTALL_PREREQS" "$uninstall_prereqs")
contents=$(replace "$contents" "UNINSTALL_LOCALES_PREREQS" "$uninstall_locales_prereqs")

contents=$(replace "$contents" "EXECUTABLES" "$executables")
contents=$(replace "$contents" "MAIN_EXEC" "$main_exec")
contents=$(replace "$contents" "EXEC" "$executable")

contents=$(replace "$contents" "BC_TEST" "$bc_test")
contents=$(replace "$contents" "DC_TEST" "$dc_test")

contents=$(replace "$contents" "VG_BC_TEST" "$vg_bc_test")
contents=$(replace "$contents" "VG_DC_TEST" "$vg_dc_test")

contents=$(replace "$contents" "TIMECONST" "$timeconst")

contents=$(replace "$contents" "KARATSUBA" "$karatsuba")
contents=$(replace "$contents" "KARATSUBA_TEST" "$karatsuba_test")

contents=$(replace "$contents" "GEN_EMU" "$GEN_EMU")

printf '%s\n' "$contents" > "$scriptdir/Makefile"

cd "$scriptdir"

make clean > /dev/null
