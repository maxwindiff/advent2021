using LinearAlgebra, Combinatorics

rotations = []
for x ∈ (-1,1), y ∈ (-1,1), z ∈ (-1,1)
  for q in permutations([[x 0 0], [0 y 0], [0 0 z]])
    m = vcat(q...)
    if det(m) == 1
      push!(rotations, m)
    end
  end
end

function merge(s1, s2)
  for p1 ∈ s1.beacons
    shifted1 = s1.beacons .- [p1]
    sdists1 = [sum(p.^2) for p ∈ shifted1]

    for p2 ∈ s2.beacons
      shifted2 = s2.beacons .- [p2]

      # Sanity check
      sdists2 = [sum(p.^2) for p ∈ shifted2]
      length(intersect(sdists1, sdists2)) < 12 && continue

      for r ∈ rotations
        rotated2 = [r] .* shifted2
        if length(intersect(shifted1, rotated2)) >= 12
          return (
            scanners=union(s1.scanners .- [p1], [r] .* (s2.scanners .- [p2])),
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
