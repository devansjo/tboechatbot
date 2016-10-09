defmodule Tboechatbot.Phrase do

#   each phrase has
#   an id (unique), a context and text for the phrase in specified language
#   - conversation openers
#   - chasing first name
#   - chasing last name
#   - chasing birthdate
#   - chasing gender
#   - chasing publication date (current age or next age)
#   - chasing relationship (use this to determine the type of book? e.g. romantic, book of dad or generic birthday etc.)
#   - summarising information provided
#   - evading when cannot understand human response (to connect to another context)
#   - random fact
#   - random joke
#   - present link to bookbuilder
#   - conversation closers

  defstruct [
        :context,
        :en_UK,
        :en_US,
        :actions
      ]
end