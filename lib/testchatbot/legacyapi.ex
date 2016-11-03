defmodule LegacyApi do
  use HTTPoison.Base

  require Logger

  def process_url(url) do
    Application.get_env(:tboechatbot, :legacy_api_url) <> url
  end

  def process_response_body(body) do
    [ body, _ ] = Regex.run(~r/({.*})$/, body)
    case Poison.decode(body) do
      {:ok, value} -> value
      {:error, _} -> body
    end
  end

  def request(method, url, body \\ "", headers \\ [], options \\ []) do
    data = %{
      type: "legacy-api",
      method: method,
      url: url,
      body: body_for_logging(body),
      headers: Enum.into(headers, %{}),
      options: Enum.into(options, %{})
    }

    case Poison.encode(data) do
      {:ok, json} ->
        Logger.info(json)
      _ ->
        Logger.error("unable to log legacy api call - [#{method}] #{url}")
    end

    super(method, url, body, headers, options)
  end

  defp body_for_logging(body) when is_list(body) do
    Enum.into(body, %{})
  end

  defp body_for_logging({:form, body}) when is_list(body) do
    Enum.into(body, %{})
  end

  defp body_for_logging(body)  do
    body
  end
end
