defmodule SoftalizaWeb.EventController do
  use SoftalizaWeb, :controller

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

  def create(conn, _params) do
    json(conn, %{})
  end
end
