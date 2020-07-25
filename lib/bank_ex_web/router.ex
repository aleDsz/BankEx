defmodule BankExWeb.Router do
  use BankExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankExWeb do
    pipe_through :api
  end
end
