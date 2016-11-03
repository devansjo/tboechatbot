defmodule Tboechatbot.PhraseRepo do
  @moduledoc """
  In memory repository.
"""
    def all() do
      [
        %Tboechatbot.Phrase{ context: "open", en_GB: "¡Hola! I am the test chatbot. We are going to make a book." },
        %Tboechatbot.Phrase{ context: "open", en_GB: "What's up? I am the test chatbot. I am going to help you write a book." },
        %Tboechatbot.Phrase{ context: "hello", en_GB: "Hey ###FROMNAME###" },
        %Tboechatbot.Phrase{ context: "for1", en_GB: "Firstly, who is the book for?", actions: [
            %{"type": "postback", "text": "A friend", "payload": "friend" },
            %{"type": "postback", "text": "Boyfriend", "payload": "boyfriend"},
            %{"type": "postback", "text": "Girlfriend", "payload": "girlfriend"},
            %{"type": "postback", "text": "Mum", "payload": "mum"},
            %{"type": "postback", "text": "Dad", "payload": "dad"},
            %{"type": "postback", "text": "Show me more options", "payload": "for2"}
        ] },
        %Tboechatbot.Phrase{ context: "for2", en_GB: "So maybe one of the following?", actions: [
            %{"type": "postback", "text": "Husband", "payload": "husband" },
            %{"type": "postback", "text": "Wife", "payload": "wife"},
            %{"type": "postback", "text": "Work colleague", "payload": "colleague"},
            %{"type": "postback", "text": "A relative", "payload": "relative"},
            %{"type": "postback", "text": "Other", "payload": "friend"}
        ] },
        %Tboechatbot.Phrase{ context: "from", en_GB: "Who is the book from? Your name, please."},
        %Tboechatbot.Phrase{ context: "first_name", en_GB: "What is the first name of the person you want to make a book for?" },
        %Tboechatbot.Phrase{ context: "first_name_validation_tip", en_GB: "The name needs to be less than 14 letters otherwise it won't fit :-(" },

        %Tboechatbot.Phrase{ context: "last_name", en_GB: "And what is the last name?" },
        %Tboechatbot.Phrase{ context: "last_name_validation_tip", en_GB: "The name needs to be less than 14 letters otherwise it won't fit :-(" },

        %Tboechatbot.Phrase{ context: "dob_year", en_GB: "We need ###FIRSTNAME###'s birthday. What year were they born in?" },
        %Tboechatbot.Phrase{ context: "dob_year_validation_tip", en_GB: "I'm sorry but I need a valid year e.g. 1985." },

        %Tboechatbot.Phrase{ context: "dob_month", en_GB: "The month were they born?" },
        %Tboechatbot.Phrase{ context: "dob_month_validation_tip", en_GB: "I'm sorry but I need a valid month, e.g. October or 10." },

        %Tboechatbot.Phrase{ context: "dob_day", en_GB: "What day of the month?" },
        %Tboechatbot.Phrase{ context: "dob_day_validation_tip", en_GB: "I'm sorry but I need a valid day, e.g. 1, 2 etc. " },

        %Tboechatbot.Phrase{ context: "gender", en_GB: "Are they male or female?", actions: [
            %{"type": "postback", "text": "Male", "payload": "m" },
            %{"type": "postback", "text": "Female", "payload": "f"}
        ] },
        %Tboechatbot.Phrase{ context: "occasion", en_GB: "Is this a birthday present?", actions: [
            %{"type": "postback", "text": "Yes", "payload": "next" },
            %{"type": "postback", "text": "No", "payload": "current"}
        ] },
        %Tboechatbot.Phrase{ context: "encourage", en_GB: "Great!" },
        %Tboechatbot.Phrase{ context: "encourage", en_GB: "Good!" },
        %Tboechatbot.Phrase{ context: "encourage", en_GB: "Woot!" },
        %Tboechatbot.Phrase{ context: "encourage", en_GB: "Got it!" },
        %Tboechatbot.Phrase{ context: "encourage", en_GB: "Roger that!" },
        %Tboechatbot.Phrase{ context: "joke", en_GB: "A man walked into a bar... Ouch! It was an iron bar." },
        %Tboechatbot.Phrase{ context: "evade", en_GB: "I'm sorry. I don't understand that request." },
        %Tboechatbot.Phrase{ context: "evade", en_GB: "Hey! I'm asking the questions here!'" },
        %Tboechatbot.Phrase{ context: "close", en_GB: "Here is a link to your book. ¡Hasta luego! ###BOOKLINK###" },
        %Tboechatbot.Phrase{ context: "start_again", en_GB: "Refresh the page to start the conversation again" },
        %Tboechatbot.Phrase{ context: "faq_prices", en_GB: "I would tell you about prices now but I need to copy the info from the website and haven't done that yet." },
        %Tboechatbot.Phrase{ context: "faq_delivery", en_GB: "I would tell you about delivery times now but I need to copy the info from the website and haven't done that yet." },
        %Tboechatbot.Phrase{ context: "fail", en_GB: "Yeah, you got me. I'm just a chatbot and I have no idea what you just said or how it answers the question I asked. Let's try that again." },
        %Tboechatbot.Phrase{ context: "flip_off", en_GB: "\xF0\x9F\x98\x8A (pending carousel implementation)" },
#        %Tboechatbot.Phrase{ context: "flip_off", items: [
#            %{"title": "Title", "description": "Description", "mediaUrl": "http://example.org/image.jpg", "actions": [
#                %{"text": "Select", "type": "postback", "payload": "TACOS"}
#             ]}
#         ]}
      ]
      |> Enum.shuffle
    end

    def get(context) do
         Enum.find all(), fn map -> map.context == context end
    end
end

defmodule Tboechatbot.ConversationRepo do
    import Redix
    def all() do
          [
            %Tboechatbot.Conversation{ product: "define_product", steps: [
                %Tboechatbot.ConversationStep{context: "for1", value: 1},
                %Tboechatbot.ConversationStep{context: "for2", value: 0}
            ] },
            %Tboechatbot.Conversation{ product: "birthday", steps: [
                %Tboechatbot.ConversationStep{context: "product_code", value: "birthday"},
                %Tboechatbot.ConversationStep{context: "from", value: 1},
                %Tboechatbot.ConversationStep{context: "first_name", value: 0},
                %Tboechatbot.ConversationStep{context: "last_name", value: 0},
                %Tboechatbot.ConversationStep{context: "gender", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_year", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_month", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_day", value: 0},
                %Tboechatbot.ConversationStep{context: "relationship", value: 0},
                %Tboechatbot.ConversationStep{context: "occasion", value: 0},
                %Tboechatbot.ConversationStep{context: "close", value: 0}
            ] },
            %Tboechatbot.Conversation{ product: "milestone", steps: [
                %Tboechatbot.ConversationStep{context: "product_code", value: "milestone"},
                %Tboechatbot.ConversationStep{context: "from", value: 1},
                %Tboechatbot.ConversationStep{context: "first_name", value: 0},
                %Tboechatbot.ConversationStep{context: "last_name", value: 0},
                %Tboechatbot.ConversationStep{context: "gender", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_year", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_month", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_day", value: 0},
                %Tboechatbot.ConversationStep{context: "relationship", value: 0},
                %Tboechatbot.ConversationStep{context: "occasion", value: 0},
                %Tboechatbot.ConversationStep{context: "close", value: 0}
            ] },
            %Tboechatbot.Conversation{ product: "bookofdad", steps: [
                %Tboechatbot.ConversationStep{context: "product_code", value: "bookofdad"},
                %Tboechatbot.ConversationStep{context: "from", value: 1},
                %Tboechatbot.ConversationStep{context: "first_name", value: 0},
                %Tboechatbot.ConversationStep{context: "last_name", value: 0},
                %Tboechatbot.ConversationStep{context: "gender", value: "m"},
                %Tboechatbot.ConversationStep{context: "dob_year", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_month", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_day", value: 0},
                %Tboechatbot.ConversationStep{context: "relationship", value: "family"},
                %Tboechatbot.ConversationStep{context: "nick_name", value: "Dad"},
                %Tboechatbot.ConversationStep{context: "occasion", value: 0},
                %Tboechatbot.ConversationStep{context: "close", value: 0}
            ] },
            %Tboechatbot.Conversation{ product: "bookofmum", steps: [
                %Tboechatbot.ConversationStep{context: "product_code", value: "bookofmum"},
                %Tboechatbot.ConversationStep{context: "from", value: 1},
                %Tboechatbot.ConversationStep{context: "first_name", value: 0},
                %Tboechatbot.ConversationStep{context: "last_name", value: 0},
                %Tboechatbot.ConversationStep{context: "gender", value: "f"},
                %Tboechatbot.ConversationStep{context: "dob_year", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_month", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_day", value: 0},
                %Tboechatbot.ConversationStep{context: "relationship", value: "family"},
                %Tboechatbot.ConversationStep{context: "nick_name", value: "Mum"},
                %Tboechatbot.ConversationStep{context: "occasion", value: 0},
                %Tboechatbot.ConversationStep{context: "close", value: 0}
            ] },
            %Tboechatbot.Conversation{ product: "romantic", steps: [
                %Tboechatbot.ConversationStep{context: "product_code", value: "romantic"},
                %Tboechatbot.ConversationStep{context: "from", value: 1},
                %Tboechatbot.ConversationStep{context: "first_name", value: 0},
                %Tboechatbot.ConversationStep{context: "last_name", value: 0},
                %Tboechatbot.ConversationStep{context: "gender", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_year", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_month", value: 0},
                %Tboechatbot.ConversationStep{context: "dob_day", value: 0},
                %Tboechatbot.ConversationStep{context: "relationship", value: "love"},
                %Tboechatbot.ConversationStep{context: "occasion", value: 0},
                %Tboechatbot.ConversationStep{context: "close", value: 0}
            ] },
          ]
    end

    def initialise_conversation(userId) do
        conversation = get_conversation("define_product", "", "")
        save_conversation(conversation, userId)
        conversation
    end

    def save_conversation(conversation, userId) when is_map(conversation) do
        #{:ok, conn} = start_link(Application.get_env(:redix, :url))
        bin_conversation   = :erlang.term_to_binary(conversation)
        Redix.command!(:redis, ["SET", userId, bin_conversation])
    end

    def save_conversation(reply_conversation, userId) when is_tuple(reply_conversation) do
        save_conversation(elem(reply_conversation, 1), userId)
        elem(reply_conversation, 0)
    end

    def get_conversation(userId) when is_integer(userId) do
        bin_conversation = Redix.command!(:redis, ["GET", userId])
        :erlang.binary_to_term(bin_conversation)
    end

    def get_conversation(they_said) when is_binary(they_said) do
        case they_said do
            "dad" -> get_conversation("bookofdad", "", "")
            "mum" -> get_conversation("bookofmum", "", "")
            "boyfriend" -> get_conversation("romance", "gender", "m")
            "girlfriend" -> get_conversation("romance", "gender", "f")
            "husband" -> get_conversation("romance", "gender", "m")
            "wife" -> get_conversation("romance", "gender", "f")
            _ -> get_conversation("birthday", "relationship", "friend")
        end
    end

    def get_conversation(product, context, _value) when context == "" do
        Enum.find(all(), fn map -> map.product == product end)
    end

    def get_conversation(product, context, value) do
        conversation = Enum.find(all(), fn map -> map.product == product end)
        updated_steps = update_step(conversation.steps, context, value)
        %{conversation | steps: updated_steps}
    end


    def find_current_context(conversation) do
        Enum.find_value(
            conversation.steps,
            "start_again",
            fn(%Tboechatbot.ConversationStep{context: context, value: value}) ->
                case value do
                  1 -> context
                  _ -> false
                end
            end
        )
    end

    def find_next_context(conversation) do
        index =  Enum.find_index(
                  conversation.steps,
                  fn(%Tboechatbot.ConversationStep{context: _, value: value}) ->
                      value == 0
                  end
                )
        case is_integer(index) do
            true -> Enum.at(conversation.steps, index).context
            false -> "start_again"
        end
    end

    defp find_index_of_context(steps, context_to_find) do
        Enum.find_index(
          steps,
          fn(%Tboechatbot.ConversationStep{context: context, value: _}) ->
              context_to_find == context
          end
        )
    end

    def update_step(_steps, context, _value) when context == "start_again" do
        conversation = get_conversation("define_product", "", "")
        conversation.steps
    end

    def update_step(steps, context, value) do
        steps
        |> find_index_of_context(context)
        |> (&(List.update_at(steps, &1, fn(_) -> %Tboechatbot.ConversationStep{context: context, value: value} end))).()
    end

    def who_from(conversation) do
        conversation.steps
        |> find_value_of_context("from")
    end

    def who_to(conversation) do
        conversation.steps
        |> find_value_of_context("first_name")
    end

    defp find_value_of_context(steps, context_to_find) do
        Enum.find_value(
            steps,
            "mate",
            fn(%Tboechatbot.ConversationStep{context: context, value: value}) ->
                cond do
                  context == context_to_find && is_binary(value) -> value
                  true -> false
                end
            end
        )
    end

    def remove_all_redis() do
        {:ok, conn} = start_link(Application.get_env(:redix, :url))
        Redix.command!(conn, ["FLUSHDB"])
        Redix.stop(conn)
    end
end