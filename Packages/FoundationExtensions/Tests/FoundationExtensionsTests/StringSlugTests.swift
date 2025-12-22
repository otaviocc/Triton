import Foundation
import Testing
@testable import FoundationExtensions

@Suite("StringSlug Tests")
struct StringSlugTests {

    @Test("It should convert simple string with space to slug format")
    func slugified_withSimpleString_returnsSlugFormat() {
        // Given
        let input = "Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should convert simple string with space to slug format"
        )
    }

    @Test("It should trim leading and trailing whitespace")
    func slugified_withLeadingTrailingWhitespace_trimsWhitespace() {
        // Given
        let input = "  multiple   spaces  "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "multiple-spaces",
            "It should trim leading and trailing whitespace"
        )
    }

    @Test("It should handle already slugged strings")
    func slugified_withAlreadySluggedString_returnsSameFormat() {
        // Given
        let input = "already-slugged"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "already-slugged",
            "It should handle already slugged strings"
        )
    }

    @Test("It should handle multiple consecutive spaces")
    func slugified_withMultipleSpaces_replacesWithSingleHyphen() {
        // Given
        let input = "multiple    spaces    here"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "multiple-spaces-here",
            "It should handle multiple consecutive spaces"
        )
    }

    @Test("It should handle tabs and newlines as whitespace")
    func slugified_withTabsAndNewlines_replacesWithHyphens() {
        // Given
        let input = "hello\tworld\nhere"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "hello-world-here",
            "It should handle tabs and newlines as whitespace"
        )
    }

    @Test("It should handle empty string")
    func slugified_withEmptyString_returnsEmptyString() {
        // Given
        let input = ""

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "",
            "It should handle empty string"
        )
    }

    @Test("It should handle string with only whitespace")
    func slugified_withOnlyWhitespace_returnsEmptyString() {
        // Given
        let input = "   \t\n   "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "",
            "It should handle string with only whitespace"
        )
    }

    @Test("It should handle single word")
    func slugified_withSingleWord_returnsWord() {
        // Given
        let input = "Hello"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello",
            "It should handle single word"
        )
    }

    @Test("It should preserve special characters in words")
    func slugified_withSpecialCharacters_preservesCharacters() {
        // Given
        let input = "test@email.com user123"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "test@email.com-user123",
            "It should preserve special characters in words"
        )
    }

    @Test("It should handle unicode characters")
    func slugified_withUnicodeCharacters_preservesUnicode() {
        // Given
        let input = "café naïve résumé"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "café-naïve-résumé",
            "It should handle unicode characters"
        )
    }

    @Test("It should handle emoji characters")
    func slugified_withEmojiCharacters_preservesEmoji() {
        // Given
        let input = "Hello 👋 World 🌟"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-👋-World-🌟",
            "It should handle emoji characters"
        )
    }

    @Test("It should handle mixed case strings")
    func slugified_withMixedCase_preservesCase() {
        // Given
        let input = "Hello World Test"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World-Test",
            "It should handle mixed case strings"
        )
    }

    @Test("It should handle string starting with whitespace")
    func slugified_withLeadingWhitespace_trimsLeadingWhitespace() {
        // Given
        let input = "   Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string starting with whitespace"
        )
    }

    @Test("It should handle string ending with whitespace")
    func slugified_withTrailingWhitespace_trimsTrailingWhitespace() {
        // Given
        let input = "Hello World   "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string ending with whitespace"
        )
    }

    @Test("It should handle string with single space")
    func slugified_withSingleSpace_replacesWithHyphen() {
        // Given
        let input = "Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string with single space"
        )
    }

    @Test("It should handle numbers in string")
    func slugified_withNumbers_preservesNumbers() {
        // Given
        let input = "test 123 456"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "test-123-456",
            "It should handle numbers in string"
        )
    }

    @Test("It should handle punctuation in words")
    func slugified_withPunctuation_preservesPunctuation() {
        // Given
        let input = "hello-world test.com"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "hello-world-test.com",
            "It should handle punctuation in words"
        )
    }
}
