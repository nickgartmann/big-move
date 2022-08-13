votes = File.read!("./votes_by_geoid.json")
        |> Jason.decode!


#votemap = Enum.reduce(votes, %{}, fn(v, acc) ->
#  Map.put(acc, Map.get(v, "geoid"), %{
#    gop: Map.get(v, "gop"),
#    dem: Map.get(v, "dem")
#  })
#end)

filename = "wigeo2020"
#filename = "wi000012020"
#filename = "wi000022020"
#filename = "wi000032020"

stream = "./pl/#{filename}.pl"
|> Path.expand(__DIR__)
|> File.stream!

stream
|> Stream.each(fn(line) ->
  parts = String.split(line, "|")
  logrecno = Enum.at(parts, 7)
  geoid = Enum.at(parts, 8) 
  geopart = Enum.at(parts, 9)
  blockid = Enum.at(parts, 34)
  #v = Map.get(votemap, geopart) 

  IO.puts geoid

  #if v != nil do
  #  IO.inspect v
  #end

end)
|> Stream.run

"""
stream = "./pl/#{filename}.pl"
|> Path.expand(__DIR__)
|> File.stream!

Stream.drop(stream, 10)
|> Stream.take(10)
|> Stream.filter(fn(line) ->
  IO.inspect line
  #parts = String.split(line, "|")
  #total_pop = Enum.at(parts, 5)
end)
|> Stream.run
"""
