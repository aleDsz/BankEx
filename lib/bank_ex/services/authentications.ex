defmodule BankEx.Services.Authentications do
  @moduledoc """
  Handle user authentications
  """
  alias BankEx.Services.{Authenticator, Crypto, Users}

  @doc """
  Authenticate user from parameters
  """
  @spec login(map()) :: {:ok, binary()} | {:error, term()}
  def login(%{"email" => email, "password" => password}) do
    with {:ok, user} <- Users.get_by_email(email) do
      hash_password = password |> Crypto.encrypt()

      if hash_password === user.password do
        {:ok, token, _claims} = Authenticator.encode_and_sign(user)
        {:ok, token}
      else
        {:error, :unauthorized}
      end
    end
  end
  def login(_params), do: {:error, :bad_request}
end
