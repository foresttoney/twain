defmodule Content do

  def get_image(url) do
    %HTTPoison.Response{body: image} =  HTTPoison.get!(url, [], [{:follow_redirect, true}])
    image
  end

end
