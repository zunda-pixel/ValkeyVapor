import Vapor

extension Application {
  public var valkey: ValkeyCache {
    valkey(.default)
  }

  public func valkey(_ id: ValkeyCache.ID) -> ValkeyCache {
    ValkeyCache(id: id, application: self)
  }

  public var valKeyStorage: ValkeyStorage {
    if let existing = self.storage[ValkeyKey.self] {
      return existing
    }

    let storage = ValkeyStorage()
    self.storage[ValkeyKey.self] = storage
    self.lifecycle.use(ValkeyCache.Lifecycle())
    return storage
  }
}
