defmodule Softaliza.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :active, :boolean, default: true
    field :description, :string
    field :end_date, :date
    field :end_hour, :time
    field :hosted_by, :string
    field :link, :string
    field :online, :boolean, default: false
    field :start_date, :date
    field :start_hour, :time
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :start_hour,
      :end_hour,
      :start_date,
      :end_date,
      :online,
      :hosted_by,
      :link
    ])
    |> validate_required([
      :title,
      :start_hour,
      :end_hour,
      :start_date,
      :end_date
    ])
  end
end
