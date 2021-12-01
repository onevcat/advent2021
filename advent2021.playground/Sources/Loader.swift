import Foundation

public func load(index: Int) throws -> [String] {
    let url = Bundle.main.url(forResource: "\(index)", withExtension: "")!
    let s = try String(contentsOf: url)
    return s.split(separator: "\n").map { String($0) }
}
