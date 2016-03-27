defmodule Twain.Gratisography do

  @moduledoc """
  Scrape [`Gratisography`](http://www.gratisography.com/) for all images.
  """

  @photographer "Ryan McGuire"
  @source "Gratisography"
  @url "http://www.gratisography.com/"

  def scrape do
    Stream.resource(
      fn -> get_state(@url) end,
      &process/1,
      fn(_state) -> end
    )
  end

  defp get_contents(html) do
    Floki.find(html, "li.all")
  end

  defp get_image_url(content) do
    content
    |> Floki.find("a")
    |> hd
    |> Floki.attribute("href")
    |> hd
  end

  # Gratisography is not currently paginated
  defp get_next_page_url(html) do
    nil
  end

  defp get_state(url) do
    %{:body => html} = HTTPoison.get!(@url)
    contents = get_contents(html)
    next_page_url = get_next_page_url(html)
    {contents, next_page_url}
  end

  defp get_tags(content) do
    content
    |> Floki.attribute("class")
    |> hd
    |> String.split
    |> Enum.reject(fn(tag) -> tag ==="mix" or tag === "all" or tag === "lazy" end)
  end

  defp parse(content) do
    image = get_image_url(content)
    tags = get_tags(content)
    %{image: image, photographer: @photographer, tags: tags, source: @source}
  end

  defp process(state = {[], nil}) do
    {:halt, state}
  end

  defp process(state) do
    state_reducer(state)
  end

  defp state_reducer({[content|contents], next_page_url}) do
    new_state = {contents, next_page_url}
    parsed_content = parse(content)
    {[parsed_content], new_state}
  end

end
