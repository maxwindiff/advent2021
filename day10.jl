const matching = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')
const illegal_score = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
const autocomplete_score = Dict('(' => 1, '[' => 2, '{' => 3, '<' => 4)

score1 = 0
score2s = []
for l ∈ readlines("data/day10.txt")
  stack = []
  illegal = false
  for c ∈ l
    if c ∈ "([{<"
      push!(stack, c)
    else
      if isempty(stack) || stack[end] != matching[c]
        global score1 += illegal_score[c]
        illegal = true
        break
      else
        pop!(stack)
      end
    end
  end

  if !illegal
    score2 = 0
    for c ∈ reverse(stack)
      score2 = score2 * 5 + autocomplete_score[c]
    end
    push!(score2s, score2)
  end
end

# Part 1 - What is the total syntax error score for those errors?
println("part1 = ", score1)

# Part 2 - Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score?
sort!(score2s)
println("part2 = ", score2s[(length(score2s)+1) ÷ 2])
