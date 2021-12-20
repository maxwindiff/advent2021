using OffsetArrays

data = map(readlines("data/day08.txt")) do x
  a, b = split(x, " | ")
  return (split(a), split(b))
end

# Part 1
outputs = [d[2] for d ∈ data]
println(count(x -> length(x) ∈ [2, 4, 3, 7], vcat(outputs...)))

# Part 2
total = 0
for (pattern, output) ∈ data
  ps = Set.(pattern)

  chars = OffsetArray(Array{Set{Char}}(undef, 10), 0:9)
  chars[1] = first(filter(x -> length(x) == 2, ps))
  chars[4] = first(filter(x -> length(x) == 4, ps))
  chars[7] = first(filter(x -> length(x) == 3, ps))
  chars[8] = first(filter(x -> length(x) == 7, ps))

  len6 = filter(x -> length(x) == 6, ps)
  chars[9] = first(filter(x -> chars[4] ⊆ x, len6))
  chars[6] = first(filter(x -> chars[1] ⊈ x && x != chars[9], len6))
  chars[0] = first(filter(x -> x != chars[9] && x != chars[6], len6))

  len5 = filter(x -> length(x) == 5, ps)
  chars[3] = first(filter(x -> chars[1] ⊆ x, len5))
  chars[5] = first(filter(x -> x ⊆ chars[9] && x != chars[3], len5))
  chars[2] = first(filter(x -> x != chars[3] && x != chars[5], len5))

  lookup = Dict(chars[i] => i for i ∈ 0:9)
  num = ""
  for digit ∈ output
    num *= string(lookup[Set(digit)])
  end
  global total += parse(Int, num)
end
println(total)
