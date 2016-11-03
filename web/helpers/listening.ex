defmodule Tboechatbot.Listening do

    use Timex

    def more_product_options(they_said) do
      they_said == "for2"
    end

    def faq(they_said) do
      # TODO add regex stuff for faqs and standard responses
      # https://github.com/VerbalExpressions/ElixirVerbalExpressions
      cond do
        String.contains? they_said, "how much" -> "faq_prices"
        String.contains? they_said, " cost " -> "faq_prices"
        String.contains? they_said, " cost?" -> "faq_prices"
        String.contains? they_said, " price " -> "faq_prices"
        String.contains? they_said, " price?" -> "faq_prices"
        String.contains? they_said, " deliver" -> "faq_delivery"
        String.contains? they_said, "how long " -> "faq_delivery"
        String.contains? they_said, "when " -> "faq_delivery"
        true -> false
      end
    end

    def unknown_question(they_said) do
        String.contains? they_said, "?"
    end

    def joke_request(they_said) do
        String.contains? they_said, "joke"
    end

    def hey_im_matt(they_said, conversation) do
        context = Tboechatbot.ConversationRepo.find_current_context(conversation)
        they_said_to_lower = String.downcase(they_said)
        context == "from" && String.contains? they_said_to_lower, "matt"
    end

    def fails_validation(they_said, conversation) do
        case Tboechatbot.ConversationRepo.find_current_context(conversation) do
          "first_name" -> !valid_name(they_said)
          "last_name" -> !valid_name(they_said)
          "dob_year" -> !valid_year(they_said)
          "dob_month" -> !valid_month(they_said)
          "dob_day" -> !valid_day(they_said)
          _ -> false
        end
    end

    defp valid_name(name) do
        String.length(name) <= 14
    end

    defp valid_year(year) do
        case Timex.Parse.DateTime.Parser.parse(year, "%Y", :strftime) do
            {:ok, _} -> true
            _ -> false
        end
    end

    defp valid_month(month) do
        case {Timex.Parse.DateTime.Parser.parse(month, "{M}"), Timex.Parse.DateTime.Parser.parse(String.capitalize(month), "%B", :strftime)} do
            {{:ok, _}, _} -> true
            {_, {:ok, _}} -> true
            _ -> false
        end
    end

    defp valid_day(day) do
        day = day
        |> String.replace("st", "")
        |> String.replace("nd", "")
        |> String.replace("rd", "")
        |> String.replace("th", "")
        case Timex.Parse.DateTime.Parser.parse(day, "%e", :strftime) do
            {:ok, _} -> true
            _ -> false
        end
    end

end