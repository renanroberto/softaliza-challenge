defmodule SoftalizaWeb.ErrorResponse do
  use SoftalizaWeb, :controller

  alias SoftalizaWeb.ErrorView

  def bad_request(conn, %Ecto.Changeset{} = changeset) do
    errors =
      Ecto.Changeset.traverse_errors(
        changeset,
        &SoftalizaWeb.ErrorHelpers.translate_error/1
      )

    bad_request(conn, errors)
  end

  def bad_request(conn, msg) do
    conn
    |> put_status(400)
    |> put_view(ErrorView)
    |> render("error.json", data: msg)
  end

  def unauthorized(conn) do
    conn
    |> put_status(401)
    |> put_view(ErrorView)
    |> render("error.json", data: "unauthorized")
  end

  def not_found(conn, entity) do
    conn
    |> put_status(404)
    |> put_view(ErrorView)
    |> render("error.json", data: "#{entity} not found")
  end
end
