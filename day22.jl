function axis(ps)
  widths = [ps[i]-ps[i-1] for i ∈ 2:length(ps)]
  map = Dict(p => i for (i, p) ∈ enumerate(ps))
  return widths, bounds -> map[bounds[1]]:map[bounds[2]+1]-1
end

function count(cmds)
  px = unique(sort(vcat([[c.x[1], c.x[2]+1] for c ∈ cmds]...)))
  py = unique(sort(vcat([[c.y[1], c.y[2]+1] for c ∈ cmds]...)))
  pz = unique(sort(vcat([[c.z[1], c.z[2]+1] for c ∈ cmds]...)))
  widthx, mapx = axis(px)
  widthy, mapy = axis(py)
  widthz, mapz = axis(pz)

  state = falses(length(widthx), length(widthy), length(widthz))
  for (cmd, x, y, z) ∈ cmds
    state[mapx(x), mapy(y), mapz(z)] .= cmd == "on" ? 1 : 0
  end

  sum = 0
  for idx ∈ CartesianIndices(state)
    if state[idx]
      sum += widthx[idx[1]] * widthy[idx[2]] * widthz[idx[3]]
    end
  end
  return sum
end

cmds = map(readlines("data/day22.txt")) do l
  m = match(r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)", l)
  c = parse.(Int, m.captures[2:end])
  return (cmd=m[1], x=c[1:2], y=c[3:4], z=c[5:6])
end

# Part 1 - Considering only cubes in the region x=-50..50,y=-50..50,z=-50..50, how many cubes are on?
part1cmds = filter(cmds) do (cmd, x, y, z)
  return all(p ∈ -50:50 for p ∈ vcat(x, y, z))
end
println("part1 = ", count(part1cmds))

# Part 2 - Considering all cubes, how many cubes are on?
println("part2 = ", count(cmds))
