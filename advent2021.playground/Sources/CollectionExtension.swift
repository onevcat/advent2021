import Foundation

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    public var transposed: [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in map{ $0[index] } }
    }
}
