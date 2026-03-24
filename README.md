# qwordfilter
A Lua library for detecting and filtering forbidden words from quick engine

✨ **Core Features**  
- **High Performance** 
- **Low Memory Footprint**
- **Zero Memory Overhead with qxtable/qstable**

# usages:
```lua 
-- Load from array
local word_list = {"word1", "word2"}
qwordfilter.load(word_list)

-- Load from configuration (using qxtable/qstable for zero memory footprint)
local forbidden_set = qxtable.find("forbidden_words")
qwordfilter.set(forbidden_set)

local text = "Check special char, forbidden word A word1, forbidden word B word2"

-- Check if contains special characters
local has_special = qwordfilter.contains_special_char(text)
assert(has_special == true)

-- Check if contains forbidden words (quick check)
local has_forbidden = qwordfilter.check_forbidden_word(text)
assert(has_forbidden == true)

-- Check and get list of forbidden words found
local found_words = {}
local found = qwordfilter.check_forbidden_word(text, found_words)
assert(found == true)
assert(#found_words == 2)
assert(found_words[1] == "word1")
assert(found_words[2] == "word2")

-- Replace forbidden words with custom placeholder
local cleaned_text = qwordfilter.replace_forbidden_word(text, "***")
assert(cleaned_text == "Check special char, forbidden word A ***, forbidden word B ***")

```
