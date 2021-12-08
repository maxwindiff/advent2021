nums = parse.(Int, split(readline("data/day07.txt"), ","))

cost1(x) = x
cost2(x) = x * (x+1) ÷ 2

for cost ∈ [cost1, cost2]
  min_cost = minimum(pos -> sum(cost.(abs.(nums .- pos))), minimum(nums):maximum(nums))
  println(min_cost)
end
