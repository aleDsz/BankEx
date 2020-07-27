defmodule BankExWeb.AuthView do
  @moduledoc """
  The auth view context.
  """
  use BankExWeb, :view

  @doc """
  Render the user's token 
  """
  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
