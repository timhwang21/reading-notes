# IO and the file system

* IO
* File
* Path

## IO

Three symbols to write to:

* `stdio`
* `stderr`

`IO.puts` takes either a string or an argument list and returns `:ok`:

```elixir
IO.puts "hello world"
# logs to stdio

IO.puts :stderr, "hello world"
# logs to stderr
```

## File

### Read

```elixir
# read returns a either a success tuple or a failure tuple
# it should be used when one needs to handle the case of the file not existing
case File.read("somefile.txt") do
  {:ok, body} -> handle_body body
  {:error, reason} -> handle_error reason
end

# read! either returns file process or errors
# it should be used when the file not existing is an error that should be reported
File.read!("somefile.txt")
```

### Write

Files are opened as binaries by default. Can be opened as UTF-8 by passing `:utf8`.

```elixir
{:ok, file} = File.open "somefile.txt", [:write]
IO.binwrite file, "some contents to write"
File.close file
```

Note that the above is bad practice as it doesn't handle `:error`. We will get a match error if an error happens, and the actual error will be lost. If one does not plan on handling the error, the bang version should be used.

Writing actually sends a message to the PID represented by `file` that looks like:

```elixir
{:io_request, #PID<something>, #Reference<something>, {:put_chars, :unicode, "your message"}}
```

It then expects a response. So if we want to implement our own custom file process we will have to handle the above message and then send the appropriate response.

There is a `StringIO` library that does what `IO` does but with strings rather than files. This allows us to use a familiar API to handle parallelization of processes involving strings that don't necessarily involve disk IO.

## Path

Standard path handling library.

## Group Leaders

TODO. Don't really get this, need more context.

Processes have a group leader (supervisor)? In IO, the group leader handles `puts`.
