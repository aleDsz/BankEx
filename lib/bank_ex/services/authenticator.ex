defmodule BankEx.Services.Authenticator do
  @moduledoc """
  Guardian Authenticator module
  """
  use Guardian, otp_app: :bank_ex

  alias BankEx.Services.Users

  def subject_for_token(%{id: user_id}, _claims),
    do: {:ok, user_id}
  
  def subject_for_token(_, _),
    do: {:error, :bad_request}

  def resource_from_claims(%{"sub" => user_id}),
    do: Users.get(user_id)

  def resource_from_claims(_claims),
    do: {:error, :bad_request}
end
