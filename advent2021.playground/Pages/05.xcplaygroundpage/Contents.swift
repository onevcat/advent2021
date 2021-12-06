import Foundation
import CoreGraphics


let input = try load(index: 5)
    .map { Line(pair: $0.components(separatedBy: " -> ")) }

// Part 1
let map1 = Map(size: Line.mapSize(in: input))
let orthogonality = input.filter { $0.isOrthogonality }

orthogonality.forEach { $0.mark(in: map1) }
print(map1.values.flatMap { $0 }.filter { $0 >= 2 }.count)

// Part 2
let map2 = Map(size: Line.mapSize(in: input))
input.forEach { $0.mark(in: map2) }
print(map2.values.flatMap { $0 }.filter { $0 >= 2 }.count)
