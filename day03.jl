using OffsetArrays

function part1(lines)
  len = length(lines[1])
  counts = OffsetArray(zeros(Int, len, 2), 1:len, 0:1)

  for l ∈ lines
    for (i, c) ∈ enumerate(l)
      counts[i, parse(Int, c)] += 1
    end
  end

  gamma = ""
  epsilon = ""
  for i ∈ 1:len
    if counts[i, 0] >= counts[i, 1]
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
  str = ""
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
    str *= ch

    lines = filter(l -> l[i] == ch, lines)
    if length(lines) == 1
      str = lines[1]
      break
    end
  end
  return str
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

println("part1 = $(part1(lines))")
println("part2 = $(part2(lines))")
