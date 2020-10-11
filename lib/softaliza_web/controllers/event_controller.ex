defmodule SoftalizaWeb.EventController do
  use SoftalizaWeb, :controller

  alias Softaliza.Events

  def index(conn, _params) do
    events = [
      %{id: 1, title: "microbiologia", active: true},
      %{id: 2, title: "sistemas dinâmicos", active: true},
      %{id: 3, title: "equações diferenciais", active: false}
    ]

    render(conn, "events.json", data: events)
  end

  def show(conn, %{"id" => id}) do
    event = %{id: String.to_integer(id), name: "renan", age: 22}

    render(conn, "event.json", data: event)
  end

  def create(conn, params) do
    start_date = parse_date(params["start_date"])
    end_date = parse_date(params["end_date"])

    start_hour = parse_time(params["start_hour"])
    end_hour = parse_time(params["end_hour"])

    event =
      Map.merge(params, %{
        "start_date" => start_date,
        "end_date" => end_date,
        "start_hour" => start_hour,
        "end_hour" => end_hour
      })

    case Events.create_event(event) do
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

  # TODO provide better error when fail to parse
  defp parse_date(nil), do: nil

  defp parse_date(str) do
    case Date.from_iso8601(str) do
      {:ok, date} -> date
      {:error, :invalid_format} -> nil
    end
  end

  defp parse_time(nil), do: nil

  defp parse_time(str) do
    case Time.from_iso8601(str) do
      {:ok, time} -> time
      {:error, :invalid_format} -> nil
    end
  end
end
