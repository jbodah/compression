require "algorithms"
require "tree"

module Compression
  module HuffmanEncoding
    class << self
      HeapNode = Struct.new(:freq, :char, :tree)

      def compress(string)
        tree = build_tree(string)
        dict = {}
        encoded =
          string.each_char.map do |char|
            if dict[char]
              dict[char]
            else
              encoded_char = walk_and_encode(tree, char)
              dict[char] = encoded_char
              encoded_char
            end
          end.join
        [encoded, dict]
      end

      def walk_and_encode(tree, char, acc = "")
        return acc if tree.name == char

        left = left(tree)
        return walk_and_encode(left, char, acc + "0") if left.name.include?(char)

        right = right(tree)
        return walk_and_encode(right, char, acc + "1") if right.name.include?(char)

        raise "Unexpected error!"
      end

      def left(tree)
        tree.children[0]
      end

      def right(tree)
        tree.children[1]
      end

      def build_tree(string)
        freq_map =
          string.each_char.reduce({}) do |acc, char|
            acc[char] ||= 0
            acc[char] += 1
            acc
          end

        heap = Containers::MinHeap.new
        freq_map.each do |char, freq|
          tree = Tree::TreeNode.new(char)
          heap.push(freq, HeapNode.new(freq, char, tree))
        end

        until heap.size == 1 do
          a = heap.pop
          b = heap.pop
          combined_char = a.char + b.char
          combined_freq = a.freq + b.freq
          combined_tree = Tree::TreeNode.new(combined_char)
          combined_tree << a.tree
          combined_tree << b.tree
          combined = HeapNode.new(combined_freq, combined_char, combined_tree)
          heap.push(combined_freq, combined)
        end

        heap.pop.tree
      end

      # Not efficitent, but just for testing
      # Could also use a tree instead of a dict to save some space
      def decompress(string, dict)
        inv_dict = dict.invert
        rest = string
        acc = ""
        until rest.empty? do
          k = inv_dict.keys.find { |k| rest.start_with?(k) }
          acc << inv_dict[k]
          rest = rest.sub(k, '')
        end
        acc
      end
    end
  end
end
