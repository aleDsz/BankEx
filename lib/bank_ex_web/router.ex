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

  scope "/docs" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :bank_ex,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0.0",
        title: "BankEx ;)",
        description: "The new bank account creation method"
      },
      tags: [
        %{name: "Users", description: "Manage all BankEx Users"}
      ]
    }
  end
end
