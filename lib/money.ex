defmodule Money do
  @moduledoc """
  Represents money as integer values internally for safer operations
  """
  alias Money.CurrencyError

  defmodule CurrencyError do
    defexception [:m1, :m2]

    def message(exception) do
      "Currencies #{exception.m1.currency} and #{exception.m2.currency} are not compatible"
    end
  end

  @supported_currencies ~w(GBP USD EUR)a

  @type currency ::
          unquote(
            @supported_currencies
            |> Enum.map(&inspect/1)
            |> Enum.join(" | ")
            |> Code.string_to_quoted!()
          )

  @type t :: %__MODULE__{
          amount: integer,
          currency: currency
        }

  defstruct amount: 0, currency: :GBP

  @doc "Create Money structs with the ~M sigil. Requires 'import Money' to use sigil."
  def sigil_M(amount_raw, []), do: new(String.to_integer(amount_raw))

  def sigil_M(amount_raw, currency_raw) do
    new(String.to_integer(amount_raw), List.to_string(currency_raw) |> String.to_atom())
  end

  def new(amount) when is_integer(amount), do: struct(__MODULE__, amount: amount)

  def new(amount, currency) when is_integer(amount) and currency in @supported_currencies,
    do: struct(__MODULE__, amount: amount, currency: currency)

  @spec zero?(t) :: boolean()
  def zero?(%Money{amount: amount}), do: amount === 0

  @spec positive?(t) :: boolean()
  def positive?(%Money{amount: amount}), do: amount > 0
  def pos?(m), do: positive?(m)

  @spec negative?(t) :: boolean()
  def negative?(%Money{amount: amount}), do: amount < 0
  def neg?(m), do: negative?(m)

  @spec equals?(t, t) :: boolean()
  def equals?(%Money{} = m1, %Money{} = m2), do: m1 === m2
  def eq?(m1, m2), do: equals?(m1, m2)

  @spec not_equals?(t, t) :: boolean()
  def not_equals?(%Money{} = m1, %Money{} = m2), do: m1 !== m2
  def ne?(m1, m2), do: not_equals?(m1, m2)

  @spec gt?(t, t) :: boolean()
  def gt?(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}), do: a1 > a2
  def gt?(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec gte?(t, t) :: boolean()
  def gte?(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}), do: a1 >= a2
  def gte?(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec lt?(t, t) :: boolean()
  def lt?(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}), do: a1 < a2
  def lt?(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec lte?(t, t) :: boolean()
  def lte?(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}), do: a1 <= a2
  def lte?(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec compare(t, t) :: :eq | :gt | :lt
  def compare(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}) do
    cond do
      a1 === a2 -> :eq
      a1 > a2 -> :gt
      a1 < a2 -> :lt
    end
  end

  def compare(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec abs(t) :: t
  def abs(%Money{amount: a} = m) when a < 0, do: %Money{m | amount: -a}
  def abs(%Money{} = m), do: m

  @spec add(t, t) :: t
  def add(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}) do
    %Money{amount: a1 + a2, currency: c}
  end

  def add(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec sub(t, t) :: t
  def sub(%Money{amount: a1, currency: c}, %Money{amount: a2, currency: c}) do
    %Money{amount: a1 - a2, currency: c}
  end

  def sub(%Money{} = m1, %Money{} = m2), do: raise(CurrencyError, m1: m1, m2: m2)

  @spec mul(t, number) :: t
  def mul(%Money{amount: a, currency: c}, multiplier) when is_number(multiplier) do
    %Money{amount: round(a * multiplier), currency: c}
  end

  @spec div(t, number) :: t
  def div(%Money{}, 0), do: raise(ArithmeticError, "Division by zero is not a number")
  def div(%Money{}, +0.0), do: raise(ArithmeticError, "Division by zero is not a number")

  def div(%Money{amount: a, currency: c}, divisor) when is_number(divisor) do
    %Money{amount: round(a / divisor), currency: c}
  end

  @spec split(t, pos_integer) :: [t]
  def split(%Money{} = m, 1), do: [m]

  def split(%Money{amount: a} = m, n) when is_integer(n) and n > 0 do
    [%Money{amount: head_a} | tail] = for _ <- 1..n, do: %Money{m | amount: Kernel.div(a, n)}
    [%Money{m | amount: head_a + rem(a, n)} | tail]
  end

  def split(%Money{}, _), do: raise(ArgumentError, "Number of parts must be a positive integer")

  @doc """
  Weighted allocation of money into proportional parts.

  It is a money-preserving allocator, not a purely mathematical allocator.
  - The sum of all parts must be greater than zero.
  - Allocated results must always sum to the original money amount.
  - Remainders are distributed round-robin style, equally in a rotating, sequential order.

  ## Examples

      iex> Money.allocate(~M[100], [4, 6])
      [%Money{amount: 40}, %Money{amount: 60}]
      iex> Money.allocate(~M[5], [3, 7])
      [%Money{amount: 2}, %Money{amount: 3}]

  """
  @spec allocate(t, [non_neg_integer]) :: [t]
  def allocate(%Money{}, []), do: raise(ArgumentError, "Parts cannot be empty")

  def allocate(%Money{amount: amount} = m, parts) when is_list(parts) do
    validate_parts!(parts)

    sum_parts = Enum.sum(parts)
    base_amount = Kernel.div(amount, sum_parts)
    base_shares = Enum.map(parts, &%Money{m | amount: base_amount * &1})
    remainder = Kernel.rem(amount, sum_parts)

    distribute_remainder(base_shares, remainder)
  end

  defp validate_parts!(parts) do
    unless Enum.all?(parts, &(is_integer(&1) and &1 >= 0)) do
      raise(ArgumentError, "All parts must be non-negative integers")
    end

    unless Enum.sum(parts) > 0 do
      raise(ArgumentError, "Sum of all parts must be greater than zero")
    end
  end

  defp distribute_remainder(shares, 0), do: shares

  # Uses a quota-based round-robin distribution to allocate remaining cents fairly.
  defp distribute_remainder(shares, remainder) do
    num_shares = length(shares)

    # Calculates the amount we can evenly allocate to each share from the remainder,
    # and the remainder of the remainder that we cannot evenly allocate per share.
    # This avoids looping over the shares multiple times to distribute a cent at a time.
    extra_per_share = Kernel.div(remainder, num_shares)
    extra_remainder = Kernel.rem(remainder, num_shares)

    shares
    |> Enum.with_index()
    |> Enum.map(fn {%Money{amount: amount} = money, idx} ->
      extra = extra_per_share + if(idx < extra_remainder, do: 1, else: 0)
      %Money{money | amount: amount + extra}
    end)
  end

  @spec convert(t, {currency, currency, number}) :: t
  def convert(%Money{}, {from, from, _rate}), do: raise(ArgumentError, "Exchange rate invalid")

  def convert(%Money{currency: from} = m, {from, to, rate})
      when to in @supported_currencies and rate > 0 do
    mul(%Money{m | currency: to}, rate)
  end

  def convert(%Money{}, _exchange_rate), do: raise(ArgumentError, "Exchange rate invalid")

  def currency_code(%Money{currency: c}), do: currency_code(c)
  def currency_code(c) when c in @supported_currencies, do: Kernel.to_string(c)

  def currency_name(%Money{currency: c}), do: currency_name(c)
  def currency_name(:GBP), do: "Sterling"
  def currency_name(:USD), do: "United States dollar"
  def currency_name(:EUR), do: "Euro"

  def currency_symbol(%Money{currency: c}), do: currency_symbol(c)
  def currency_symbol(:GBP), do: "£"
  def currency_symbol(:USD), do: "$"
  def currency_symbol(:EUR), do: "€"

  @typedoc """
  Options for formatting money as a string.

    * `:symbol` - Include currency symbol (default: `true`)
    * `:code` - Include currency code (default: `false`)
    * `:separator` - Thousands separator character (default: `","`)
    * `:delimiter` - Decimal delimiter character (default: `"."`)
  """
  @type format_opts :: [
          {:symbol, boolean()},
          {:code, boolean()},
          {:separator, String.t()},
          {:delimiter, String.t()}
        ]
  @spec to_string(t, format_opts) :: String.t()
  def to_string(%Money{amount: amount, currency: currency}, opts \\ []) do
    opts =
      opts
      |> Keyword.validate!(symbol: true, code: false, separator: ",", delimiter: ".")
      |> Enum.into(%{})

    formatted_digits = format_digits(amount, opts)
    sign = if amount < 0, do: "-", else: ""
    symbol = if opts[:symbol], do: currency_symbol(currency), else: ""
    code = if opts[:code], do: currency_code(currency), else: ""
    String.trim("#{sign}#{symbol}#{formatted_digits} #{code}")
  end

  @spec to_s(t) :: String.t()
  def to_s(%Money{} = m), do: Money.to_string(m)

  # Formats an amount as a string with thousands separators and decimal delimiter.
  #
  # Example: amount 123499 which represents $1,234.99
  # 1. Converts amount to digit characters in reverse order: ["9","9","4","3","2","1"]
  # 2. Indexes each digit by position: [{"9",0}, {"9",1}, {"4",2}, {"3",3}, {"2",4}, {"1",5}]
  # 3. Recursively processes digits, inserting delimiters and separators at the right positions
  # 4. Joins the result into a final string: "1,234.99"
  @spec format_digits(integer, map) :: String.t()
  defp format_digits(amount, %{separator: s, delimiter: d}) do
    amount
    |> Kernel.abs()
    |> Kernel.to_string()
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> do_format_digits([], %{separator: s, delimiter: d})
    |> Enum.join()
  end

  # Recursive formatter that builds the digit list with separators and delimiters.
  # Base cases handle amounts with fewer than 3 digits (e.g., $0.05, $0.50).
  @typep indexed_digit :: {String.t(), non_neg_integer()}
  @spec do_format_digits([indexed_digit()], [String.t()], map) :: [String.t()]
  defp do_format_digits([], [_] = acc, %{delimiter: delim}), do: ["0", delim, "0" | acc]
  defp do_format_digits([], [_, _] = acc, %{delimiter: delim}), do: ["0", delim | acc]
  defp do_format_digits([], [_, _, _ | _] = acc, _opts), do: acc

  # Inserts the decimal delimiter when we've accumulated 2 digits and there's a 3rd digit.
  defp do_format_digits([{digit, _} | tail], [_, _] = acc, %{delimiter: delim} = opts),
    do: do_format_digits(tail, [digit, delim | acc], opts)

  # Insert separator every 3 digits for remaining digits beyond decimals.
  defp do_format_digits([{digit, idx} | tail], acc, %{separator: sep} = opts)
       when rem(idx, 3) == 2,
       do: do_format_digits(tail, [digit, sep | acc], opts)

  # No special case, just accumulate the digit.
  defp do_format_digits([{digit, _} | tail], acc, opts),
    do: do_format_digits(tail, [digit | acc], opts)
end

defimpl String.Chars, for: Money do
  @spec to_string(Money.t()) :: String.t()
  def to_string(%Money{} = m), do: Money.to_string(m)
end
