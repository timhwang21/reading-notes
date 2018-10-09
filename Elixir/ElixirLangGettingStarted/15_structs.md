# Structs

Maps with compile-time checks and default values. They allow for typing and polymorphic handling of data.

```elixir
defmodule Person do
  @enforce_keys [:fname] # errors if struct is created without first name
  defstruct fname: "John", lname: "Doe", age: nil
end

structureless_user = %{fname: "foo"} # can omit last name with no issue
structured_user = %Person{fname: "foo", lname: "bar"} # will throw when unknown field occurs

# map updates with | also apply
structured_user_2 = %{structured_user | name: "foo2"} # note that we can update a plain map

# structs pattern match like maps
%Person{fname: myfname, lname: mlname} = structured_user
mfname # => "foo"
mlname # => "bar"
```

## Implementation

Maps and structs both descend from "bare maps" (like Javascript POJOs). Maps are "bare maps" with enumerator APIs and structs are "safe" maps.
