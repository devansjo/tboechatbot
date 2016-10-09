defmodule Tboechatbot.ConversationView do
  use Tboechatbot.Web, :view

  def render("index.json", %{phrases: phrases}) do
   %{
      phrases: Enum.map(phrases, fn(phrase) -> phrases_json(phrase) end)
    }
  end
  def render("response.json", %{response: response}) do
   %{
      response: response
    }
  end

  def phrases_json(phrase) do
   %{
      id: phrase.id,
      context: phrase.context,
      en_GB: phrase.en_GB
    }
  end

#  def params_json(param) do
#    %{
#     id: param
#    }
#  end
end