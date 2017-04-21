defmodule Server.User do
  use Server.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :referral, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :encrypted_password, :referral])
    |> validate_required([:email, :encrypted_password, :referral])
  end
end
