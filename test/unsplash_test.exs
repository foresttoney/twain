defmodule TwaIn.Unsplash do

  use ExUnit.Case, async: true

  alias Twain.Unsplash

  test "it returns content from the home page" do
    contents_stream = Unsplash.scrape()

    content = contents_stream
    |> Stream.take(5)
    |> Enum.to_list

    assert length(content) === 5
  end

  test "it returns content from multiple pages" do
    contents_stream = Unsplash.scrape()

    content = contents_stream
    |> Stream.take(30)
    |> Enum.to_list

    IO.inspect(content)

    assert length(content) === 30
  end

end
