using DataStructures: DefaultDict

function setup(seq)
  counts = DefaultDict{String, Int}(0)
  for i ∈ 1:(length(seq)-1)
    counts[seq[i:i+1]] += 1
  end
  return counts, seq[1], seq[end]
end

function sim(state, insertions, steps)
  state = DefaultDict(0, state)  # defensive copy since we are mutating
  for _ ∈ 1:steps
    for (pair, count) ∈ collect(pairs(state))  # collect is to make a copy
      if haskey(insertions, pair)
        state[pair[1] * insertions[pair]] += count
        state[insertions[pair] * pair[2]] += count
        state[pair] -= count
      end
    end
  end
  return state
end

function count(state, s, e)
  counts = DefaultDict{Char, Int}(0)
  counts[s] = 1
  counts[e] = 1
  for (pair, count) ∈ state
    counts[pair[1]] += count
    counts[pair[2]] += count
  end
  map!(x -> x /= 2, values(counts))
  return counts
end

f = open("data/day14.txt")
state, s, e = setup(readline(f))
readline(f)
insertions = Dict(map(x -> split(x, " -> "), eachline(f)))

for steps ∈ [10, 40]
  result = sim(state, insertions, steps)
  counts = count(result, s, e)
  println(maximum(values(counts)) - minimum(values(counts)))
end
