defmodule JayMantriTest do

  use ExUnit.Case, async: true
  use Hound.Helpers

  @site_url "http://jaymantri.com/"

  setup_all do
    Hound.start_session
    navigate_to(@site_url)
    site = page_source
    content = JayMantri.get_content(site)
    {:ok, %{content: content, site: site}}
  end

  test "it has content", context do
    assert Enum.empty?(context[:content]) === false
  end

  # TODO - This test doesn't accurately test the expected behavior.
  #        The test should test that each content the possibility of having tags, not that
  #        the image has actually been taged.
  test "content has tags", context do
    [head|_] = context[:content]
    tags = JayMantri.get_tags(head)
    assert Enum.empty?(tags) === false
  end

  test "content has an image", context do
    [head|_] = context[:content]
    image = JayMantri.get_image(head)
    assert is_bitstring(image) === true
  end

  test "has next page", context do
    next_page = JayMantri.get_next_url(context[:site])
    assert is_bitstring(next_page) === true
  end

end

