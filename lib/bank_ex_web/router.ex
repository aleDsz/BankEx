defmodule BankExWeb.Router do
  use BankExWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
    plug BankExWeb.Plugs.Crypto
  end

  pipeline :private do
    plug :accepts, ["json"]
    plug BankExWeb.Plugs.Authentications
  end

  scope "/users", BankExWeb do
    pipe_through :public

    post "/", UsersController, :create
  end

  scope "/login", BankExWeb do
    pipe_through :public

    post "/", AuthController, :login
  end

  scope "/users", BankExWeb do
    pipe_through :private

    get "/:referral_code/indications", UsersController, :indications
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
