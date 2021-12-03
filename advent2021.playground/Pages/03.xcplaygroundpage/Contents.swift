import Foundation

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in map{ $0[index] } }
    }
}

extension Array where Element: Equatable {
    func moreThanHalf(_ v: Element) -> Bool {
        var count = 0
        for i in self {
            if i == v {
                count += 1
                if count > self.count / 2 {
                    return true
                }
            }
        }
        return false
    }
    
    func indexesOf(_ v: Element) -> [Int] {
        var result = [Int]()
        for (i, vv) in self.enumerated() {
            if vv == v {
                result.append(i)
            }
        }
        return result
    }
}

extension Array where Element == Character {
    var number: Int { Int(String(self), radix: 2)! }
    var complementary: Self { self.map { $0 == "1" ? "0" : "1" } }
    var mostCommon: Character { moreThanHalf("1") ? "1" : "0" }
    
    func commonIndexes(most: Bool, targetWhenEqual: Character) -> [Int] {
        if moreThanHalf("1") {
            return most ? indexesOf("1") : indexesOf("0")
        } else if moreThanHalf("0") {
            return most ? indexesOf("0") : indexesOf("1")
        } else {
            return indexesOf(targetWhenEqual)
        }
    }
}

extension Array where Element == [Character] {
    func submarineReduce(keeping: ([Character]) -> [Int]) -> [Character] {
        var result = self
        var index = 0
        
        while result.count > 1 {
            let currentPass = result.transposed()[index]
            var left = [[String.Element]]()
            for index in keeping(currentPass) {
                left.append(result[index])
            }
            index += 1
            result = left
        }
        
        return result[0]
    }
}

let input = try load(index: 3).map { Array($0) }

// Part 1
let gamma = input.transposed().map { $0.mostCommon }
let epsilon = gamma.complementary
print(gamma.number * epsilon.number)

// Part 2
let oxygen = input.submarineReduce { $0.commonIndexes(most: true,  targetWhenEqual: "1") }.number
let co2 =    input.submarineReduce { $0.commonIndexes(most: false, targetWhenEqual: "0") }.number
print(oxygen * co2)
