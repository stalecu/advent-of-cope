use v5.40;
use List::Util 'reduce', 'zip';

my @left;
my @right;

open DATA, q|inputs/input| or die "Cannot open file: $!";
while (<DATA>) {
    chomp;
    my @line = split /\s+/;
    push @left,  $line[0];
    push @right, $line[1];
}

my @sorted = sort { $a->[0] <=> $b->[0] } map { [ $_->[0], $_->[1] ] } zip(\@left, \@right);

my $part_1 = reduce { $a + abs($b->[0] - $b->[1]) } @sorted;

my %right_counts = map { $_ => 0 } @right;
$right_counts{$_}++ for @right;
my $part_2 = reduce { $a + $b * ($right_counts{$b} // 0) } 0, @left;

say "Part 1: $part_1";
say "Part 2: $part_2";

close DATA;
