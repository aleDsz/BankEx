defmodule BankExWeb.Router do
  use BankExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BankExWeb.Plugs.Crypto
  end

  scope "/", BankExWeb do
    pipe_through :api

    post "/users", UsersController, :create
    get "/users/:referral_code/indications", UsersController, :indications
  end
end
