mutable struct Snail
  v::Union{Int, Nothing}
  l::Union{Snail, Nothing}
  r::Union{Snail, Nothing}
  prev::Union{Snail, Nothing}
  next::Union{Snail, Nothing}
end

regular(v) = Snail(v, nothing, nothing, nothing, nothing)
pair(a, b) = Snail(nothing, a, b, nothing, nothing)

isregular(n) = !isnothing(n) && !isnothing(n.v)
ispair(n) = !isnothing(n) && !isregular(n)
isregularpair(n) = !isnothing(n) && isregular(n.l) && isregular(n.r)

Base.show(io::IO, n::Snail) = print(io, isregular(n) ? "$(n.v)" : "[$(n.l),$(n.r)]")

# add links between regular numbers in left-to-right (in-order traversal) order
function add_links(num)
  last = nothing
  function recur(num)
    if isregular(num)
      if !isnothing(last)
        num.prev = last
        last.next = num
      end
      last = num
    elseif ispair(num)
      recur(num.l)
      recur(num.r)
    end
  end
  recur(num)
end

function explode(num, level)
  if isregularpair(num) && level > 4
    !isnothing(num.l.prev) && (num.l.prev.v += num.l.v)
    !isnothing(num.r.next) && (num.r.next.v += num.r.v)
    num.v = 0
    num.l = num.r = nothing
    return true
  elseif ispair(num)
    explode(num.l, level+1) && return true
    explode(num.r, level+1) && return true
  end
  return false
end

function split(num)
  if isregular(num) && num.v >= 10
    num.l = regular(fld(num.v, 2))
    num.r = regular(cld(num.v, 2))
    num.v = nothing
    return true
  elseif ispair(num)
    split(num.l) && return true
    split(num.r) && return true
  end
  return false
end

function reduce!(num)
  while true
    add_links(num)
    explode(num, 1) && continue
    split(num) && continue
    break
  end
  return num
end

function parse_snail(str)
  if str[1] == '['
    left, str = parse_snail(str[2:end])
    right, str = parse_snail(str[2:end])
    return pair(left, right), str[2:end]
  else
    m = match(r"^(\d+)", str)
    return regular(parse(Int, m[1])), str[length(m[1])+1:end]
  end
end

function mag(num)
  if isregular(num)
    return num.v
  elseif ispair(num)
    return 3*mag(num.l) + 2*mag(num.r)
  end
  return 0
end

nums = map(x -> parse_snail(x)[1], readlines("data/day18.txt"))
final = foldl((a, b) -> reduce!(deepcopy(pair(a, b))), nums)

# Part 1 - What is the magnitude of the final sum?
println("part1 = ", mag(final))

# Part 2 - What is the largest magnitude of any sum of two different snailfish numbers from the homework assignment?
best = 0
for (i, a) ∈ enumerate(nums), (j, b) ∈ enumerate(nums)
  if i != j
    global best = max(best, mag(reduce!(deepcopy(pair(a, b)))))
  end
end
println("part2 = ", best)
