local pairs = pairs
local string_byte = string.byte
local string_sub = string.sub
local string_gsub = string.gsub
local tinsert = table.insert
local tremove = table.remove

local forbidden_words = {}
local words_size = {}

local _M = {}

-- Load forbidden words from array
function _M.load(words)
    forbidden_words = {}
    for _,word in pairs(words) do
        forbidden_words[word] = 1
    end
end

-- Set forbidden words collection directly
-- Recommended to use qxtable/qstable for zero memory footprint
function _M.set(words_set)
    forbidden_words = words_set
end

local function init_words_len()
    for i=1,127 do
        words_size[i] = 1
    end
    for i=192,222 do
        words_size[i] = 2
    end
    for i=224,239 do
        words_size[i] = 3
    end
    for i=240,247 do
        words_size[i] = 4
    end
end

init_words_len()

local function split_words(str)
    local str_len = #str
    local result = {}
    local pos = 1
    while pos <= str_len do
        local b = string_byte(str, pos)
        local char_len = words_size[b] or 1
        local end_pos = pos + char_len - 1
        if end_pos > str_len then
            end_pos = str_len
        end
        result[#result+1] = string_sub(str, pos, end_pos)
        pos = pos + char_len
    end
    return result
end

function _M.contains_special_char(str)
    local words = split_words(str)
    for _,word in pairs(words) do
        if #word == 1 then
            local b = string_byte(word, 1)
            local valid = (b >= 48 and b <= 57) or (b >= 65 and b <= 90) or (b >= 97 and b <= 122) --0-9 A-Z a-z
            if not valid then
                return true
            end
        end
    end
    return false
end

function _M.check_forbidden_word(str, ret_words)
    local len = #str
    if len <= 0 then
        return false
    end
    local words = split_words(str)
    local contains = false
    for i=1,#words do
        local start_word = words[i]
        local cur_word = start_word
        if forbidden_words[cur_word] then
            if ret_words then
                contains = true
                tinsert(ret_words, cur_word)
            else
                return true
            end
        end
        for j=i+1,#words do
            cur_word = cur_word .. words[j]
            if forbidden_words[cur_word] then
                if ret_words then
                    contains = true
                    tinsert(ret_words, cur_word)
                else
                    return true
                end
            end
        end
    end
    if ret_words then
        for i=#ret_words,1,-1 do
            if ret_words[i] == ret_words[i-1] then
                tremove(ret_words, i)
            end
        end
    end
    return contains
end

function _M.replace_forbidden_word(str, rep)
    local words = {}
    if _M.check_forbidden_word(str, words) then
        for i=#words,1,-1 do
            str = string_gsub(str, words[i], rep or "***")
        end
    end
    return str
end

return _M