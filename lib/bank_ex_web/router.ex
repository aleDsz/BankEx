defmodule BankExWeb.Router do
  use BankExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BankExWeb.Plugs.Crypto
  end

  scope "/", BankExWeb do
    pipe_through :api

    post "/users", UsersController, :create
  end
end
