import Vapor

extension ValkeyCache {
  struct Lifecycle: LifecycleHandler {
    func shutdown(_ application: Application) async {
      for (_, configuration) in application.valKeyStorage.configuration.withLock({ $0 }) {
        try? await configuration.client.shutdown()
      }
    }
  }
}
