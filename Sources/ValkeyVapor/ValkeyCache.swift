import NIOCore
import Valkey
import Vapor

public struct ValkeyCache: Cache {
  public var id: ID
  public var application: Application

  public var configuration: ValkeyCache.Configuration? {
    get {
      application.valKeyStorage.configuration.withLock { $0[id] }
    }
    nonmutating set {
      application.valKeyStorage.configuration.withLock { $0[id] = newValue }
    }
  }

  func getConfiguration() throws -> ValkeyCache.Configuration {
    guard let configuration = application.valKeyStorage.configuration.withLock({ $0[id] }) else {
      throw ValkeyError.notFoundConfiguration
    }
    return configuration
  }

  public var client: ValkeyClient {
    get throws {
      try getConfiguration().client
    }
  }

  public func run() async throws {
    try await self.client.run()
  }

  public func shutdown() async throws {
    try await self.client.shutdown()
  }

  public func get<T>(
    _ key: String,
    as type: T.Type
  ) async throws -> T? where T: Decodable, T: Sendable {
    let configuration = try getConfiguration()
    guard let data = try await self.client.get(Valkey.ValkeyKey(key)) else { return nil }
    return try configuration.jsonDecoder.decode(T.self, from: data)
  }

  public func get(
    _ key: String
  ) async throws -> String? {
    let configuration = try getConfiguration()
    guard let data = try await configuration.client.get(Valkey.ValkeyKey(key)) else { return nil }
    return String(buffer: data)
  }

  public func set<T>(
    _ key: String,
    to value: T?,
    expiresIn expirationTime: Vapor.CacheExpirationTime?
  ) async throws where T: Encodable, T: Sendable {
    let configuration = try getConfiguration()
    if let value {
      let data = try configuration.jsonEncoder.encode(value)
      try await configuration.client.set(
        Valkey.ValkeyKey(key),
        value: data,
        expiration: expirationTime.map { .seconds($0.seconds) }
      )
    } else {
      try await configuration.client.del(keys: [Valkey.ValkeyKey(key)])
    }
  }

  public func set(
    _ key: String,
    to value: String?,
    expiresIn expirationTime: Vapor.CacheExpirationTime?
  ) async throws {
    guard let configuration = application.valKeyStorage.configuration.withLock({ $0[id] }) else {
      throw ValkeyError.notFoundConfiguration
    }
    if let value {
      let data = ByteBuffer(string: value)
      try await configuration.client.set(
        Valkey.ValkeyKey(key),
        value: data,
        expiration: expirationTime.map { .seconds($0.seconds) }
      )
    } else {
      try await configuration.client.del(keys: [Valkey.ValkeyKey(key)])
    }
  }
}
