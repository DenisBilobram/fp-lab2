defmodule DictionaryProject do

  @moduledoc false

  alias __MODULE__.BST

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
