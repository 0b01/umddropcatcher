defmodule Server.Router do
  use Server.Web, :router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Server do
    pipe_through :browser 
    resources "/watcher", WatcherController
    get "/ack/:id", WatcherController, :ack
    get "/", PageController, :index
    get "/refer", PageController, :refer
    get "/logout", PageController, :index
  end

  scope "/" do
    addict :routes
  end

end
