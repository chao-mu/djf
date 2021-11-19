DJF
===

The Dot Jif Format is an Erisian file format based on the Discordian Society Super Secret Cryptographic Cypher Code on page 00071 of the Principia Discordia. It is used to encode all manner of bytes, whether they be audio, visuals, or audiovisuals.

While the only way of decoding a DJF encoded file is through brute force, the time it takes to decode scales linearly as the data is broken into chunks.

# Usage

```
$ echo 'Inter-Office Private Wire Sent' > input.txt
$ perl djfv1_encode.pl input.txt output.jif
$ wc -c input.txt output.jif
 31 input.txt
111 output.jif
...
$ perl djfv1_decode.pl output.jif output.txt
$ cat output.txt
Inter-Office Private Wire Sent
```

# Format and Implementation

A .jif is composed of a series of sections. Each section is a MD5 hash followed by up to 7 bytes (referred to as a "chunk"). These chunks are numerically sorted (ascending) 7 byte sequences of the representeddata. All chunks leading to the last will be 7 bytes, the last one may be less if the file size is not a multiple of 7. The MD5 hash is a checksum of the bytes in their original order.

## Encoding (Pseudocode)

```
# Read up to 7 bytes
chunk = read(input_file, 7)
checksum = md5(chunk)
encoded_chunk = sort_ascending(chunk)
section = concat(chunk, encoded_chunk)
write(output_file, section)
```

## Decoding

Read each 23 byte section of the encoded file. Split the leading 16 byte checksum from the remaining chunk (maximimum of 7 bytes). Repeatedly try all permutations of bytes in the chunk until they match their respective md5 hash.

See reference implementation for code example.

# Readers

Currently the only known reader of a .jif is the decoder.

# Pronunciation

While pronunciation of the Dot Jif Format varries, the creator has come out to say publically that it is pronounced as the extension suggests, .jif.
