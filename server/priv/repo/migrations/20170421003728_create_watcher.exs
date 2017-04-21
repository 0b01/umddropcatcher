defmodule Server.Repo.Migrations.CreateWatcher do
  use Ecto.Migration

  def change do
    create table(:watchers) do
      add :course, :string
      add :email, :string

      timestamps()
    end

  end
end
