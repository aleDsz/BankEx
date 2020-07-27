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

      %{"referral_code" => referral_code} = response
      {:ok, %{status: status}} = Users.get_by_referral_code(referral_code)

      assert(
        not is_nil(response)
        and status === "pending"
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

      %{"referral_code" => referral_code} = old_response
      {:ok, old_user} = Users.get_by_referral_code(referral_code)

      new_params =
        params
        |> Map.put(:city, "São Paulo")

      new_response =
        conn
        |> post(Routes.users_path(conn, :create), new_params)
        |> json_response(201)

      %{"referral_code" => referral_code} = new_response
      {:ok, new_user} = Users.get_by_referral_code(referral_code)

      assert(
        not is_nil(old_response)
        and old_user.id === new_user.id
        and old_user.status === "pending"
        and new_user.status === "completed"
        and is_nil(old_user.city)
        and new_user.city === "São Paulo"
      )
    end

    test "with valid parameters, should create a new user and produce status 201 without error [POST /users]", %{conn: conn} do
      params = build(:user)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)

      %{"referral_code" => referral_code} = response
      {:ok, %{status: status}} = Users.get_by_referral_code(referral_code)

      assert(
        not is_nil(response)
        and status === "completed"
      )
    end

    test "with valid parameters and referral code, should create a new user and produce status 201 without error [POST /users]", %{conn: conn} do
      %{"referral_code" => referral_code} =
        conn
        |> post(Routes.users_path(conn, :create), build(:user))
        |> json_response(201)

      {:ok, %{id: user_id}} = Users.get_by_referral_code(referral_code)

      params =
        build(:user)
        |> Map.put(:referral_code, referral_code)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(201)
      
      %{"referral_code" => referral_code} = response
      {:ok, %{status: status, referred_user: %{id: referred_user_id}}} =
        Users.get_by_referral_code(referral_code)

      assert(
        not is_nil(response)
        and status === "completed"
        and referred_user_id === user_id
      )
    end
  end
end
