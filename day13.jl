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
    # Part 1 - How many dots are visible after completing just the first fold instruction on your transparent paper?
    println("part1 = ", length(Set(dots)))
  end
end

mx = maximum(((x, y),) -> x, dots)
my = maximum(((x, y),) -> y, dots)
output = fill(' ', my+1, mx+1)
for (x, y) ∈ dots
  output[y+1, x+1] = '■'
end

# Part 2 - What code do you use to activate the infrared thermal imaging camera system?
println("part2:")
for row ∈ eachrow(output)
  println(join(row, ""))
end
