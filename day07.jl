nums = parse.(Int, split(readline("data/day07.txt"), ','))

cost1(x) = x
cost2(x) = x * (x+1) ÷ 2

for cost ∈ [cost1, cost2]
  min_cost = minimum(pos -> sum(cost.(abs.(nums .- pos))), minimum(nums):maximum(nums))

  # Part 1 & 2 - How much fuel must they spend to align to that position? (for two cost functions)
  println("partX = ", min_cost)
end
