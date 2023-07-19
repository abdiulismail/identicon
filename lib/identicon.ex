defmodule Identicon do

  def main(input) do

    input
    |> hash_input()
    |> pick_color()
    |> build_grid()

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

  @doc """
    the build grid function takes in the Identicon.Image struct
    and chunks the hex data at every 3rd element

    ## example
       iex(2)> Identicon.main("dfdffff")
       [[132, 195, 149], [156, 44, 66], [89, 148, 74], ~c"M\v&", [186, 43, 88], ~c"n"]
  """
  def build_grid(%Identicon.Image{hex: hex} = _) do
    hex
    |> Enum.chunk_every(3)

  end
end
