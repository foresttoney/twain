defmodule Twain.JayMantriTest do

  use ExUnit.Case, async: true

  alias Twain.JayMantri

  # test "it parses content" do
  #   contents_stream = JayMantri.scrape()

  #   content = contents_stream
  #   |> Stream.take(1)
  #   |> Enum.to_list
  # end

  test "it returns contents from the home page" do
    contents_stream = JayMantri.scrape()

    contents = contents_stream
    |> Stream.take(5)
    |> Enum.to_list

    assert length(contents) === 5
  end

  test "it returns contents from multiple pages" do
    contents_stream = JayMantri.scrape()

    contents = contents_stream
    |> Stream.take(30)
    |> Enum.to_list

    assert length(contents) === 30
  end

end

