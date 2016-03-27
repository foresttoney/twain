defmodule Twain.JayMantri do

  @moduledoc """
  Scrape [`Jay Mantri`](http://jaymantri.com/) for all images and corresponding tags.
  """

  @type html  :: String.t
  @type state :: {[], String.t | nil}
  @type url   :: String.t

  @url "http://jaymantri.com"

  @doc """
  Returns a stream of parsed content.
  """
  def scrape do
    Stream.resource(
      fn -> get_state(@url) end,
      &process/1,
      fn(_state) -> end
    )
  end

  @spec get_contents(html) :: Floki.html_tree
  defp get_contents(html) do
    Floki.find(html, "#posts .post")
  end

  @spec get_image_url(Floki.html_tree) :: url
  defp get_image_url(content) do
    with [a | _]             <- Floki.find(content, "div.caption p a"),
         [href | _]          <- Floki.attribute(a, "href"),
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
      [file_path | _] -> @url <> file_path
      _               -> nil
    end
  end

  @spec get_state(url) :: state
  defp get_state(url) do
    %{:body => html} = HTTPoison.get!(url)
    contents = get_contents(html)
    next_page_url = get_next_page_url(html)
    {contents, next_page_url}
  end

  @spec get_tags(Floki.html_tree) :: [String.t]
  defp get_tags(content) do
    content
    |> Floki.find("ul.tags li a")
    |> Enum.map(&Floki.text/1)
  end

  defp parse(content) do
    image = get_image_url(content)
    tags = get_tags(content)
    %{image: image, tags: tags}
  end

  @spec process(state) :: {:halt | [], state}
  defp process(state = {[], nil}) do
    {:halt, state}
  end

  defp process({[], next_page_url}) do
    state = get_state(next_page_url)
    state_reducer(state)
  end

  defp process(state) do
    state_reducer(state)
  end

  @spec state_reducer(state) :: {[], state}
  defp state_reducer({[content|contents], next_page_url}) do
    new_state = {contents, next_page_url}
    parsed_content = parse(content)
    {[parsed_content], new_state}
  end

end

