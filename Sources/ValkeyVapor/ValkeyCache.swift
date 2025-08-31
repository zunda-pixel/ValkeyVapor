import NIOCore
import Valkey
import Vapor

public struct ValkeyCache {
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
}
