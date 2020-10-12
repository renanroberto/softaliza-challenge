defmodule SoftalizaWeb.ErrorResponse do
  use SoftalizaWeb, :controller

  def bad_request(conn, msg) do
    conn
    |> put_status(400)
    |> put_view(SoftalizaWeb.ErrorView)
    |> render("error.json", data: msg)
  end
end
