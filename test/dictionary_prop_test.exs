Code.require_file("generators.ex", __DIR__)

defmodule DictionaryProjectPropCheckTest do
  use ExUnit.Case
  alias DictionaryProject
  alias DictionaryProject.BST

  import Generators

  @num_tests 50

  test "add/2 is associative (monoid property)" do
    for _ <- 1..@num_tests do
      tree_a = bst_gen()
      tree_b = bst_gen()
      tree_c = bst_gen()

      left = DictionaryProject.add(DictionaryProject.add(tree_a, tree_b), tree_c)
      right = DictionaryProject.add(tree_a, DictionaryProject.add(tree_b, tree_c))

      assert trees_content_equal?(left, right)
    end
  end

  test "nil is the identity element for add/2 (monoid property)" do
    for _ <- 1..@num_tests do
      tree = bst_gen()

      left = DictionaryProject.add(nil, tree)
      right = DictionaryProject.add(tree, nil)

      assert trees_equal?(left, tree)
      assert trees_equal?(right, tree)
    end
  end

  test "filter/2 with a predicate always returning true returns the original tree" do
    for _ <- 1..@num_tests do
      tree = bst_gen()
      filtered_tree = DictionaryProject.filter(tree, fn _ -> true end)

      assert trees_equal?(filtered_tree, tree)
    end
  end

  defp trees_equal?(nil, nil), do: true

  defp trees_equal?(%BST{key: k1, value: v1, left: l1, right: r1},
                    %BST{key: k2, value: v2, left: l2, right: r2}) do
    k1 == k2 and v1 == v2 and trees_equal?(l1, l2) and trees_equal?(r1, r2)
  end

  defp trees_equal?(_, _), do: false

  defp collect_pairs(nil), do: []

  defp collect_pairs(%BST{key: key, value: value, left: left, right: right}) do
    [{key, value} | collect_pairs(left) ++ collect_pairs(right)]
  end

  defp trees_content_equal?(tree1, tree2) do
    pairs1 = collect_pairs(tree1) |> MapSet.new()
    pairs2 = collect_pairs(tree2) |> MapSet.new()
    MapSet.equal?(pairs1, pairs2)
  end
end
