defmodule Server.Repo.Migrations.CreateWatcher do
  use Ecto.Migration

  def change do
    create table(:watchers) do
      add :course, :string
      add :section, :string
      add :enabled, :boolean, default: false, null: false
      add :acknowledged, :boolean, default: false, null: false
      add :user_id, :integer

      timestamps()
    end

  end
end
