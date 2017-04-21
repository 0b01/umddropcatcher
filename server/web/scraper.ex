defmodule Server.PeriodicallyScrape do
  use GenServer
  require Logger

  alias Server.Repo

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    Server.Watcher
    |> select (:
    Logger.info "test"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 1000) # In 2 seconds 
  end
end
