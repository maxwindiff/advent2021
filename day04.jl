function won(board)
  for row in eachrow(board)
    all(row .== -1) && return true
  end
  for col in eachcol(board)
    all(col .== -1) && return true
  end
  return false
end

function score(board, seq)
  loc = Dict()
  for i ∈ eachindex(board)
    loc[board[i]] = i
  end
  for (step, s) ∈ enumerate(seq)
    if s ∈ keys(loc)
      board[loc[s]] = -1
      if won(board)
        return step, s * sum(board[board .!= -1])
      end
    end
  end
  return typemax(Int), 0
end

f = open("data/day04.txt")
seq = parse.(Int, split(readline(f), ','))
groups = split(read(f, String), "\n\n", keepempty=false)
boards = [reshape(parse.(Int, split(x, keepempty=false)), 5, 5) for x ∈ groups]
results = score.(boards, [seq])

# Part 1 - ...figure out which board will win first. What will your final score be if you choose that board?
println("part1 = ", argmin(((steps, score),) -> steps, results))

# Part 2 - Figure out which board will win last. Once it wins, what would its final score be?
println("part2 = ", argmax(((steps, score),) -> steps, results))
