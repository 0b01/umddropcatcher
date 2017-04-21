defmodule Server.WatcherController do
  use Server.Web, :controller
  require Logger
  plug Addict.Plugs.Authenticated when action in [:index, :new, :create, :show, :edit, :update, :delete]

  alias Server.Watcher

  def index(conn, _params) do
    id = Addict.Helper.current_user(conn).id
    watchers = Repo.all(from u in Watcher, where: u.user_id == ^id)
    render(conn, "index.html", watchers: watchers)
  end

  def new(conn, _params) do
    changeset = Watcher.changeset(%Watcher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"watcher" => watcher_params}) do
    id = Addict.Helper.current_user(conn).id
    changeset = Watcher.changeset(%Watcher{}, Map.put(watcher_params, "user_id", id))

    case Repo.insert(changeset) do
      {:ok, _watcher} ->
        conn
        |> put_flash(:info, "Watcher created successfully.")
        |> redirect(to: watcher_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    watcher = Repo.get!(Watcher, id)
    render(conn, "show.html", watcher: watcher)
  end

  def ack(conn, %{"id" => id}) do
    watcher = Repo.get!(Watcher, id)
    changeset = Watcher.changeset(watcher, %{"acknowledged": true, "sent": false})
    case Repo.update(changeset) do
      {:ok, watcher} ->
        conn
        |> put_flash(:info, "Watcher updated successfully.")
        |> redirect(to: watcher_path(conn, :show, watcher))
      {:error, changeset} ->
        render(conn, "index.html", watcher: watcher, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    watcher = Repo.get!(Watcher, id)
    changeset = Watcher.changeset(watcher)
    render(conn, "edit.html", watcher: watcher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "watcher" => watcher_params}) do
    watcher = Repo.get!(Watcher, id)
    changeset = Watcher.changeset(watcher, watcher_params)

    case Repo.update(changeset) do
      {:ok, watcher} ->
        conn
        |> put_flash(:info, "Watcher updated successfully.")
        |> redirect(to: watcher_path(conn, :show, watcher))
      {:error, changeset} ->
        render(conn, "edit.html", watcher: watcher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    watcher = Repo.get!(Watcher, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(watcher)

    conn
    |> put_flash(:info, "Watcher deleted successfully.")
    |> redirect(to: watcher_path(conn, :index))
  end
end
