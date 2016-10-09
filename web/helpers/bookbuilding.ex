defmodule Tboechatbot.Bookbuilding do
    def create_book(params) do

          params = Map.merge(%{
            "occasion" => "current",
            "relationship" => "friends",
            "nick_name" => params["first_name"],
          }, params)

          user_id = 165
          dob_month = params["dob_month"]
              |> String.downcase
              |> String.replace("january", "1") #make case insensitive
              |> String.replace("february", "2")
              |> String.replace("march", "3")
              |> String.replace("april", "4")
              |> String.replace("may", "5")
              |> String.replace("june", "6")
              |> String.replace("july", "7")
              |> String.replace("august", "8")
              |> String.replace("september", "9")
              |> String.replace("october", "10")
              |> String.replace("november", "11")
              |> String.replace("december", "12")

          dob_day = params["dob_day"]
              |> String.downcase
              |> String.replace("first", "1") #make case insensitive
              |> String.replace("second", "2")
              |> String.replace("third", "3")
              |> String.replace("fourth", "4")
              |> String.replace("fifth", "5")
              |> String.replace("sixth", "6")
              |> String.replace("seventh", "7")
              |> String.replace("eighth", "8")
              |> String.replace("ninth", "9")
              |> String.replace("tenth", "10") #etc etc
              |> String.replace("st", "")
              |> String.replace("nd", "")
              |> String.replace("rd", "")
              |> String.replace("th", "")

          { :ok, publication_date } = case params["occasion"] do
            "current" -> Timex.Date.now
            "next" -> get_next_birthday(dob_month, dob_day)
          end |> Timex.format("{YYYY}{0M}{0D}")

          senders = cond do
            is_list(params["from"]) ->
              params["from"]
            is_map(params["from"]) ->
              Map.values(params["from"])
            is_binary(params["from"]) ->
              String.split(params["from"], ~r/[\r\n]+/, trim: true) |> Enum.filter(&String.length/1)
          end

          customer_data = [
            "customer_data[receiver][first_name]": params["first_name"],
            "customer_data[receiver][last_name]": params["last_name"],
            "customer_data[receiver][nick_name]": params["nick_name"],
            "customer_data[receiver][birth_date]": [ dob_day, dob_month, params["dob_year"] ]
            |> Enum.map(&(String.rjust(&1, 2, ?0)))
            |> Enum.join("-"),
            "customer_data[receiver][gender]": params["gender"],
            "customer_data[publication_date]": publication_date,
            "customer_data[relationship]": params["relationship"],
            "customer_data[product]": params["product_code"],
            "customer_data[occasion]": params["occasion"],
            user_id: user_id,
            unique_id: (Crypto.md5(Ecto.UUID.generate) |> String.slice(0..12))
          ]

          customer_data = senders |> Enum.with_index |> Enum.reduce(customer_data, fn({sender, idx}, data) ->
            Keyword.put(data, :"customer_data[givers][#{idx}]", sender)
          end) |> Enum.reverse

          # API does not accept JSON and Hackney's url encoder doesn't
          # work recursively
          book = LegacyApi.post!(
            "/get/book",
            {:form, customer_data},
            %{"Content-type" => "application/x-www-form-urlencoded"},
            [ recv_timeout: 50_000 ]
          ).body
           Application.get_env(:tboechatbot, :bookbuilder_url) <> String.lstrip(book["unique_id"], ?#)
    end

    def flatten_map(steps) do
        Enum.reduce(steps, %{}, fn(x, acc) -> Map.merge(acc, %{x.context => x.value}) end)
    end


    defp get_next_birthday(month, day) do
        birthday_this_year = Timex.Date.from({Timex.Date.now.year, String.to_integer(month), String.to_integer(day)})
        birthday_next_year = Timex.Date.from({Timex.Date.now.year + 1, String.to_integer(month), String.to_integer(day)})
        case Timex.Date.compare(birthday_this_year, Timex.Date.now) do
            1 -> birthday_this_year
            _ -> birthday_next_year
        end
    end
end

defmodule Crypto do
  def md5(nil), do: md5("")
  def md5(data) do
    Base.encode16(:erlang.md5("tboe" <> data <> "2020"), case: :lower)
  end
end