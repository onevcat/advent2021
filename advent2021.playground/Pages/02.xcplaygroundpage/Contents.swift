import Foundation
import Darwin

enum Action {
    case forward(Int)
    case down(Int)
    case up(Int)
    
    init(_ command: String) {
        let values = command.split(separator: " ")
        switch values[0] {
        case "forward": self = .forward(Int(values[1])!)
        case "down": self = .down(Int(values[1])!)
        case "up": self = .up(Int(values[1])!)
        default: fatalError()
        }
    }
}

struct Position {
    var horizontal = 0
    var depth = 0
    var aim = 0
}

// Part 1
func calculate(actions: [Action]) -> Position {
    actions.reduce(Position()) { r, input in
        var result = r
        switch input {
        case .forward(let v): result.horizontal += v
        case .down(let v): result.depth += v
        case .up(let v): result.depth = max(result.depth - v, 0)
        }
        return result
    }
}

let input = try load(index: 2).map { Action($0) }
let final = calculate(actions: input)
print(final.horizontal * final.depth)

// Part 2

func calculate2(actions: [Action]) -> Position {
    actions.reduce(Position()) { r, input in
        var result = r
        switch input {
        case .forward(let v):
            result.horizontal += v
            result.depth += result.aim * v
        case .down(let v): result.aim += v
        case .up(let v): result.aim = max(result.aim - v, 0)
        }
        return result
    }
}

let final2 = calculate2(actions: input)
print(final2.horizontal * final2.depth)
