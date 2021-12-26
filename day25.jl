using CircularArrays

m = CircularArray(reduce(vcat, permutedims.(collect.(eachline("data/day25.txt")))))

for i ∈ 1:1000
  moved = false
  for (char, dir) ∈ ['>' => CartesianIndex(0, 1), 'v' => CartesianIndex(1, 0)]
    movers = [idx for idx ∈ findall(m .== char) if m[idx + dir] == '.']
    m[movers] .= '.'
    m[movers .+ [dir]] .= char
    moved |= !isempty(movers)
  end

  if !moved
    # Part 1 - What is the first step on which no sea cucumbers move?
    println("part1 = ", i)
    break
  end
end
