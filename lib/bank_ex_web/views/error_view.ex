defmodule BankExWeb.ErrorView do
  use BankExWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("400.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: %{detail: translate_errors(changeset)}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
