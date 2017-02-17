# compression

playing around with various compression algorithms and techniques

## Usage

```
# Huffman encoding
bundle exec ruby -I. -rcompression -e 'puts Compression::HuffmanEncoding.decompress *Compression::HuffmanEncoding.compress("hello world")'
```
