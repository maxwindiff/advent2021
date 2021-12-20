m = match(r"target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)", readline("data/day17.txt"))
(x1, x2, y1, y2) = parse.(Int, m.captures)

hit(x, y) = x ∈ x1:x2 && y ∈ y1:y2

function sim(dx, dy)
  x, y = 0, 0
  path = [(x, y)]
  while !hit(x, y)
    x += dx
    y += dy
    dx -= sign(dx)
    dy -= 1
    push!(path, (x, y))

    if x > x2
      return path, :x_bounds
    elseif y < y1
      return path, :y_bounds
    elseif x < x1 && dx <= 0
      return path, :out_of_gas
    end
  end
  return path, :success
end

my = typemin(Int)
trials, successes = 0, 0
for dx ∈ 1:x2, dy ∈ y1:-y1
  (path, result) = sim(dx, dy)
  global trials += 1
  if result == :success
    global my = max(my, maximum(w -> w[2], path))
    global successes += 1
  elseif result == :x_bounds
    # increasing dy will only make it go even more out of bounds
    break
  end
end

println(my)
println(successes)
println(trials)
