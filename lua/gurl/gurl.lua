AddCSLuaFile()
local TYPE_SIMPLE = 1
local _M = {
  TYPE_SIMPLE = TYPE_SIMPLE,
  TYPE_PATTERN = 2, --TODO rest of these
  TYPE_BLACKLIST = 3,
}
_M.blocked_urls = _G.gurl and _G.gurl.blocked_urls or {}

local whitelistPatterns = {}
local blacklistPatterns = {}
local gurl_print_blocked = CreateConVar("gurl_print_blocked", "0", {FCVAR_ARCHIVE}, "If enabled, prints blocked URLs to console")

local entries = include("gurl/url_whitelist.lua")
for _, entry in ipairs(entries) do
  local typ, txt = entry[1], entry[2]
  if typ == TYPE_SIMPLE then
    whitelistPatterns[#whitelistPatterns + 1] = "^" .. string.PatternSafe(txt) .. "/.*"
  elseif typ == 2 then --TODO rest of these
    whitelistPatterns[#whitelistPatterns + 1] = "^" .. txt .. "$"
  elseif typ == 3 then 
    blacklistPatterns[#blacklistPatterns + 1] = "^" .. string.PatternSafe(txt) .. ".*" -- TODO: make these into functions
  end
end

local sv_downloadurl = GetConVar("sv_downloadurl")

local host = (sv_downloadurl:GetString() or ""):match( "^%w-://([^/]+)")
if host then
  whitelistPatterns[#whitelistPatterns + 1] = "^" .. string.PatternSafe(host:lower()) .. "/.*"
end

---@param url string
---@return string
function _M.make_downloadable(url)
  -- Also maintained in https://raw.githubusercontent.com/CapsAdmin/pac3/refs/heads/develop/lua/pac3/core/shared/http.lua
  url = url:Trim()
  url = url:gsub("[\"'<>\n\\]+", "")

  if url:find("dropbox", 1, true) then
    url = url:gsub([[^http%://dl%.dropboxusercontent%.com/]], [[https://dl.dropboxusercontent.com/]])
    url = url:gsub([[^https?://dl.dropbox.com/]], [[https://www.dropbox.com/]])
    url = url:gsub([[^https?://www.dropbox.com/s/(.+)%?dl%=[01]$]], [[https://dl.dropboxusercontent.com/s/%1]])
    url = url:gsub([[^https?://www.dropbox.com/s/(.+)$]], [[https://dl.dropboxusercontent.com/s/%1]])
    url = url:gsub([[^https?://www.dropbox.com/scl/(.+)$]], [[https://dl.dropboxusercontent.com/scl/%1]])
    return url
  end

  if url:find("drive.google.com", 1, true) then
    local id =
        url:match("https://drive.google.com/file/d/(.-)/") or
        url:match("https://drive.google.com/file/d/(.-)$") or
        url:match("https://drive.google.com/open%?id=(.-)$") or
        url:match("https://drive.google.com/uc%?export=download&id=(.-)$") or
        url:match("https://drive.google.com/uc%?id=(.-)&export=download$")
    if id then
      if not url:find("export=download", 1, true) then
        return "https://drive.google.com/uc?export=download&id=" .. id
      end
    end
    return url
  end

  if url:find("gitlab.com", 1, true) then
    return url:gsub("^(https?://.-/.-/.-/)blob", "%1raw")
  end

  url = url:gsub([[^http%://onedrive%.live%.com/redir?]], [[https://onedrive.live.com/download?]])
  url = url:gsub("pastebin%.com/([a-zA-Z0-9]*)$", "pastebin.com/raw.php?i=%1")
  url = url:gsub("github%.com/([a-zA-Z0-9_]+)/([a-zA-Z0-9_]+)/blob/", "github.com/%1/%2/raw/")

  return url
end

---@param domain string
function _M.add_simple(domain)
  if type(domain) ~= "string" then return end
  local pat = "^" .. string.PatternSafe(domain) .. "/.*"
  whitelistPatterns[#whitelistPatterns + 1] = pat
end

---@param url string
---@return boolean ok
---@return string reason
function _M.check_url_easy(url)
  local ok, reason = _M.check_url(url)
  if not ok then
    local already = false
    for _, v in ipairs(_M.blocked_urls) do
      if v == url then already = true; break end
    end
    if not already then
      table.insert(_M.blocked_urls, 1, url)
      if #_M.blocked_urls > 100 then
        _M.blocked_urls[#_M.blocked_urls] = nil
      end
    end
    local domain = (string.match(url, "^%w-://(.+)") or url):match("^([^/]+)")
    if domain then
      chat.AddText(Color(255, 100, 100), "[gurl] Blocked: ", url, "  |  allow with: gurl_allow ", Color(255, 200, 100), domain)
    else
      chat.AddText(Color(255, 100, 100), "[gurl] Blocked: ", url)
    end
  end
  return ok, reason
end

---@return { whitelist: string[], blacklist: string[] }
function _M.GetTable()
  return {
    whitelist = whitelistPatterns,
    blacklist = blacklistPatterns,
  }
end

---@param url string
---@return boolean ok
---@return string reason
function _M.check_url(url)
  if type(url) ~= "string" then
    if gurl_print_blocked:GetBool() then Msg("[GURL Whitelist] Blocked ") end
    return false, "url is not a string"
  end

  if not string.match(url, "^(%w-)://") then
    url = "http://" .. url
  end

  local hookResult = hook.Run("CanAccessUrl", url)
  if hookResult == true then return true, "allowed by hook"
  elseif hookResult == false then
    if gurl_print_blocked:GetBool() then Msg("[GURL Whitelist] Blocked ") print(url) end
    return false, "blocked by hook"
  end

  local _, _, _, site, data = string.find(url, "^(%w-)://([^/]*)/?(.*)")
  if not site then
    if gurl_print_blocked:GetBool() then Msg("[GURL Whitelist] Blocked ") print(url) end
    return false, "malformed url"
  end
  site = site:lower() .. "/" .. (data or "")

  for _, pat in ipairs(blacklistPatterns) do
    if string.match(site, pat) then
      if gurl_print_blocked:GetBool() then Msg("[GURL Whitelist] Blocked ") print(url) end
      return false, "blacklisted"
    end
  end

  for _, pat in ipairs(whitelistPatterns) do
    if string.match(site, pat) then
      return true, "allowed by whitelist"
    end
  end

  if gurl_print_blocked:GetBool() then
    Msg("[GURL Whitelist] Blocked ")
    print(url)
  end
  return false, "not whitelisted"
end


return _M
