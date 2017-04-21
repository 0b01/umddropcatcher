defmodule Server.Watcher do
  use Server.Web, :model

  
  schema "watchers" do
    field :course, :string
    field :section, :string
    field :enabled, :boolean, default: false
    field :acknowledged, :boolean, default: false
    field :user_id, :integer
    field :open, :integer
    field :waitlist, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:course, :section, :enabled, :acknowledged, :user_id, :open, :waitlist])
    |> validate_required([:course, :section, :enabled, :acknowledged, :user_id, :open, :waitlist])
    |> validate_inclusion(:course, String.split(File.read!("courses"), "\n"))
  end
end
