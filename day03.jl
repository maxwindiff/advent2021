using OffsetArrays

function part1(lines)
  gamma, epsilon = "", ""
  for i ∈ 1:length(lines[1])
    counts = OffsetArray(zeros(Int, 2), 0:1)
    for l ∈ lines
      counts[parse(Int, l[i])] += 1
    end

    if counts[0] >= counts[1]
      gamma *= "0"
      epsilon *= "1"
    else
      gamma *= "1"
      epsilon *= "0"
    end
  end

  g = parse(Int, gamma, base=2)
  e = parse(Int, epsilon, base=2)
  println("gamma = $gamma ($g)")
  println("epsil = $epsilon ($e)")

  return g * e
end

function find_common(lines, most)
  for i ∈ 1:length(lines[1])
    counts = OffsetArray(zeros(Int, 2), 0:1)
    for l ∈ lines
      counts[parse(Int, l[i])] += 1
    end

    if counts[0] > counts[1]
      ch = most ? '0' : '1'
    elseif counts[0] < counts[1]
      ch = most ? '1' : '0'
    else
      ch = most ? '1' : '0'
    end

    lines = filter(l -> l[i] == ch, lines)
    if length(lines) == 1
      return only(lines)
    end
  end
  error("cannot narrow down to a single string")
end

function part2(lines)
  oxygen = find_common(lines, true)
  o = parse(Int, oxygen, base=2)
  println("oxy = $oxygen ($o)")
  co2 = find_common(lines, false)
  c = parse(Int, co2, base=2)
  println("co2 = $co2 ($c)")
  return o * c
end

lines = readlines("data/day03.txt")

# Part 1 - What is the power consumption of the submarine?
println("part1 = ", part1(lines))

# Part 2 - What is the life support rating of the submarine?
println("part2 = ", part2(lines))
