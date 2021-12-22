using BitBasis: packbits
using OffsetArrays

function enhance(img, mapping)
  out = zero(img)
  ax, ay = axes(img)
  for i ∈ ax[2]:ax[end-1], j ∈ ay[2]:ay[end-1]
    bits = reverse(vec(img[i-1:i+1, j-1:j+1]'))
    out[i, j] = mapping[packbits(bits)]
  end
  border = mapping[packbits(repeat([img[1,1]], 9))]
  out[1, 1:end] = out[end, 1:end] = out[1:end, 1] = out[1:end, end] .= border
  return out
end

lines = replace.(readlines("data/day20.txt"), '.' => '0', '#' => '1')

mapping = OffsetArray(parse.(Int, split(lines[1], "")), 0:511)
input = vcat(map(lines[3:end]) do line
  transpose(parse.(Int, split(line, "")))
end...)

t = 50
sx, sy = size(input)
buf = zeros(Bool, sx+t*4, sy+t*4)
buf[(1+t*2):(sx+t*2), (1+t*2):(sy+t*2)] = input
for i ∈ 1:t
  global buf = enhance(buf, mapping)
  # Part 1 & 2 - How many pixels are lit in the resulting image? (after 2 or 50 iterations)
  println("$i: $(sum(buf))")
end
