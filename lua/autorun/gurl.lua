-- GMod URL whitelist and rewriter

if SERVER then AddCSLuaFile() end

_G.gurl = include("gurl/gurl.lua")

concommand.Add("gurl_test", function(pl, _, args)

  if SERVER and pl:IsValid() and not pl:IsSuperAdmin() then return end

  if not args[1] then
    print("usage: gurl_test <url>")
    return
  end
  local ok, reason = _G.gurl.check_url(args[1])
  if ok then
    print("gurl_test: " .. args[1] .. " -> ALLOWED (" .. reason .. ")")
  else
    print("gurl_test: " .. args[1] .. " -> BLOCKED (" .. reason .. ")")
  end
end, nil, "Tests if a URL is allowed by the gurl whitelist")

concommand.Add("gurl_dump", function(pl)

  if SERVER and pl:IsValid() and not pl:IsSuperAdmin() then return end

  local tbl = _G.gurl.GetTable()
  MsgC(Color(255, 200, 100), "--- gurl whitelist ---\n")
  for _, pat in ipairs(tbl.whitelist) do
    MsgC(Color(180, 255, 180), pat .. "\n")
  end
  MsgC(Color(255, 200, 100), "--- gurl blacklist ---\n")
  for _, pat in ipairs(tbl.blacklist) do
    MsgC(Color(255, 180, 180), pat .. "\n")
  end
  local json = util.TableToJSON(tbl, true)
  file.Write("gurl.json", json)
  MsgC(Color(200, 200, 255), "Dumped to gurl.json\n")
end, nil, "Dumps all whitelist and blacklist patterns")

concommand.Add("gurl_allow", function(pl, _, args)

  if SERVER and pl:IsValid() and not pl:IsSuperAdmin() then return end

  if not args[1] then
    print("usage: gurl_allow <domain or url>")
    return
  end
  local domain = string.match(args[1], "^%w-://(.+)") or args[1]
  domain = string.match(domain, "^([^/]+)") or domain
  _G.gurl.add_simple(domain)
  print("gurl: allowed " .. domain)
end, nil, "Adds a simple domain whitelist entry (strips protocol/path)")
