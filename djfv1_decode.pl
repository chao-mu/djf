#!/usr/bin/env perl

use strict;
use warnings;

use 5.014;

# CPAN
use Digest::MD5 qw(md5);
use Algorithm::Permute;

use constant CHUNK_SIZE => 7;
use constant CHECKSUM_SIZE => 16;

sub crack;

if (@ARGV < 2)
{
  die "Usage: $0 <input file> <output file>\n"
}

my $in_path = $ARGV[0];
my $out_path = $ARGV[1];

open(my $in_file, '<', $in_path) or die "Cannot open $in_path: $!\n";
open(my $out_file, '>', $out_path) or die "Cannot open $out_path: $!\n";

while (1)
{
  my $checksum;
  my $bytes_read = read($in_file, $checksum, CHECKSUM_SIZE) // die "Error reading $in_path: $!\n";

  last if ($bytes_read == 0);

  if ($bytes_read < CHECKSUM_SIZE)
  {
    die "File ended prematurely (don't worry, it happens to a lot of men).\n";
  }

  my $encoded_data;
  $bytes_read = read($in_file, $encoded_data, CHUNK_SIZE) // die "Error reading $in_path: $!\n";

  if ($bytes_read == 0)
  {
    die "File ended prematurely (don't worry, it happens to a lot of men).\n";
  }

  print $out_file crack($encoded_data, $checksum);
}

sub crack()
{
  my $encoded_data = shift;
  my $checksum = shift;

  my $combos = Algorithm::Permute->new([split('', $encoded_data)]);
  while (my @candidate_combo = $combos->next())
  {
    my $candidate = join('', @candidate_combo);
    
    if (md5($candidate) eq $checksum)
    {
      return $candidate;
    }
  }

  die "Something went funky - the bad kind of funky. Are you sure this is a DJF?\n";
}
