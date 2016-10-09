defmodule Tboechatbot.Router do
  use Tboechatbot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Tboechatbot.User
#    plug Tboechatbot.Jwt
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", Tboechatbot do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Tboechatbot do
    pipe_through :api

    resources "/conversation", ConversationController, only: [:index, :create, :new]
   end
end
