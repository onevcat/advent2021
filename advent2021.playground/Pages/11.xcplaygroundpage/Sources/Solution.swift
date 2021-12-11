import Foundation

public struct Map {
  
  struct Point: Equatable {
    let x: Int
    let y: Int
  }
  
  public init(values: [[Int]]) {
    self.values = values
  }

  public var values: [[Int]]
  public mutating func nextStep() -> Int {
    
    var flashing = [Point]()
    var checked = [Point]()
    
    for y in 0 ..< values.count {
      for x in 0 ..< values[y].count {
        values[y][x] += 1
        if values[y][x] == 10 {
          flashing.append(.init(x: x, y: y))
        }
      }
    }
    
    while !flashing.isEmpty {
      let current = flashing.removeFirst()
      checked.append(current)
      
      let newFlashing = increaseAdjacent(x: current.x, y: current.y)
      flashing += newFlashing
    }
    
    var flashCount = 0
    for y in 0 ..< values.count {
      for x in 0 ..< values[y].count {
        if values[y][x] >= 10 {
          values[y][x] = 0
          flashCount += 1
        }
      }
    }
    
    // print(values)
    return flashCount
  }
  
  // Return the flashing points
  mutating func increaseAdjacent(x: Int, y: Int) -> [Point] {
    let offsets = [
      (-1, -1), (0, -1), (1, -1),
      (-1, 0)          , (1, 0),
      (-1, 1),  (0, 1),  (1, 1),
    ]
    
    var newFlashing = [Point]()
    
    for offset in offsets {
      let targetX = x + offset.0
      let targetY = y + offset.1
      if targetX < 0 || targetX >= values[0].count || targetY < 0 || targetY >= values.count {
        continue
      }
      
      values[targetY][targetX] += 1
      if values[targetY][targetX] == 10 {
        newFlashing.append(.init(x: targetX, y: targetY))
      }
    }
    return newFlashing
  }
}
