defmodule Twain.Unsplash do

  @moduledoc """
  Scrape [`Unsplash`](https://unsplash.com/) for all images and corresponding photographer.
  """

  @type html  :: String.t
  @type state :: {[], String.t | nil}
  @type url   :: String.t

  @url "https://unsplash.com"

  def scrpae do
    # Stream.resource(
    #   fn -> get_state(@url) end,
    #   &process/1,
    #   fn(_state) -> end
    # )
  end

  # @spec get_contents(html) :: Floki.html_tree
  # defp get_contents(html) do
    
  # end

  @spec get_state(url) :: state
  defp get_state(_url) do
    %{:body => html} = HTTPoison.get!(@url)
    IO.inspect(html)
  end

end

