defmodule JayMantri do

  @moduledoc """
  """
  @site_url "http://jaymantri.com"

  def get_content(html) do
    Floki.find(html, "#posts .post")
  end

  def get_image(html) do
    html
    |> Floki.find("div.caption p a")
    |> Floki.attribute("href")
    |> hd
  end

  # TODO - Determine is this is the approperiate way to pattern match next_url
  def get_next_url(html) do
    next_url = html
    |> Floki.find(".nextPage")
    |> Floki.attribute("href")

    case next_url do
      [url] -> combine_url(@site_url, url)
      _     -> nil
    end
  end

  def get_tags(html) do
    html
    |> Floki.find("ul.tags li a")
    |> Enum.map(&Floki.text/1)
  end

  def scrape do
    process_url(@site_url)
  end

  defp combine_url(site_url, url) do
    site_url <> url
  end

  defp parse(html) do
    IO.inspect(html)
  end

  # TODO - Determine if this is the appropriate way to pattern match process_url
  defp process_url(url) do
    %HTTPoison.Response{:body => html} = HTTPoison.get!(url)

    case get_next_url(html) do
      url when is_bitstring(url) -> process_url(url)
      _                          -> nil
    end
  end

end

