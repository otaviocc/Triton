# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records for the OMG application. These documents capture important architectural decisions, their context, and consequences.

## What is an ADR?

An Architecture Decision Record (ADR) is a document that captures an important architectural decision made along with its context and consequences. This helps understand why certain decisions were made and provides guidance for future development.

## ADR Format

Each ADR follows this structure:

- **Status:** Accepted, Proposed, Deprecated, or Superseded
- **Date:** When the decision was made
- **Context:** The situation and requirements that led to the decision
- **Decision:** What was decided and key principles
- **Consequences:** Positive, negative, and neutral outcomes
- **Related Decisions:** Links to related ADRs
- **Notes:** Additional context or implementation details

## Core Architecture ADRs

### [ADR-001: Modular Architecture with Swift Package Manager](ADR-001-modular-architecture-with-spm.md)
Decision to use Swift Package Manager for modularizing the codebase into discrete, maintainable packages with clear dependency boundaries.

### [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md)
Establishes the strict layered architecture with one-way dependency flow from Views → ViewModels → Repositories → Services → Foundation Modules.

### [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md)
Defines how features are organized as complete vertical slices with their own layers, and how they integrate with the main application through AppFactory patterns.

## Technology Decisions

### [ADR-004: Migration from Combine to Async/Await](ADR-004-migration-from-combine-to-async-await.md)
Migration from Combine to async/await in services and repositories for cleaner asynchronous code and better integration with modern Swift concurrency.

### [ADR-005: Adoption of Swift Observation Framework](ADR-005-adoption-of-swift-observation-framework.md)
Adoption of Swift's @Observable macro to replace ObservableObject and @Published in view models, completing the removal of Combine from the UI layer.

### [ADR-006: Swift Data over Core Data](ADR-006-swift-data-over-core-data.md)
Migration from Core Data to Swift Data to eliminate excessive boilerplate for the application's straightforward data models.

### [ADR-007: MicroClient for HTTP Communication](ADR-007-microclient-for-http-communication.md)
Use of MicroClient, a custom-built lightweight HTTP client, for all API communication with type-safe request/response patterns.

### [ADR-008: MicroContainer for Dependency Injection](ADR-008-microcontainer-for-dependency-injection.md)
Use of MicroContainer (DependencyContainer), a custom-built lightweight DI container, for managing dependencies and factory registration throughout the application.

## Design Patterns

### [ADR-009: Protocol-First Repository and Service Boundaries](ADR-009-protocol-first-repository-and-service-boundaries.md)
Use of public protocols to define repository and service contracts, with Sendable conformance for concurrency safety. Only protocols are documented; implementations remain internal.

### [ADR-010: AppFactory Pattern for Feature Integration](ADR-010-appfactory-pattern-for-feature-integration.md)
Standardized factory pattern for feature integration with makeAppView(), makeScene(), and makeSettingsView() methods providing consistent entry points for all features.

### [ADR-011: Actor Isolation for Repository and Service Concurrency](ADR-011-actor-isolation-for-repository-concurrency.md)
Use of Swift actors for services and repositories to ensure thread safety and prevent data races while maintaining clean async/await APIs.

## Data Flow

### [ADR-012: DTO-Based Data Flow](ADR-012-dto-based-data-flow.md)
Use of Data Transfer Objects (DTOs) in the OMGAPI package to represent API contracts, with repositories responsible for mapping DTOs to domain models or persistence models.

### [ADR-013: Repository Caching and Streaming Patterns](ADR-013-repository-caching-and-streaming-patterns.md)
Stream-based caching pattern where repositories use AsyncStream to coordinate automatic data synchronization between network and SwiftData persistence layers.

## UI/UX Patterns

### [ADR-014: SwiftUI-First UI Development](ADR-014-swiftui-first-ui-development.md)
Pure SwiftUI approach for all UI development with no AppKit or UIKit usage, leveraging the DesignSystem package for shared components and consistent styling.

### [ADR-015: Context Menu Sharing Patterns](ADR-015-context-menu-sharing-patterns.md)
Standardized context menu structure for content items using native ShareLink for external sharing, with consistent ordering of edit, copy, share, and delete actions.

### [ADR-016: SwiftUI Previews with Mother Objects](ADR-016-swiftui-previews-with-mother-objects.md)
Use of Mother Object pattern for creating reusable test fixtures that support SwiftUI Previews across 90% of views, enabling rapid UI development with realistic data.

## Contributing

When making significant architectural decisions:

1. Create a new ADR using the next available number
2. Follow the established format
3. Link to related ADRs
4. Update this README with the new ADR

## Status Definitions

- **Proposed:** Decision under consideration
- **Accepted:** Decision is approved and implemented
- **Deprecated:** No longer recommended but not yet removed
- **Superseded:** Replaced by another ADR (link to replacement)
