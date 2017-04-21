defmodule Server.UserActions do
  require Ecto.Query
  require Ecto.Changeset

  alias Server.Repo

  def login(conn, status, model) do
    IO.inspect status
    IO.inspect model
    conn
  end

  def logout(conn, status, model) do
    IO.inspect status
    IO.inspect model
    conn
  end

  def register(conn, status, model) do
    id = Addict.Helper.current_user(conn).id
    user = Repo.get(Server.User, id)
    user = Ecto.Changeset.change user, referral: random_string(10)
    Repo.update user
    conn
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def validate({:ok, _}, %{"referral" => referral}) do
    case Repo.get_by(Server.User, referral: referral) do
      nil  -> {:error, [name: "Referral code does not exists."]}
      exists -> {:ok, []}
    end
  end
end
