defmodule BankExWeb.UsersView do
  @moduledoc """
  
  """
  use BankExWeb, :view

  @doc """
  
  """
  def render("user.json", %{user: user}) do
    user
  end
end
