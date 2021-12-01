function count_increases(nums, len)
  if length(nums) < len
    return 0
  end

  last = sum(nums[1:len])
  inc = 0
  for i ∈ len:length(nums)
    sum2 = sum(nums[i-len+1:i])
    inc += sum2 > last ? 1 : 0
    last = sum2
  end
  return inc
end

f = open("day1.txt")
lines = readlines(f)
nums = map(x->parse(Int32, x), lines)

println(count_increases(nums, 1))
println(count_increases(nums, 3))
