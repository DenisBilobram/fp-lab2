defmodule Generators do

  @moduledoc false

  def key_gen do
    :rand.uniform(2_000_001) - 1_000_001
  end

  def value_gen do
    length = :rand.uniform(10)
    chars = for _ <- 1..length, do: :rand.uniform(0x10FFFF)
    :unicode.characters_to_binary(chars)
  end

  def bst_gen(max_depth \\ 3) do
    bst_gen(:min_value, :max_value, max_depth)
  end

  defp bst_gen(_min, _max, 0) do
    nil
  end

  defp bst_gen(min, max, depth) when depth > 0 do
    case key_in_range(min, max) do
      :empty -> nil
      key ->
        value = value_gen()
        left = bst_gen(min, key, depth - 1)
        right = bst_gen(key, max, depth - 1)
        %DictionaryProject.BST{
          key: key,
          value: value,
          left: left,
          right: right
        }
    end
  end

  defp key_in_range(:min_value, :max_value) do
    key_gen()
  end

  defp key_in_range(:min_value, max) when is_integer(max) do
    max_value = max - 1
    if max_value < -1_000_000 do
      :empty
    else
      :rand.uniform(max_value + 1_000_001) - 1_000_001
    end
  end

  defp key_in_range(min, :max_value) when is_integer(min) do
    min_value = min + 1
    if min_value > 1_000_000 do
      :empty
    else
      :rand.uniform(1_000_000 - min_value + 1) + min_value - 1
    end
  end

  defp key_in_range(min, max) when is_integer(min) and is_integer(max) and min < max - 1 do
    min_value = min + 1
    max_value = max - 1
    :rand.uniform(max_value - min_value + 1) + min_value - 1
  end

  defp key_in_range(_, _), do: :empty
end
