defmodule BankExWeb.UsersView do
  @moduledoc """
  The user view context.
  """
  use BankExWeb, :view

  @doc """
  Render the user response 
  """
  def render("user.json", %{user: %{referral_code: referral_code}}) do
    %{message: "User created successfully", referral_code: referral_code}
  end
  def render("users.json", %{users: users}) do
    users
  end
end
