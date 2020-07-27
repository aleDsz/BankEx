defmodule BankExWeb.Plugs.Authentications do
  @moduledoc """
  Implement the authentications to requests
  """
  use Guardian.Plug.Pipeline, otp_app: :bank_ex

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
