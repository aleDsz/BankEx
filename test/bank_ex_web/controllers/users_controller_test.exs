defmodule BankExWeb.UsersControllerTest do
  use BankExWeb.ConnCase, async: false
  @moduletag :users

  alias BankEx.Services.Users

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

    test "with incomplete parameters, should create a new user and update with complete parameter and produce status 201 without error [POST /users]", %{conn: conn} do
      params =
        build(:user)
        |> Map.delete(:city)

      old_response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)

      new_params =
        params
        |> Map.put(:city, "São Paulo")

      new_response =
        conn
        |> post(Routes.users_path(conn, :create), new_params)
        |> json_response(201)

      assert(
        not is_nil(old_response)
        and Ecto.UUID.cast(old_response["id"]) != :error
        and old_response["id"] === new_response["id"]
        and old_response["status"] === "pending"
        and new_response["status"] === "completed"
        and is_nil(old_response["city"])
        and new_response["city"] === "São Paulo"
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

    test "with valid parameters and referral code, should create a new user and produce status 201 without error [POST /users]", %{conn: conn} do
      %{"id" => user_id} =
        conn
        |> post(Routes.users_path(conn, :create), build(:user))
        |> json_response(201)

      {:ok, %{referral_code: referral_code}} = Users.get(user_id)

      params =
        build(:user)
        |> Map.put(:referral_code, referral_code)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)

      {:ok, %{referred_user: %{id: referred_user_id}}} =
        Users.get(response["id"])

      assert(
        not is_nil(response)
        and Ecto.UUID.cast(response["id"]) != :error
        and response["status"] === "completed"
        and referred_user_id === user_id
      )
    end
  end
end
