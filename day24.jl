using DataStructures: DefaultDict

mutable struct State
  regs::Vector{Int}
  max::Int64
  min::Int64
end

function reduce(states)
  bests = DefaultDict((0, typemax(Int64)))
  for state ∈ states
    best = bests[state.regs[3]]
    bests[state.regs[3]] = (max(best[1], state.max), min(best[2], state.min))
  end
  return bests
end

function sim(cmds)
  states = [State([0, 0, 0, 0], 0, 0)]

  for (i, (cmd, dst, src, val)) ∈ enumerate(cmds)
    if cmd == "inp"
      @time bests = reduce(states)
      println(length(states), " => ", length(bests))
      @time states = collect(State([0, 0, z, d], max*10+d, min*10+d) for (z, (max, min)) ∈ bests, d ∈ 1:9)
      println(length(bests), " => ", length(states))
    else
      Threads.@threads for state ∈ states
        arg = isnothing(src) ? val : state.regs[src]
        if cmd == "add"
          state.regs[dst] += arg
        elseif cmd == "mul"
          state.regs[dst] *= arg
        elseif cmd == "div"
          state.regs[dst] ÷= arg
        elseif cmd == "mod"
          state.regs[dst] %= arg
        elseif cmd == "eql"
          state.regs[dst] = state.regs[dst] == arg ? 1 : 0
        end
      end
    end
    println("$i: $(length(states))")
  end

  valid = filter(s -> s.regs[3] == 0, states)
  println("z=0: ", valid)
  return maximum(s -> s.max, valid), minimum(s -> s.min, valid)
end

addr = Dict("x" => 1, "y" => 2, "z" => 3, "w" => 4)
cmds = map(readlines("data/day24.txt")) do line
  tokens = split(line)
  src, val = nothing, nothing
  if length(tokens) == 3
    src, val = tokens[3][1] ∈ "xyzw" ? (addr[tokens[3]], nothing) : (nothing, parse(Int, tokens[3]))
  end
  return (cmd=tokens[1], dst=addr[tokens[2]], src=src, val=val)
end

@time m, n = sim(cmds)

# Part 1 - What is the largest model number accepted by MONAD?
println("part1 = ", m)

# Part 2 - What is the smallest model number accepted by MONAD?
println("part2 = ", n)
