use v5.40;
use List::Util 'reduce';

my @left;
my @right;

open DATA, q|../inputs/input|;
while (<DATA>) {
    chomp;
    my @line = split /\s+/, $_;
    push @left,  $line[0];
    push @right, $line[1];
}

@left  = sort { $a <=> $b } @left;
@right = sort { $a <=> $b } @right;

my $part_1 = reduce { $a + abs( $left[$b] - $right[$b] ) } 0 .. $#left;

my %right_counts = map { $_ => 0 } @right;
$right_counts{$_}++ for @right;

my $part_2 = reduce { $a + $b * ( $right_counts{$b} // 0 ) } 0, @left;

say "Part 1: $part_1";
say "Part 2: $part_2";