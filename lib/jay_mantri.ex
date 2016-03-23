defmodule Twain.JayMantri do

  @moduledoc """
  Scrape [`Jay Mantri`](http://jaymantri.com/) for all images and corresponding tags.
  """

  @type html :: String.t
  @type url  :: String.t

  @url "http://jaymantri.com"

  def scrape do
    stream = Stream.resource(
      fn        -> start(@url) end,
      fn(state) -> process(state) end,
      fn        -> {:complete} end
    )

    Stream.run(stream)
  end

  @spec get_content(html) :: Floki.html_tree
  defp get_content(html) do
    Floki.find(html, "#posts .post")
  end

  @spec get_full_url(url, String.t) :: url
  defp get_full_url(url, file_path) do
    url <> file_path
  end

  @spec get_image_url(Floki.html_tree) :: url
  def get_image_url(content) do
    with [a]                 <- Floki.find(content, "div.caption p a"),
         [href]              <- Floki.attribute(a, "href"),
         decoded_url          = URI.decode(href),
         %{:query => query}  <- URI.parse(decoded_url),
         %{"z" => image_url} <- URI.decode_query(query),
      do: image_url
  end

  @spec get_next_page_url(html) :: url | nil
  defp get_next_page_url(html) do
    next_page_url = html
    |> Floki.find(".nextPage")
    |> Floki.attribute("href")

    case next_page_url do
      [file_path] -> get_full_url(@url, file_path)
      _           -> nil
    end
  end

  @spec get_tags(Floki.html_tree) :: [String.t]
  defp get_tags(content) do
    content
    |> Floki.find("ul.tags li a")
    |> Enum.map(&Floki.text/1)
  end

  # defp parse(content) do
  #   tags = Enum.map(content, &get_tags/1)
  # end

  defp process(state) do
    {:halt, nil}
  end

  @spec start(url) :: {Floki.html_tree, url|nil}
  defp start(url) do
    %{:body => html} = HTTPoison.get!(@url)
    content = get_content(html)
    next_page_url = get_next_page_url(html)
    {content, next_page_url}
  end

end

