import Foundation

struct Map {
  var data: [[Bool]]
  
  var size: (Int, Int) {
    return (data[0].count, data.count)
  }
  
  var markedCount: Int {
    data.flatMap { $0 }.filter { $0 }.count
  }
  
  func output() {
    for y in 0 ..< data.count {
      for x in 0 ..< data[y].count {
        print(data[y][data[y].count - x - 1] ? "#" : ".", separator: "", terminator: "")
      }
      print("")
    }
  }
  
  init(pairs: [String]) {
    let coors = pairs.map { $0.split(separator: ",").map { Int(String($0))! } }
    let maxX = coors.map { $0[0] }.max()!
    let maxY = coors.map { $0[1] }.max()!
    
    data = .init(repeating: .init(repeating: false, count: maxX + 1), count: maxY + 1)
    for p in coors {
      data[p[1]][p[0]] = true
    }
  }
  
  mutating func fold(_ f: Fold) {
    switch f {
    case .x(let x): foldAt(foldingX: x)
    case .y(let y): foldAt(foldingY: y)
    }
  }
  
  mutating func foldAt(foldingX: Int) {
    let newSize = sizeAfterFold(foldingX: foldingX)
    var newData = [[Bool]].init(repeating: .init(repeating: false, count: newSize.0), count: newSize.1)
    for y in 0 ..< data.count {
      for x in 0 ..< data[y].count {
        if data[y][x] {
          if let newPoint = pointAfterFold(x: x, y: y, foldingX: foldingX) {
            newData[newPoint.1][newPoint.0] = true
          }
        }
      }
    }
    data = newData
  }
  
  mutating func foldAt(foldingY: Int) {
    let newSize = sizeAfterFold(foldingY: foldingY)
    var newData = [[Bool]].init(repeating: .init(repeating: false, count: newSize.0), count: newSize.1)
    for y in 0 ..< data.count {
      for x in 0 ..< data[y].count {
        if data[y][x] {
          if let newPoint = pointAfterFold(x: x, y: y, foldingY: foldingY) {
            newData[newPoint.1][newPoint.0] = true
          }
        }
      }
    }
    data = newData
  }
  
  func pointAfterFold(x: Int, y: Int, foldingX: Int) -> (Int, Int)? {
    if x == foldingX {
      return nil
    }
    
    if foldingX <= data[0].count / 2 {
      if x <= foldingX {
        return (foldingX - x - 1, y)
      } else {
        return (x - foldingX - 1, y)
      }
    } else {
      if x <= foldingX {
        return (x, y)
      } else {
        return (2 * foldingX - x, y)
      }
    }
  }
  
  func pointAfterFold(x: Int, y: Int, foldingY: Int) -> (Int, Int)? {
    if y == foldingY {
      return nil
    }
    
    if foldingY < data.count / 2 {
      if y <= foldingY {
        return (x, foldingY - y - 1)
      } else {
        return (x, y - foldingY - 1)
      }
    } else {
      if y <= foldingY {
        return (x, y)
      } else {
        return (x, 2 * foldingY - y)
      }
    }
  }
  
  func sizeAfterFold(foldingX: Int) -> (Int, Int) {
    let y = data.count
    let columnCount = data[0].count
    if foldingX < columnCount / 2 {
      return (columnCount - foldingX - 1, y)
    } else {
      return (foldingX, y)
    }
  }
  
  func sizeAfterFold(foldingY: Int) -> (Int, Int) {
    let x = data[0].count
    if foldingY <= data.count / 2 {
      return (x, data.count - foldingY - 1)
    } else {
      return (x, foldingY)
    }
  }
}

//let sample = [
//  "6,10",
//  "0,14",
//  "9,10",
//  "0,3",
//  "10,4",
//  "4,11",
//  "6,0",
//  "6,12",
//  "4,1",
//  "0,13",
//  "10,12",
//  "3,4",
//  "3,0",
//  "8,4",
//  "1,10",
//  "2,14",
//  "8,10",
//  "9,0"
//]
//
//let instruction = [
//  "fold along y=7",
//  "fold along x=5"
//]


//var map = Map(pairs: sample)
//print(map.size)
//print(map.sizeAfterFold(foldingY: 7))
//
//map.foldAt(foldingY: 7)
//map.output()
//map.markedCount
//map.foldAt(foldingX: 5)
//map.output()
//map.markedCount

enum Fold {
  case x(Int)
  case y(Int)
  init(_ s: String) {
    let pair = s.split(separator: " ").last!.split(separator: "=")
    if pair[0] == "x" {
      self = .x(Int(pair[1])!)
    } else if pair[0] == "y" {
      self = .y(Int(pair[1])!)
    } else {
      fatalError()
    }
  }
}

let input = try load(index: 130)

let coordinates = Array(input.prefix { !$0.starts(with: "fold") })
var folds = input.suffix(from: coordinates.count).map { Fold($0) }

var map = Map(pairs: coordinates)

// Part 1
let first = folds.removeFirst()
map.fold(first)
print(map.markedCount)

// Part 2
for f in folds {
  map.fold(f)
}
map.output()
