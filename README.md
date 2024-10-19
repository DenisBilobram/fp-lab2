# fp-lab-2

* Билобрам Денис Андреевич, P3319
* Вариант: bt-dict (Словарь на бинарном дереве)

# Структура с необходимыми функциями

``` elixir
defmodule DictionaryProject.BST do
  defstruct key: nil, value: nil, left: nil, right: nil
end

defmodule DictionaryProject do

  def insert(nil, key, value) do
    %BST{key: key, value: value}
  end

  def insert(%BST{key: k, left: left, right: right} = node, key, value) do
    cond do
      key < k ->
        %{node | left: insert(left, key, value)}
      key > k ->
        %{node | right: insert(right, key, value)}
      true ->
        %{node | value: value}
    end
  end

  def get(nil, _key), do: nil

  def get(%BST{key: k, value: v, left: left, right: right}, key) do
    cond do
      key == k ->
        v
      key < k ->
        get(left, key)
      key > k ->
        get(right, key)
    end
  end

  def delete(nil, _key), do: nil

  def delete(%BST{key: k, left: left, right: right} = node, key) do
    cond do
      key < k ->
        %{node | left: delete(left, key)}
      key > k ->
        %{node | right: delete(right, key)}
      true ->
        remove_node(node)
    end
  end

  defp remove_node(%BST{left: nil, right: nil}), do: nil
  defp remove_node(%BST{left: nil, right: right}), do: right
  defp remove_node(%BST{left: left, right: nil}), do: left
  defp remove_node(%BST{left: _left, right: right} = node) do
    {min_key, min_value} = find_min(right)
    %{node | key: min_key, value: min_value, right: delete(right, min_key)}
  end

  defp find_min(%BST{key: k, value: v, left: nil}), do: {k, v}
  defp find_min(%BST{left: left}), do: find_min(left)

  def add(nil, tree), do: tree
  def add(tree, nil), do: tree

  def add(%BST{key: k1, value: v1, left: l1, right: r1},
          %BST{key: k2, value: v2, left: l2, right: r2} = tree2) do
    cond do
      k1 == k2 ->
        new_value = merge_values(v1, v2)
        %BST{
          key: k1,
          value: new_value,
          left: add(l1, l2),
          right: add(r1, r2)
        }
      k2 < k1 ->
        %BST{
          key: k1,
          value: v1,
          left: add(l1, tree2),
          right: r1
        }
      k2 > k1 ->
        %BST{
          key: k1,
          value: v1,
          left: l1,
          right: add(r1, tree2)
        }
    end
  end

  defp merge_values(_v1, v2) do
    v2
  end

  def map(nil, _func) do
    nil
  end
  def map(%BST{} = node, func) when is_function(func, 1) do
    %BST{node | value: func.(node.value), left: map(node.left, func), right: map(node.right, func)}
  end

  def foldl(nil, acc, _func), do: acc

  def foldl(%BST{left: left, value: value, right: right}, acc, func) do
    acc = foldl(left, acc, func)
    acc = func.(value, acc)
    foldl(right, acc, func)
  end

  def foldr(nil, acc, _func), do: acc

  def foldr(%BST{left: left, value: value, right: right}, acc, func) do
    acc = foldr(right, acc, func)
    acc = func.(value, acc)
    foldr(left, acc, func)
  end

  def filter(tree, _func) when tree == nil do
    nil
  end

  def filter(%BST{key: key, value: value, left: left, right: right}, filter_func) when is_function(filter_func, 1) do
    filtered_left = filter(left, filter_func)
    filtered_right = filter(right, filter_func)

    if filter_func.(value) do
      %BST{
        key: key,
        value: value,
        left: filtered_left,
        right: filtered_right
      }
    else
      merge_trees(filtered_left, filtered_right)
    end
  end

  defp merge_trees(nil, right), do: right
  defp merge_trees(left, nil), do: left
  defp merge_trees(left, right) do
    {min_key, min_value} = find_min(right)
    new_right = delete(right, min_key)
    %BST{
      key: min_key,
      value: min_value,
      left: left,
      right: new_right
    }
  end

end
```

# Тесты

## Unit-тесты

``` elixir
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
```

## Property-based тесты

``` elixir
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
```