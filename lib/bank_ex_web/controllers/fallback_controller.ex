defmodule BankExWeb.FallbackController do
  @moduledoc """
  
  """
  use BankExWeb, :controller

  @doc """
  
  """
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankExWeb.ErrorView)
    |> render("error.json", changeset: changeset)
  end
end
