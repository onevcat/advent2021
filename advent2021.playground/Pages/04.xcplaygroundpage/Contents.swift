import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

class Number {
    let value: Int
    var marked: Bool
    
    init(value: Int) {
        self.value = value
        self.marked = false
    }
}

class Card {
    let rowRepresent: [[Number]]
    let columnRepresent: [[Number]]
    var alreadyMatched = false
    
    init(numbers: [[Int]]) {
        rowRepresent = numbers.map { $0.map { Number(value: $0) } }
        columnRepresent = rowRepresent.transposed
    }
    
    func mark(number: Int) -> [Number]? {
        
        if alreadyMatched { return nil }
        
        for i in 0 ..< rowRepresent.count {
            for j in 0 ..< columnRepresent.count {
                if rowRepresent[i][j].value == number {
                    rowRepresent[i][j].marked = true
                    columnRepresent[j][i].marked = true
                    
                    let matched = check()
                    if matched != nil {
                        alreadyMatched = true
                    }
                    return check()
                }
            }
        }
        
        return nil
    }
    
    func check() -> [Number]? {
        rowRepresent.first { $0.allSatisfy { $0.marked } } ?? columnRepresent.first { $0.allSatisfy { $0.marked } }
    }
    
    var unmarked: [Number] {
        rowRepresent.flatMap { $0 }.filter { !$0.marked }
    }
    
    func calculateScore(called: Int) -> Int {
        unmarked.reduce(0) { $0 + $1.value } * called
    }
    
}

let input = try load(index: 4)
let drawn = input[0].split(separator: ",").map { Int($0)! }
let cards = Array(input[1...]).chunked(into: 5)
    .map { $0.map { $0.split(separator: " ").map { Int($0)! } } }
    .map { Card(numbers: $0) }

// Part 1
outer: for c in drawn {
    for card in cards {
        if let _ = card.mark(number: c) {
            print(card.calculateScore(called: c))
            break outer
        }
    }
}

// Part 2
var result: Int? = nil
for c in drawn {
    for card in cards {
        if let _ = card.mark(number: c) {
            result = card.calculateScore(called: c)
        }
    }
}

print(result!)
