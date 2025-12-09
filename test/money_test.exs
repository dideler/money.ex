defmodule MoneyTest do
  use ExUnit.Case

  import Money

  doctest Money

  test "sigil" do
    assert %Money{amount: 10_00} == ~M[10_00]
    assert %Money{amount: 100, currency: :GBP} == ~M[100]
    assert %Money{amount: 100, currency: :USD} == ~M[1_00]USD
  end

  test "zero?/1" do
    assert Money.zero?(%Money{amount: 0})
    refute Money.zero?(%Money{amount: 1})
    refute Money.zero?(%Money{amount: -1})
  end

  test "positive?/1" do
    assert Money.positive?(%Money{amount: 1})
    refute Money.positive?(%Money{amount: 0})
    refute Money.positive?(%Money{amount: -1})
  end

  test "negative?/1" do
    assert Money.negative?(%Money{amount: -1})
    refute Money.negative?(%Money{amount: 0})
    refute Money.negative?(%Money{amount: 1})
  end

  test "equals?/2" do
    assert Money.equals?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    refute Money.equals?(%Money{amount: 1, currency: :USD}, %Money{amount: 1, currency: :GBP})
    refute Money.equals?(%Money{amount: 0, currency: :GBP}, %Money{amount: 1, currency: :GBP})
  end

  test "not_equals?/2" do
    assert Money.not_equals?(%Money{amount: 0, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    assert Money.not_equals?(%Money{amount: 1, currency: :USD}, %Money{amount: 1, currency: :GBP})
    refute Money.not_equals?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
  end

  test "gt?/2" do
    assert Money.gt?(%Money{amount: 2, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    refute Money.gt?(%Money{amount: 1, currency: :GBP}, %Money{amount: 2, currency: :GBP})
    refute Money.gt?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
  end

  test "gt?/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.gt?(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "gte?/2" do
    assert Money.gte?(%Money{amount: 2, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    assert Money.gte?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    refute Money.gte?(%Money{amount: 1, currency: :GBP}, %Money{amount: 2, currency: :GBP})
  end

  test "gte?/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.gte?(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "lt?/2" do
    assert Money.lt?(%Money{amount: 1, currency: :GBP}, %Money{amount: 2, currency: :GBP})
    refute Money.lt?(%Money{amount: 2, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    refute Money.lt?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
  end

  test "lt?/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.lt?(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "lte?/2" do
    assert Money.lte?(%Money{amount: 1, currency: :GBP}, %Money{amount: 2, currency: :GBP})
    assert Money.lte?(%Money{amount: 1, currency: :GBP}, %Money{amount: 1, currency: :GBP})
    refute Money.lte?(%Money{amount: 2, currency: :GBP}, %Money{amount: 1, currency: :GBP})
  end

  test "lte?/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.lte?(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "compare/2" do
    assert :eq == Money.compare(%Money{amount: 1}, %Money{amount: 1})
    assert :gt == Money.compare(%Money{amount: 2}, %Money{amount: 1})
    assert :lt == Money.compare(%Money{amount: 1}, %Money{amount: 2})
  end

  test "compare/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.compare(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "abs/1" do
    assert %Money{amount: 5} = Money.abs(%Money{amount: -5})
    assert %Money{amount: 0} = Money.abs(%Money{amount: 0})
    assert %Money{amount: 2} = Money.abs(%Money{amount: 2})
  end

  test "add/2" do
    assert %Money{amount: 10} = Money.add(%Money{amount: 5}, %Money{amount: 5})
  end

  test "add/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.add(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "sub/2" do
    assert %Money{amount: -5} = Money.sub(%Money{amount: 0}, %Money{amount: 5})
  end

  test "sub/2 with incompatible currencies" do
    assert_raise Money.CurrencyError, "Currencies GBP and USD are not compatible", fn ->
      Money.sub(%Money{currency: :GBP}, %Money{currency: :USD})
    end
  end

  test "mul/2" do
    assert %Money{amount: 0} = Money.mul(%Money{amount: 0}, 2)
    assert %Money{amount: 0} = Money.mul(%Money{amount: 2}, 0)
    assert %Money{amount: 4} = Money.mul(%Money{amount: 2}, 2)
    assert %Money{amount: 5} = Money.mul(%Money{amount: 2}, 2.5)
    assert %Money{amount: 3} = Money.mul(%Money{amount: 2}, 1.333)
    assert %Money{amount: 267} = Money.mul(%Money{amount: 200}, 1.333)
    assert %Money{amount: 267} = Money.mul(%Money{amount: 200}, 1.335)
  end

  test "div/2" do
    assert %Money{amount: 0} = Money.div(%Money{amount: 0}, 2)
    assert %Money{amount: 2} = Money.div(%Money{amount: 4}, 2)
    assert %Money{amount: 3} = Money.div(%Money{amount: 5}, 2)
    assert %Money{amount: 1} = Money.div(%Money{amount: 2}, 1.5)
  end

  test "div/2 when dividing by 0" do
    assert_raise ArithmeticError, "Division by zero is not a number", fn ->
      Money.div(%Money{}, 0)
    end
  end

  test "split/2" do
    assert [%Money{amount: 10}] = Money.split(%Money{amount: 10}, 1)
    assert [%Money{amount: 0}, %Money{amount: 0}] = Money.split(%Money{amount: 0}, 2)
    assert [%Money{amount: 6}, %Money{amount: 5}] = Money.split(%Money{amount: 11}, 2)
    assert [%Money{amount: 34}, %Money{amount: 33}, %Money{amount: 33}] = Money.split(~M[100], 3)
  end

  test "split/2 when splitting into incompatible parts" do
    assert_raise ArgumentError, fn ->
      Money.split(%Money{}, 0)
    end

    assert_raise ArgumentError, fn ->
      Money.split(%Money{}, -1)
    end

    assert_raise ArgumentError, fn ->
      Money.split(%Money{}, 0.5)
    end
  end

  test "allocate/2" do
    assert [~M[100]] == Money.allocate(~M[100], [1])
    assert [~M[100]] == Money.allocate(~M[100], [2])
    assert [~M[100], ~M[0]] == Money.allocate(~M[100], [1, 0])
    assert [~M[50], ~M[50]] == Money.allocate(~M[100], [3, 3])
    assert [~M[67], ~M[33]] == Money.allocate(~M[100], [2, 1])
    assert [~M[60], ~M[40]] == Money.allocate(~M[100], [6, 4])
    assert [~M[40], ~M[60]] == Money.allocate(~M[100], [40, 60])
    assert [~M[34], ~M[33], ~M[33]] == Money.allocate(~M[100], [1, 1, 1])
    assert [~M[34], ~M[33], ~M[33]] == Money.allocate(~M[100], [2, 2, 2])
    assert [~M[34], ~M[34], ~M[33]] == Money.allocate(~M[101], [1, 1, 1])
  end

  for amount <- [700_273, -700_273] do
    test "allocate/2 with complex case from ruby money gem (amount: #{amount})" do
      amount = unquote(amount)

      allocations = [
        1.1818583143661,
        1.1818583143661,
        1.1818583143661,
        1.1818583143661,
        1.1818583143661,
        1.1818583143661,
        1.1818583143661,
        1.170126087450276,
        1.0,
        1.0,
        1.0,
        1.0
      ]

      normalised_allocations = Money.Util.normalize_ratios(allocations)

      result = Money.allocate(Money.new(amount), normalised_allocations)

      sum_of_parts = Enum.reduce(result, 0, fn %Money{amount: a}, acc -> acc + a end)
      assert sum_of_parts == amount

      sign = if amount < 0, do: -1, else: 1

      # Note Ruby's money gem allocates slightly differently.
      # For index 0, they allocate 61566, we allocate 61565.
      # For index 7, they allocate 60953, we allocate 60954.
      # Our strategy is more fair given that shares 0-6 have equal weighting.
      expected_shares =
        [
          61565,
          61565,
          61565,
          61565,
          61565,
          61565,
          61565,
          60954,
          52091,
          52091,
          52091,
          52091
        ]
        |> Enum.map(&Money.new(&1 * sign))

      assert result == expected_shares
    end
  end

  test "allocate/2 with incompatible parts" do
    assert_raise ArgumentError, fn ->
      Money.allocate(%Money{amount: 100}, [])
    end

    assert_raise ArgumentError, fn ->
      Money.allocate(%Money{amount: 100}, [0])
    end

    assert_raise ArgumentError, fn ->
      Money.allocate(%Money{amount: 100}, [0, 0])
    end

    assert_raise ArgumentError, fn ->
      Money.allocate(%Money{amount: 100}, [2, -1])
    end

    assert_raise ArgumentError, fn ->
      Money.allocate(%Money{amount: 100}, ["foo"])
    end
  end

  test "convert/3" do
    m = %Money{amount: 100, currency: :USD}
    assert %Money{amount: 81, currency: :GBP} = Money.convert(m, {:USD, :GBP, 0.809581})
  end

  test "convert/3 when exchange invalid" do
    assert_raise ArgumentError, "Exchange rate invalid", fn ->
      Money.convert(%Money{currency: :USD}, {:USD, :USD, 1})
    end

    assert_raise ArgumentError, "Exchange rate invalid", fn ->
      Money.convert(%Money{currency: :USD}, {:GBP, :USD, 1})
    end

    assert_raise ArgumentError, "Exchange rate invalid", fn ->
      Money.convert(%Money{currency: :USD}, {:USD, :FOO, 1})
    end

    assert_raise ArgumentError, "Exchange rate invalid", fn ->
      Money.convert(%Money{currency: :USD}, {:USD, :GBP, 0})
    end

    assert_raise ArgumentError, "Exchange rate invalid", fn ->
      Money.convert(%Money{currency: :USD}, {:USD, :GBP, -1})
    end
  end

  test "currency_code/1" do
    assert "USD" == Money.currency_code(%Money{currency: :USD})
    assert "GBP" == Money.currency_code(%Money{currency: :GBP})
  end

  test "currency_name/1" do
    assert "United States dollar" == Money.currency_name(%Money{currency: :USD})
    assert "Sterling" == Money.currency_name(%Money{currency: :GBP})
  end

  test "currency_symbol/1" do
    assert "$" == Money.currency_symbol(%Money{currency: :USD})
    assert "£" == Money.currency_symbol(%Money{currency: :GBP})
  end

  test "to_string/2" do
    assert "$0.00" == Money.to_string(%Money{amount: 0, currency: :USD})
    assert "$0.00" == Money.to_string(%Money{amount: -0, currency: :USD})
    assert "$0.05" == Money.to_string(%Money{amount: 5, currency: :USD})
    assert "$0.05" == Money.to_string(%Money{amount: 05, currency: :USD})
    assert "$0.50" == Money.to_string(%Money{amount: 50, currency: :USD})
    assert "$1.50" == Money.to_string(%Money{amount: 150, currency: :USD})
    assert "$15.00" == Money.to_string(%Money{amount: 1500, currency: :USD})
    assert "$150.00" == Money.to_string(%Money{amount: 15000, currency: :USD})
    assert "£1,234.56" == Money.to_string(%Money{amount: 123_456, currency: :GBP})
    assert "£1,234,567.89" == Money.to_string(%Money{amount: 123_456_789, currency: :GBP})
    assert "-£0.09" == Money.to_string(%Money{amount: -9, currency: :GBP})
    assert "-£0.99" == Money.to_string(%Money{amount: -99, currency: :GBP})
    assert "-£9.99" == Money.to_string(%Money{amount: -999, currency: :GBP})
    assert "-£99.99" == Money.to_string(%Money{amount: -9999, currency: :GBP})
  end

  test "to_string/2 with options" do
    assert "1.00" == Money.to_string(%Money{amount: 100}, symbol: false)
    assert "£1.00 GBP" == Money.to_string(%Money{amount: 100}, code: true)
    assert "£1.000.00" == Money.to_string(%Money{amount: 100_000}, separator: ".")
    assert "£1,000,00" == Money.to_string(%Money{amount: 100_000}, delimiter: ",")

    assert "€1.000,00 EUR" ==
             Money.to_string(%Money{amount: 100_000, currency: :EUR},
               separator: ".",
               delimiter: ",",
               code: true
             )
  end

  test "String.Chars protocol" do
    assert "$1.99" == Kernel.to_string(%Money{amount: 199, currency: :USD})
  end
end

# TODO: Consider moving this to the main library as a public helper function,
#       as it allows users to work with fractions when allocating money into shares.
#       My hesitation is that it introduces Decimal into the main library,
#       which I've been trying to avoid given our int-based representation.
defmodule Money.Util do
  @doc """
  Normalizes a list of fractional ratios to integer ratios suitable for allocation.
  Example: [0.5, 0.25, 0.125] -> [500, 250, 125]
  """
  def normalize_ratios(fractions) do
    scale = get_max_decimal_places(fractions)
    scale_factor = :math.pow(10, scale)

    Enum.map(fractions, fn f -> round(f * scale_factor) end)
  end

  defp get_max_decimal_places(fractions) do
    fractions
    |> Enum.map(&count_decimal_places/1)
    |> Enum.max()
  end

  defp count_decimal_places(number) do
    number
    |> Decimal.from_float()
    |> Decimal.to_string()
    |> parse_decimal_length()
  end

  defp parse_decimal_length(string) do
    case String.split(string, ".") do
      [_, fraction] -> String.length(fraction)
      _ -> 0
    end
  end
end
