defmodule ContentTest do

  use ExUnit.Case, async: true

  @image_url "http://t.umblr.com/redirect?z=http%3A%2F%2Fbit.ly%2F1gePS2y&t=OGQ5YjcxZDI2NzMyMTU3YmU1NmVmOWE5OWYxYzRlNjRlMmI1MTIyNyw2WnBmQzNWMw%3D%3D"

  test "It should retrieve an image binary" do
    image = Content.get_image(@image_url)
    assert is_binary(image) == true
  end

end

