defmodule Jay_Mantri do

  use Hound.Helpers

  @home "http://jaymantri.com/"

  def scrape do
    Hound.start_session
    navigate_to @home
    process
  end

  defp get_photo(post) do
    find_within_element(post, :css, "div.caption > p > a") 
      |> attribute_value("href")
  end

  defp get_tags(post) do
    find_all_within_element(post, :css, "ul.tags > li:not(:first-child) > a")
      |> Enum.map(&inner_html/1)
  end

  defp process do
    find_element(:id, "posts")
      |> find_all_within_element(:class, "post")
      |> Enum.map(&process_post/1)
  end

  defp process_post(post) do 
    photos = get_photo(post)
    tags = get_tags(post)
  end

end

