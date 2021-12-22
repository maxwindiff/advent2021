using DataStructures

m = vcat(map(eachline("data/day15.txt")) do line
  transpose(parse.(Int, split(line, "")))
end...)

function dijk(m)
  src = CartesianIndex(1, 1)
  dst = CartesianIndex(size(m)...)  # bottom-right corner

  queue = PriorityQueue{CartesianIndex, Int}()
  dist = fill(typemax(Int), size(m)...)

  queue[src] = dist[src] = 0
  while !isempty(queue)
    this = dequeue!(queue)
    for (dx, dy) ∈ [(-1, 0), (1, 0), (0, -1), (0, 1)]
      next = this + CartesianIndex(dx, dy)
      if checkbounds(Bool, m, next)
        ndist = dist[this] + m[next]
        if ndist < dist[next]
          queue[next] = dist[next] = ndist
        end
      end
    end
    if dist[dst] < typemax(Int)
      break
    end
  end

  return dist[dst]
end

# Part 1 - What is the lowest total risk of any path from the top left to the bottom right?
println("part1 = ", dijk(m))

m2 = hcat([m .+ i for i ∈ 0:4]...)
m2 = vcat([m2 .+ i for i ∈ 0:4]...)
m2[m2 .>= 10] .-= 9

# Part 2 - Using the full map, what is the lowest total risk of any path from the top left to the bottom right?
println("part2 = ", dijk(m2))
