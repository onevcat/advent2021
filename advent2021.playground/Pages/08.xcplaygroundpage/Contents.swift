import Foundation

enum Digit {
    case zero, one, two, three, four, five, six, seven, eight, nine
    static let uniques: [Digit] = [.one, .four, .seven, .eight]
    var segCount: Int {
        switch self {
        case .zero: return 6
        case .one: return 2
        case .two: return 5
        case .three: return 5
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 3
        case .eight: return 7
        case .nine: return 6
        }
    }
}

struct Guess {
    let orderedInput: [String]
    
    init(input: [String]) {
        orderedInput = input
            .sorted { $0.count < $1.count }
            .map { String($0.sorted()) }
    }
    
    var values: [String: Int] {
        var result: [String: Int] = [:]
        result[guess0] = 0
        result[guess1] = 1
        result[guess2] = 2
        result[guess3] = 3
        result[guess4] = 4
        result[guess5] = 5
        result[guess6] = 6
        result[guess7] = 7
        result[guess8] = 8
        result[guess9] = 9
        return result
    }
    
    func getResult(_ input: [String]) -> Int {
        let normalized = input.map { String($0.sorted()) }
        return values[normalized[0]]! * 1000 + values[normalized[1]]! * 100 + values[normalized[2]]! * 10 + values[normalized[3]]!
    }
    
    var guess0: String {
        orderedInput[6...8].filter { $0 != guess6 && $0 != guess9 }[0]
    }
    var guess1: String { orderedInput[0] }
    var guess2: String {
        orderedInput[3...5].filter { $0 != guess3 && $0 != guess5 }[0]
    }
    var guess3: String {
        orderedInput[3...5].filter { Set(guess1).isSubset(of: $0) }[0]
    }
    var guess4: String { orderedInput[2] }
    var guess5: String {
        orderedInput[3...5].filter { Set($0).isSubset(of: Set(guess6)) }[0]
    }
    var guess6: String {
        orderedInput[6...8].filter { !Set(guess1).isSubset(of: $0) }[0]
    }
    var guess7: String { orderedInput[1] }
    var guess8: String { orderedInput[9] }
    var guess9: String {
        orderedInput[6...8].filter { Set(guess3).isSubset(of: $0) }[0]
    }
}

struct DigitSeg {
    let segs: [Character]
}

let input = try load(index: 8)

let wires = input
    .map { String($0.split(separator: "|")[0]) }
    .map { $0.split(separator: " ").map {String($0)} }

let digits = input
    .map { $0.split(separator: "|")[1] }
    .map { $0.split(separator: " ") }


// Part 1
let uniqueSegCounts = Digit.uniques.map { $0.segCount }
func isUnique(_ s: String.SubSequence) -> Bool {
    uniqueSegCounts.contains(s.count)
}
let result1 = digits
    .flatMap { $0 }
    .filter { isUnique($0) }
    .count
print(result1)

/// Part 2

let lookupTable = wires.map { Guess(input: $0) }

var r = 0
for (index, v) in digits.enumerated() {
    let guess = lookupTable[index]
    let d = v.map { String($0) }
    r += guess.getResult(d)
}
print(r)
