defmodule BankExWeb.AuthControllerTest do
  use BankExWeb.ConnCase, async: false
  @moduletag :auth

  describe "Received auth request from API so" do
    test "with invalid credentials, shouldn't generate token and produce status 404 with error message [POST /login]", %{conn: conn} do
      params =
        build(:user)

      response =
        conn
        |> post(Routes.auth_path(conn, :login), params)
        |> json_response(404)

      assert(
        not is_nil(response)
        and response["errors"]["detail"] === "Not Found"
      )
    end

    test "with invalid parameters, shouldn't generate token and produce status 400 with error message [POST /login]", %{conn: conn} do
      response =
        conn
        |> post(Routes.auth_path(conn, :login), %{})
        |> json_response(400)

      assert(
        not is_nil(response)
        and response["errors"]["detail"] === "Bad Request"
      )
    end

    test "with valid parameters, should generate token and produce status 201 without error [POST /login]", %{conn: conn} do
      params = build(:user)

      conn
      |> post(Routes.users_path(conn, :create), params)
      |> json_response(201)

      params = %{
        "email" => params.email,
        "password" => params.password
      }
      
      response =
        conn
        |> post(Routes.auth_path(conn, :login), params)
        |> json_response(201)

      assert(
        not is_nil(response)
        and response["token"] |> String.length() > 0
      )
    end
  end
end
