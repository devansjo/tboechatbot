defmodule Tboechatbot.Bookbuilding do
    def create_book(params) do

          params = Map.merge(%{
            "occasion" => "current",
            "relationship" => "friends",
            "nick_name" => params["first_name"],
          }, params)

          user_id = 165
          dob_month = get_month(params["dob_month"])
          IO.puts dob_month
          dob_day = get_day(params["dob_day"])
          IO.puts dob_day
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

    defp get_month(month) do
        case {Timex.Parse.DateTime.Parser.parse(month, "{M}"), Timex.Parse.DateTime.Parser.parse(String.capitalize(month), "{%B}", :strftime)} do
            {{:ok, date}, _} -> date.month
            {_, {:ok, date}} -> date.month
            _ -> false
        end
    end

    defp get_day(day) do
        day = day
        |> String.replace("st", "")
        |> String.replace("nd", "")
        |> String.replace("rd", "")
        |> String.replace("th", "")
        case Timex.Parse.DateTime.Parser.parse(day, "%d", :strftime) do
            {:ok, date} -> date.day
            _ -> false
        end
    end
end


defmodule Crypto do
  def md5(nil), do: md5("")
  def md5(data) do
    Base.encode16(:erlang.md5("tboe" <> data <> "2020"), case: :lower)
  end
end