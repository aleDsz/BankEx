defmodule BankExWeb.UsersView do
  @moduledoc """
  The user view context.
  """
  use BankExWeb, :view

  @doc """
  Render the referral code when creating new user
  """
  def render("user.json", %{user: %{referral_code: referral_code}}) do
    %{message: "User created successfully", referral_code: referral_code}
  end
end
