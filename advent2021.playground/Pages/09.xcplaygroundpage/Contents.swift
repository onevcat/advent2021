import Foundation

let input = try load(index: 9).map { Array($0).map { Int(String($0))! } }

// Part 1
var m = Map(values: input)
print(m.getLowPoints().reduce(0, { $0 + $1.riskLevel }))

// Part 2
var m1 = Map(values: input)
let basins = m1.getBasins()
print(basins.sorted { $0.size > $1.size }.prefix(3).reduce(1) { $0 * $1.size })
