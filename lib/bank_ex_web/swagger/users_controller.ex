defmodule BankExWeb.Swagger.UsersController do
  @moduledoc """
  The user controller swagger context
  """

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      @doc """
      Definitions for Swagger
      """
      def swagger_definitions do
        %{
          User: swagger_schema do
            title "Indicated User"
            description "An user"
            properties do
              id :string, "User's ID"
              name :string, "User's full name"
            end
          end,
          NewUser: swagger_schema do
            title "User"
            description "An user"
            properties do
              name :string, "User's full name"
              email :string, "User's email"
              password :string, "User's password"
              cpf :string, "User's CPF number", required: true
              birth_date :string, "User's birth date"
              gender :string, "Users' gender", enum: ~w(M F O)
              city :string, "User's city"
              state :string, "User's state"
              country :string, "User's country"
            end
          end,
          Response: swagger_schema do
            title "New User response"
            description "A new user"
            properties do
              message :string, "Response message"
              referral_code :string, "User's referral code"
            end
          end
        }
      end

      swagger_path :create do
        post "/users"

        operation_id "create_user"
        summary "Create new user"
        description "Create new User"
        tag "Users"

        produces "application/json"
        consumes "application/json"

        parameters do
          user :body, PhoenixSwagger.Schema.ref(:NewUser), "User data", required: true
        end

        response 201, "Ok", PhoenixSwagger.Schema.ref(:Response)
      end

      swagger_path :indications do
        get "/users/{referral_code}/indications"

        operation_id "list_user_indications"
        summary "List all user's indications"
        description "List all user's indications"
        tag "Users"

        produces "application/json"
        consumes "application/json"

        parameters do
          referral_code :path, :string, "User's referral code", required: true, example: "12345678"
        end

        security [%{Bearer: []}]
        response 200, "Ok", PhoenixSwagger.Schema.array(:User)
      end
    end
  end
end
