using OffsetArrays

function sim(days=80)
  state = OffsetArray(zeros(Int, days+1, 9), 0:days, 0:8)
  state[0, :] = [1 0 0 0 0 0 0 0 0]
  for i ∈ 1:days
    state[i, 0:7] = state[i-1, 1:8]
    state[i, 6] += state[i-1, 0]
    state[i, 8] += state[i-1, 0]
  end
  return sum(state, dims=2)[1:end]
end

growth = sim(256)
println(growth)

state = map(x -> parse(Int, x), split(readline("day06.txt"), ","))
total = 0
for s ∈ state
  global total += growth[end - s]
end
println(total)
