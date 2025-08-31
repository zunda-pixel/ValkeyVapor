# ValkeyVapor

Valkey for Vapor

```swift
import Vapor
import ValkeyVapor

let app = try await Application(env)

app.valkey.configuration = ValkeyCache.Configuration(
  client: .init(
    .hostname("localhost", port: 6379),
    logger: app.logger
  )
)

do {
  try await configure(app)
  try await withThrowingTaskGroup(of: Void.self) { group in
    group.addTask { try await app.run() }
    group.addTask { try await app.valkey.run() }

    try await group.waitForAll()
  }

} catch {
  app.logger.report(error: error)
  try? await app.shutdown()
  throw error
}
try await app.shutdown()
```
