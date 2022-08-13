zip_filepath = "./votes.zip" 
               |> Path.expand(__DIR__)

[
  {"wi_2020", _proj, shapes}
] = Exshape.from_zip(zip_filepath)

{_, %{columns: headers}} = Stream.take(shapes, 1) |> Enum.at(0)

IO.inspect headers
"""

data = shapes
|> Stream.drop(1)
|> Stream.map(fn({_shape, data}) -> 

  hwi = Enum.with_index(headers)

  dem_header_idxs = Enum.filter(hwi, fn({%{name: name}, _}) ->
    String.at(name, 6) == "D"
  end)
  |> Enum.map(fn({_, i}) -> i end)

  gop_header_idxs = Enum.filter(hwi, fn({%{name: name}, _}) ->
    String.at(name, 6) == "R"
  end)
  |> Enum.map(fn({_, i}) -> i end)


  dem_count = dem_header_idxs 
              |> Enum.reduce(0, fn(idx, count) -> 
                count + Enum.at(data, idx)
              end)
  gop_count = gop_header_idxs 
              |> Enum.reduce(0, fn(idx, count) -> 
                count + Enum.at(data, idx)
              end)

  %{
    geoid: String.trim(Enum.at(data, 0)),
    gop: gop_count,
    dem: dem_count
  }

  IO.puts String.trim(Enum.at(data, 0))

end) 
|> Enum.to_list
|> Jason.encode!


File.write!("./votes_by_geoid.json", data)
"""
