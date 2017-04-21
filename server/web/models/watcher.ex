defmodule Server.Watcher do
  use Server.Web, :model

  
  schema "watchers" do
    field :course, :string
    field :section, :string
    field :enabled, :boolean, default: false
    field :acknowledged, :boolean, default: false
    field :user_id, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:course, :section, :enabled, :acknowledged, :user_id])
    |> validate_required([:course, :section, :enabled, :acknowledged, :user_id])
    |> validate_inclusion(:course, String.split(File.read!("courses"), "\n"))
  end
end
