defmodule SoftalizaWeb.EventController do
  use SoftalizaWeb, :controller

  alias Softaliza.Events
  alias Softaliza.PdfJobs

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
        ErrorResponse.not_found(conn, "event")
    end
  end

  def create(conn, params) do
    case Events.create_event(params) do
      {:ok, event} ->
        conn
        |> put_status(201)
        |> render("event.json", data: event)

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, event} <- Events.get_event(id),
         {:ok, new_event} <- Events.update_event(event, params) do
      render(conn, "event.json", data: new_event)
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "event")

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, event} <- Events.get_event(id),
         {:ok, deleted_event} <- Events.delete_event(event) do
      render(conn, "event.json", data: deleted_event)
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "event")

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end

  def certificate(conn, %{"id" => id} = params) do
    with {:ok, event} <- Events.get_event(id),
         {:ok, name} <- Map.fetch(params, "name") do
      cert = %{
        event: event.title,
        name: name
      }

      key = Base.encode64(to_string(event.id) <> " - " <> name)

      PdfJobs.insert(key, cert)

      conn
      |> put_status(201)
      |> json(%{key: key})
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "event")

      :error ->
        ErrorResponse.bad_request(conn, "bad request")
    end
  end

  def get_certificate(conn, %{"key" => key}) do
    with {:ok, pdf} <- PdfJobs.lookup(key) do
      send_download(
        conn,
        {:binary, pdf},
        filename: "certification.pdf",
        charset: "utf-8"
      )
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "certificate")

      {:error, :processing} ->
        conn
        |> put_status(200)
        |> json(%{
          status: "processing",
          message: "PDF is being processed"
        })
    end
  end
end
