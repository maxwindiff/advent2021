function pos1(cmds)
  x, y = 0, 0
  for (cmd, n) ∈ cmds
    if cmd == "forward"
      x += n
    elseif cmd == "down"
      y += n
    elseif cmd == "up"
      y -= n
    end
  end
  return x * y
end

function pos2(cmds)
  x, y, aim = 0, 0, 0
  for (cmd, n) ∈ cmds
    if cmd == "forward"
      x += n
      y += n * aim
    elseif cmd == "down"
      aim += n
    elseif cmd == "up"
      aim -= n
    end
  end
  return x * y
end

cmds = map(readlines("data/day02.txt")) do x
  a, b = split(x)
  return a, parse(Int, b)
end

# Part 1 - What do you get if you multiply your final horizontal position by your final depth?
println("part1 = ", pos1(cmds))

# Part 2 - Using this new interpretation... What do you get if you multiply your final horizontal position by your final depth?
println("part2 = ", pos2(cmds))
