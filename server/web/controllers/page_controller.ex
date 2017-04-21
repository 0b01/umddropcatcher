defmodule Server.PageController do
  use Server.Web, :controller
  require Logger
  plug Addict.Plugs.Authenticated when action in [:refer]


  def index(conn, _params) do
    render(conn, "index.html", is_logged_in: Addict.Helper.is_logged_in(conn))
  end

  def refer(conn, _params) do
    me = Repo.get(Server.User, Addict.Helper.current_user(conn).id)
    Logger.info me.referral
    render(conn, "refer.html", code: me.referral)
  end
end
