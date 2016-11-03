defmodule Tboechatbot.SmoochOut do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    register_before_send(conn, fn(conn) ->
          response_map = Poison.decode!(conn.resp_body, as: %{})
          case response_map do
            %{"response" => %{"user_id" => user_id, "reply" => reply}}
                ->  #send each message in list to smooch
                    case Enum.all?(reply, fn(message) -> send_message(user_id, message["en_GB"], message["actions"], message["items"]) end) do
                      true  -> resp(conn, 204, "")
                      false -> resp(conn, 500, "Smooch unavailable or there was an error in reply")
                    end
            %{"response" => _}
                ->  conn
            _   ->  resp(conn, 500, "Error processing the request")
          end
        end)
  end

  defp send_message(user_id, thing_to_say, actions, _items) when actions != nil do
    message = %{
            "text": thing_to_say,
            "role": "appMaker",
            "actions": actions
        }
        |> Poison.encode!
  end

  defp send_message(user_id, thing_to_say, _actions, items) when items != nil do
    message = %{
            "text": thing_to_say,
            "role": "appMaker",
            "items": items
        }
        |> Poison.encode!
  end

  defp send_message(user_id, thing_to_say, _actions, _items) do
    message = %{
            "text": thing_to_say,
            "role": "appMaker"
        }
        |> Poison.encode!
  end

  defp smooch(user_id, message) do
    jwt = Application.get_env(:tboechatbot, :smooch_api_jwt)
    smooch_api_url = Application.get_env(:tboechatbot, :smooch_api_url)
    smooched_it = HTTPotion.post smooch_api_url <> "/appusers/" <> (user_id |> to_string) <> "/messages", [body: message, headers: ["Authorization": "Bearer " <> jwt, "Content-Type": "application/json"]]
    case smooched_it do
      %{status_code: 201} ->
           true
      %{message: message} ->
           IO.puts message
           false
      _ ->
           false
    end
  end

end