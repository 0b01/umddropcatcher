defmodule Server.PageController do
  use Server.Web, :controller
  require Logger


  def index(conn, _params) do
    render conn, "index.html"
  end

  def refer(conn, _params) do
    me = Repo.get(Server.User, Addict.Helper.current_user(conn).id)
    Logger.info me.referral
    text conn, "My referral code: #{me.referral}"

  end
end
