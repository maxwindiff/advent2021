struct Boards
  io::Base.IO
end
function Base.iterate(b::Boards, state=nothing)
  board = []
  while true
    line = readline(b.io)
    if !isempty(line)
      push!(board, map(x -> parse(Int, x), split(line)))
    elseif !isempty(board)
      return (board, nothing)
    elseif eof(b.io)
      return nothing
    end
  end
end

function won(board)
  for row in eachrow(board)
    all(row .== -1) && return true
  end
  for col in eachcol(board)
    all(col .== -1) && return true
  end
  # diag = [board[i, i] for i ∈ 1:size(board)[1]]
  # all(diag .== -1) && return true
  # inv_diag = [board[i, size(board)[1] - i + 1] for i ∈ 1:size(board)[1]]
  # all(inv_diag .== -1) && return true
  return false
end

function calc_score(board, seq)
  loc = Dict()
  for (i, row) ∈ enumerate(board)
    for (j, v) ∈ enumerate(row)
      loc[v] = (j, i)
    end
  end
  nd = hcat(board...)
  for (i, s) ∈ enumerate(seq)
    if s ∈ keys(loc)
      nd[loc[s][1], loc[s][2]] = -1
      if won(nd)
        println("nd = $nd step = $i s = $s sum = $(sum(nd[nd .!= -1]))")
        return i, s * sum(nd[nd .!= -1])
      end
    end
  end
  return 100, 0
end

function best_board(boards, seq, want_first)
  best_steps = want_first ? 100 : 0
  best_score = 0

  for board ∈ boards
    steps, score = calc_score(board, seq)
    if (want_first && steps < best_steps) || (!want_first && steps > best_steps)
      best_steps = steps
      best_score = score
    end
  end

  return best_score
end

f = open("day04.txt")
seq = map(x -> parse(Int, x), split(readline(f), ","))
println("want_first = $(best_board(Boards(f), seq, true))")

f = open("day04.txt")
seq = map(x -> parse(Int, x), split(readline(f), ","))
println("want_last = $(best_board(Boards(f), seq, false))")
