defmodule Identicon do

  def main(input) do

    input
    |> hash_input()
    |> pick_color()

  end

  def pick_color(myimage) do
    %Identicon.Image{hex: hexlist} = myimage
    [r,g,b ] = hexlist
    [r,g,b]
  end

  def hash_input(input) do
    # hash = :crypto.hash(:md5, "banana")
    # :binary.bin_to_list(hash)

    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}

  end

end
