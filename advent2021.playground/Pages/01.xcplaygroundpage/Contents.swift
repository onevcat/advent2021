import Foundation

// Part 1
let input = try load(index: 1).map { Int($0)! }
print(offsetCompare(input))

// Part 2
let aligned = zip(zip(input, input[1...]), input[2...]).map { v in
    v.0.0 + v.0.1 + v.1
}
print(offsetCompare(aligned))

func offsetCompare(_ input: [Int]) -> Int {
    zip(input, input[1...]).reduce(0) { partialResult, v in
        v.0 < v.1 ? partialResult + 1 : partialResult
    }
}
