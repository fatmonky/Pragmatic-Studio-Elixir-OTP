
# Practice 5 Apr 235pm: completely failed to compile.
defmodule Recurse do

  def my_map([head | tail], func) do
    #IO.puts "Head: #{head}, Tail: #{inspect(tail)}"
    [func.(head) | my_map(tail, func)] # had right idea of calling func on head, but typed func(head) instead of this. Also missed out func in my_map(tail, func)
  end

  def my_map([], _func), do: [] # missed out on _ 

end

IO.inspect Recurse.my_map([1,2,3,4,5], &(&1 * 2))
