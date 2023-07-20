defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    # hash = :crypto.hash(:md5, "banana")
    # :binary.bin_to_list(hash)

    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  # def pick_color(myimage) do
  #   # %Identicon.Image{hex: hexlist} = myimage
  #   # [r,g,b | _tail ] = hexlist
  #   %Identicon.Image{hex: [r,g,b | _tail ]} = myimage
  #   %Identicon.Image{myimage | color: {r,g,b}}
  # end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = myimage) do
    # %Identicon.Image{hex: hexlist} = myimage
    # [r,g,b | _tail ] = hexlist
    # %Identicon.Image{hex: [r,g,b | _tail ]} = myimage
    %Identicon.Image{myimage | color: {r, g, b}}
  end

  @doc """
    the build grid function takes in the Identicon.Image struct
    and chunks the hex data at every 3rd element

    ## example
       iex(2)> Identicon.main("dfdffff")
       [[132, 195, 149], [156, 44, 66], [89, 148, 74], ~c"M\v&", [186, 43, 88], ~c"n"]
  """
  def build_grid(%Identicon.Image{hex: hex} = myimage) do
    grid =
      hex
      |> Enum.chunk(3)
      # passing a reference to a function
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{myimage | grid: grid}
  end

  @doc """
   takes in the chunked list and mirror elements of each list
   takes in eg [145, 46, 200] and returns [145,46,200,46,145]
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  @doc """
    this returns the old image passed to it plus an updated grid from this
    function
    the operator | adds additional items or updates

    ## Example
       %Identicon.Image{hex: [144,1,80,152], color: {144,1,80}, grid: [{144,0},{80,2}]
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
