import Foundation
import Valkey

extension ValkeyCache {
  public struct Configuration: Sendable {
    public var client: ValkeyClient
    public var jsonDecoder: JSONDecoder
    public var jsonEncoder: JSONEncoder

    public init(
      client: ValkeyClient,
      jsonDecoder: JSONDecoder = .init(),
      jsonEncoder: JSONEncoder = .init()
    ) {
      self.client = client
      self.jsonDecoder = jsonDecoder
      self.jsonEncoder = jsonEncoder
    }
  }
}
