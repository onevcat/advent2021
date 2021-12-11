import Foundation

let input = try load(index: 11).map { Array($0).map { Int(String($0))! } }

// Part 1
var m = Map(values: input)
var value = 0
for _ in 0 ..< 100 {
  value += m.nextStep()
}
print(value)

// Part 2
m = Map(values: input)
var found = false
var step: Int = 0
while !found {
  step += 1
  if m.nextStep() == input.count * input[0].count {
    found = true
  }
}
print(step)

