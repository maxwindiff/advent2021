nums = sort(map(x -> parse(Int, x), split(readline("data/day07.txt"), ",")))

#median = nums[length(nums) ÷ 2]
#println(median, ": ", sum(abs.(nums .- median)))

cost1(x) = x
cost2(x) = x * (x+1) ÷ 2

for cost_func ∈ [cost1, cost2]
  min_pos = nothing
  min_cost = typemax(Int)
  for i ∈ nums[1]:nums[end]
    cost = sum(cost_func.(abs.(nums .- i)))
    if cost < min_cost
      min_pos = i
      min_cost = cost
    end
  end
  println(min_pos, ": ", min_cost)
end
