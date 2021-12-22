using ShiftedArrays

m = vcat(map(eachline("data/day11.txt")) do line
  transpose(parse.(Int, split(line, "")))
end...)

function run_step(m)
  flashed = zeros(Bool, size(m)...)
  m .+= 1
  while true
    flashing = m .> 9 .&& .!flashed
    if sum(flashing) == 0
      break
    end
    flashed .|= flashing

    for dx ∈ -1:1, dy ∈ -1:1
      m[ShiftedArray(flashing, (dx, dy), default=false)] .+= 1
    end
  end
  m[flashed] .= 0
  return sum(flashed)
end

total_flashes = 0
first_sync = 0
for step ∈ 1:300
  global total_flashes, first_sync
  flash_count = run_step(m)
  if step <= 100
    total_flashes += flash_count
  end
  if flash_count == length(m) && first_sync == 0
    first_sync = step
  end
end

# Part 1 - How many total flashes are there after 100 steps?
println("part1 = ", total_flashes)

# Part 2 - What is the first step during which all octopuses flash?
println("part2 = ", first_sync)
