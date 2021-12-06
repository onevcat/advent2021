import Foundation

public struct Point {
    let x: Int
    let y: Int
}

public struct Line {
    let start: Point
    let end: Point
    
    public var isOrthogonality: Bool { start.x == end.x || start.y == end.y }
    
    public init(pair: [String]) {
        guard pair.count == 2 else {
            fatalError()
        }
        
        let startPoints = pair[0].split(separator: ",").map { Int($0)! }
        let start = Point(x: startPoints[0], y: startPoints[1])
        
        let endPoints = pair[1].split(separator: ",").map { Int($0)! }
        let end = Point(x: endPoints[0], y: endPoints[1])
        self.init(start: start, end: end)
    }
    
    init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }
    
    public func mark(in map: Map) {
        for p in path {
            map.markPoint(x: p.x, y: p.y)
        }
    }
        
    func next(_ current: Point) -> Point? {
        let offSetX: Int
        let offSetY: Int
        
        if current.x < end.x {
            offSetX = 1
        } else if current.x > end.x {
            offSetX = -1
        } else {
            offSetX = 0
        }
        
        if current.y < end.y {
            offSetY = 1
        } else if current.y > end.y {
            offSetY = -1
        } else {
            offSetY = 0
        }
        if offSetX == 0 && offSetY == 0 {
            return nil
        }
        return .init(x: current.x + offSetX, y: current.y + offSetY)
    }
    
    var path: [Point] {
        var result: [Point] = [start]
        var current = start
        while let p = next(current) {
            result.append(p)
            current = p
        }
        return result
    }
    
    public static func mapSize(in lines: [Line]) -> CGSize {
        var maxX = -1
        var maxY = -1
        for l in lines {
            maxX = max(maxX, Int(max(l.start.x, l.end.x)))
            maxY = max(maxY, Int(max(l.start.y, l.end.y)))
        }
        return .init(width: maxX + 1, height: maxY + 1)
    }
}

public class Map {
    public var values: [[Int]]
    
    func markPoint(x: Int, y: Int) {
        values[x][y] += 1
    }
    
    public init(size: CGSize) {
        values = .init(repeating: .init(repeating: 0, count: Int(size.width)), count: Int(size.height))
    }
}
