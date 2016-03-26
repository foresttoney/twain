defmodule Twain.JayMantriTest do

  use ExUnit.Case, async: true

  alias Twain.JayMantri

  test "it returns contents from the home page" do
    contents_stream = JayMantri.scrape()

    contents = contents_stream
    |> Stream.take(5)
    |> Enum.to_list

    assert length(contents) === 5
  end

end

  # use Hound.Helpers

  # setup_all do
  #   Hound.start_session
  #   navigate_to(@site_url)
  #   site = page_source
  #   content = JayMantri.get_content(site)
  #   {:ok, %{content: content, site: site}}
  # end

  # test "it has content", context do
  #   assert Enum.empty?(context[:content]) === false
  # end

  # # TODO - This test doesn't accurately test the expected behavior.
  # #        The test should test that each content the possibility of having tags, not that
  # #        the image has actually been taged.
  # test "content has tags", context do
  #   [head|_] = context[:content]
  #   tags = JayMantri.get_tags(head)
  #   assert Enum.empty?(tags) === false
  # end

  # test "content has an image url", context do
  #   [head|_] = context[:content]
  #   image_url = JayMantri.get_image_url(head)
  #   assert is_bitstring(image_url) === true
  # end

  # test "has next page", context do
  #   next_page = JayMantri.get_next_url(context[:site])
  #   assert is_bitstring(next_page) === true
  # end


