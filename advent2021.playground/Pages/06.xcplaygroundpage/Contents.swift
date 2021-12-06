import Foundation

public class Fish {
    static let firstLifeTime = 8
    static let normalLifeTime = 6
    
    private var generatedFirst: Bool = false
    private var lifeTime: Int { generatedFirst ? Self.normalLifeTime : Self.firstLifeTime }
    
    private let initialTimer: Int
    private let leftTime: Int
    
    public lazy var allCount: Int = {
        var result = 1
        var newLeft = leftTime - initialTimer - 1
        
        while newLeft >= 0 {
            if let value = newFishOfDay[newLeft] {
                result += value
            } else {
                let newFish = Fish(leftTime: newLeft)
                let c = newFish.allCount
                newFishOfDay[newLeft] = newFish.allCount
                result += c
            }
            generatedFirst = true
            newLeft = newLeft - lifeTime - 1
        }
        return result
    }()
    
    public init(initialTimer: Int, leftTime: Int, generatedFirst: Bool = true) {
        self.generatedFirst = generatedFirst
        self.initialTimer = initialTimer
        self.leftTime = leftTime
    }
    
    // Brand new fish.
    private convenience init(leftTime: Int) {
        self.init(initialTimer: Self.firstLifeTime, leftTime: leftTime, generatedFirst: false)
    }
}

// Cache
var newFishOfDay: [Int: Int] = [:]


let input = try load(index: 6)[0].split(separator: ",").map { Int($0)! }

// Part 1
let fishesCount = (0...8)
    .map { Fish(initialTimer: $0, leftTime: 80).allCount }
print(input.reduce(0) { r, index in r + fishesCount[index] })

// Part 2
let fishesCount2 = (0...8)
    .map { Fish(initialTimer: $0, leftTime: 256).allCount }
print(input.reduce(0) { r, index in r + fishesCount2[index] })
