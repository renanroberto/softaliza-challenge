defmodule SoftalizaWeb.ErrorResponse do
  use SoftalizaWeb, :controller

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
    |> put_view(SoftalizaWeb.ErrorView)
    |> render("error.json", data: msg)
  end

  def unauthorized(conn) do
    conn
    |> put_status(401)
    |> put_view(SoftalizaWeb.ErrorView)
    |> render("error.json", data: "unauthorized")
  end
end
