function part1(lines)
  len = length(lines[1])
  counts = zeros(Int, len, 2)

  for l ∈ lines
    for (i, c) ∈ enumerate(l)
      counts[i, parse(Int, c)+1] += 1
    end
  end

  println("counts = $counts")

  gamma = ""
  epsilon = ""
  for i ∈ 1:len
    if counts[i, 1] >= counts[i, 2]
      gamma *= "0"
      epsilon *= "1"
    else
      gamma *= "1"
      epsilon *= "0"
    end
  end

  println("gamma = $gamma")
  println("epsil = $epsilon")

  g = parse(Int, gamma, base=2)
  e = parse(Int, epsilon, base=2)
  return g * e
end

function find_common(lines, most)
  str = ""
  for i ∈ 1:length(lines[1])
    counts = zeros(Int, 2)
    for l ∈ lines
      counts[parse(Int, l[i])+1] += 1
    end

    if counts[1] > counts[2]
      ch = most ? '0' : '1'
    elseif counts[1] < counts[2]
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
  return parse(Int, str, base=2)
end

function part2(lines)
  oxygen = find_common(lines, true)
  println("oxy = $oxygen")
  co2 = find_common(lines, false)
  println("co2 = $co2")
  return oxygen * co2
end

f = open("day03.txt")
lines = readlines(f)

println("part1 = $(part1(lines))")
println("part2 = $(part2(lines))")
