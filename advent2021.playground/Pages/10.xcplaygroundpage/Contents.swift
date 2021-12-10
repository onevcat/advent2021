import Foundation

// Not sure why but I cannot use `10` as the file name...Otherwise it won't load with an error
// "couldn’t be opened because the text encoding of its contents can’t be determined".
let input = try load(index: 100)

extension Character {
  var isOpen: Bool { self == "[" || self == "{" || self == "<" || self == "(" }
  func isCloseFor(_ open: Character) -> Bool {
    self == open.expectedClose
  }
  
  var expectedClose: Character {
    if self == "[" { return "]" }
    if self == "{" { return "}" }
    if self == "<" { return ">" }
    if self == "(" { return ")" }
    fatalError()
  }
  
  var corruptedScore: Int {
    switch self {
    case ")": return 3
    case "]": return 57
    case "}": return 1197
    case ">": return 25137
    default: fatalError()
    }
  }
  
  var incompleteScore: Int {
    switch self {
    case ")": return 1
    case "]": return 2
    case "}": return 3
    case ">": return 4
    default: fatalError()
    }
  }
}

enum ParseError: Error {
  case corrupted(expected: Character, found: Character)
  case closeWithoutAnyOpen
}

var openStack: [Character] = []
var level: Int = 0

typealias OpenCharacter = Character

func parseOne(c: Character) throws -> OpenCharacter? {
  if c.isOpen {
    openStack.append(c)
    return nil
  } else { // isClose
    if let lastOpen = openStack.popLast() {
      if c.isCloseFor(lastOpen) {
        return lastOpen
      } else {
        throw ParseError.corrupted(expected: lastOpen.expectedClose, found: c)
      }
    } else {
      throw ParseError.closeWithoutAnyOpen
    }
  }
}

var corruptedScore = 0
var incompleteScores: [Int] = []
outer: for s in input {
//outer: for s in sample {
  openStack = []
  for c in s {
    do {
      if let _ = try parseOne(c: c) {
        level -= 1
      } else {
        level += 1
      }
    } catch {
      if case .corrupted(_, let found) = error as? ParseError {
        corruptedScore += found.corruptedScore
      }
      continue outer
    }
  }
  let incompleteScore = openStack.reversed().map { $0.expectedClose }.reduce(0) { result, c in
    return result * 5 + c.incompleteScore
  }
  incompleteScores.append(incompleteScore)
}

// Part 1
print(corruptedScore)

// Part 2
print(incompleteScores.sorted()[incompleteScores.count / 2])
