struct Packet
  version::Int
  type::Int
  value::BigInt
  children::Vector{Packet}
end

function Base.show(io::IO, p::Packet)
  if p.type == 4
    print(io, "Packet[v$(p.version), $(p.value)]")
  else
    print(io, "Packet[v$(p.version), op=$(p.type), children=$(p.children)]")
  end
end

conv(bits) = parse(Int, join(bits, ""), base=2)
convbig(bits) = parse(BigInt, join(bits, ""), base=2)

function parsebits(bits)
  version = conv(bits[1:3])
  type = conv(bits[4:6])

  if type == 4
    buf::Vector{Int} = []
    i = 7
    while true
      append!(buf, bits[i+1:i+4])
      i += 5
      if bits[i-5] == 0
        break
      end
    end
    return Packet(version, type, convbig(buf), []), i-1
  else
    children = []
    start = 0
    offset = 0
    if bits[7] == 0
      # bound by number of bits
      start = 23
      while offset < conv(bits[8:22])
        (packet, consumed) = parsebits(@view bits[(start+offset):end])
        offset += consumed
        push!(children, packet)
      end
    else
      # bound by number of packets
      start = 19
      for i ∈ 1:conv(bits[8:18])
        (packet, consumed) = parsebits(@view bits[(start+offset):end])
        offset += consumed
        push!(children, packet)
      end
    end
    return Packet(version, type, 0, children), start+offset-1
  end
end

part1(p) = p.version + (p.type == 4 ? 0 : sum(part1.(p.children)))

function part2(p)
  c = part2.(p.children)
  if p.type == 0
    return sum(c)
  elseif p.type == 1
    return prod(c)
  elseif p.type == 2
    return minimum(c)
  elseif p.type == 3
    return maximum(c)
  elseif p.type == 4
    return p.value
  elseif p.type == 5
    return c[1] > c[2] ? 1 : 0
  elseif p.type == 6
    return c[1] < c[2] ? 1 : 0
  elseif p.type == 7
    return c[1] == c[2] ? 1 : 0
  end
end

for l ∈ eachline("data/day16.txt")
  println(l)
  bits = reverse(digits(parse(BigInt, l, base=16), base=2, pad=length(l)*4))
  #println(join(bits, ""))
  packet = parsebits(bits)[1]
  #println(packet)
  println("part1 = $(part1(packet))")
  println("part2 = $(part2(packet))")
  println()
end
