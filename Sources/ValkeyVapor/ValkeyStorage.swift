import Synchronization

public final class ValkeyStorage: Sendable {
  let configuration: Mutex<[ValkeyCache.ID: ValkeyCache.Configuration]> = .init([:])
}
