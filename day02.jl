function pos1(cmds)
  x = 0
  y = 0
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
  x = 0
  y = 0
  aim = 0
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
  return (a, parse(Int32, b))
end

println(pos1(cmds))
println(pos2(cmds))
