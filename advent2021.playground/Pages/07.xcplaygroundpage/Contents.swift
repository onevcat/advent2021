import Foundation

extension Int {
    var accumulated: Int {
        if self == 0 { return 0 }
        var r = 0
        for i in 1 ... self {
            r += i
        }
        return r
    }
}

struct Input {
    let values: [Int]
    let incremental: Bool

    let min: Int
    let max: Int
    
    init(values: [Int], incremental: Bool) {
        self.values = values
        self.min = values.min()!
        self.max = values.max()!
        self.incremental = incremental
    }
    
    func distance(to target: Int) -> Int {
        values.reduce(0) { r, c in
            r + (incremental ? abs(c - target).accumulated : abs(c - target))
        }
    }
    
    func solve() -> Int {
        return solve(min: min, max: max)
    }
    
    func solve(min: Int, max: Int) -> Int {
        print("Solve: \(min) - \(max)")
        if min == max || min + 1 == max {
            let minDis = distance(to: min)
            let maxDis = distance(to: max)
            return minDis < maxDis ? min : max
        }
        
        let mid = (min + max) / 2
        let distanceToMid = distance(to: mid)
        
        let left = (min + mid) / 2
        let distanceToLeft = distance(to: left)
        
        let right = (mid + max) / 2
        let distanceToRight = distance(to: right)
        
        if distanceToMid <= distanceToLeft && distanceToMid <= distanceToRight {
            return solve(min: left, max: right)
        }
        if distanceToLeft < distanceToMid {
            return solve(min: min, max: mid)
        }
        if distanceToRight < distanceToMid {
            return solve(min: mid, max: max)
        }
        fatalError()
    }
}

let values = try load(index: 7)[0]
    .split(separator: ",")
    .map { Int($0)! }

// Part 1
let input1 = Input(values: values, incremental: false)
print(input1.distance(to: input1.solve()))

// Part 2
let input2 = Input(values: values, incremental: true)
print(input2.distance(to: input2.solve()))
