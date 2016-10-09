defmodule Tboechatbot.User do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    #take user id from session, or create random if not
    user_id = get_session(conn, :user_id)
    if !user_id do
        user_id = :os.system_time(:milli_seconds) #temp until implement proper auth
        conn = put_session(conn, :user_id, user_id)
    end
    conn = assign(conn, :user_id, user_id)
  end
end