"""
Interactive Elixir (1.18.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> add = fn(x, y) -> x + y end
#Function<41.81571850/2 in :erl_eval.expr/6>
iex(2)> add.(10, 20)
30
iex(3)> add = &x + y end
** (SyntaxError) invalid syntax found on iex:3:14:
    error: unexpected reserved word: end
    │
  3 │ add = &x + y end
    │              ^
    │
    └─ iex:3:14
    (iex 1.18.3) lib/iex/evaluator.ex:299: IEx.Evaluator.parse_eval_inspect/4
    (iex 1.18.3) lib/iex/evaluator.ex:189: IEx.Evaluator.loop/1
    (iex 1.18.3) lib/iex/evaluator.ex:34: IEx.Evaluator.init/5
    (stdlib 6.2.2) proc_lib.erl:329: :proc_lib.init_p_do_apply/3
iex(3)> add = &(&1 + &2)
&:erlang.+/2
iex(4)> add.(10, 20)
30
iex(5)> h String.duplicate

                           def duplicate(subject, n)

  @spec duplicate(t(), non_neg_integer()) :: t()

Returns a string subject repeated n times.

Inlined by the compiler.

## Examples

    iex> String.duplicate("abc", 0)
    ""

    iex> String.duplicate("abc", 1)
    "abc"

    iex> String.duplicate("abc", 2)
    "abcabc"

iex(6)> india = "In India, for everything that is true, it's opposite is also true."
"In India, for everything that is true, it's opposite is also true."
iex(7)> india_mult = fn(x) -> String.duplicate(india, x) end
#Function<42.81571850/1 in :erl_eval.expr/6>
iex(8)> india_mult.(4)
"In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true."
iex(9)> india_mult2 = &String.duplicate(india, &1)
#Function<42.81571850/1 in :erl_eval.expr/6>
iex(10)> india_mult2.(3)
"In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true."
iex(11)> india_mult3 = &String.duplicate/2
&:binary.copy/2
iex(12)> india_mult3.(3)
** (BadArityError) &:binary.copy/2 with arity 2 called with 1 argument (3)
    iex:12: (file)
iex(12)> india_mult3.(india, 3)
"In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true.In India, for everything that is true, it's opposite is also true."

"""
