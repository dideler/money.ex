defmodule AllocateBench do
  @moduledoc """
  Benchmarks three allocation strategies:
  - A: List.update_at -> O(remainder × n)
  - B: Quota method -> O(n)
  - C: :array -> O(remainder + n)
  """

  defmodule Money do
    defstruct amount: 0, currency: :USD
  end

  # === Option A: List.update_at ===
  def allocate_a(%Money{amount: amount} = m, parts) do
    sum_parts = Enum.sum(parts)
    base_amount = div(amount, sum_parts)
    remainder = rem(amount, sum_parts)
    base_shares = Enum.map(parts, &%Money{m | amount: base_amount * &1})

    distribute_remainder_a(base_shares, remainder)
  end

  defp distribute_remainder_a(shares, 0), do: shares
  defp distribute_remainder_a(shares, remainder) do
    num = length(shares)
    Enum.reduce(1..remainder, shares, fn i, acc ->
      idx = rem(i - 1, num)
      List.update_at(acc, idx, fn %Money{amount: a} = s ->
        %Money{s | amount: a + 1}
      end)
    end)
  end

  # === Option B: Quota Method ===
  def allocate_b(%Money{amount: amount} = money, parts) do
    sum_parts = Enum.sum(parts)
    base_per_unit = div(amount, sum_parts)
    remainder = rem(amount, sum_parts)
    num_parts = length(parts)
    extras_per_part = div(remainder, num_parts)
    extra_remainder = rem(remainder, num_parts)

    parts
    |> Enum.with_index()
    |> Enum.map(fn {weight, index} ->
      base_share = base_per_unit * weight
      extra = extras_per_part + if(index < extra_remainder, do: 1, else: 0)
      %Money{money | amount: base_share + extra}
    end)
  end

  # === Option C: :array ===
  def allocate_c(%Money{amount: amount} = m, parts) do
    sum_parts = Enum.sum(parts)
    base_amount = div(amount, sum_parts)
    remainder = rem(amount, sum_parts)
    base_shares = Enum.map(parts, &%Money{m | amount: base_amount * &1})

    distribute_remainder_c(base_shares, remainder)
  end

  defp distribute_remainder_c(shares, 0), do: shares
  defp distribute_remainder_c(shares, remainder) do
    num_shares = length(shares)
    arr = :array.from_list(shares)

    final_arr =
      for i <- 0..(remainder - 1), reduce: arr do
        acc ->
          idx = rem(i, num_shares)
          share = :array.get(idx, acc)
          :array.set(idx, %Money{share | amount: share.amount + 1}, acc)
      end

    :array.to_list(final_arr)
  end

  # === Inputs ===
  def inputs do
    %{
      "5_parts_small_rem"     => {100, [1, 1, 1, 1, 1]},        # remainder = 0
      "5_parts_large_rem"     => {109, [1, 1, 1, 1, 1]},        # remainder = 4
      "100_parts"             => {10_000, Enum.to_list(1..100)},
      "1_000_parts"           => {100_000, Enum.to_list(1..1_000)},
      "10_000_parts_small_rem"=> {10_000_000, Enum.to_list(1..10_000)}, # ~1M per part
      "10_000_parts_large_rem"=> {10_000_000 + 9999, Enum.to_list(1..10_000)} # big remainder 10,009,999
    }
  end

  def run do
    Benchee.run(
      %{
        "A (update_at)" => fn {a, p} -> allocate_a(%Money{amount: a}, p) end,
        "B (quota method)"       => fn {a, p} -> allocate_b(%Money{amount: a}, p) end,
        "C (:array)"             => fn {a, p} -> allocate_c(%Money{amount: a}, p) end
      },
      inputs: inputs(),
      time: 5,
      memory_time: 1,
      warmup: 1,
      print: [fast_warning: false],
      formatters: [
        Benchee.Formatters.Console,
        Benchee.Formatters.HTML
      ]
    )
  end
end

# === Run with: mix run bench/allocate_bench.exs ===
AllocateBench.run()
