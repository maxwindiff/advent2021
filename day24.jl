using DataStructures: DefaultDict
using Folds

mutable struct State
  regs::Vector{Int64}
  best::Int64
end

function reduce(states, reducefunc)
  bests = Dict{Int64, Int64}()
  sizehint!(bests, length(states))
  for state ∈ states
    z = state.regs[3]
    if haskey(bests, z)
      bests[z] = reducefunc(bests[z], state.best)
    else
      bests[z] = state.best
    end
  end
  return bests
end

function sim(cmds, reducefunc)
  states = [State([0, 0, 0, 0], 0)]

  for (i, (cmd, dst, src, val)) ∈ enumerate(cmds)
    if cmd == "inp"
      # Assume registers x and y will be wiped out
      @time bests = reduce(states, reducefunc)
      println(length(states), " => ", length(bests))
      @time states = Folds.collect(State([0, 0, z, d], best*10+d) for (z, best) ∈ bests, d ∈ 1:9)
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

  return map(s -> s.best, filter(s -> s.regs[3] == 0, states))
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

# Part 1 - What is the largest model number accepted by MONAD?
@time m = sim(cmds, max)
println("part1 = ", maximum(m))

# Part 2 - What is the smallest model number accepted by MONAD?
@time m = sim(cmds, min)
println("part1 = ", minimum(m))
