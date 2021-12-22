using DataStructures: DefaultDict

graph = DefaultDict{String, Vector{String}}([])
for line ∈ eachline("data/day12.txt")
  a, b = split(line, '-')
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

# Part 1 - How many paths through this cave system are there that visit small caves at most once?
println("part1 = ", search(visited, "start", false))

# Part 2 - What if a single small cave can be visited at most twice?
println("part2 = ", search(visited, "start", true))
