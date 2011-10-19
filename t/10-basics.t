#! perl

use strict;
use warnings;

use Test::More 0.88;
use Test::Exception;

use Bio::DNA::Incomplete -all;

ok(match_pattern('ACGT', 'ACGT'),"'ACGT' matches 'ACGT'");
ok(match_pattern('ACKT', 'ACGT'), "'ACKT' matches 'ACGT'");
ok(match_pattern('ACKT', 'acgt'), "'ACKT' matches 'acgt'");
ok(match_pattern('ackt', 'ACGT'), "'ackt' matches 'ACGT'");
ok(!match_pattern('KCKT', 'ACGT'), "'KCKT' does not match 'ACGT'");
ok(!match_pattern('ACKT', 'ACGT '), "'ACKT ' does not match 'ACGT'");

throws_ok { pattern_to_regex_string("XXX") } qr/Invalid/, 'Invalid pattern gives an error';

done_testing;
