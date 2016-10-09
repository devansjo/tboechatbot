defmodule Tboechatbot.ConversationController do

  use Tboechatbot.Web, :controller
  import Tboechatbot.Bookbuilding
  import Tboechatbot.Listening
  alias Tboechatbot.ConversationStep

  plug Tboechatbot.SmoochIn
  plug Tboechatbot.SmoochOut

  def index(conn, _params) do
    render conn, "response.json", response: PhraseRepo.all()
  end

  def new(conn, _params) do
    user_id = conn.assigns.user_id
    {reply, _} = {[], ConversationRepo.initialise_conversation(user_id)}
        |> add_message("open")
        |> add_message("for1")
    render conn, "response.json", response: %{user_id: user_id, reply: reply}
  end

  def create(conn, _params) do
    user_id = conn.assigns.user_id
    they_said = conn.assigns.they_said
    reply = user_id
        |> ConversationRepo.get_conversation
        |> move_the_conversation_along(they_said)
        |> ConversationRepo.save_conversation(user_id)
    render conn, "response.json", response: %{user_id: user_id, reply: reply}
  end

  defp move_the_conversation_along(conversation, they_said) do
    reply = []
    cond do
        they_said |> more_product_options
                ->    { reply, conversation }
                      |> add_message("for2")
        faq_answer = they_said |> faq
                ->    { reply, conversation }
                      |> add_message(faq_answer)
                      |> repeat_the_question
                      |> remove_placeholders
        they_said |> unknown_question
                ->    { reply, conversation }
                      |> add_message("evade")
                      |> repeat_the_question
                      |> remove_placeholders
        they_said |> joke_request
                ->    { reply, conversation }
                      |> add_message("joke")
                      |> repeat_the_question
                      |> remove_placeholders
        they_said
                ->    { reply, conversation }
                      |> add_message("encourage")
                      |> ask_next_question(they_said)
                      |> remove_placeholders
    end
  end

  defp repeat_the_question({phrases, conversation}) do
    context = ConversationRepo.find_current_context(conversation)
    add_message({phrases, conversation}, context)
  end

  defp ask_next_question({phrases, conversation}, they_said) do
    conversation = update_conversation(conversation, they_said)
    context = ConversationRepo.find_current_context(conversation)
    add_message({phrases, conversation}, context)
  end

  defp add_message({phrases, conversation}, context) do
    reply =  phrases ++ [ PhraseRepo.get(context) ]
    { reply, conversation }
  end

  defp remove_placeholders({phrases, conversation}) do
    reply = Enum.reduce(phrases, [], fn(phrase, acc) ->
            updated_phrase = phrase
                |> replace_generic(conversation)
                |> replace_booklink(conversation)
            List.insert_at(acc, -1, updated_phrase)
    end)
    { reply, conversation }
  end

  defp replace_generic(phrase, conversation) do
   cond do
        String.contains? phrase.en_GB, "###" ->
            updated_en_GB = phrase.en_GB
                |> String.replace("###FROMNAME###", ConversationRepo.who_from(conversation))
                |> String.replace("###FIRSTNAME###", ConversationRepo.who_to(conversation))
#            updated_en_US = phrase.en_US
#                |> String.replace("###FROMNAME###", ConversationRepo.who_from(conversation))
#                |> String.replace("###FIRSTNAME###", ConversationRepo.who_to(conversation))
            %{ phrase | en_GB: updated_en_GB}
        true -> phrase
   end
  end

  defp replace_booklink(phrase, conversation) do
    cond do
        String.contains? phrase.en_GB, "###BOOKLINK###" ->
            book_link = conversation.steps
                |> flatten_map
                |> create_book
            updated_en_GB = phrase.en_GB
                |> String.replace("###BOOKLINK###", book_link)
#            updated_en_US = phrase.en_US |> String.replace("###BOOKLINK###", book_link)
            %{ phrase | en_GB: updated_en_GB}
        true -> phrase
    end
  end

  defp update_conversation(conversation, they_said) do
    Enum.find_value(conversation.steps, conversation, fn(step) ->
      case step do
          %ConversationStep{context: "for1", value: 1}
            -> ConversationRepo.get_conversation(they_said)
          %ConversationStep{context: "for2", value: 1}
            -> ConversationRepo.get_conversation(they_said)
          %ConversationStep{context: current_context, value: 1}
            ->  next_context = ConversationRepo.find_next_context(conversation)
                updated_steps = conversation.steps
                    |> ConversationRepo.update_step(current_context, they_said)
                    |> ConversationRepo.update_step(next_context, 1)
                %{ conversation | steps: updated_steps }
          _ ->  false
      end
    end)
  end

end