using DataStructures

m = vcat(map(eachline("data/day15.txt")) do line
  transpose(parse.(Int, split(line, "")))
end...)

function dijk(m)
  src = CartesianIndex(1, 1)
  dst = CartesianIndex(size(m)...)

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

println(dijk(m))

m2 = hcat([m .+ i for i ∈ 0:4]...)
m2 = vcat([m2 .+ i for i ∈ 0:4]...)
m2[m2 .>= 10] .-= 9
println(dijk(m2))
