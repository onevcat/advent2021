import Foundation

public struct Map {
  
  public struct Point: Hashable {
    let x: Int
    let y: Int
    let value: Int
    
    public var riskLevel: Int { value + 1 }
  }
  
  public struct Basin {
    let points: [Point]
    
    func contains(x: Int, y: Int) -> Bool {
      points.contains { p in x == p.x && y == p.y }
    }
    
    public var size: Int { points.count }
  }
  
  let sample: [[Int]]
  
  public init(values: [[Int]]) {
    sample = values
  }
  
  var currentX: Int = 0
  var currentY: Int = 0
  
  public mutating func getLowPoints() -> [Point] {
    var result = [Point]()
    while let next = nextLowPoint() {
      result.append(next)
    }
    return result
  }
  
  mutating func nextLowPoint() -> Point? {
    
    if currentY == sample.count {
      return nil
    }
    
    let current = getValue(x: currentX, y: currentY)!
    if current < (getValue(x: currentX, y: currentY - 1) ?? .max) &&
        current < (getValue(x: currentX - 1, y: currentY) ?? .max) &&
        current < (getValue(x: currentX, y: currentY + 1) ?? .max) &&
        current < (getValue(x: currentX + 1, y: currentY) ?? .max)
    {
      defer {
        advance()
      }
      return .init(x: currentX, y: currentY, value: current)
    }
    
    advance()
    return nextLowPoint()
  }
  
  mutating func advance() {
    currentX += 1
    if currentX == sample[0].count {
      currentX = 0
      currentY += 1
    }
  }
  
  func getValue(x: Int, y: Int) -> Int? {
    if x < 0 || y < 0 || x >= sample[0].count || y >= sample.count {
      return nil
    }
    return sample[y][x]
  }
  
  public mutating func getBasins() -> [Basin] {
    var result = [Basin]()
    while let next = nextBasin(found: result) {
      result.append(next)
    }
    return result
  }
  
  mutating func nextBasin(found: [Basin]) -> Basin? {
    if currentY == sample.count {
      return nil
    }
    if (found.contains { $0.contains(x: currentX, y: currentY) }) {
      advance()
      return nextBasin(found: found)
    }
    
    // A new base point
    let baseX = currentX
    let baseY = currentY
    let value = getValue(x: baseX, y: baseY)!
    if value == 9 {
      advance()
      return nextBasin(found: found)
    }
    
    let initPoint = Point(x: baseX, y: baseY, value: value)
    
    let foundBasinPoints: Set<Point> = [initPoint]
    let points = basinPointsAround(x: baseX, y: baseY, existing: foundBasinPoints)
    
    advance()
    return Basin(points: Array(points))
  }
  
  func basinPointsAround(x: Int, y: Int, existing: Set<Point>) -> Set<Point> {
    
    let points = [(x, y - 1), (x - 1, y), (x, y + 1), (x + 1, y)]
    let values = points.map { getValue(x: $0.0, y: $0.1) }
    
    let found = zip(points, values)
      .filter { $1 != nil && $1 != 9 }
      .map { Point(x: $0.0, y: $0.1, value: $1!) }
    
    var newExisting = existing
    for p in found {
      if !newExisting.contains(p) {
        newExisting.insert(p)
        newExisting.formUnion(basinPointsAround(x: p.x, y: p.y, existing: newExisting))
      }
    }
    return newExisting
  }
}
