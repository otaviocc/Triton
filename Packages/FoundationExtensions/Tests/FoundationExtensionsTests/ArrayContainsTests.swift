import Testing
@testable import FoundationExtensions

@Suite("ArrayContains Tests")
struct ArrayContainsTests {

    @Test("It should return true when array contains element with matching substring")
    func containsPartial_withMatchingSubstring_returnsTrue() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when array contains element with matching substring"
        )
    }

    @Test("It should return true when multiple elements contain the partial string")
    func containsPartial_withMultipleMatches_returnsTrue() {
        // Given
        let array = ["application", "approach", "apple", "banana"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when multiple elements contain the partial string"
        )
    }

    @Test("It should return false when no elements contain the partial string")
    func containsPartial_withNoMatches_returnsFalse() {
        // Given
        let array = ["banana", "orange", "grape"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when no elements contain the partial string"
        )
    }

    @Test("It should return true when partial string matches case-insensitively")
    func containsPartial_withUppercasePartial_returnsTrue() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = "APP"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial string matches case-insensitively"
        )
    }

    @Test("It should return true with mixed case partial string")
    func containsPartial_withMixedCasePartial_returnsTrue() {
        // Given
        let array = ["application", "BANANA", "OrAnGe"]
        let partial = "aPp"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true with mixed case partial string"
        )
    }

    @Test("It should return true when array elements are uppercase but partial is lowercase")
    func containsPartial_withUppercaseArrayElements_returnsTrue() {
        // Given
        let array = ["APPLE", "BANANA", "ORANGE"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when array elements are uppercase but partial is lowercase"
        )
    }

    @Test("It should return false when array is empty")
    func containsPartial_withEmptyArray_returnsFalse() {
        // Given
        let array: [String] = []
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when array is empty"
        )
    }

    @Test("It should return false when partial string is empty (empty string matches nothing)")
    func containsPartial_withEmptyPartialString_returnsFalse() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = ""

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when partial string is empty (empty string matches nothing)"
        )
    }

    @Test("It should return false when both array and partial string are empty")
    func containsPartial_withEmptyArrayAndEmptyPartial_returnsFalse() {
        // Given
        let array: [String] = []
        let partial = ""

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when both array and partial string are empty"
        )
    }

    @Test("It should return false when array contains empty string and partial is empty (empty string matches nothing)")
    func containsPartial_withEmptyStringInArray_returnsFalse() {
        // Given
        let array = ["apple", "", "banana"]
        let partial = ""

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when array contains empty string and partial is empty (empty string matches nothing)"
        )
    }

    @Test(
        "It should return true when searching for non-empty partial in array with empty string (should match 'apple')"
    )
    func containsPartial_withSearchingInEmptyString_returnsFalse() {
        // Given
        let array = ["apple", "", "banana"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when searching for non-empty partial in array with empty string (should match 'apple')"
        )
    }

    @Test("It should return true when partial is whitespace and array contains strings with spaces")
    func containsPartial_withWhitespacePartial_returnsTrue() {
        // Given
        let array = ["hello world", "banana", "orange"]
        let partial = " "

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial is whitespace and array contains strings with spaces"
        )
    }

    @Test("It should return true when partial contains whitespace and matches substring with spaces")
    func containsPartial_withWhitespaceInPartial_returnsTrue() {
        // Given
        let array = ["hello world", "banana split", "orange juice"]
        let partial = "lo wo"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial contains whitespace and matches substring with spaces"
        )
    }

    @Test("It should return true when array element has trailing whitespace")
    func containsPartial_withTrailingWhitespace_returnsTrue() {
        // Given
        let array = ["apple ", "banana", "orange"]
        let partial = "apple"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when array element has trailing whitespace"
        )
    }

    @Test("It should return true when array element has leading whitespace")
    func containsPartial_withLeadingWhitespace_returnsTrue() {
        // Given
        let array = [" apple", "banana", "orange"]
        let partial = "apple"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when array element has leading whitespace"
        )
    }

    @Test("It should return true when partial contains special characters and matches")
    func containsPartial_withSpecialCharacters_returnsTrue() {
        // Given
        let array = ["test@email.com", "user123", "hello-world"]
        let partial = "@email"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial contains special characters and matches"
        )
    }

    @Test("It should return true when partial contains numbers and matches")
    func containsPartial_withNumbersInPartial_returnsTrue() {
        // Given
        let array = ["user123", "test456", "admin"]
        let partial = "123"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial contains numbers and matches"
        )
    }

    @Test("It should return true when partial contains unicode characters and matches")
    func containsPartial_withUnicodeCharacters_returnsTrue() {
        // Given
        let array = ["café", "naïve", "résumé"]
        let partial = "café"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial contains unicode characters and matches"
        )
    }

    @Test("It should return true when partial contains emoji and matches")
    func containsPartial_withEmojiCharacters_returnsTrue() {
        // Given
        let array = ["Hello 👋", "Good morning", "Have a nice day"]
        let partial = "👋"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial contains emoji and matches"
        )
    }

    @Test("It should return true when partial is single character and matches")
    func containsPartial_withSingleCharacterPartial_returnsTrue() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = "a"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial is single character and matches"
        )
    }

    @Test("It should return false when single character partial doesn't match any element")
    func containsPartial_withSingleCharacterNoMatch_returnsFalse() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = "z"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when single character partial doesn't match any element"
        )
    }

    @Test("It should return true when array contains single characters and partial matches")
    func containsPartial_withSingleCharacterArray_returnsTrue() {
        // Given
        let array = ["a", "b", "c"]
        let partial = "a"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when array contains single characters and partial matches"
        )
    }

    @Test("It should return true when partial exactly matches an array element")
    func containsPartial_withExactMatch_returnsTrue() {
        // Given
        let array = ["apple", "banana", "orange"]
        let partial = "apple"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial exactly matches an array element"
        )
    }

    @Test("It should return true when partial exactly matches with different case")
    func containsPartial_withExactMatchDifferentCase_returnsTrue() {
        // Given
        let array = ["Apple", "Banana", "Orange"]
        let partial = "APPLE"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial exactly matches with different case"
        )
    }

    @Test("It should return false when plain text doesn't match accented characters exactly")
    func containsPartial_withAccentedCharacters_returnsFalse() {
        // Given
        let array = ["café", "résumé", "naïve"]
        let partial = "cafe"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when plain text doesn't match accented characters exactly"
        )
    }

    @Test("It should return true when accented characters match exactly")
    func containsPartial_withMatchingAccentedCharacters_returnsTrue() {
        // Given
        let array = ["café", "résumé", "naïve"]
        let partial = "café"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when accented characters match exactly"
        )
    }

    @Test("It should return false when plain text doesn't match umlauts exactly")
    func containsPartial_withGermanUmlaut_returnsFalse() {
        // Given
        let array = ["Müller", "Straße", "Käse"]
        let partial = "muller"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when plain text doesn't match umlauts exactly"
        )
    }

    @Test("It should return true when umlauts match exactly")
    func containsPartial_withMatchingUmlaut_returnsTrue() {
        // Given
        let array = ["Müller", "Straße", "Käse"]
        let partial = "Müller"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when umlauts match exactly"
        )
    }

    @Test("It should return true when case-insensitive matching works with umlauts")
    func containsPartial_withCaseInsensitiveUmlaut_returnsTrue() {
        // Given
        let array = ["Müller", "Straße", "Käse"]
        let partial = "müller"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when case-insensitive matching works with umlauts"
        )
    }

    @Test("It should return true when searching in very long strings")
    func containsPartial_withVeryLongString_returnsTrue() {
        // Given
        let longString = String(repeating: "a", count: 1000) + "target" + String(repeating: "b", count: 1000)
        let array = [longString, "short", "medium"]
        let partial = "target"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when searching in very long strings"
        )
    }

    @Test("It should return false when partial string is longer than all array elements")
    func containsPartial_withPartialLongerThanElements_returnsFalse() {
        // Given
        let array = ["a", "bb", "ccc"]
        let partial = "longpartialstring"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            !result,
            "It should return false when partial string is longer than all array elements"
        )
    }

    @Test("It should return true when partial matches at the end of an element")
    func containsPartial_withSubstringAtEnd_returnsTrue() {
        // Given
        let array = ["something", "another", "endapp"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial matches at the end of an element"
        )
    }

    @Test("It should return true when partial matches in the middle of an element")
    func containsPartial_withSubstringInMiddle_returnsTrue() {
        // Given
        let array = ["something", "mapplication", "other"]
        let partial = "app"

        // When
        let result = array.containsPartial(partial)

        // Then
        #expect(
            result,
            "It should return true when partial matches in the middle of an element"
        )
    }
}
