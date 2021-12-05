function count_increases(nums, len)
  last = sum(nums[1:len])
  inc = 0
  for i ∈ len:length(nums)
    sum2 = sum(nums[i-len+1:i])
    inc += sum2 > last ? 1 : 0
    last = sum2
  end
  return inc
end

lines = readlines("day01.txt")
nums = map(x->parse(Int32, x), lines)

println(count_increases(nums, 1))
println(count_increases(nums, 3))
