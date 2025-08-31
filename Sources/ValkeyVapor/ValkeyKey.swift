import Vapor

public struct ValkeyKey: StorageKey, Sendable {
  public typealias Value = ValkeyStorage
}
