defmodule Twain.GratisographyTest do

  use ExUnit.Case, async: true

  alias Twain.Gratisography

  test "it should return images from the home page" do
    images_stream = Gratisography.scrape()

    images = images_stream
    |> Stream.take(20)
    |> Enum.to_list

    assert length(images) === 20
  end
end
