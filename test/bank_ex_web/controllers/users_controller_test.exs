defmodule BankExWeb.UsersControllerTest do
  use BankExWeb.ConnCase, async: false
  @moduletag :users

  describe "Received request from API so" do
    test "with invalid CPF, shouldn't create a new user and produce status 422 with error message [POST /users]", %{conn: conn} do
      params =
        build(:user)
        |> Map.put(:cpf, "123456")

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(422)

      assert(
        not is_nil(response)
        and response["errors"]["detail"] === %{"cpf" => ["invalid cpf"]}
      )
    end

    test "with invalid CNPJ, shouldn't create a new user and produce status 422 with error message [POST /users]", %{conn: conn} do
      params =
        build(:user)
        |> Map.put(:cpf, Brcpfcnpj.cnpj_generate())

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(422)

      assert(
        not is_nil(response)
        and response["errors"]["detail"] === %{"cpf" => ["invalid cpf"]}
      )
    end

    test "without CPF, shouldn't create a new user and produce status 422 with error message [POST /users]", %{conn: conn} do
      params =
        build(:user)
        |> Map.delete(:cpf)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(422)

      assert(
        not is_nil(response)
        and response["errors"]["detail"] === %{"cpf" => ["can't be blank"]}
      )
    end

    test "without city, should create a new user and produce status 201 without error [POST /users]", %{conn: conn} do
      params =
        build(:user)
        |> Map.delete(:city)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)

      assert(
        not is_nil(response)
        and Ecto.UUID.cast(response["id"]) != :error
        and response["status"] === "pending"
      )
    end

    test "with valid parameters, should create a new user and produce status 201 without error [POST /users]", %{conn: conn} do
      params = build(:user)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)

      assert(
        not is_nil(response)
        and Ecto.UUID.cast(response["id"]) != :error
        and response["status"] === "completed"
      )
    end
  end
end
