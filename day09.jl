using PaddedViews

m = vcat(map(eachline("data/day09.txt")) do line
  transpose(parse.(Int, split(line, "")))
end...)
sx, sy = size(m)

# Part 1 - What is the sum of the risk levels of all low points on your heightmap?
p = PaddedView(9, m, (0:(sx+1), 0:(sy+1)), (1:sx, 1:sy))
mask = [p[i,j] < p[i-1,j] && p[i,j] < p[i+1,j] && p[i,j] < p[i,j-1] && p[i,j] < p[i,j+1] for i ∈ 1:sx, j ∈ 1:sy]
masked = m[mask]
println("part1 = ", sum(masked) + length(masked))

# Part 2 - What do you get if you multiply together the sizes of the three largest basins?
function dfs(idx, visited)
  if visited[idx] || m[idx] == 9
    return 0
  end
  visited[idx] = true

  size = 1
  for next ∈ [idx + CartesianIndex(shift) for shift ∈ [(-1,0), (1,0), (0,-1), (0,1)]]
    if checkbounds(Bool, m, next) && m[next] > m[idx]
      size += dfs(next, visited)
    end
  end
  return size
end

visited = zero(mask)
basins = []
for idx ∈ findall(==(1), mask)
  push!(basins, dfs(idx, visited))
end
sort!(basins, rev=true)
println("part2 = ", basins[1]*basins[2]*basins[3])
