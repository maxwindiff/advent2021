function sim(days=80)
  state = zeros(Int, days + 1, 9)
  state[1, :] = [1 0 0 0 0 0 0 0 0]
  for i ∈ 2:(days+1)
    state[i, 1:8] = state[i-1, 2:9]
    state[i, 7] += state[i-1, 1]
    state[i, 9] += state[i-1, 1]
  end
  return sum(state, dims=2)[2:end]
end

growth = sim(256)
println(growth)

state = map(x -> parse(Int, x), split(readline("day05.txt"), ","))
total = 0
for s ∈ state
  global total += growth[end - s]
end
println(total)
