defmodule SoftalizaWeb.EventController do
  use SoftalizaWeb, :controller

  alias Softaliza.Events

  def index(conn, _params) do
    events = Events.list_events()

    render(conn, "events.json", data: events)
  end

  def show(conn, %{"id" => id}) do
    if event = Events.get_event(id) do
      render(conn, "event.json", data: event)
    else
      json(conn, %{status: "error", error: "event not found"})
    end
  end

  def update(conn, %{"id" => id} = params) do
    if event = Events.get_event(id) do
      {:ok, new_event} = Events.update_event(event, params)

      render(conn, "event.json", data: new_event)
    else
      json(conn, %{status: "error", error: "event not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    if event = Events.get_event(id) do
      Events.delete_event(event)

      json(conn, %{status: "ok", message: "event #{id} deleted"})
    else
      json(conn, %{status: "error", error: "event not found"})
    end
  end

  def create(conn, params) do
    case Events.create_event(params) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> json(%{status: "ok", user: user.id})

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(
            changeset,
            &SoftalizaWeb.ErrorHelpers.translate_error/1
          )

        conn
        |> put_status(400)
        |> json(%{status: "error", errors: errors})
    end
  end
end
