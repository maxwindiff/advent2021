using OffsetArrays

function sim(init=[1 0 0 0 0 0 0 0 0], days=80)
  state = OffsetArray(zeros(Int, days+1, 9), 0:days, 0:8)
  state[0, :] = init
  for i ∈ 1:days
    state[i, 0:7] = state[i-1, 1:8]
    state[i, 6] += state[i-1, 0]
    state[i, 8] += state[i-1, 0]
  end
  return sum(state[days, :])
end

fishes = parse.(Int, split(readline("data/day06.txt"), ","))
state = [count(==(i), fishes) for i ∈ 0:8]
println(sim(state, 80))
println(sim(state, 256))
