function pos1(cmds)
  x = 0
  y = 0
  for cmd ∈ cmds
    if cmd[1] == "forward"
      x += cmd[2]
    elseif cmd[1] == "down"
      y += cmd[2]
    elseif cmd[1] == "up"
      y -= cmd[2]
    end
  end
  return x * y
end

function pos2(cmds)
  x = 0
  y = 0
  aim = 0
  for cmd ∈ cmds
    if cmd[1] == "forward"
      x += cmd[2]
      y += cmd[2] * aim
    elseif cmd[1] == "down"
      aim += cmd[2]
    elseif cmd[1] == "up"
      aim -= cmd[2]
    end
  end
  return x * y
end

f = open("day02.txt")
cmds = map(function(x)
  a, b = split(x)
  return (a, parse(Int32, b))
end, readlines(f))

println(pos1(cmds))
println(pos2(cmds))
