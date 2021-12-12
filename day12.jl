using DataStructures: DefaultDict

graph = DefaultDict{String, Vector{String}}([])
for line ∈ eachline("data/day12.txt")
  a, b = split(line, "-")
  b != "start" && push!(graph[a], b)
  a != "start" && push!(graph[b], a)
end

function search(visited, loc, allow_one_revisit)
  if loc == "end"
    return 1
  elseif visited[loc] > 0 && !allow_one_revisit
    return 0
  end

  loc[1] ∈ 'a':'z' && (visited[loc] += 1)
  ret = sum(search(visited, next, allow_one_revisit && visited[loc] < 2) for next ∈ graph[loc])
  loc[1] ∈ 'a':'z' && (visited[loc] -= 1)
  return ret
end

visited = DefaultDict{String, Int}(0)
println(search(visited, "start", false))
println(search(visited, "start", true))
