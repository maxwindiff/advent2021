using DataStructures: DefaultDict

graph = DefaultDict{String, Vector{String}}([])
for line ∈ eachline("data/day12.txt")
  a, b = split(line, "-")
  push!(graph[a], b)
  push!(graph[b], a)
end

function search(visited, loc, allow_one_revisit)
  if loc == "end"
    return 1
  elseif loc[1] ∈ 'a':'z' && visited[loc] > 0
    if !allow_one_revisit || any(>(1), (v for (k, v) ∈ visited if k[1] ∈ 'a':'z'))
      return 0
    end
  end
  visited[loc] += 1
  ret = sum(search(visited, next, allow_one_revisit) for next ∈ graph[loc] if next != "start")
  visited[loc] -= 1
  return ret
end

visited = DefaultDict{String, Int}(0)
println(search(visited, "start", false))
println(search(visited, "start", true))
