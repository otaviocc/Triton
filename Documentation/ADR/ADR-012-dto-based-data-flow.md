# ADR-012: DTO-Based Data Flow

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When designing data flow through the application layers, I needed to decide how data should be represented and transformed as it moves from the network to the UI. Key considerations included:

1. **API coupling:** Keep API response formats separate from domain models
2. **Type safety:** Ensure compile-time safety at layer boundaries
3. **Mapping responsibility:** Clear ownership of data transformation
4. **Flexibility:** Enable API changes without affecting domain logic
5. **Testability:** Easy to create test fixtures at each layer

**Decision:**

I adopted a DTO (Data Transfer Object) based approach where data flows through distinct representations at each layer:

```
Network API
    ↓
DTOs (OMGAPI package) ← Codable, API-shaped structures
    ↓
Repository ← Maps DTOs to domain models or persistence models
    ↓
Domain Models / Persistence Models ← SwiftData @Model or view-friendly structs
    ↓
ViewModels / Views
```

**Layer Responsibilities:**

1. **OMGAPI Package (DTOs)**
   - Contains all request and response models
   - Matches API structure exactly (Codable)
   - Marked `Sendable` for concurrency safety
   - Public, shared across features

2. **NetworkService Layer**
   - Fetches data from API
   - Decodes responses into DTOs
   - No mapping logic - returns DTOs as-is

3. **Repository Layer**
   - Maps DTOs to domain/persistence models
   - Applies business logic during transformation
   - Coordinates between network DTOs and local storage

4. **PersistenceService Layer**
   - Stores/retrieves domain or DTO representations
   - Uses SwiftData @Model types for persistence

**Example Flow:**

```swift
// 1. DTO in OMGAPI package
public struct PURLsResponse: Decodable, Sendable {
    public let request: RequestResponse
    public let response: Response

    public struct Response: Decodable, Sendable {
        public let message: String
        public let purls: [PURLResponse]
    }
}

public extension PURLsResponse.Response {
    struct PURLResponse: Decodable, Sendable {
        public let name: String
        public let url: URL
        public let counter: Int?
    }
}

// 2. NetworkService returns DTOs
actor PURLsNetworkService: PURLsNetworkServiceProtocol {
    func fetchPURLs(for address: String) async throws {
        let request = OMGAPIFactory.makeAllPURLsRequest(for: address)
        let response: PURLsResponse = try await client.run(request)
        // Emit DTOs through stream
        continuation.yield(response.response.purls)
    }
}

// 3. Repository maps to persistence model
actor PURLsRepository: PURLsRepositoryProtocol {
    private func startPURLsSync() {
        for await purls in networkService.purlsStream() {
            let storablePurls = purls.map { purlResponse in
                StorablePURL(
                    address: current,
                    purlResponse: purlResponse  // Map DTO to @Model
                )
            }
            try await persistenceService.storePURLs(purls: storablePurls)
        }
    }
}

// 4. SwiftData persistence model
@Model
final class StorablePURL {
    var address: String
    var name: String
    var url: URL
    var counter: Int?

    init(address: String, purlResponse: PURLResponse) {
        self.address = address
        self.name = purlResponse.name
        self.url = purlResponse.url
        self.counter = purlResponse.counter
    }
}
```

**Mapping Patterns:**

- **DTO → @Model:** Repository maps during persistence operations
- **@Model → View Models:** SwiftData queries provide models directly to views
- **DTO → Domain Structs:** Some features use lightweight structs instead of @Model
- **No direct DTO to View:** Views never see DTOs, only domain models

**Consequences:**

### Positive

- **Decoupling:** API changes don't ripple through all layers
- **Type safety:** Each layer has appropriate types for its purpose
- **Clear boundaries:** Transformation happens at well-defined points
- **Testability:** Easy to create fixtures at each layer
- **Sendable safety:** DTOs are Sendable, enabling actor isolation
- **Flexibility:** Can change domain models without affecting API contract

### Negative

- **Mapping boilerplate:** Need code to transform between representations
- **Multiple representations:** Same data exists in different forms
- **Memory overhead:** Temporary DTO objects during transformation

### Neutral

- **Mapping complexity:** Simple for straightforward cases, more complex for nested structures
- **Performance impact:** Mapping cost is generally negligible for typical data sizes

**Why Not Direct API Models:**

Alternatives considered:
- **Use DTOs everywhere:** Couples domain logic to API structure
- **Use domain models for network:** Forces Codable on domain types
- **Manual JSON parsing:** Error-prone and verbose

**Related Decisions:**

- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - DTOs flow through layers
- [ADR-006: Swift Data over Core Data](ADR-006-swift-data-over-core-data.md) - @Model types are mapping targets
- [ADR-007: MicroClient for HTTP Communication](ADR-007-microclient-for-http-communication.md) - NetworkRequest uses DTOs for response types

**Notes:**

The DTO-based approach provides clean separation between API contracts and domain models. While it requires mapping code, the benefits of decoupling and type safety outweigh the boilerplate cost. The OMGAPI package serves as the single source of truth for API data structures.
