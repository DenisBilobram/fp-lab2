Code.require_file("generators.ex", __DIR__)

defmodule DictionaryProjectTest do
  use ExUnit.Case
  alias DictionaryProject
  alias DictionaryProject.BST

  describe "insert/3 and get/2" do
    test "insert into an empty tree" do
      tree = DictionaryProject.insert(nil, 5, "five")
      assert %BST{key: 5, value: "five"} = tree
    end

    test "insert multiple keys and retrieve them" do
      tree = nil
      tree = DictionaryProject.insert(tree, 5, "five")
      tree = DictionaryProject.insert(tree, 3, "three")
      tree = DictionaryProject.insert(tree, 7, "seven")

      assert DictionaryProject.get(tree, 5) == "five"
      assert DictionaryProject.get(tree, 3) == "three"
      assert DictionaryProject.get(tree, 7) == "seven"
    end

    test "update existing key" do
      tree = DictionaryProject.insert(nil, 5, "five")
      tree = DictionaryProject.insert(tree, 5, "updated five")

      assert DictionaryProject.get(tree, 5) == "updated five"
    end
  end

  describe "delete/2" do
    test "delete a leaf node" do
      tree = nil
      tree = DictionaryProject.insert(tree, 5, "five")
      tree = DictionaryProject.insert(tree, 3, "three")
      tree = DictionaryProject.delete(tree, 3)

      assert DictionaryProject.get(tree, 3) == nil
      assert DictionaryProject.get(tree, 5) == "five"
    end

    test "delete node with one child" do
      tree = nil
      tree = DictionaryProject.insert(tree, 5, "five")
      tree = DictionaryProject.insert(tree, 3, "three")
      tree = DictionaryProject.insert(tree, 2, "two")
      tree = DictionaryProject.delete(tree, 3)

      assert DictionaryProject.get(tree, 3) == nil
      assert DictionaryProject.get(tree, 2) == "two"
    end

    test "delete node with two children" do
      tree = nil
      tree = DictionaryProject.insert(tree, 5, "five")
      tree = DictionaryProject.insert(tree, 3, "three")
      tree = DictionaryProject.insert(tree, 4, "four")
      tree = DictionaryProject.insert(tree, 2, "two")
      tree = DictionaryProject.delete(tree, 3)

      assert DictionaryProject.get(tree, 3) == nil
      assert DictionaryProject.get(tree, 2) == "two"
      assert DictionaryProject.get(tree, 4) == "four"
    end

    test "delete root node" do
      tree = DictionaryProject.insert(nil, 5, "five")
      tree = DictionaryProject.delete(tree, 5)

      assert tree == nil
    end
  end

  describe "add/2" do
    test "add two trees without overlapping keys" do
      tree1 = nil
      tree1 = DictionaryProject.insert(tree1, 1, "one")
      tree1 = DictionaryProject.insert(tree1, 2, "two")

      tree2 = nil
      tree2 = DictionaryProject.insert(tree2, 3, "three")
      tree2 = DictionaryProject.insert(tree2, 4, "four")

      merged_tree = DictionaryProject.add(tree1, tree2)

      assert DictionaryProject.get(merged_tree, 1) == "one"
      assert DictionaryProject.get(merged_tree, 2) == "two"
      assert DictionaryProject.get(merged_tree, 3) == "three"
      assert DictionaryProject.get(merged_tree, 4) == "four"
    end

    test "add two trees with overlapping keys" do
      tree1 = nil
      tree1 = DictionaryProject.insert(tree1, 2, "two from tree1")
      tree1 = DictionaryProject.insert(tree1, 4, "four from tree1")

      tree2 = nil
      tree2 = DictionaryProject.insert(tree2, 2, "two from tree2")
      tree2 = DictionaryProject.insert(tree2, 3, "three from tree2")

      merged_tree = DictionaryProject.add(tree1, tree2)

      assert DictionaryProject.get(merged_tree, 2) == "two from tree2"
      assert DictionaryProject.get(merged_tree, 3) == "three from tree2"
      assert DictionaryProject.get(merged_tree, 4) == "four from tree1"
    end
  end

  describe "map/2" do
    test "apply function to all values" do
      tree = nil
      tree = DictionaryProject.insert(tree, 1, 10)
      tree = DictionaryProject.insert(tree, 2, 20)
      tree = DictionaryProject.insert(tree, 3, 30)

      mapped_tree = DictionaryProject.map(tree, fn x -> x * 2 end)

      assert DictionaryProject.get(mapped_tree, 1) == 20
      assert DictionaryProject.get(mapped_tree, 2) == 40
      assert DictionaryProject.get(mapped_tree, 3) == 60
    end
  end

  describe "foldl/3" do
    test "sum all values using foldl" do
      tree = nil
      tree = DictionaryProject.insert(tree, 1, 1)
      tree = DictionaryProject.insert(tree, 2, 2)
      tree = DictionaryProject.insert(tree, 3, 3)

      sum = DictionaryProject.foldl(tree, 0, fn value, acc -> value + acc end)

      assert sum == 6
    end
  end

  describe "foldr/3" do
    test "concatenate values using foldr" do
      tree = nil
      tree = DictionaryProject.insert(tree, 1, "a")
      tree = DictionaryProject.insert(tree, 2, "b")
      tree = DictionaryProject.insert(tree, 3, "c")

      result = DictionaryProject.foldr(tree, "", fn value, acc -> acc <> value end)

      assert result == "cba"
    end
  end

  describe "filter/2" do
    test "filter out values less than 15" do
      tree = nil
      tree = DictionaryProject.insert(tree, 1, 10)
      tree = DictionaryProject.insert(tree, 2, 15)
      tree = DictionaryProject.insert(tree, 3, 20)

      filtered_tree = DictionaryProject.filter(tree, fn value -> value >= 15 end)

      assert DictionaryProject.get(filtered_tree, 1) == nil
      assert DictionaryProject.get(filtered_tree, 2) == 15
      assert DictionaryProject.get(filtered_tree, 3) == 20
    end
  end

end
