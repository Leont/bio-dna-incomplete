#! perl

use strict;
use warnings;

use Test::More 0.88;

use Bio::DNA::Incomplete -all;

ok(match_pattern("ACGT", "ACGT"));
ok(match_pattern("ACKT", "ACGT"));
ok(!match_pattern("KCKT", "ACGT"));
ok(!match_pattern("ACKT", "ACGT "));

done_testing;
