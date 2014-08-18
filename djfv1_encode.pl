#!/usr/bin/env perl

use strict;
use warnings;

use 5.014;

# CPAN
use Digest::MD5 qw(md5);

# This plus 16 byte hash means 23 byte sections!
use constant CHUNK_SIZE => 7;

sub make_checksum;
sub make_encoded_data;

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
  my $chunk;
  my $bytes_read =  read($in_file, $chunk, CHUNK_SIZE) // die "Error reading $in_path: $!\n";
  last if ($bytes_read == 0);

  my $encoded_data = make_encoded_data($chunk);
  my $section = make_checksum($chunk) . $encoded_data;

  print $out_file $section;
  
  last if ($bytes_read < CHUNK_SIZE);
}

sub make_checksum()
{
  my $encoded_data = shift;

  return md5($encoded_data);
}

sub make_encoded_data()
{
  my $data = shift;

  my @encoded_data = sort(split('', $data));

  return join('', @encoded_data);
}
