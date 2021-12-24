using DataStructures

struct State
  hallway::Vector{Char}
  rooms::Vector{String}
end
Base.:(==)(s1::State, s2::State) = s1.hallway == s2.hallway && s1.rooms == s2.rooms
Base.hash(s::State) = hash(s.hallway, hash(s.rooms))
Base.copy(s::State) = State(copy(s.hallway), copy(s.rooms))
Base.show(io::IO, s::State) = print(io, "State{$(join(s.hallway, "")) $(join(s.rooms, "."))}")

costs = Dict('A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000)
dests = Dict('A' => 1, 'B' => 2, 'C' => 3, 'D' => 4)

# Obstacles between room i and hallway position j
obstacles = [
  [2:2, 1:0, 1:0, 3:3, 3:4, 3:5, 3:6],
  [2:3, 3:3, 1:0, 1:0, 4:4, 4:5, 4:6],
  [2:4, 3:4, 4:4, 1:0, 1:0, 5:5, 5:6],
  [2:5, 3:5, 4:5, 5:5, 1:0, 1:0, 6:6],
]
steps = [
  3 2 2 4 6 8 9;
  5 4 2 2 4 6 7;
  7 6 4 2 2 4 5;
  9 8 6 4 2 2 3;
]

function moves(state, dst, roomsize)
  ret = []

  # From rooms to hallway
  for (i, room) ∈ enumerate(state.rooms)
    room == dst.rooms[i][1:length(room)] && continue  # don't move if the room already looks ok

    mover = room[1]
    stayers = room[2:end]
    for j ∈ 1:7
      if state.hallway[j] == '.' && all(==('.'), state.hallway[obstacles[i][j]])
        next = copy(state)
        next.hallway[j] = mover
        next.rooms[i] = stayers
        push!(ret, (next, costs[mover] * (steps[i,j] + roomsize - length(room))))
      end
    end
  end

  # From hallway to rooms
  for i ∈ 1:7
    mover = state.hallway[i]
    mover == '.' && continue

    j = dests[mover]
    room = state.rooms[j]
    if all(==(mover), room) && all(==('.'), state.hallway[obstacles[j][i]])
      next = copy(state)
      next.hallway[i] = '.'
      next.rooms[j] *= mover
      push!(ret, (next, costs[mover] * (steps[j,i] + roomsize - length(room) - 1)))
    end
  end

  return ret
end

# A* heuristic -- quite effective in part 1 but less so in part 2, why?
function h(state)
  score = sum(c == '.' ? 0 : costs[c] * steps[dests[c],i] for (i, c) ∈ enumerate(state.hallway))
  for (i, room) ∈ enumerate(state.rooms), c ∈ room
    if dests[c] != i
      score += costs[c] * (abs(dests[c]-i) * 2 + 2)
    end
  end
  return score
end

function search(src, dst, roomsize)
  dist = DefaultDict{State, Int}(typemax(Int))
  queue = PriorityQueue{State, Int}()

  queue[src] = dist[src] = 0
  while !isempty(queue)
    this = dequeue!(queue)
    this == dst && break
    for (next, cost) ∈ moves(this, dst, roomsize)
      ndist = dist[this] + cost
      if ndist < dist[next]
        dist[next] = ndist
        queue[next] = ndist + h(next)
      end
    end
  end

  return dist[dst]
end

# Part 1 - What is the least energy required to organize the amphipods?
src1 = State(collect("......."), ["AB", "DC", "BD", "CA"])
#src1 = State(collect("......."), ["BA", "CD", "BC", "DA"])  # example
dst1 = State(collect("......."), ["AA", "BB", "CC", "DD"])
println("part1 = ", search(src1, dst1, 2))

# Part 2 - Using the initial configuration from the full diagram, what is the least energy required to organize the amphipods?
src2 = State(collect("......."), ["ADDB", "DCBC", "BBAD", "CACA"])
#src2 = State(collect("......."), ["BDDA", "CCBD", "BBAC", "DACA"])  # example
dst2 = State(collect("......."), ["AAAA", "BBBB", "CCCC", "DDDD"])
println("part2 = ", search(src2, dst2, 4))
