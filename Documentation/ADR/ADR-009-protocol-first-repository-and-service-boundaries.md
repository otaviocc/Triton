# ADR-009: Protocol-First Repository and Service Boundaries

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When designing the architecture for repositories and services, I needed to decide how to define their boundaries and contracts. Key considerations included:

1. **Abstraction:** Enable testing and flexibility without tight coupling to implementations
2. **Documentation:** Clear contracts for what each layer provides
3. **Dependency injection:** Support for swapping implementations
4. **Type safety:** Compile-time guarantees about capabilities
5. **Sendable conformance:** Support for Swift concurrency and actor isolation

The options were:
- **Concrete types only:** Simple but inflexible, hard to test
- **Protocols for everything:** Maximum flexibility but adds boilerplate
- **Protocol-first boundaries:** Protocols at layer boundaries, concrete types internally

**Decision:**

I adopted a protocol-first approach for repositories and services, where:

1. **Public protocols define contracts** - Each repository and service has a public protocol
2. **Concrete implementations are internal/actor-based** - Implementations use `actor` for thread safety
3. **Only protocols are documented** - DocC documentation focuses on public protocol contracts
4. **Protocols are Sendable** - Enable safe usage across actor boundaries
5. **Implementations remain undocumented** - Internal details don't need public documentation

**Implementation Pattern:**

```swift
/// Public protocol with comprehensive documentation
public protocol PURLsNetworkServiceProtocol: AnyObject, Sendable {
    /// Provides a stream of PURL collection updates.
    ///
    /// This method returns an AsyncStream that emits arrays of `PURLResponse` objects
    /// whenever PURL collections are fetched or modified. This enables reactive UI updates
    /// and real-time synchronization between network operations and local storage.
    ///
    /// - Returns: An `AsyncStream<[PURLResponse]>` that emits PURL collection updates.
    func purlsStream() -> AsyncStream<[PURLResponse]>

    /// Fetches all PURLs for a specific address and emits them through the stream.
    ///
    /// - Parameter address: The address to fetch PURLs for.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchPURLs(for address: String) async throws

    func addPURL(address: String, name: String, url: String) async throws
    func deletePURL(address: String, name: String) async throws
}

/// Actor implementation without public documentation
actor PURLsNetworkService: PURLsNetworkServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private let purlsStreamContinuation: AsyncStream<[PURLResponse]>.Continuation

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        // Implementation details...
    }

    func fetchPURLs(for address: String) async throws {
        // Implementation...
    }

    // Other methods...
}
```

**Protocol Naming Convention:**

- Repositories: `FeatureNameRepositoryProtocol` (e.g., `PURLsRepositoryProtocol`)
- Network Services: `FeatureNameNetworkServiceProtocol` (e.g., `PURLsNetworkServiceProtocol`)
- Persistence Services: `FeatureNamePersistenceServiceProtocol`
- Implementations drop the `Protocol` suffix (e.g., `PURLsRepository`)

**Sendable Conformance:**

Protocols marked as `Sendable` to enable:
- Safe passing across actor boundaries
- Usage in concurrent contexts
- Compliance with Swift 6 strict concurrency

```swift
public protocol PURLsRepositoryProtocol: Sendable {
    // Methods...
}
```

**Documentation Strategy:**

1. **Protocols:** Fully documented with DocC comments
   - What the method does
   - Parameters and return values
   - Error conditions
   - Usage examples when helpful

2. **Implementations:** Minimal or no documentation
   - Implementation details are internal
   - Comments only for complex internal logic
   - Focus on maintainability, not external API

**Why Not Document Implementations:**

- Implementations are `actor` or internal types, not part of public API
- Keeps documentation focused on contracts, not implementation details
- Reduces maintenance burden when implementations change
- Protocol documentation is the source of truth

**Consequences:**

### Positive

- **Testability:** Easy to create mock implementations for testing
- **Flexibility:** Can swap implementations without affecting consumers
- **Clear contracts:** Protocol defines exactly what each layer provides
- **Documentation clarity:** Protocol docs are single source of truth
- **Type safety:** Compiler enforces protocol conformance
- **Sendable safety:** Protocols ensure safe concurrent usage
- **Reduced maintenance:** Don't need to keep implementation docs in sync

### Negative

- **Boilerplate:** Need to define both protocol and implementation
- **Indirection:** One extra layer between usage and implementation
- **Protocol proliferation:** Many protocols throughout the codebase

### Neutral

- **Naming conventions:** Need consistent protocol naming patterns
- **Protocol granularity:** Ongoing decisions about protocol size and scope

**Integration with Architecture:**

- **Repository layer:** Repositories depend on service protocols, not implementations
- **Dependency injection:** Factories register protocol types in DependencyContainer
- **View models:** Depend on repository protocols
- **Testing:** Mock objects conform to protocols

```swift
// Repository depends on service protocols
actor PURLsRepository: PURLsRepositoryProtocol {
    private let networkService: any PURLsNetworkServiceProtocol
    private let persistenceService: any PURLsPersistenceServiceProtocol
    // ...
}

// Registered by protocol type
container.register(
    type: (any PURLsRepositoryProtocol).self,
    allocation: .static
) { container in
    PURLsRepository(
        networkService: container.resolve(),
        persistenceService: container.resolve()
    )
}
```

**Related Decisions:**

- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Protocols define layer boundaries
- [ADR-008: MicroContainer for Dependency Injection](ADR-008-microcontainer-for-dependency-injection.md) - Protocols registered in container
- [ADR-011: Actor Isolation for Repository and Service Concurrency](ADR-011-actor-isolation-for-repository-concurrency.md) - Implementations are actors

**Notes:**

The protocol-first approach strikes the right balance between abstraction and simplicity. By documenting only protocols, I maintain clear contracts while keeping implementation details internal and flexible. The Sendable conformance ensures protocols work seamlessly with Swift's actor-based concurrency model.
