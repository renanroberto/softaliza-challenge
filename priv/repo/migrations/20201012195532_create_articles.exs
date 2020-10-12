defmodule Softaliza.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :authors, :string
      add :doi, :string
      add :publication_date, :date
      add :published_by, :string
      add :active, :boolean, default: false, null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:articles, [:doi])
    create index(:articles, [:event_id])
  end
end
