defmodule Example do
  alias DictionaryProject

  def run do
    tree = nil
    tree = DictionaryProject.insert(tree, 5, "five")
    tree = DictionaryProject.insert(tree, 3, "three")
    tree = DictionaryProject.insert(tree, 7, "seven")

    IO.puts(DictionaryProject.get(tree, 3))    # Вывод: "three"
    IO.puts(DictionaryProject.get(tree, 5))    # Вывод: "five"

    tree = DictionaryProject.delete(tree, 5)
    IO.inspect(DictionaryProject.get(tree, 5)) # Вывод: nil
  end
end

Example.run()
