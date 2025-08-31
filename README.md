# ValkeyVapor

Valkey for Vapor

```swift
import Logging
import NIOCore
import NIOPosix
import ValkeyVapor
import Vapor

@main
enum Entrypoint {
  static func main() async throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)

    let app = try await Application(env)

    app.valkey.configuration = ValkeyCache.Configuration(
      client: .init(
        .hostname("localhost"),
        logger: app.logger
      )
    )

    do {
      try await configure(app)
      try await withThrowingTaskGroup(of: Void.self) { group in
        group.addTask { try await app.run() }
        group.addTask { try await app.valkey.client.run() }

        try await group.waitForAll()
      }

    } catch {
      app.logger.report(error: error)
      try? await app.shutdown()
      throw error
    }
    try await app.shutdown()
  }
}


func routes(_ app: Application) throws {
  app.get { req async throws in
    guard let buffer = try await req.application.valkey.client.get("TestKey") else {
      throw Abort(.notFound)
    }
    return String(buffer: buffer)
  }
}
```
