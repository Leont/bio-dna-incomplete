package Bio::DNA::Incomplete;
use strict;
use warnings;

use Carp 'croak';
use Sub::Exporter -setup => { exports => [qw/pattern_to_regex pattern_to_regex_string match_pattern all_possibilities/], groups => { default => [qw/pattern_to_regex pattern_to_regex_string match_pattern all_possibilities/]} };

my %simple = map { ( $_ => $_ ) } qw/A C G T/;

my %meaning_of = (
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
my %pattern_for = %meaning_of;
$_ = "[$_]" for values %pattern_for;
my ($invalid) = map { qr/[^$_]/ } join '', keys %simple, keys %pattern_for;
my %bases_for = (%meaning_of, %simple);
$_ = [ split // ] for values %bases_for;

sub pattern_to_regex_string {
	my $pattern = uc shift;
	croak 'Invalid pattern' if $pattern =~ /$invalid/;

	$pattern =~ s/([^ATCG])/$pattern_for{$1}/g;
	return "(?i:$pattern)";
}

sub pattern_to_regex {
	my $pattern = uc shift;
	my $string = pattern_to_regex_string($pattern);
	return qr/$string/;
};

sub match_pattern {
	my ($pattern, @args) = @_;
    my $regex = pattern_to_regex($pattern);
    return grep { $_ =~ /\A $regex \z/xms } @args;
}

sub _all_possibilities {
	my ($current, @rest) = @_;
	if (@rest) {
		my @ret;
		my $pretail = _all_possibilities(@rest);
		for my $head (@{$bases_for{$current}}) {
			for my $tail (@{$pretail}) {
				push @ret, $head.$tail;
			}
		}
		return \@ret;
	}
	else {
		return $bases_for{$current};
	}
}

sub all_possibilities {
    my $pattern = uc shift;
	my @bases = split //, $pattern;
	return @{ _all_possibilities(@bases) };
}

1;

#ABSTRACT: Match incompletely specified bases in nucleic acid sequences

__END__

=func match_pattern($pattern, @things_to_test)

Returns the list of sequences that match C<$pattern>.

=func pattern_to_regex($pattern)

Returns a compiled regex which is the equivalent of the pattern.

=func pattern_to_regex_string($pattern)

Returns a regex string which is the equivalent of the pattern.

=func all_possibilities($pattern)

Returns a list of all possible sequences that can match the pattern.

=head1 SEE ALSO

=over 1

=item * Text::Glob

=back
