defmodule Jay_Mantri do

  use Hound.Helpers

  @home "http://jaymantri.com/"

  def scrape do
    process(@home)
  end

  @doc "Given a post element, return the corresponding download url for the image."
  defp get_photo(post) do
    find_within_element(post, :css, "div.caption > p > a") 
      |> attribute_value("href")
  end

  @doc "Given a post element, return the corresponding tags for the image."
  defp get_tags(post) do
    find_all_within_element(post, :css, "ul.tags > li:not(:first-child) > a")
      |> Enum.map(&inner_html/1)
  end

  defp process(url) do
    Hound.start_session
    navigate_to(url)

    photos = find_element(:id, "posts")
      |> find_all_within_element(:class, "post")
      |> Enum.map(&process_post/1)

    IO.inspect photos

    next_page_url = find_element(:css, ".nextPage") |> attribute_value("href")

    Hound.end_session
    process(next_page_url)
  end

  defp process_post(post) do 
    image = get_photo(post)
    tags = get_tags(post)
    {image, tags} 
  end

end

