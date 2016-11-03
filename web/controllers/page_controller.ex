defmodule Tboechatbot.PageController do
  require Logger
  use Tboechatbot.Web, :controller

  def index(conn, _params) do
    user_id = conn.assigns.user_id
    app_token = Application.get_env(:tboechatbot, :smooch_app_token)
    chat_api_url = Application.get_env(:tboechatbot, :chat_api_url)
    IO.puts chat_api_url
    render conn, "index.html", %{header: "header.html", footer: "footer.html", user_id: user_id, app_token: app_token, chat_api_url: chat_api_url}
  end
end
