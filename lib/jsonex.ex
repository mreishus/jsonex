defmodule Jsonex do
  @moduledoc """
  Documentation for Jsonex.
  """

  def encode(nil), do: "null"
  def encode([]), do: "[]"
  def encode(true), do: "true"
  def encode(false), do: "false"

  def encode(atom) when is_atom(atom) do
    Atom.to_string(atom) |> encode()
  end

  def encode(num) when is_integer(num) do
    Integer.to_string(num)
  end

  def encode(list) when is_list(list) do
    items_str =
      list
      |> Enum.map(&encode/1)
      |> Enum.join(",")

    "[" <> items_str <> "]"
  end

  def encode(map) when is_map(map) do
    str =
      map
      |> Map.keys()
      |> Enum.map(fn k ->
        encode(k) <> ":" <> encode(map[k])
      end)
      |> Enum.join(",")

    "{" <> str <> "}"
  end

  def encode(str) when is_bitstring(str) do
    "\"" <> str <> "\""
  end

  def encode(pid) when is_pid(pid), do: raise(Jsonex.BadInputError)
  def encode(float) when is_float(float), do: raise(Jsonex.BadInputError)
  def encode(tuple) when is_tuple(tuple), do: raise(Jsonex.BadInputError)

  # Unsure if needed
  def encode(str) do
    str
  end
end

defmodule Jsonex.BadInputError do
  defexception [:message]

  @impl true
  def exception(value) do
    msg = "did not get what was expected, got: #{inspect(value)}"
    %Jsonex.BadInputError{message: msg}
  end
end
