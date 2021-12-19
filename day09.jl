using PaddedViews

m = vcat(map(eachline("data/day09a.txt")) do line
  transpose(parse.(Int, split(line, "")))
end...)
sx, sy = size(m)

# Part 1
p = PaddedView(9, m, (0:(sx+1), 0:(sy+1)), (1:sx, 1:sy))
mask = [p[i,j] < p[i-1,j] && p[i,j] < p[i+1,j] && p[i,j] < p[i,j-1] && p[i,j] < p[i,j+1] for i ∈ 1:sx, j ∈ 1:sy]
masked = m[mask]
println(sum(masked) + length(masked))

# Part 2
path = []
function dfs((x, y), visited)
  if visited[x,y] || m[x,y] == 9
    return 0
  end
  visited[x,y] = true
  push!(path, (x, y))
  println(path)

  size = 1
  for next ∈ [(x-1,y), (x+1,y), (x,y-1), (x,y+1)]
    if checkbounds(Bool, m, next...) && m[next...] > m[x,y]
      size += dfs(next, visited)
    end
  end
  pop!(path)
  return size
end

visited = zero(mask)
basins = []
for idx ∈ findall(==(1), mask)
  println("=== $idx ===")
  push!(basins, dfs(Tuple(idx), visited))
end
sort!(basins, rev=true)
println(basins[1]*basins[2]*basins[3])
