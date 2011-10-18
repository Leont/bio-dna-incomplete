package Bio::DNA::Incomplete;
use strict;
use warnings;

use Sub::Exporter -setup => { exports => [qw/pattern_to_regex pattern_to_regex_string match_pattern/], groups => { default => [qw/pattern_to_regex pattern_to_regex_string match_pattern/]} };

my %replacement = (
	R => 'AG',
	Y => 'CT',
	W => 'AT',
	S => 'CG',
	M => 'AC',
	K => 'GT',
	H => 'ACT',
	B => 'CGT',
	V => 'ACG',
	D => 'AGT',
	N => 'ACGT',
);
$_ = "[$_]" for values %replacement;
my $valid = map { qr/[^$_]/ } qw/A C G T/, keys %replacement;

sub pattern_to_regex_string {
	my $pattern = shift;
	die 'Invalid pattern' if $pattern =~ /$valid/;

	$pattern =~ s/([^ATCG])/$replacement{$1}/gi;
	return qr/$pattern/
}

sub pattern_to_regex {
	my $pattern = shift;
	my $string = pattern_to_regex_string($pattern);
	return qr/$string/;
};

sub match_pattern {
    my $pattern = shift;
    my $regex = pattern_to_regex($pattern);
    local $_;
    return grep { $_ =~ /\A $regex \z/xms } @_;
}
 

1;

__END__

#ABSTRACT: Match incompletely specified bases in nucleic acid sequences

=func match_pattern($pattern, @things_to_test)

Returns the list of sequences that match C<$pattern>.

=func pattern_to_regex

Returns a compiled regex which is the equivalent of the pattern.

=func pattern_to_regex_string

Returns a regex string which is the equivalent of the globbing pattern.

=head1 SEE ALSO

=over 1

=item * Text::Glob

=back
