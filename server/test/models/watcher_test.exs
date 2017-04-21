defmodule Server.WatcherTest do
  use Server.ModelCase

  alias Server.Watcher

  @valid_attrs %{acknowledged: true, course: "some content", enabled: true, section: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Watcher.changeset(%Watcher{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Watcher.changeset(%Watcher{}, @invalid_attrs)
    refute changeset.valid?
  end
end
