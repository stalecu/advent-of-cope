#!/usr/bin/env perl
use v5.40;
use List::Util qw/any sum/;

sub calc( $input, $mode ) {
    my $total      = 0;
    my $is_enabled = 1;

    while ( $input =~ /(do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))/g ) {
        my $match = $1;

        if ( $mode == 2 ) {
            $is_enabled = 1 if $match eq 'do()';
            $is_enabled = 0 if $match eq "don't()";
        }

        if ( $is_enabled && $match =~ /^mul\((\d{1,3}),(\d{1,3})\)$/ ) {
            $total += $1 * $2;
        }
    }

    return $total;
}

sub solve ($input) {
    return ( calc( $input, 1 ), calc( $input, 2 ) );
}

my $file = $ARGV[0] or die "Usage: $0 <input_files>\n";
open my $fh, '<', $file or die "Cannot open file '$file': $!\n";
my $input_text = do { local $/; <$fh> };
close $fh;

die "Input file is empty or invalid." unless $input_text =~ /\S/;

say for solve($input_text);
