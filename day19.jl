# https://stackoverflow.com/a/16467849
function rot(v)
  roll(v) = (v[1], v[3], -v[2])
  turn(v) = (-v[2], v[1], v[3])
  vs = []
  for _ ∈ 1:2
    for _ ∈ 1:3
      v = roll(v)
      push!(vs, v)
      for _ ∈ 1:3
        v = turn(v)
        push!(vs, v)
      end
    end
    v = roll(turn(roll(v)))
  end
  return vs
end
rotations = rot([1, 2, 3])

rotate(p, r) = [i > 0 ? p[i] : -p[-i] for i ∈ r]
shiftall(ps, p) = [px - p for px ∈ ps]
rotateall(ps, r) = [rotate(p, r) for p ∈ ps]

function merge(s1, s2)
  for p1 ∈ s1.beacons
    shifted1 = shiftall(s1.beacons, p1)
    sdists1 = [sum(p.^2) for p ∈ shifted1]

    for p2 ∈ s2.beacons
      shifted2 = shiftall(s2.beacons, p2)

      # Sanity check
      sdists2 = [sum(p.^2) for p ∈ shifted2]
      length(intersect(sdists1, sdists2)) < 12 && continue

      for r ∈ rotations
        rotated2 = rotateall(shifted2, r)
        if length(intersect(shifted1, rotated2)) >= 12
          return (
            scanners=union(shiftall(s1.scanners, p1), rotateall(shiftall(s2.scanners, p2), r)),
            beacons=union(shifted1, rotated2),
          )
        end
      end
    end
  end
  return nothing
end

lines = readlines("data/day19.txt")
scanners = []
for l ∈ lines
  if occursin("---", l)
    global beacons = []
    push!(scanners, (scanners=[[0, 0, 0]], beacons=beacons))
  elseif !isempty(l)
    push!(beacons, parse.(Int, split(l, ",")))
  end
end

while length(scanners) > 1
  for i ∈ 1:length(scanners), j ∈ (i+1):length(scanners)
    merged = merge(scanners[i], scanners[j])
    if !isnothing(merged)
      global scanners = vcat(scanners[setdiff(1:end, (i, j))], [merged])
      break
    end
  end
end
final = scanners[1]
println(length(final.beacons))
println(maximum((sum(abs.(s1-s2)) for s1 ∈ final.scanners, s2 ∈ final.scanners)))
