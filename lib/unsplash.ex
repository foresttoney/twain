defmodule Twain.Unsplash do

  @moduledoc """
  Scrape [`Unsplash`](https://unsplash.com/) for all images and corresponding photographer.
  """

  @type html  :: String.t
  @type state :: {[], String.t | nil}
  @type url   :: String.t

  @url "https://unsplash.com"
  @source "Unsplash"

  def scrape do
    Stream.resource(
      fn -> get_state(@url) end,
      &process/1,
      fn(_state) -> end
    )
  end

  @spec get_contents(html) :: Floki.html_tree
  defp get_contents(html) do
    Floki.find(html, ".photo-grid > .photo-container")
  end

  @spec get_image_url(Floki.html_tree) :: url
  defp get_image_url(content) do
    content
    |> Floki.find(".photo__image")
    |> Floki.attribute("src")
    |> hd
    |> (&Regex.split(~r/\?/, &1)).()
    |> hd
  end

  @spec get_next_page_url(html) :: String.t
  defp get_next_page_url(html) do
    next_page_url = html
    |> Floki.find(".next_page")
    |> Floki.attribute("href")

    case next_page_url do
      [file_path | _] -> @url <> file_path;
      _               -> nil
    end
  end

  @spec get_photographer(Floki.html_tree) :: String.t
  defp get_photographer(content) do
    content
    |> Floki.find(".photo-description__info > .photo-description__author > a")
    |> Floki.text
  end

  @spec get_state(url) :: state
  defp get_state(url) do
    %{:body => html} = HTTPoison.get!(url)
    contents = get_contents(html)
    next_page_url = get_next_page_url(html)
    {contents, next_page_url}
  end

  defp parse(content) do
    image = get_image_url(content)
    photographer = get_photographer(content)
    %{image: image, photographer: photographer, source: @source}
  end

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

