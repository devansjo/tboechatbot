defmodule Tboechatbot.SmoochIn do
  import Plug.Conn

  def init(opts) do
    opts
  end

  ## just want to strip out user and/or message from json given by smooch
    def call(conn, _opts) do
        user_id = get_user(conn.params)
        they_said = what_did_they_say(conn.params) #https://en.wikipedia.org/wiki/Singular_they
        conn
        |> assign(:user_id, user_id)
        |> assign(:they_said, they_said)
    end

    defp get_user(params) do
      cond do
        params["appUser"] -> params["appUser"]["userId"] |> String.to_integer
        params["user_id"] -> params["user_id"] |> String.to_integer
        true -> "0"
      end
    end

    defp what_did_they_say(params) do
      cond do
        params["messages"] -> List.last(params["messages"])["text"]
        params["postbacks"] -> List.last(params["postbacks"])["action"]["payload"]
        true -> "?"
      end
    end

end