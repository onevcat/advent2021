import Foundation

public struct Cave: Equatable, Hashable, CustomStringConvertible {
  let name: String
  var isBig: Bool {
    self != .start && self != .end && self.name.allSatisfy { $0.isUppercase }
  }
  
  init(_ name: String) {
    self.name = name
  }
  
  static let start = Cave("start")
  static let end = Cave("end")
  
  func visitNext(in map: Map, currentPath: [Cave], found: inout [[Cave]], canRevisitSingleSmall: Bool) {
    if self == .end {
      found.append(currentPath + [self])
      return
    }
    
    var nextCanRevisit = canRevisitSingleSmall
    if !isBig && currentPath.contains(self) {
      if self == .start || !canRevisitSingleSmall {
        return
      }
      nextCanRevisit = false
    }
    
    var newPath = currentPath
    newPath.append(self)
    for next in map.connectedCaves(of: self) {
      next.visitNext(in: map, currentPath: newPath, found: &found, canRevisitSingleSmall: nextCanRevisit)
    }
  }
  
  public var description: String { name }
}

public struct Connection {
  let cave1: Cave
  let cave2: Cave
  
  public init(_ path: String) {
    let caves = path.split(separator: "-").map { Cave(String($0)) }
    cave1 = caves[0]
    cave2 = caves[1]
  }
}

public struct Map {
  let start = Cave.start
  let end = Cave.end
  
  let data: [Cave: [Cave]]
  
  public init(_ connections: [Connection]) {
    var d: [Cave: [Cave]] = [:]
    for c in connections {
      d[c.cave1] = d[c.cave1, default: []] + [c.cave2]
      d[c.cave2] = d[c.cave2, default: []] + [c.cave1]
    }
    self.data = d
  }
  
  func connectedCaves(of cave: Cave) -> [Cave] {
    data[cave]!
  }
  
  public func findAllPaths(canRevisitSingleSmall: Bool = false) -> [[Cave]] {
    var found = [[Cave]]()
    start.visitNext(in: self, currentPath: [], found: &found, canRevisitSingleSmall: canRevisitSingleSmall)
    return found
  }
}
