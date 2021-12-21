function count_increases(nums, len)
  increases = 0
  for i ∈ len+1:length(nums)
    if sum(nums[i-len+1:i]) > sum(nums[i-len:i-1])
      increases += 1
    end
  end
  return increases
end

nums = parse.(Int, readlines("data/day01.txt"))

# Part 1 - How many measurements are larger than the previous measurement?
println("part1 = ", count_increases(nums, 1))

# Part 2 - Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?
println("part2 = ", count_increases(nums, 3))
