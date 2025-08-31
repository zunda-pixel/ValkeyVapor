extension ValkeyCache {
  public struct ID: Hashable,
    Codable,
    RawRepresentable,
    ExpressibleByStringLiteral,
    ExpressibleByStringInterpolation,
    CustomStringConvertible,
    Comparable,
    Sendable
  {

    public let rawValue: String

    public init(stringLiteral: String) {
      self.rawValue = stringLiteral
    }

    public init(rawValue: String) {
      self.rawValue = rawValue
    }

    public init(_ string: String) {
      self.rawValue = string
    }

    public var description: String { rawValue }
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }

    public static let `default`: Self = "default"
  }
}
