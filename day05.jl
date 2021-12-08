using OffsetArrays

vents = map(readlines("data/day05.txt")) do x
  m = match(r"(\d+),(\d+) -> (\d+),(\d+)", x)
  n = parse.(Int, m.captures)
  return (a=(x=n[1], y=n[2]), b=(x=n[3], y=n[4]))
end

x_max = maximum(v -> max(v.a.x, v.b.x), vents)
y_max = maximum(v -> max(v.a.y, v.b.y), vents)
floor1 = OffsetArray(zeros(Int, x_max+1, y_max+1), 0:x_max, 0:y_max)
floor2 = OffsetArray(zeros(Int, x_max+1, y_max+1), 0:x_max, 0:y_max)

for (a, b) ∈ vents
  if a.x == b.x
    for y ∈ a.y:sign(b.y - a.y):b.y
      floor1[a.x, y] += 1
      floor2[a.x, y] += 1
    end
  elseif a.y == b.y
    for x ∈ a.x:sign(b.x - a.x):b.x
      floor1[x, a.y] += 1
      floor2[x, a.y] += 1
    end
  else
    for (x, y) ∈ zip(a.x:sign(b.x - a.x):b.x, a.y:sign(b.y - a.y):b.y)
      floor2[x, y] += 1
    end
  end
end
#display(floor1)
println(count(>(1), floor1))
println(count(>(1), floor2))
