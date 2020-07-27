defmodule BankExWeb.Swagger.AuthController do
  @moduledoc """
  The auth controller swagger context
  """

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      @doc """
      Definitions for Swagger
      """
      def swagger_definitions do
        %{
          Auth: swagger_schema do
            title "Credentials"
            description "User credentials"
            properties do
              email :string, "User's email"
              password :string, "User's password"
            end
          end,
          Token: swagger_schema do
            title "Token"
            description "A user Token"
            properties do
              token :string, "Users's token"
            end
          end
        }
      end

      swagger_path :login do
        post "/login"

        operation_id "login"
        summary "Authenticate user"
        description "Authenticate user"
        tag "Auth"

        produces "application/json"
        consumes "application/json"

        parameters do
          auth :body, PhoenixSwagger.Schema.ref(:Auth), "User credentials", required: true
        end

        response 201, "Ok", PhoenixSwagger.Schema.ref(:Token)
      end
    end
  end
end
