lines = readlines("data/day13.txt")

dots = map(filter(l -> ',' ∈ l, lines)) do l
  return parse.(Int, split(l, ','))
end
folds = map(filter(l -> '=' ∈ l, lines)) do l
  dir, loc = match(r"fold along (.)=(.*)", l).captures
  return (dir, parse(Int, loc))
end

for (i, (dir, loc)) ∈ enumerate(folds)
  global dots = map(dots) do (x, y)
    if dir == "x" && x > loc
      x = 2*loc - x
    elseif dir == "y" && y > loc
      y = 2*loc - y
    end
    return (x, y)
  end
  if i == 1
    println(length(Set(dots)))
  end
end

mx = maximum(dots) do (x, y) return x end
my = maximum(dots) do (x, y) return y end
output = fill(' ', my+1, mx+1)
for (x, y) ∈ dots
  output[y+1, x+1] = '■'
end
for row ∈ eachrow(output)
  println(join(row, ""))
end
