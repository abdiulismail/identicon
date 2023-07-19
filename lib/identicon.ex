defmodule Identicon do

  def main(input) do

    input
    |> hash_input()
    |> pick_color()
    |> buil_grid()

  end



  def hash_input(input) do
    # hash = :crypto.hash(:md5, "banana")
    # :binary.bin_to_list(hash)

    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}

  end

    # def pick_color(myimage) do
  #   # %Identicon.Image{hex: hexlist} = myimage
  #   # [r,g,b | _tail ] = hexlist
  #   %Identicon.Image{hex: [r,g,b | _tail ]} = myimage
  #   %Identicon.Image{myimage | color: {r,g,b}}
  # end

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail ]} = myimage) do
    # %Identicon.Image{hex: hexlist} = myimage
    # [r,g,b | _tail ] = hexlist
    # %Identicon.Image{hex: [r,g,b | _tail ]} = myimage
    %Identicon.Image{myimage | color: {r,g,b}}
  end

  def buil_grid(%Identicon.Image{hex: hex} = myimage) do
    hex
    |> Enum.chunk_every(3)

  end
end
