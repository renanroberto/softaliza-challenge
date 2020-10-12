defmodule SoftalizaWeb.EventController do
  use SoftalizaWeb, :controller

  alias Softaliza.Events
  alias SoftalizaWeb.ErrorResponse

  def index(conn, _params) do
    events = Events.list_events()

    render(conn, "events.json", data: events)
  end

  def show(conn, %{"id" => id}) do
    case Events.get_event(id) do
      {:ok, event} ->
        render(conn, "event.json", data: event)

      {:error, :not_found} ->
        ErrorResponse.bad_request(conn, "event not found")
    end
  end

  def create(conn, params) do
    case Events.create_event(params) do
      {:ok, event} ->
        conn
        |> put_status(201)
        |> render("event.json", data: event)

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(
            changeset,
            &SoftalizaWeb.ErrorHelpers.translate_error/1
          )

        ErrorResponse.bad_request(conn, errors)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, event} <- Events.get_event(id),
         {:ok, new_event} <- Events.update_event(event, params) do
      render(conn, "event.json", data: new_event)
    else
      {:error, :not_found} ->
        ErrorResponse.bad_request(conn, "event not found")

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(
            changeset,
            &SoftalizaWeb.ErrorHelpers.translate_error/1
          )

        ErrorResponse.bad_request(conn, errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, event} <- Events.get_event(id),
         {:ok, deleted_event} <- Events.delete_event(event) do
      render(conn, "event.json", data: deleted_event)
    else
      {:error, :not_found} ->
        ErrorResponse.bad_request(conn, "event not found")

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(
            changeset,
            &SoftalizaWeb.ErrorHelpers.translate_error/1
          )

        ErrorResponse.bad_request(conn, errors)
    end
  end
end
