defmodule Server.PeriodicallyScrape do
  use GenServer
  require Logger
  import Ecto.Query, only: [from: 2]
  alias Server.Repo
  @config domain: Application.get_env(:addict, :mailgun_domain),
          key: Application.get_env(:addict, :mailgun_key)
  use Mailgun.Client, @config

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    HTTPoison.start

    query = from u in Server.Watcher,
          select: u.course
    all_courses = Repo.all(query)
    scrape(all_courses)

    schedule_work()
    {:noreply, state}
  end

  def get_data(body, selector) do 
    selected = Floki.find(body, selector)
    Enum.map(selected, fn {a,b,[c]} -> 
      c
      |> (fn w -> Regex.run( ~r/\d+/, w) end).()
      |> hd
    end)
  end

  def scrape([course|tail]) do
    term = Application.get_env(:server, Server.Endpoint)[:term]
    resp = HTTPoison.get! "https://ntst.umd.edu/soc/#{term}/sections?courseIds=#{course}"

    open_seats = get_data(resp.body, "span.open-seats-count")
    section_id = get_data(resp.body, "span.section-id")
    waitlist_count = get_data(resp.body, "span.waitlist-count")

    sections = Enum.zip([Enum.take(Stream.cycle([course]),100), open_seats, section_id, waitlist_count])
    updateCourses(sections)

    scrape(tail)
  end

  def updateCourses(sections) do
    Enum.map(sections, fn {courseID, open, sectionID, wlCount} ->
      watchers = Repo.all(from u in Server.Watcher, where: u.course == ^courseID and u.section == ^sectionID)
      op = String.to_integer(open)
      wl = String.to_integer(wlCount)
      Enum.each(watchers, fn (watcher) -> 
        changeset = Server.Watcher.changeset(watcher, %{"open": op, "waitlist": wl})
        Repo.update(changeset)

        if wl == 0 and not watcher.acknowledged and not watcher.sent do
          mail(watcher)
        end

      end)
    end)
  end 

  def mail(watcher) do
    em = Repo.get!(Server.User, watcher.user_id).email
    send_email to: em,
               from: "coursedrop@umd.fyi",
               subject: "ACTION REQUIRED: Course Drop",
               text: "The course you wanted is now available to register: #{watcher.course} #{watcher.section}.<a href=\"https://ntst.umd.edu/testudo/#/main/dropAdd\">Testudo</a>"

    changeset = Server.Watcher.changeset(watcher, %{"sent": true})
    Repo.update(changeset)
  end

  def scrape([]) do
    Logger.info "Done scraping"
    []
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 20* 1000) # In 2 seconds 
  end
end
