import Foundation

let input = try load(index: 120).map { Connection($0) }
let map = Map(input)

// Part 1
print(map.findAllPaths().count)

// Part 2
print(map.findAllPaths(canRevisitSingleSmall: true).count)
