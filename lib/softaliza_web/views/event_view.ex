defmodule SoftalizaWeb.EventView do
  use SoftalizaWeb, :view

  def render("event.json", %{data: event}) do
    Map.delete(event, :active)
  end

  def render("events.json", %{data: events}) do
    events
    |> Enum.filter(&active_event?/1)
    |> render_many(__MODULE__, "event.json", as: :data)
  end

  defp active_event?(event) do
    event.active
  end
end
