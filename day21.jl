using OffsetArrays
using DataStructures: DefaultDict

next(turn) = 3 - turn

function part1(init)
  rolls = 0
  dice = 0
  function roll()
    rolls += 1
    dice = mod1(dice+1, 100)
  end

  players = copy(init)
  scores = [0, 0]
  turn = 1
  while true
    players[turn] = mod1(players[turn] + roll() + roll() + roll(), 10)
    scores[turn] += players[turn]
    if scores[turn] >= 1000
      return scores[next(turn)] * rolls
    end
    turn = next(turn)
  end
end

function part2(init)
  dices = DefaultDict(0)
  for a ∈ 1:3, b ∈ 1:3, c ∈ 1:3
    dices[a+b+c] += 1
  end

  counts = OffsetArray(zeros(Int64, 22, 22, 10, 10, 2), 0:21, 0:21, :, :, :)
  counts[0, 0, init[1], init[2], 1] = 1
  for s1 ∈ 0:20, s2 ∈ 0:20, p1 ∈ 1:10, p2 ∈ 1:10, turn ∈ 1:2
    from = counts[s1, s2, p1, p2, turn]
    from == 0 && continue

    for (dice, times) ∈ dices
      if turn == 1
        p1new = mod1(p1 + dice, 10)
        s1new = min(21, s1 + p1new)
        counts[s1new, s2, p1new, p2, next(turn)] += from * times
      else
        p2new = mod1(p2 + dice, 10)
        s2new = min(21, s2 + p2new)
        counts[s1, s2new, p1, p2new, next(turn)] += from * times
      end
    end
  end
  p1wins = sum(counts[21, :, :, :, :])
  p2wins = sum(counts[:, 21, :, :, :])
  return max(p1wins, p2wins)
end

init = [4, 10]

# Part 1 - What do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?
println("part1 = ", part1(init))

# Part 2 - Find the player that wins in more universes; in how many universes does that player win?
println("part2 = ", part2(init))
