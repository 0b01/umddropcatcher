defmodule Server.WatcherControllerTest do
  use Server.ConnCase

  alias Server.Watcher
  @valid_attrs %{acknowledged: true, course: "some content", enabled: true, section: "some content", user_id: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, watcher_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing watchers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, watcher_path(conn, :new)
    assert html_response(conn, 200) =~ "New watcher"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, watcher_path(conn, :create), watcher: @valid_attrs
    assert redirected_to(conn) == watcher_path(conn, :index)
    assert Repo.get_by(Watcher, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, watcher_path(conn, :create), watcher: @invalid_attrs
    assert html_response(conn, 200) =~ "New watcher"
  end

  test "shows chosen resource", %{conn: conn} do
    watcher = Repo.insert! %Watcher{}
    conn = get conn, watcher_path(conn, :show, watcher)
    assert html_response(conn, 200) =~ "Show watcher"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, watcher_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    watcher = Repo.insert! %Watcher{}
    conn = get conn, watcher_path(conn, :edit, watcher)
    assert html_response(conn, 200) =~ "Edit watcher"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    watcher = Repo.insert! %Watcher{}
    conn = put conn, watcher_path(conn, :update, watcher), watcher: @valid_attrs
    assert redirected_to(conn) == watcher_path(conn, :show, watcher)
    assert Repo.get_by(Watcher, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    watcher = Repo.insert! %Watcher{}
    conn = put conn, watcher_path(conn, :update, watcher), watcher: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit watcher"
  end

  test "deletes chosen resource", %{conn: conn} do
    watcher = Repo.insert! %Watcher{}
    conn = delete conn, watcher_path(conn, :delete, watcher)
    assert redirected_to(conn) == watcher_path(conn, :index)
    refute Repo.get(Watcher, watcher.id)
  end
end
