/*
 * *****************************************************************************
 *
 * Copyright 2018 Gavin D. Howard
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 * *****************************************************************************
 *
 * The main procedure of dc.
 *
 */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <status.h>
#include <vector.h>
#include <dc.h>
#include <vm.h>
#include <args.h>

#if DC_ENABLED
int dc_main(int argc, char *argv[]) {

	bcg.bc = false;
	bcg.name = dc_name;
	bcg.help = dc_help;
#if BC_ENABLE_SIGNALS
	bcg.sig_msg = dc_sig_msg;
#endif // BC_ENABLE_SIGNALS

	bcg.init = dc_parse_init;
	bcg.exp = dc_parse_expr;
	bcg.sbgn = '[';
	bcg.send = ']';

	return (int) bc_vm_run(argc, argv, "DC_LINE_LENGTH");
}
#endif // DC_ENABLED
