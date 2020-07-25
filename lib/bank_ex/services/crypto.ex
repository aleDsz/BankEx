defmodule BankEx.Services.Crypto do
  @moduledoc """
  Encrypt and decrypt data
  """

  @doc """
  Encrypt data to store
  """
  @spec encrypt(term()) :: binary()
  def encrypt(value),
    do: value |> :erlang.term_to_binary() |> Base.encode64()

  @doc """
  Decrypt data from storage
  """
  @spec decrypt(binary()) :: term()
  def decrypt(value),
    do: value |> Base.decode64!() |> :erlang.binary_to_term()
end
