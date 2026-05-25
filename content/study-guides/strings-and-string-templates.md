---
title: "Strings and String Templates"
slug: "strings-and-string-templates"
date: 2026-05-24
weight: 1
tags:
  - kotlin
  - strings
  - beginner
summary: "A beginner-friendly Kotlin tutorial for strings, string templates, useful methods, and LeetCode easy practice problems."
---

Audience: beginner Kotlin developer with some Android experience.

Goal: understand Kotlin strings from basic syntax to common algorithm patterns used in interviews and LeetCode easy problems.

## 1. Why Strings Matter

In Android, strings show up everywhere:

- UI text from `TextView`, `EditText`, `Button`, and Compose `Text`.
- User input validation.
- API responses and JSON fields.
- File paths, URLs, dates, and identifiers.
- Search, filtering, formatting, and display logic.

In Kotlin, a `String` is a sequence of characters. You can read from it, search it, split it, transform it, and build new strings from it. But strings are immutable, which means once a `String` is created, its content cannot be changed.

```kotlin
fun main() {
    val name = "kotlin"
    val upper = name.uppercase()

    println(name)  // kotlin
    println(upper) // KOTLIN
}
```

`uppercase()` does not modify `name`. It returns a new string.

This is important for performance and for algorithm problems. If you repeatedly create new strings inside a loop, it can become expensive. For heavy string building, use `StringBuilder`.

## 2. Creating Strings

The simplest string is written with double quotes:

```kotlin
val language = "Kotlin"
val message = "Hello"
```

What happens: both variables store string values. `language` stores six characters, and `message` stores five characters. Because they are declared with `val`, you cannot assign a different string to those variables later.

Kotlin also has nullable strings:

```kotlin
val title: String = "Profile"
val subtitle: String? = null
```

What happens: `title` must always contain a real `String`, while `subtitle` is allowed to contain either a `String` or `null`. The `?` after `String` is Kotlin's way of saying "this value may be missing."

You can only call regular string methods directly on non-null strings:

```kotlin
val text: String? = "hello"

println(text?.uppercase()) // HELLO
println(text ?: "fallback") // hello
```

What happens: `text?.uppercase()` calls `uppercase()` only if `text` is not null. The Elvis operator `?:` returns `"fallback"` only when `text` is null, so this example prints the original `"hello"` value.

Useful null-handling patterns:

```kotlin
val input: String? = null

val safeText = input.orEmpty()
val displayText = input ?: "No text"
val length = input?.length ?: 0
```

What happens: because `input` is null, `orEmpty()` returns an empty string, the Elvis expression returns `"No text"`, and the safe length expression returns `0`. These patterns are common when converting optional API or UI input into safe display values.

`orEmpty()` is useful in Android UI code when a nullable string should become `""`.

## 3. Escaped Strings

Escaped strings use double quotes and allow escape sequences.

```kotlin
val line = "Hello\nWorld"
println(line)
```

What happens: `\n` is interpreted as a newline character inside the string. The string still comes from one Kotlin literal, but when printed it appears on two lines.

Output:

```text
Hello
World
```

Common escape sequences:

- `\n` creates a new line.
- `\t` creates a tab.
- `\"` inserts a double quote.
- `\\` inserts a backslash.
- `\$` inserts a dollar sign in a regular escaped string.

Example:

```kotlin
val quote = "She said, \"Kotlin is fun.\""
val path = "C:\\Users\\Demo"
val price = "Total: \$9.99"
```

What happens: `\"` keeps the quote inside the string instead of ending it, `\\` stores a single backslash character, and `\$` stores a literal dollar sign instead of starting a string template.

## 4. Raw Multiline Strings

Raw strings use triple quotes:

```kotlin
val json = """
    {
      "name": "Kotlin",
      "type": "language"
    }
"""
```

What happens: the triple-quoted string stores the line breaks and indentation exactly as written. This is convenient for text that would be awkward to write with many `\n` and `\"` escape sequences.

Raw strings can span multiple lines and do not use normal backslash escaping. This is helpful for JSON samples, SQL, regular expressions, and long UI messages.

Use `trimIndent()` to remove common indentation:

```kotlin
val json = """
    {
      "name": "Kotlin",
      "type": "language"
    }
""".trimIndent()

println(json)
```

What happens: `trimIndent()` looks at the common indentation shared by the non-blank lines and removes it. The JSON remains multiline, but it no longer includes the extra spaces caused by indenting the Kotlin code.

Output:

```json
{
  "name": "Kotlin",
  "type": "language"
}
```

Use `trimMargin()` when you want to mark the real start of each line:

```kotlin
val text = """
    |First line
    |Second line
    |Third line
""".trimMargin()
```

What happens: `trimMargin()` removes everything before and including the `|` margin marker on each line. This lets you align the raw string nicely in your source file without putting those spaces in the final text.

You can choose a custom margin prefix:

```kotlin
val text = """
    #Title
    #Body
""".trimMargin("#")
```

What happens: this is the same idea as the previous example, but `#` is used as the margin marker instead of the default `|`.

To place a literal dollar sign inside a raw string, use `${'$'}`:

```kotlin
val price = """
    Price: ${'$'}9.99
""".trimIndent()
```

What happens: raw strings do not use `\$` for escaping, so `${'$'}` inserts the dollar character through a string template expression.

## 5. String Templates

String templates let you insert values into strings.

Use `$name` for a simple variable:

```kotlin
val name = "Asha"
val greeting = "Hello, $name"

println(greeting) // Hello, Asha
```

What happens: `$name` is replaced with the value stored in `name`, so the final string becomes `"Hello, Asha"`.

Use `${expression}` for an expression:

```kotlin
val name = "Asha"
val message = "Your name has ${name.length} characters"

println(message) // Your name has 4 characters
```

What happens: Kotlin evaluates `name.length` first, gets `4`, and inserts that result into the string.

String templates work with any expression:

```kotlin
val unreadCount = 5
val status = "You have ${if (unreadCount == 0) "no" else unreadCount} unread messages"

println(status) // You have 5 unread messages
```

What happens: the `if` expression runs inside `${...}`. Since `unreadCount` is `5`, the expression returns `5`, and that value is inserted into the message.

They also call `toString()` automatically:

```kotlin
data class User(val id: Int, val name: String)

val user = User(1, "Maya")
println("Loaded user: $user")
// Loaded user: User(id=1, name=Maya)
```

What happens: `$user` becomes `user.toString()`. Data classes generate a useful `toString()` automatically, which is why the printed value includes the property names and values.

### When to Use Braces

Use braces when:

- You need an expression.
- The variable name touches other text.
- You want clarity.

```kotlin
val item = "book"

println("One $item")       // One book
println("Many ${item}s")   // Many books
```

What happens: `$item` works when the variable name is clearly separated from the surrounding text. `${item}` is needed before `s` so Kotlin knows the variable is `item`, not `items`.

Without braces, Kotlin would look for a variable named `items`.

### Templates vs `String.format()`

String templates are best when you are inserting values directly:

```kotlin
val name = "Maya"
val score = 95

println("$name scored $score points")
```

What happens: both `$name` and `$score` are replaced with their values. This is the most readable choice when you do not need special number formatting.

`String.format()` is useful when you need formatted numbers, fixed decimal places, or old-style placeholder formatting:

```kotlin
val price = 9.5

println(String.format("%.2f", price)) // 9.50
println(String.format("%S", "hello")) // HELLO
```

What happens: `%.2f` formats the number with exactly two digits after the decimal point, and `%S` formats the string argument in uppercase.

For Android/JVM code, use an explicit locale when formatting user-visible numbers:

```kotlin
import java.util.Locale

val priceText = String.format(Locale.US, "%.2f", price)
```

What happens: `Locale.US` tells the formatter which locale rules to use. This avoids surprises from device locales that use different decimal separators or casing rules.

### Android Example

In real Android apps, prefer string resources for user-facing text because they support localization.

For quick debugging, templates are fine:

```kotlin
Log.d("Profile", "Loaded userId=$userId, name=$name")
```

What happens: the log message is assembled with the current `userId` and `name` values. This is useful for debugging because the message is not user-facing and does not need localization.

For UI text, prefer:

```kotlin
// strings.xml:
// <string name="welcome_user">Welcome, %1$s</string>

val text = context.getString(R.string.welcome_user, name)
```

What happens: Android loads the localized string resource and replaces `%1$s` with `name`. This keeps user-visible text translatable.

String templates are still very useful for internal logs, tests, algorithm practice, and non-localized messages.

## 6. Reading Basic String Information

### `length`

Returns the number of UTF-16 code units in the string.

```kotlin
val s = "Kotlin"
println(s.length) // 6
```

What happens: Kotlin counts the string's stored character units and returns `6`. For ordinary English letters, this matches the number of visible characters.

For normal English letters, this feels like "number of characters." For some emoji and combined Unicode characters, `length` may not equal what a user visually sees.

```kotlin
val emoji = "😀"
println(emoji.length) // Usually 2, because it uses a surrogate pair
```

What happens: this emoji is stored internally as two UTF-16 code units, so `length` reports `2` even though a user sees one emoji. This matters in UI text, but most beginner algorithm problems avoid this complexity.

For most LeetCode easy problems, input usually uses ASCII lowercase or uppercase letters, so `length` works as expected.

### `isEmpty()` and `isNotEmpty()`

```kotlin
val s = ""

println(s.isEmpty())    // true
println(s.isNotEmpty()) // false
```

What happens: `s` contains no characters, so `isEmpty()` is true. Since there are no characters, `isNotEmpty()` is false.

Empty means length is `0`.

### `isBlank()` and `isNotBlank()`

```kotlin
val s = "   \n\t"

println(s.isBlank())    // true
println(s.isNotBlank()) // false
```

What happens: the string contains whitespace characters, but no visible non-whitespace text. That makes it blank even though it is not technically empty.

Blank means the string is empty or contains only whitespace.

Common validation:

```kotlin
fun isValidName(name: String): Boolean {
    return name.isNotBlank()
}
```

What happens: this function accepts names that contain at least one non-whitespace character and rejects `""`, `"   "`, and similar inputs.

## 7. Accessing Characters

Strings can be indexed like arrays.

```kotlin
val s = "Kotlin"

println(s[0]) // K
println(s[1]) // o
println(s[5]) // n
```

What happens: bracket access reads the character at a specific index. `s[0]` returns the first character, and `s[5]` returns the last character in `"Kotlin"`.

Kotlin uses zero-based indexing:

- First character is at index `0`.
- Last character is at index `s.length - 1`.

Useful properties:

```kotlin
val s = "Kotlin"

println(s.indices)   // 0..5
println(s.lastIndex) // 5
```

What happens: `indices` gives the valid index range for the string, and `lastIndex` gives the final valid position. These are safer than hardcoding numbers.

Loop over characters:

```kotlin
for (ch in "Kotlin") {
    println(ch)
}
```

What happens: the loop visits each character from left to right. On each iteration, `ch` holds the current character.

Loop over indices:

```kotlin
val s = "Kotlin"

for (i in s.indices) {
    println("index=$i char=${s[i]}")
}
```

What happens: the loop visits each valid index. This is useful when you need both the position `i` and the character `s[i]`.

Loop backward:

```kotlin
val s = "Kotlin"

for (i in s.lastIndex downTo 0) {
    print(s[i])
}
// niltoK
```

What happens: `downTo` creates a decreasing range from the last index to `0`. Reading characters in that order prints the string backward.

### `first()`, `last()`, `single()`

```kotlin
val s = "abc"

println(s.first()) // a
println(s.last())  // c
```

What happens: `first()` returns the character at index `0`, and `last()` returns the character at `lastIndex`.

`single()` expects exactly one character:

```kotlin
println("x".single()) // x
```

What happens: `"x"` has exactly one character, so `single()` can safely return it.

Be careful:

```kotlin
// "".first() throws NoSuchElementException
// "ab".single() throws IllegalArgumentException
```

What happens: these calls fail because the method requirements are not met. An empty string has no first character, and `"ab"` has more than one character.

Use safe variants:

```kotlin
println("".firstOrNull()) // null
println("".lastOrNull())  // null
```

What happens: the `OrNull` versions return `null` instead of throwing when the string does not contain a matching character.

## 8. Comparing Strings

### `==`

In Kotlin, `==` checks structural equality. For strings, that means same text.

```kotlin
val a = "hello"
val b = "he" + "llo"

println(a == b) // true
```

What happens: Kotlin compares the text content of `a` and `b`, not whether they are the same object in memory. Both contain `"hello"`, so the result is true.

### `equals()`

Use `equals()` when you need case-insensitive comparison:

```kotlin
val answer = "Yes"

println(answer.equals("yes", ignoreCase = true)) // true
```

What happens: `ignoreCase = true` makes `Y` and `y` count as equal, so `"Yes"` matches `"yes"`.

### `compareTo()`

`compareTo()` compares lexicographically, like dictionary order.

```kotlin
println("apple".compareTo("banana")) // negative
println("cat".compareTo("cat"))      // 0
println("dog".compareTo("cat"))      // positive
```

What happens: `compareTo()` returns a negative number when the left string sorts before the right string, `0` when they are equal, and a positive number when it sorts after.

It can also ignore case:

```kotlin
println("abc".compareTo("ABC", ignoreCase = true)) // 0
```

What happens: ignoring case makes `"abc"` and `"ABC"` compare as equal, so the result is `0`.

This is useful for sorting:

```kotlin
val names = listOf("Zoe", "anna", "Bob")
println(names.sorted())
println(names.sortedWith(String.CASE_INSENSITIVE_ORDER))
```

What happens: `sorted()` uses the default ordering, where uppercase and lowercase can affect order. `CASE_INSENSITIVE_ORDER` sorts by text while ignoring letter case.

## 9. Searching Inside Strings

### `contains()`

```kotlin
val text = "Android Kotlin"

println(text.contains("Kotlin")) // true
println(text.contains("XML"))    // false
```

What happens: `contains()` scans the string for the requested text. It finds `"Kotlin"` inside `"Android Kotlin"`, but it does not find `"XML"`.

Case-insensitive:

```kotlin
println(text.contains("kotlin", ignoreCase = true)) // true
```

What happens: `ignoreCase = true` allows lowercase `"kotlin"` to match uppercase `K` in `"Kotlin"`.

You can also use the `in` operator:

```kotlin
println("Kotlin" in text) // true
```

What happens: `"Kotlin" in text` is a readable operator form of `text.contains("Kotlin")`.

### `startsWith()` and `endsWith()`

```kotlin
val file = "photo.png"

println(file.startsWith("photo")) // true
println(file.endsWith(".png"))    // true
```

What happens: `startsWith()` checks the beginning of the string, while `endsWith()` checks the end. This is useful for prefixes, file extensions, and URL checks.

Case-insensitive:

```kotlin
println("README.MD".endsWith(".md", ignoreCase = true)) // true
```

What happens: the file name ends with `.MD`, and the comparison treats `.MD` and `.md` as the same.

### `indexOf()` and `lastIndexOf()`

`indexOf()` returns the first index where a character or substring appears. If not found, it returns `-1`.

```kotlin
val s = "banana"

println(s.indexOf('a'))      // 1
println(s.indexOf("na"))     // 2
println(s.indexOf('x'))      // -1
println(s.lastIndexOf('a'))  // 5
```

What happens: `indexOf()` returns where the first match begins, while `lastIndexOf()` searches from the end. `-1` means the character or substring was not found.

You can start searching from a specific index:

```kotlin
val s = "banana"

println(s.indexOf('a', startIndex = 2)) // 3
```

What happens: Kotlin skips indexes before `2`, so it ignores the `'a'` at index `1` and finds the next one at index `3`.

Common pattern:

```kotlin
val email = "user@example.com"
val atIndex = email.indexOf('@')

if (atIndex != -1) {
    println("Domain starts at ${atIndex + 1}")
}
```

What happens: the code first checks whether `@` exists. If it does, the domain begins one position after the `@` character.

### `find()` and `findLast()`

Find the first or last character matching a condition:

```kotlin
val s = "abc123"

println(s.find { it.isDigit() })     // 1
println(s.findLast { it.isLetter() }) // c
```

What happens: `find()` returns the first character that passes the condition, and `findLast()` returns the last one. Here the first digit is `'1'`, and the last letter is `'c'`.

They return `Char?`, so the result may be null.

## 10. Extracting Parts of a String

### `substring()`

```kotlin
val s = "Kotlin"

println(s.substring(0, 3)) // Kot
println(s.substring(3))    // lin
```

What happens: `substring(0, 3)` takes characters from index `0` up to but not including index `3`. `substring(3)` starts at index `3` and keeps everything to the end.

The end index is exclusive:

```text
substring(startIndex, endIndex)
includes startIndex, excludes endIndex
```

For `"Kotlin"`:

```text
K o t l i n
0 1 2 3 4 5
```

`s.substring(0, 3)` returns characters at indices `0`, `1`, and `2`.

### `substringBefore()` and `substringAfter()`

These are great for parsing simple text:

```kotlin
val email = "user@example.com"

println(email.substringBefore("@")) // user
println(email.substringAfter("@"))  // example.com
```

What happens: Kotlin finds the `@` delimiter. `substringBefore("@")` returns everything to the left of it, and `substringAfter("@")` returns everything to the right.

If the delimiter is not found:

```kotlin
val text = "username"

println(text.substringBefore("@")) // username
println(text.substringAfter("@"))  // username
```

What happens: because `@` is missing, both methods return the original string by default. This is useful to know because missing delimiters do not automatically throw an error.

You can provide a fallback:

```kotlin
println(text.substringAfter("@", missingDelimiterValue = "no-domain"))
```

What happens: if `@` is missing, Kotlin returns `"no-domain"` instead of returning the original string.

Useful related methods:

```kotlin
val path = "/users/photos/profile.png"

println(path.substringBeforeLast("/")) // /users/photos
println(path.substringAfterLast("/"))  // profile.png
```

What happens: these methods use the last `/`, not the first one. That makes them useful for path-like strings where the final segment has special meaning.

### `take()`, `takeLast()`, `drop()`, `dropLast()`

```kotlin
val s = "Kotlin"

println(s.take(3))     // Kot
println(s.takeLast(3)) // lin
println(s.drop(3))     // lin
println(s.dropLast(3)) // Kot
```

What happens: `take` keeps characters, while `drop` removes characters. The `Last` versions work from the right side of the string.

These are often easier to read than `substring()`.

### `takeWhile()` and `dropWhile()`

```kotlin
val s = "123abc456"

println(s.takeWhile { it.isDigit() }) // 123
println(s.dropWhile { it.isDigit() }) // abc456
```

What happens: both methods scan from the start. `takeWhile` keeps the leading digits, while `dropWhile` removes the leading digits and returns the rest.

## 11. Changing and Cleaning Strings

Remember: these return new strings.

### `uppercase()` and `lowercase()`

```kotlin
val s = "Kotlin"

println(s.uppercase()) // KOTLIN
println(s.lowercase()) // kotlin
```

What happens: Kotlin creates uppercase and lowercase copies. The original `s` still contains `"Kotlin"`.

For Android/JVM code where locale matters, use an explicit locale:

```kotlin
import java.util.Locale

val normalized = "TITLE".lowercase(Locale.ROOT)
```

What happens: `Locale.ROOT` applies stable, language-neutral casing rules. This is a good default when normalizing values for comparison or storage.

This helps avoid language-specific casing surprises.

### `replace()`

Replace all occurrences:

```kotlin
val s = "banana"

println(s.replace("na", "NA")) // baNANA
println(s.replace('a', 'o'))   // bonono
```

What happens: `replace("na", "NA")` changes every `"na"` substring, and `replace('a', 'o')` changes every `'a'` character. Both return new strings.

Case-insensitive:

```kotlin
println("Hello HELLO".replace("hello", "hi", ignoreCase = true))
// hi hi
```

What happens: both `"Hello"` and `"HELLO"` match because case is ignored, so both are replaced with `"hi"`.

### `replaceFirst()`

```kotlin
val s = "one one one"

println(s.replaceFirst("one", "two")) // two one one
```

What happens: only the first `"one"` is replaced. Later occurrences are left unchanged.

### `replaceRange()`

```kotlin
val phone = "1234567890"
val masked = phone.replaceRange(3, 7, "****")

println(masked) // 123****890
```

What happens: Kotlin removes the characters from index `3` up to but not including index `7`, then inserts `"****"` at that position. In `"1234567890"`, the removed part is `"4567"`.

### `removePrefix()`, `removeSuffix()`, `removeSurrounding()`

```kotlin
val url = "https://example.com"
println(url.removePrefix("https://")) // example.com

val file = "image.png"
println(file.removeSuffix(".png")) // image

val quoted = "\"hello\""
println(quoted.removeSurrounding("\"")) // hello
```

What happens: `removePrefix()` removes the beginning only if it matches, `removeSuffix()` removes the ending only if it matches, and `removeSurrounding()` removes matching text from both sides.

These only remove text if it exists.

### `trim()`, `trimStart()`, `trimEnd()`

```kotlin
val input = "   hello   "

println(input.trim())      // hello
println(input.trimStart()) // hello   
println(input.trimEnd())   //    hello
```

What happens: `trim()` removes whitespace from both sides, `trimStart()` removes only the left side, and `trimEnd()` removes only the right side. Spaces in the middle would stay.

You can trim specific characters:

```kotlin
val path = "/users/"

println(path.trim('/')) // users
```

What happens: `trim('/')` removes `/` characters from the beginning and end. It does not remove characters from the middle.

Or use a predicate:

```kotlin
val text = "***Important***"

println(text.trim { it == '*' }) // Important
```

What happens: Kotlin removes characters from both ends while the predicate is true. It stops trimming when it reaches `I` on the left and `t` on the right.

### `padStart()` and `padEnd()`

```kotlin
val number = "42"

println(number.padStart(5, '0')) // 00042
println(number.padEnd(5, '.'))   // 42...
```

What happens: `padStart()` adds characters to the left until the string reaches length `5`, and `padEnd()` adds characters to the right.

Useful for formatting IDs, timers, and fixed-width output.

### `repeat()`

```kotlin
println("ha".repeat(3)) // hahaha
```

What happens: `repeat(3)` concatenates the original string three times.

### `reversed()`

```kotlin
println("abc".reversed()) // cba
```

What happens: `reversed()` returns a new string with the characters in the opposite order.

Useful for palindrome checks.

## 12. Splitting and Joining

### `split()`

```kotlin
val csv = "red,green,blue"
val colors = csv.split(",")

println(colors) // [red, green, blue]
```

What happens: Kotlin cuts the string wherever it sees `,` and returns the pieces as a `List<String>`.

Kotlin's `split()` can accept multiple delimiters:

```kotlin
val text = "one,two;three four"
val words = text.split(",", ";", " ")

println(words) // [one, two, three, four]
```

What happens: Kotlin treats comma, semicolon, and space as separators. Each separator creates a boundary between words.

Limit the number of parts:

```kotlin
val pair = "key=value=extra"
println(pair.split("=", limit = 2)) // [key, value=extra]
```

What happens: `limit = 2` allows only two final pieces. Kotlin splits at the first `=`, then keeps the rest together as `"value=extra"`.

Ignore case:

```kotlin
val text = "aXbxb"
println(text.split("x", ignoreCase = true)) // [a, b, b]
```

What happens: both `X` and `x` are treated as delimiters because case is ignored.

Remove empty results:

```kotlin
val text = "a,,b,"
println(text.split(","))
// [a, , b, ]

println(text.split(",").filter { it.isNotEmpty() })
// [a, b]
```

What happens: splitting `"a,,b,"` creates empty strings where delimiters are adjacent or trailing. Filtering with `isNotEmpty()` removes those empty pieces.

When simple input may contain repeated spaces, split first and then remove empty pieces:

```kotlin
val input = "one   two   three"
val words = input.split(" ").filter { it.isNotEmpty() }

println(words) // [one, two, three]
```

What happens: `split(" ")` creates empty pieces for repeated spaces. The `filter` call removes them, leaving only real words.

### `lines()` and `lineSequence()`

```kotlin
val text = """
    first
    second
    third
""".trimIndent()

println(text.lines()) // [first, second, third]
```

What happens: `lines()` breaks the multiline string at line boundaries and returns each line as a list item.

`lineSequence()` is useful for large text because it can process lazily:

```kotlin
val count = text.lineSequence()
    .filter { it.isNotBlank() }
    .count()
```

What happens: `lineSequence()` walks through the lines lazily, `filter` keeps non-blank lines, and `count()` counts how many remain.

### `joinToString()`

`joinToString()` is a collection method, but it is used constantly with strings.

```kotlin
val words = listOf("Kotlin", "is", "fun")
val sentence = words.joinToString(" ")

println(sentence) // Kotlin is fun
```

What happens: `joinToString(" ")` places a space between each list item and combines them into one string.

Customize prefix, suffix, and transform:

```kotlin
val names = listOf("asha", "maya", "ravi")

val display = names.joinToString(
    separator = ", ",
    prefix = "[",
    suffix = "]"
) { it.replaceFirstChar { ch -> ch.uppercase() } }

println(display) // [Asha, Maya, Ravi]
```

What happens: each name is transformed before joining, the names are separated by `", "`, and the final result is wrapped with `[` and `]`.

## 13. Character Checks

Kotlin has useful `Char` methods:

```kotlin
val ch = 'A'

println(ch.isLetter())      // true
println(ch.isDigit())       // false
println(ch.isLetterOrDigit()) // true
println(ch.isWhitespace())  // false
println(ch.isUpperCase())   // true
println(ch.isLowerCase())   // false
println(ch.lowercaseChar()) // a
```

What happens: each method asks a question about the character. `lowercaseChar()` returns a lowercase copy of the character instead of changing `ch`.

These are important in string algorithms.

Example: keep only letters and digits.

```kotlin
fun clean(input: String): String {
    return input
        .filter { it.isLetterOrDigit() }
        .lowercase()
}

println(clean("A man, a plan, a canal: Panama"))
// amanaplanacanalpanama
```

What happens: `filter` keeps only letters and digits, then `lowercase()` normalizes the remaining text. Punctuation, spaces, and case differences disappear.

## 14. Strings as Collections of Characters

Because a string is a `CharSequence`, many collection-like operations work.

### `forEach()`

```kotlin
"abc".forEach { ch ->
    println(ch)
}
```

What happens: `forEach` runs the lambda once for every character. The variable `ch` is the current character during each run.

### `count()`

```kotlin
val digits = "a1b2c3".count { it.isDigit() }
println(digits) // 3
```

What happens: `count` checks each character with `isDigit()` and returns how many characters passed the check.

### `any()`, `all()`, `none()`

```kotlin
val password = "abc123"

println(password.any { it.isDigit() }) // true
println(password.all { it.isLetterOrDigit() }) // true
println(password.none { it.isWhitespace() }) // true
```

What happens: `any` asks whether at least one character matches, `all` asks whether every character matches, and `none` asks whether zero characters match.

### `filter()`

```kotlin
val onlyDigits = "a1b2c3".filter { it.isDigit() }
println(onlyDigits) // 123
```

What happens: `filter` keeps only the characters where `isDigit()` returns true. For strings, the result is another string.

### `map()`

`map()` returns a `List`, not a `String`.

```kotlin
val codes = "abc".map { it.code }
println(codes) // [97, 98, 99]
```

What happens: `map` converts each character to its Unicode code point value. Because `map` transforms items, the result is a list of integers, not a string.

To make a string again:

```kotlin
val shifted = "abc"
    .map { ch -> ch + 1 }
    .joinToString("")

println(shifted) // bcd
```

What happens: each character is shifted forward by one (`'a'` to `'b'`, `'b'` to `'c'`, and so on). `joinToString("")` combines the transformed characters without separators.

For simple transformations, `map` plus `joinToString("")` is fine. In performance-sensitive loops, use `StringBuilder`.

### `chunked()`

```kotlin
val card = "1234567812345678"
println(card.chunked(4)) // [1234, 5678, 1234, 5678]
```

What happens: `chunked(4)` groups the string into pieces of four characters each.

With transform:

```kotlin
val groups = card.chunked(4)
val hidden = groups.mapIndexed { index, group ->
    if (index == groups.lastIndex) group else "****"
}.joinToString(" ")

println(hidden) // **** **** **** 5678
```

What happens: the card number is first split into groups. `mapIndexed` replaces every group except the last one with `"****"`, then `joinToString(" ")` adds spaces between groups.

### `windowed()`

`windowed()` gives sliding windows.

```kotlin
val s = "abcd"

println(s.windowed(2)) // [ab, bc, cd]
println(s.windowed(3)) // [abc, bcd]
```

What happens: `windowed()` creates overlapping slices. With size `2`, Kotlin reads `"ab"`, then moves one character and reads `"bc"`, then `"cd"`.

Useful for substring pattern problems.

## 15. Parsing Strings to Numbers

Common conversions:

```kotlin
val age = "25".toInt()
val price = "12.50".toDouble()
val count = "100".toLong()
```

What happens: Kotlin parses the text into numeric types. After conversion, `age` is an `Int`, `price` is a `Double`, and `count` is a `Long`.

These throw an exception if the string is invalid:

```kotlin
// "abc".toInt() throws NumberFormatException
```

What happens: `"abc"` cannot be interpreted as an integer, so `toInt()` would fail at runtime.

Prefer safe conversions for user input:

```kotlin
val input = "abc"
val number = input.toIntOrNull()

if (number == null) {
    println("Invalid number")
}
```

What happens: `toIntOrNull()` returns `null` instead of throwing when parsing fails. The `if` block handles that invalid-input case.

Useful safe conversions:

- `toIntOrNull()`
- `toLongOrNull()`
- `toDoubleOrNull()`
- `toFloatOrNull()`
- `toBooleanStrictOrNull()`

Boolean examples:

```kotlin
println("true".toBoolean()) // true
println("TRUE".toBoolean()) // true
println("yes".toBoolean())  // false

println("true".toBooleanStrictOrNull()) // true
println("TRUE".toBooleanStrictOrNull()) // null
```

What happens: `toBoolean()` is lenient about case for `"true"`, while `toBooleanStrictOrNull()` accepts only exactly `"true"` or `"false"`.

## 16. Other Advanced String Helpers

These do not appear in every beginner tutorial, but they are useful once you start writing parsing and formatting code.

`replaceBefore()` and `replaceAfter()`:

```kotlin
val url = "https://example.com/users/42"

println(url.replaceBefore("://", "scheme")) // scheme://example.com/users/42
println(url.replaceAfter("/users/", "id"))  // https://example.com/users/id
```

What happens: `replaceBefore("://", "scheme")` replaces everything before the delimiter and keeps the delimiter plus the rest. `replaceAfter("/users/", "id")` keeps everything through `/users/` and replaces the text after it.

`replaceBeforeLast()` and `replaceAfterLast()`:

```kotlin
val path = "/storage/photos/image.png"

println(path.replaceBeforeLast("/", "...")) // .../image.png
println(path.replaceAfterLast(".", "jpg"))  // /storage/photos/image.jpg
```

What happens: these methods use the last matching delimiter. The first call hides the parent path before the final `/`, and the second call changes the extension after the final `.`.

`removeRange()`:

```kotlin
val phone = "123-456-7890"

println(phone.removeRange(3, 4)) // 123456-7890
```

What happens: `removeRange(3, 4)` removes characters starting at index `3` and stopping before index `4`. In this string, that one-character range is the first hyphen, so the result becomes `"123456-7890"`.

`commonPrefixWith()` and `commonSuffixWith()`:

```kotlin
println("flower".commonPrefixWith("flow")) // flow
println("reading.kt".commonSuffixWith("writing.kt")) // ing.kt
```

What happens: `commonPrefixWith()` compares from the start until the strings differ. `commonSuffixWith()` compares from the end until they differ.

`regionMatches()` checks whether a region of one string matches a region of another:

```kotlin
val a = "AndroidKotlin"
val b = "kotlin"

println(a.regionMatches(7, b, 0, 6, ignoreCase = true)) // true
```

What happens: Kotlin compares six characters starting at index `7` in `a` with six characters starting at index `0` in `b`. With case ignored, `"Kotlin"` matches `"kotlin"`.

## 17. Building Strings Efficiently

For a few values, string templates are perfect:

```kotlin
val message = "User $userId loaded in ${timeMs}ms"
```

What happens: the values of `userId` and `timeMs` are inserted into the final message. This is ideal for short strings built from a few values.

For repeated appending in a loop, use `StringBuilder`:

```kotlin
fun repeatLetters(n: Int): String {
    val builder = StringBuilder()

    for (i in 0 until n) {
        builder.append(('a' + (i % 26)))
    }

    return builder.toString()
}

println(repeatLetters(5)) // abcde
```

What happens: the builder starts empty, then appends one calculated letter per loop iteration. At the end, `toString()` converts the builder into the final string.

Why not this?

```kotlin
var result = ""
for (i in 0 until 10000) {
    result += "a"
}
```

What happens: each `+=` can allocate a new string containing the old content plus `"a"`. Repeating that many times wastes work.

Each `+=` can create a new string. `StringBuilder` avoids repeatedly copying everything.

Kotlin also has `buildString`:

```kotlin
val result = buildString {
    append("Hello")
    append(", ")
    append("Kotlin")
}

println(result) // Hello, Kotlin
```

What happens: `buildString` creates a temporary `StringBuilder` for the block. Each `append` adds text, and the block returns the finished string.

This is clean and idiomatic when constructing a string in one block.

## 18. Useful String Method Checklist

Use this section as a quick review.

Basic info:

- `length`: number of UTF-16 code units.
- `indices`: valid index range.
- `lastIndex`: last valid index.
- `isEmpty()`: true if length is 0.
- `isNotEmpty()`: true if length is greater than 0.
- `isBlank()`: true if empty or only whitespace.
- `isNotBlank()`: true if at least one non-whitespace character.
- `orEmpty()`: converts nullable string to `""` if null.

Access:

- `s[index]`: character at index.
- `get(index)`: same idea as bracket access.
- `first()`, `firstOrNull()`: first character.
- `last()`, `lastOrNull()`: last character.
- `single()`, `singleOrNull()`: only character if exactly one.

Comparison:

- `==`: content equality.
- `equals(other, ignoreCase = true)`: equality with optional case-insensitivity.
- `compareTo(other)`: lexicographic comparison.
- `compareTo(other, ignoreCase = true)`: case-insensitive comparison.

Search:

- `contains(value)`: checks if character or substring exists.
- `"x" in text`: operator form of contains.
- `startsWith(prefix)`: checks prefix.
- `endsWith(suffix)`: checks suffix.
- `indexOf(value)`: first index or `-1`.
- `lastIndexOf(value)`: last index or `-1`.
- `find { condition }`: first matching character.
- `findLast { condition }`: last matching character.

Extract:

- `substring(startIndex)`: from start index to end.
- `substring(startIndex, endIndex)`: start inclusive, end exclusive.
- `substringBefore(delimiter)`: text before delimiter.
- `substringAfter(delimiter)`: text after delimiter.
- `substringBeforeLast(delimiter)`: text before last delimiter.
- `substringAfterLast(delimiter)`: text after last delimiter.
- `take(n)`: first `n` characters.
- `takeLast(n)`: last `n` characters.
- `drop(n)`: remove first `n` characters.
- `dropLast(n)`: remove last `n` characters.
- `takeWhile { condition }`: take characters while condition is true.
- `dropWhile { condition }`: drop characters while condition is true.

Clean and transform:

- `trim()`: remove leading and trailing whitespace.
- `trimStart()`: remove leading whitespace.
- `trimEnd()`: remove trailing whitespace.
- `trimIndent()`: clean indentation in raw strings.
- `trimMargin()`: clean raw strings using a margin prefix.
- `uppercase()`: uppercase copy.
- `lowercase()`: lowercase copy.
- `replace(old, new)`: replace all matches.
- `replaceFirst(old, new)`: replace first match.
- `replaceRange(start, end, replacement)`: replace part by index range.
- `replaceBefore(delimiter, replacement)`: replace text before a delimiter.
- `replaceAfter(delimiter, replacement)`: replace text after a delimiter.
- `replaceBeforeLast(delimiter, replacement)`: replace text before the last delimiter.
- `replaceAfterLast(delimiter, replacement)`: replace text after the last delimiter.
- `removePrefix(prefix)`: remove prefix if present.
- `removeSuffix(suffix)`: remove suffix if present.
- `removeSurrounding(delimiter)`: remove same delimiter from both sides.
- `removeSurrounding(prefix, suffix)`: remove matching prefix and suffix.
- `removeRange(start, end)`: remove part by index range.
- `padStart(length, char)`: pad left.
- `padEnd(length, char)`: pad right.
- `repeat(n)`: repeat string.
- `reversed()`: reverse string.
- `replaceFirstChar { ... }`: transform the first character.
- `commonPrefixWith(other)`: common starting text.
- `commonSuffixWith(other)`: common ending text.
- `regionMatches(...)`: compare a specific region of two strings.
- `String.format(...)`: format values with placeholders.

Split and lines:

- `split(delimiter)`: split into list.
- `split(delimiter1, delimiter2, ...)`: split by multiple delimiters.
- `lines()`: split text into lines.
- `lineSequence()`: lazily process lines.

Collection-style operations:

- `forEach { ... }`: visit each character.
- `count { ... }`: count matching characters.
- `any { ... }`: at least one match.
- `all { ... }`: all match.
- `none { ... }`: none match.
- `filter { ... }`: keep matching characters and return a string.
- `map { ... }`: transform characters and return a list.
- `chunked(size)`: split into chunks.
- `windowed(size)`: sliding windows.

Parsing:

- `toInt()`, `toLong()`, `toDouble()`, `toFloat()`: parse or throw.
- `toIntOrNull()`, `toLongOrNull()`, `toDoubleOrNull()`, `toFloatOrNull()`: parse safely.
- `toBoolean()`: true only for `"true"` ignoring case.
- `toBooleanStrictOrNull()`: safe strict boolean parsing.

Byte and char conversion:

- `toCharArray()`: convert to `CharArray`.
- `encodeToByteArray()`: convert to bytes using UTF-8.
- `decodeToString()`: convert bytes back to string.

## 19. Connecting Methods to Algorithm Patterns

Many easy string problems are built from a few patterns.

### Pattern 1: Two Pointers

Use when checking from both ends.

Examples:

- Palindrome check.
- Reverse vowels.
- Compare strings from left and right.

Basic shape:

```kotlin
var left = 0
var right = s.lastIndex

while (left < right) {
    val a = s[left]
    val b = s[right]

    left++
    right--
}
```

What happens: `left` starts at the beginning and `right` starts at the end. Each loop compares or uses both sides, then moves the pointers toward the middle.

### Pattern 2: Frequency Counting

Use when comparing character counts.

Examples:

- Valid anagram.
- First unique character.
- Ransom note.

For lowercase English letters, use `IntArray(26)`:

```kotlin
val counts = IntArray(26)

for (ch in s) {
    counts[ch - 'a']++
}
```

What happens: `ch - 'a'` converts a lowercase letter into an array index. For example, `'a' - 'a'` is `0`, `'b' - 'a'` is `1`, and so on.

For general characters, use a map:

```kotlin
val counts = mutableMapOf<Char, Int>()

for (ch in s) {
    counts[ch] = counts.getOrDefault(ch, 0) + 1
}
```

What happens: the map stores each character as a key and its count as the value. `getOrDefault(ch, 0)` handles characters that are being seen for the first time.

### Pattern 3: Normalize Then Compare

Use when punctuation, spaces, or case should not matter.

```kotlin
val normalized = s
    .filter { it.isLetterOrDigit() }
    .lowercase()
```

What happens: the string is cleaned by removing punctuation and spaces, then normalized to lowercase so case differences do not affect comparison.

Then compare:

```kotlin
normalized == normalized.reversed()
```

What happens: this checks whether the cleaned string is the same forward and backward.

### Pattern 4: Scan Once

Use when you only need to remember a small amount of state.

Examples:

- Longest common prefix.
- Add binary strings.
- Detect repeated adjacent characters.

```kotlin
for (i in s.indices) {
    val ch = s[i]
    // update state
}
```

What happens: the loop reads each character exactly once. You update whatever state the problem needs, such as a count, a previous character, or a running answer.

### Pattern 5: Build an Answer

Use `StringBuilder` when constructing the result in a loop.

```kotlin
val builder = StringBuilder()

for (ch in s) {
    if (ch.isLetter()) {
        builder.append(ch)
    }
}

return builder.toString()
```

What happens: matching characters are appended one by one. The builder avoids creating a new string after every append.

## 20. Worked Examples

### Example 1: Valid Palindrome

Problem: return true if a string is a palindrome after ignoring non-alphanumeric characters and case.

Input:

```text
"A man, a plan, a canal: Panama"
```

Output:

```text
true
```

Simple solution:

```kotlin
fun isPalindrome(s: String): Boolean {
    val cleaned = s
        .filter { it.isLetterOrDigit() }
        .lowercase()

    return cleaned == cleaned.reversed()
}
```

What happens: the function removes punctuation and spaces, converts the remaining text to lowercase, then compares it with its reversed version.

This is easy to read. It creates extra strings, which is fine for learning.

Two-pointer solution:

```kotlin
fun isPalindrome(s: String): Boolean {
    var left = 0
    var right = s.lastIndex

    while (left < right) {
        while (left < right && !s[left].isLetterOrDigit()) {
            left++
        }

        while (left < right && !s[right].isLetterOrDigit()) {
            right--
        }

        if (s[left].lowercaseChar() != s[right].lowercaseChar()) {
            return false
        }

        left++
        right--
    }

    return true
}
```

What happens: the outer loop continues until the pointers meet. The inner loops skip punctuation and spaces, and the comparison checks the lowercase versions of the two meaningful characters.

Why this is better for interviews:

- It does not build a cleaned copy.
- It uses constant extra space.
- It shows control over indices.

### Example 2: Valid Anagram

Problem: return true if two strings contain the same letters with the same counts.

```kotlin
fun isAnagram(s: String, t: String): Boolean {
    if (s.length != t.length) return false

    val counts = IntArray(26)

    for (ch in s) {
        counts[ch - 'a']++
    }

    for (ch in t) {
        counts[ch - 'a']--
    }

    return counts.all { it == 0 }
}
```

What happens: the first loop adds counts for `s`, and the second loop subtracts counts for `t`. If the strings are anagrams, every count returns to zero.

This assumes lowercase English letters. If the input can contain any character, use a map:

```kotlin
fun isAnagramAnyChars(s: String, t: String): Boolean {
    if (s.length != t.length) return false

    val counts = mutableMapOf<Char, Int>()

    for (ch in s) {
        counts[ch] = counts.getOrDefault(ch, 0) + 1
    }

    for (ch in t) {
        counts[ch] = counts.getOrDefault(ch, 0) - 1
    }

    return counts.values.all { it == 0 }
}
```

What happens: this version counts any `Char`, not just lowercase English letters. The same add-then-subtract idea is used, but a map replaces the fixed 26-slot array.

### Example 3: First Unique Character

Problem: return the index of the first character that appears once. If none exists, return `-1`.

```kotlin
fun firstUniqChar(s: String): Int {
    val counts = IntArray(26)

    for (ch in s) {
        counts[ch - 'a']++
    }

    for (i in s.indices) {
        if (counts[s[i] - 'a'] == 1) {
            return i
        }
    }

    return -1
}
```

What happens: the first pass counts every character. The second pass returns the first index whose character count is `1`; if no such character exists, the function returns `-1`.

Input:

```text
"leetcode"
```

Output:

```text
0
```

Input:

```text
"loveleetcode"
```

Output:

```text
2
```

### Example 4: Longest Common Prefix

Problem: given an array of strings, return the longest prefix common to all strings.

```kotlin
fun longestCommonPrefix(strs: Array<String>): String {
    if (strs.isEmpty()) return ""

    var prefix = strs[0]

    for (i in 1 until strs.size) {
        while (!strs[i].startsWith(prefix)) {
            prefix = prefix.dropLast(1)

            if (prefix.isEmpty()) return ""
        }
    }

    return prefix
}
```

What happens: the first string starts as the candidate prefix. For each later string, the prefix is shortened until that string starts with it.

Example:

```kotlin
println(longestCommonPrefix(arrayOf("flower", "flow", "flight")))
// fl
```

What happens: `"flower"` is shortened to `"flow"` for the second word, then shortened again to `"fl"` for `"flight"`.

This uses:

- `startsWith()`
- `dropLast()`
- `isEmpty()`

### Example 5: Add Binary

Problem: add two binary strings and return the sum as a binary string.

```kotlin
fun addBinary(a: String, b: String): String {
    var i = a.lastIndex
    var j = b.lastIndex
    var carry = 0
    val result = StringBuilder()

    while (i >= 0 || j >= 0 || carry > 0) {
        val bitA = if (i >= 0) a[i] - '0' else 0
        val bitB = if (j >= 0) b[j] - '0' else 0

        val sum = bitA + bitB + carry
        result.append(sum % 2)
        carry = sum / 2

        i--
        j--
    }

    return result.reverse().toString()
}
```

What happens: the function adds bits from right to left, tracks carry just like manual addition, appends result bits in reverse order, then reverses the builder at the end.

Example:

```kotlin
println(addBinary("11", "1")) // 100
```

What happens: binary `11` is decimal `3`, and binary `1` is decimal `1`. Their sum is decimal `4`, which is binary `100`.

This uses:

- `lastIndex`
- index access
- character-to-digit conversion with `ch - '0'`
- `StringBuilder`
- reverse at the end

## 21. LeetCode Easy Practice Problems

These problems are good after learning Kotlin strings. Try solving each first, then compare with the hints.

### 1. Valid Palindrome

https://leetcode.com/problems/valid-palindrome/description/

Skills:

- `isLetterOrDigit()`
- `lowercaseChar()`
- two pointers
- `filter()`
- `reversed()`

Beginner approach:

```kotlin
fun isPalindrome(s: String): Boolean {
    val cleaned = s.filter { it.isLetterOrDigit() }.lowercase()
    return cleaned == cleaned.reversed()
}
```

What happens: non-alphanumeric characters are removed, the remaining text is lowercased, and the function checks whether the cleaned text equals its reverse.

Challenge: rewrite with two pointers and no extra cleaned string.

### 2. Valid Anagram

https://leetcode.com/problems/valid-anagram/description/

Skills:

- frequency array
- looping over characters
- `ch - 'a'`
- `all { it == 0 }`

Hint:

```kotlin
val counts = IntArray(26)
```

What happens: this creates 26 integer slots, one for each lowercase English letter from `a` to `z`.

Increment for characters in `s`, decrement for characters in `t`.

### 3. First Unique Character in a String

https://leetcode.com/problems/first-unique-character-in-a-string/description/

Skills:

- frequency counting
- `indices`
- array lookup

Hint:

First pass counts characters. Second pass finds the first index with count `1`.

### 4. Ransom Note

https://leetcode.com/problems/ransom-note/description/

Problem: can you build `ransomNote` using letters from `magazine`?

Skills:

- frequency counting
- early return

Hint:

Count letters in `magazine`, then consume letters from `ransomNote`.

```kotlin
fun canConstruct(ransomNote: String, magazine: String): Boolean {
    val counts = IntArray(26)

    for (ch in magazine) {
        counts[ch - 'a']++
    }

    for (ch in ransomNote) {
        val index = ch - 'a'
        counts[index]--

        if (counts[index] < 0) {
            return false
        }
    }

    return true
}
```

What happens: the magazine loop records available letters. The ransom-note loop spends those letters; if any count drops below zero, the note needs a letter that is not available.

### 5. Longest Common Prefix

https://leetcode.com/problems/longest-common-prefix/description/

Skills:

- `startsWith()`
- `dropLast()`
- arrays of strings

Hint:

Start with the first string as prefix. Keep shortening it until every string starts with it.

### 6. Add Binary

https://leetcode.com/problems/add-binary/description/

Skills:

- scan from the end
- carry
- `StringBuilder`
- `lastIndex`

Hint:

Work right to left, just like adding numbers by hand.

### 7. Reverse String

https://leetcode.com/problems/reverse-string/description/

Kotlin version often uses `CharArray`.

Skills:

- two pointers
- swapping
- `toCharArray()`

```kotlin
fun reverseString(s: CharArray): Unit {
    var left = 0
    var right = s.lastIndex

    while (left < right) {
        val temp = s[left]
        s[left] = s[right]
        s[right] = temp

        left++
        right--
    }
}
```

What happens: the function swaps the first and last characters, then moves inward and repeats. Because the input is a `CharArray`, the swaps modify the array in place.

Note: this problem uses `CharArray`, not `String`, because strings are immutable.

### 8. Reverse Vowels of a String

https://leetcode.com/problems/reverse-vowels-of-a-string/description/

Skills:

- two pointers
- `toCharArray()`
- `String(chars)`
- helper function

Hint:

Move `left` until it points to a vowel. Move `right` until it points to a vowel. Swap them.

```kotlin
fun reverseVowels(s: String): String {
    val chars = s.toCharArray()
    var left = 0
    var right = chars.lastIndex

    fun isVowel(ch: Char): Boolean {
        return ch.lowercaseChar() in setOf('a', 'e', 'i', 'o', 'u')
    }

    while (left < right) {
        while (left < right && !isVowel(chars[left])) left++
        while (left < right && !isVowel(chars[right])) right--

        val temp = chars[left]
        chars[left] = chars[right]
        chars[right] = temp

        left++
        right--
    }

    return String(chars)
}
```

What happens: the function converts the string to a mutable character array, swaps vowels from both ends, then creates a new string from the modified array.

Small improvement: avoid creating the vowel set on every helper call.

```kotlin
val vowels = setOf('a', 'e', 'i', 'o', 'u')
fun isVowel(ch: Char) = ch.lowercaseChar() in vowels
```

What happens: the set is created once, and the helper checks membership in that set. This avoids rebuilding the same set for every character check.

### 9. Length of Last Word

https://leetcode.com/problems/length-of-last-word/description/

Skills:

- `trimEnd()`
- scanning backward
- `split()`

Beginner approach:

```kotlin
fun lengthOfLastWord(s: String): Int {
    return s.trim()
        .split(" ")
        .filter { it.isNotEmpty() }
        .last()
        .length
}
```

What happens: the code trims outside spaces, splits on spaces, removes empty pieces, takes the last remaining word, and returns its length.

More efficient approach:

```kotlin
fun lengthOfLastWord(s: String): Int {
    var i = s.lastIndex

    while (i >= 0 && s[i] == ' ') {
        i--
    }

    var length = 0

    while (i >= 0 && s[i] != ' ') {
        length++
        i--
    }

    return length
}
```

What happens: the first loop skips trailing spaces. The second loop counts characters backward until it reaches the space before the last word.

### 10. Detect Capital

https://leetcode.com/problems/detect-capital/description/

Problem: return true if capitalization is valid:

- All letters uppercase: `"USA"`
- All letters lowercase: `"leetcode"`
- Only first letter uppercase: `"Google"`

Skills:

- `isUpperCase()`
- `isLowerCase()`
- `drop(1)`
- `all { ... }`

```kotlin
fun detectCapitalUse(word: String): Boolean {
    return word.all { it.isUpperCase() } ||
        word.all { it.isLowerCase() } ||
        (word.first().isUpperCase() && word.drop(1).all { it.isLowerCase() })
}
```

What happens: the function checks the three valid capitalization patterns directly: all uppercase, all lowercase, or first uppercase with the rest lowercase.

## 22. Mini Exercises

Try these before jumping into LeetCode.

### Exercise 1: Normalize a Username

Write a function that:

- trims spaces
- lowercases the username
- removes spaces inside it

Example:

```text
"  Kotlin User  " -> "kotlinuser"
```

Possible solution:

```kotlin
fun normalizeUsername(input: String): String {
    return input.trim()
        .lowercase()
        .filter { !it.isWhitespace() }
}
```

What happens: `trim()` removes outside whitespace, `lowercase()` normalizes case, and `filter` removes any remaining whitespace inside the username.

### Exercise 2: Mask an Email

Input:

```text
"alex@example.com"
```

Output:

```text
"a***@example.com"
```

Possible solution:

```kotlin
fun maskEmail(email: String): String {
    val name = email.substringBefore("@")
    val domain = email.substringAfter("@")

    if (name.isEmpty() || domain == email) return email

    return "${name.first()}***@$domain"
}
```

What happens: the function splits the email into the local name and domain, keeps the first character of the name, hides the rest with `***`, and then adds the domain back.

### Exercise 3: Count Vowels

```kotlin
fun countVowels(s: String): Int {
    val vowels = setOf('a', 'e', 'i', 'o', 'u')
    return s.count { it.lowercaseChar() in vowels }
}
```

What happens: each character is lowercased before checking the vowel set, so uppercase and lowercase vowels both count.

### Exercise 4: Convert Kebab Case to Title

Input:

```text
"kotlin-string-templates"
```

Output:

```text
"Kotlin String Templates"
```

Possible solution:

```kotlin
fun kebabToTitle(input: String): String {
    return input
        .split("-")
        .joinToString(" ") { word ->
            word.replaceFirstChar { it.uppercase() }
        }
}
```

What happens: the string is split at each hyphen, each word has its first character capitalized, and the words are joined back together with spaces.

### Exercise 5: Check Strong Password Basics

Rules:

- At least 8 characters.
- Has at least one uppercase letter.
- Has at least one lowercase letter.
- Has at least one digit.

```kotlin
fun isStrongPassword(password: String): Boolean {
    return password.length >= 8 &&
        password.any { it.isUpperCase() } &&
        password.any { it.isLowerCase() } &&
        password.any { it.isDigit() }
}
```

What happens: the function combines four boolean checks. The password must satisfy all of them because the checks are connected with `&&`.

## 23. Common Mistakes

### Mistake 1: Forgetting Strings Are Immutable

Wrong expectation:

```kotlin
val s = "hello"
s.uppercase()
println(s) // still hello
```

What happens: `uppercase()` returns a new string, but the code ignores that return value. The original `s` remains `"hello"`.

Correct:

```kotlin
val s = "hello"
val upper = s.uppercase()
println(upper) // HELLO
```

What happens: the uppercase result is stored in `upper`, so it can be printed or reused.

### Mistake 2: Using End Index Incorrectly

```kotlin
val s = "Kotlin"
println(s.substring(0, 3)) // Kot, not Kotl
```

What happens: index `3` is the stopping point, not an included character. Kotlin returns indexes `0`, `1`, and `2`.

The end index is exclusive.

### Mistake 3: Not Handling `indexOf()` Returning `-1`

```kotlin
val email = "username"
val index = email.indexOf("@")

if (index == -1) {
    println("Invalid email")
}
```

What happens: `indexOf("@")` returns `-1` when the delimiter is missing. The check prevents later code from treating `-1` like a real position.

Never assume a delimiter exists unless the problem guarantees it.

### Mistake 4: Forgetting That `split(" ")` Can Produce Empty Strings

```kotlin
val text = "one   two"
println(text.split(" ")) // [one, , , two]
```

What happens: every single space is treated as a separator. Repeated spaces create empty strings between the separators.

Prefer filtering empty pieces when repeated spaces are possible:

```kotlin
println(text.split(" ").filter { it.isNotEmpty() }) // [one, two]
```

What happens: the split still creates empty pieces, but `filter` removes them from the final list.

### Mistake 5: Ignoring Locale in App Code

For internal algorithm problems:

```kotlin
val normalized = input.lowercase()
```

What happens: this uses the default casing behavior. That is usually fine for coding practice, but app code may need more predictable locale handling.

For Android/JVM app code where stable behavior matters:

```kotlin
import java.util.Locale

val normalized = input.lowercase(Locale.ROOT)
```

What happens: `Locale.ROOT` makes the casing operation language-neutral and stable across devices.

### Mistake 6: Rebuilding Strings with `+=` in Large Loops

For small strings, it is fine. For repeated appending, prefer `StringBuilder` or `buildString`.

```kotlin
val result = buildString {
    for (ch in "abc") {
        append(ch.uppercaseChar())
    }
}
```

What happens: `buildString` collects all appended characters efficiently and returns one final string.

## 24. Suggested Learning Path

Follow this order:

1. Create simple strings and use string templates.
2. Practice `length`, `indices`, `lastIndex`, and `s[i]`.
3. Learn `contains`, `startsWith`, `endsWith`, `indexOf`.
4. Practice `substring`, `take`, `drop`, and `split`.
5. Use `trim`, `lowercase`, `uppercase`, and `replace`.
6. Use character checks like `isDigit()` and `isLetterOrDigit()`.
7. Solve mini exercises.
8. Solve LeetCode easy problems with frequency arrays and two pointers.

## 25. Quick Reference Examples

```kotlin
val s = "  Kotlin Strings  "

println(s.trim())                 // Kotlin Strings
println(s.lowercase())            //   kotlin strings
println(s.uppercase())            //   KOTLIN STRINGS
println(s.contains("lin"))        // true
println(s.indexOf("Strings"))     // 9
println(s.trim().split(" "))      // [Kotlin, Strings]
println(s.trim().substring(0, 6)) // Kotlin
println(s.trim().takeLast(7))     // Strings
println(s.trim().reversed())      // sgnirtS niltoK
```

What happens: each line applies one common string operation to the same base string. Notice that operations like `trim()` return a cleaned copy, so the later chained calls can use that cleaned copy without changing the original `s`.

String template recap:

```kotlin
val language = "Kotlin"
val year = 2011

println("$language was first released in $year")
println("${language.uppercase()} has ${language.length} letters")
```

What happens: the first line inserts two simple variables. The second line evaluates two expressions inside `${...}` before inserting their results.

Final mental model:

- A `String` is immutable text.
- You access characters with indices.
- Most methods return a new string.
- Templates make strings readable.
- `StringBuilder` helps when building in loops.
- LeetCode string problems usually combine indexing, character checks, frequency counts, and two pointers.
