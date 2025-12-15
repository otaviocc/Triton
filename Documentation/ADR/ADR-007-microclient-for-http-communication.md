# ADR-007: MicroClient for HTTP Communication

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When designing the networking layer for the OMG application, I needed to choose an HTTP client library. The options included:

1. **URLSession directly:** Apple's native networking, but requires significant boilerplate
2. **Alamofire:** Popular third-party library with extensive features
3. **MicroClient:** Lightweight Swift-first HTTP client I built on top of URLSession

Key considerations:

- **Simplicity:** Needed clean API for straightforward HTTP requests
- **Modern Swift:** Should work naturally with async/await
- **Type safety:** Compile-time safety for requests and responses
- **Control:** Ability to customize exactly for this application's needs
- **Boilerplate reduction:** Less code than raw URLSession

**Decision:**

I chose to build and use MicroClient as the HTTP communication library for the OMG application. It provides a clean, type-safe API built on top of URLSession without the complexity of larger networking frameworks, tailored specifically to my needs.

**Key Implementation Patterns:**

1. **OMGAPIFactory:** Central factory for creating HTTP requests using MicroClient's `NetworkRequest`
2. **Request/Response models:** DTOs defined in OMGAPI package
3. **NetworkService layer:** Each feature's NetworkService uses MicroClient
4. **Async/await:** All network calls use async/await for clean asynchronous code
5. **Interceptors:** Authentication and common headers handled via MicroClient interceptors

**Example Usage:**

```swift
// In OMGAPIFactory - creates typed requests
extension OMGAPIFactory {
    static func makeAllStatusesRequest() -> NetworkRequest<VoidRequest, StatuslogResponse> {
        .init(
            path: "/statuslog",
            method: .get
        )
    }
}

// In NetworkService - executes requests
actor StatusNetworkService {
    private let client: MicroClient

    func fetchStatuses() async throws -> StatuslogResponse {
        let request = OMGAPIFactory.makeAllStatusesRequest()
        return try await client.run(request)
    }
}
```

**Consequences:**

### Positive

- **Clean API:** Simpler than raw URLSession, focused on actual needs
- **Type safety:** Request and response types checked at compile time via `NetworkRequest<Request, Response>`
- **Async/await native:** Built for modern Swift concurrency
- **Lightweight:** Minimal dependency footprint
- **Full control:** Can evolve the library alongside the application
- **Tailored design:** API shaped exactly for this application's patterns
- **Flexible:** Can add interceptors for auth, logging, etc.

### Negative

- **Maintenance responsibility:** I maintain the library
- **Documentation:** Need to document patterns for my future reference
- **External use consideration:** Library evolved alongside this specific application

### Neutral

- **Dependency management:** External dependency, but under my control
- **Feature scope:** Only implements features needed by this application

**Integration with Architecture:**

- **OMGAPI package:** Contains OMGAPIFactory and all request/response DTOs
- **NetworkService layer:** Each feature's NetworkService depends on OMGAPI and uses MicroClient
- **Repository coordination:** Repositories consume NetworkService protocols
- **Error handling:** Network errors handled at repository boundary, mapped to domain errors

**Related Decisions:**

- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - MicroClient used in NetworkService layer
- [ADR-004: Migration from Combine to Async/Await](ADR-004-migration-from-combine-to-async-await.md) - MicroClient built with async/await support
- [ADR-012: DTO-Based Data Flow](../Data-Flow/ADR-012-dto-based-data-flow.md) - Request/response models in OMGAPI

**Notes:**

Building MicroClient gave me full control over the networking layer's API design and allowed me to create a library that fits perfectly with the application's architecture and patterns. The `NetworkRequest<Request, Response>` type provides compile-time safety for API calls.
