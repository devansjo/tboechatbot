defmodule Tboechatbot.Jwt do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
#    #get jwt happening
    user_id = conn.assigns.user_id
    payload = %{
        userId: user_id |> to_string,
        scope: "appUser"
    }
    |> Poison.encode!
    |> Base.url_encode64
    header = %{
        kid: Application.get_env(:tboechatbot, :smooch_key),
        alg: "HS256",
        typ: "JWT"
    }
    |> Poison.encode!
    |> Base.url_encode64
    unsigned = Enum.join([header, payload], ".")
    signature = :crypto.hmac(:sha256, Application.get_env(:tboechatbot, :smooch_secret), unsigned)
    |> Base.url_encode64
    jwt = Enum.join([header, payload, signature], ".")
#    hm jwt not happening :( try JSON.parse to strip the backslashes? Poison.Parser.parse!
   conn = assign(conn, :jwt, jwt)
  end
end