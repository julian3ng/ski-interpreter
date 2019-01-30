#!/usr/bin/env ruby

# SKI CALCULUS
# term ::= I | K | S | (term term)

DEBUG = ARGV[0].to_i() || 0

def parse(expression)
  if expression.count("(") != expression.count(")")
    raise "Unbalanced parentheses"
  end
  
  def helper(input)
    items = []
    i = 0
    while i < input.length
      c = input[i]
      if c == "("
        inner, stride = helper(input[i+1...])
        items << inner
        i += stride
      elsif c == ")"
        return items, i+2
      else
        items << input[i]
        i += 1
      end
    end
    return items, i
  end

  return helper(expression)[0]
end

def evaluate(expression)
  if DEBUG >= 2
    p expression
  end
  tok = expression[0]
  if tok == "i"
    if expression[1]
      return evaluate(expression[1...])
    else
      return "i"
    end
  elsif tok == "k"
    if expression[2]
      return evaluate(expression[1])
    elsif expression[1]
      return ["k", evaluate(expression[1])]
    else
      return "k"
    end
  elsif tok == "s"
    if expression[3]
      x = evaluate(expression[1])
      y = evaluate(expression[2])
      z = evaluate(expression[3...])
      return evaluate([x, z, [y, z]])
    elsif expression[2]
      return ["s", evaluate(expression[1]), evaluate(expression[2])]
    elsif expression[1]
      return ["s", evaluate(expression[1])]
    else
      return "s"
    end
  elsif tok.class == Array
    evaluate(tok)
  end
end

input = STDIN.gets()
while input
  input = input.chomp().split("")

  if DEBUG >= 1
    p "parsed #{parse(input)}"
    p evaluate(parse(input))
  else
    p evaluate(parse(input))
  end
  input = STDIN.gets()
end
