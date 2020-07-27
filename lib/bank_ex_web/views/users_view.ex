defmodule BankExWeb.UsersView do
  @moduledoc """
  
  """
  use BankExWeb, :view

  @doc """
  
  """
  def render("user.json", %{user: %{referral_code: referral_code}}) do
    %{message: "User created successfully", referral_code: referral_code}
  end
end
