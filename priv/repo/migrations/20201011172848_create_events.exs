defmodule Softaliza.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text
      add :start_hour, :time
      add :end_hour, :time
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :online, :boolean, default: false, null: false
      add :hosted_by, :string
      add :link, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end
  end
end
