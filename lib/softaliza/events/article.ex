defmodule Softaliza.Events.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Softaliza.Events.Event

  schema "articles" do
    field :active, :boolean, default: true
    field :authors, :string
    field :doi, :string
    field :publication_date, :date
    field :published_by, :string
    field :title, :string
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :title,
      :authors,
      :doi,
      :publication_date,
      :published_by,
      :active
    ])
    |> validate_required([
      :title,
      :doi
    ])
    |> unique_constraint(:doi)
  end
end
