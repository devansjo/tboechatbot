defmodule Tboechatbot.Listening do

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

end