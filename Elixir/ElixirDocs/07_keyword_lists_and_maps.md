# Keyword Lists and Maps

Two main associative data structures.

## Keyword Lists

List of tuples, where the first element in the tuple is a symbol.

```elixir
keyword_list = [{:name, "Tim"}, {:age, 123}, {:favorite_color, "blue. no, yellow!"}]

# syntactic sugar -- similar to ruby hashes
keyword_list = [name: "Tim", age: 123, favorite_color: "blue. no, yellow!"]
```

The downside is that because the tuples are in a list, access is not `O(1)`, and there is no uniqueness guarantee. However, for simple cases (e.g. named arguments) this works fine.

Note that lack of a uniqueness guarantee allows for alternative use cases, such as defining DSLs. An example is a DSL for SQL:

```elixir
# Ecto library for DB queries
query = from w in Weather,
  where: w.prcp > 0,
  where: w.temp < 20,
  select: w
```

### `if` `else`

```elixir
# macro
if cond do
  foo
else
  bar
end

# as function without macro shorthand
if cond, do: foo, else: bar

# as macro without keyword list shorthand
if cond, [do: foo, else: bar]

# sugar-free
if cond, [{ :do, foo }, { :else, bar }]
```

## Maps

Maps are "true" k-v stores. Created via `%{}`. Unlike keyword lists, any value can be used as a key, there is a uniqueness guarantee, and there is no ordering.

```elixir
map = %{ :foo => 1, :bar => 2 }
sugar_map = %{ foo: 1, bar: 2 }

# access
map.foo == 1

# types
diverse_map = %{
  1 => :integer,
  :foo => :atom,
  'foo' => :charlist,
  "foo" => :string,
}
diverse_map[1] == :integer
diverse_map.foo == :atom
diverse_map['foo'] == :charlist
```

## Contrast

### Pattern matching

Maps are better at pattern matching due to no restriction on ordering. Prior knowledge of order or amount of keys is not needed to pattern match.

Pattern matching maps is very similar to JS destructuring, with the difference that there is no "object shorthand" -- the full key must be written out.

```elixir
# errors -- expects key-value pairs in left
%{ foo, bar } = %{ foo: 1, bar: 2 }

# succeeds
%{ foo: foo, bar: bar } = %{ foo: 1, bar: 2 }
```

### Get & Set

Maps better fit the use case of getting and setting. Whereas keyword lists are primarily for function arguments, in which getting and setting basically occurs based on relative position (index), maps support get & set.

```elixir
# gets :foo strictly -- if :foo doesn't exist throws an error
my_map.foo
# my_keyword_list.foo errors

# all methods below are dynamic -- if the argument doesn't exist, returns nil

# gets "foo"
my_map["foo"]
# works, but only for atoms
my_keyword_list[:foo]

# gets whatever var foo points to (works for lists only if foo is an atom)
my_map[foo]

# functional getter
Map.get(my_map, :foo)
Keyword.get(my_arg_list, :foo)
```

```
# initializing map with variable
n = :foo
my_map = %{ n => 1 }

# "sets" :foo -- in reality "map-cons"es (whatever that means) the right value into the left map
# this only works if the right key already exists in the left map
%{ map | foo: "bar" }

# functional setter
Map.put(my_map, :foo, "value set to :foo")
Keyword.put(my_keyword_list, :foo, "bar")
# Keywords are a bit trickier -- they remove all instances of :foo and then prepend the new foo: "bar"
put_in(my_nested_map[:foo][:bar], "value") # macro
put_in(my_nested_map, [:foo, :bar], "value") # desugared
update_in(my_nested_map[:foo][:bar], fn x -> x ** 2) # takes a calback to update
```
