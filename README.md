GUrl: URL Checking
==========

URL checker library for semi-trusted services that do not leak IPs (directly at least).


## Embedding in your addon

We recommend using GUrl via workshop dependency so the allowlist stays updated: https://steamcommunity.com/sharedfiles/filedetails/?id=3785250070

GUrl can also work as a standalone addon or as git submodule.

### Git submodule

```sh
cd myaddon
git submodule add https://github.com/Metastruct/gurl.git lua/myaddon/gurl
```

Then include from your code:
```lua
myaddon.gurl = include("myaddon/gurl/lua/gurl/gurl.lua")
```

*Remember to update submodule reference periodically!*

### gmod-packager (advanced)

**(not recommended, this will conflict if gurl is installed globally)**

Create `package.json`:
```json
{
  "name": "myaddon",
  "version": "1.0.0",
  "description": "My Garry's Mod addon",
  "dependencies": {
    "gurl": "git+https://github.com/Metastruct/gurl.git"
  },
  "devDependencies": {
    "gmod-packager": "git+https://github.com/Python1320/gmod-packager.git"
  },
  "scripts": {
    "postinstall": "gmod-packager"
  }
}
```

Then run `npm install` to trigger [gmod-packager](https://github.com/Python1320/gmod-packager) which builds into dist folder. See full example in: https://github.com/Metastruct/outfitter/

## API

### Global

```lua
_G.gurl -- the gurl module (set in addon/workshop mode by autorun/gurl.lua)
```

### `gurl.check_url(url) -> bool, string`

Checks a URL against the whitelist. Returns `true, reason` if allowed, `false, reason` if blocked.

```lua
local ok, reason = gurl.check_url("https://i.imgur.com/foo.png")
```

Runs the `CanAccessUrl` hook before checking the whitelist. If the hook returns `true` the URL is allowed immediately; if `false` it's blocked immediately.

### `gurl.check_url_easy(url) -> bool, string`

Like `check_url`, but also logs blocked URLs to `gurl.blocked_urls` and prints a chat message with `gurl_allow` instructions.

### `gurl.add_simple(domain)`

Adds a simple domain whitelist entry at runtime (e.g. `"example.com"` matches `example.com/anything`).

### `gurl.make_downloadable(url) -> string`

Converts hosting URLs (Google Drive, Dropbox, GitHub, GitLab, OneDrive, Pastebin) into direct-download URLs. Returns the converted URL.

```lua
local dl = gurl.make_downloadable("https://drive.google.com/file/d/abc123/view")
-- dl -> "https://drive.google.com/uc?export=download&id=abc123"
```

### `gurl.GetTable() -> { whitelist = {...}, blacklist = {...} }`

Returns the internal pattern tables for inspection.

### `gurl.blocked_urls`

Table of the last 100 blocked URLs (most recent first). Populated by `check_url_easy`.

### `gurl.TYPE_SIMPLE`, `gurl.TYPE_PATTERN`, `gurl.TYPE_BLACKLIST`

Constants (`1`, `2`, `3`) for use when editing `url_whitelist.lua` entries programmatically.

### Hooks

```
CanAccessUrl(url)
```
Return `true` to allow, `false` to block, or nil to fall through to the whitelist.

### Console commands

| Command | Description |
|---|---|---|
| `gurl_test <url>` | Tests a URL and prints result |
| `gurl_allow <domain>` | Adds a simple whitelist entry (strips protocol/path) |
| `gurl_dump` | Dumps all whitelist/blacklist patterns to console and `gurl.json` |

### Convars

| Convar | Default | Description |
|---|---|---|
| `gurl_print_blocked` | `0` | Print blocked URLs to console |

### Whitelist file format (`lua/gurl/url_whitelist.lua`)

The whitelist is defined using three functions:

- `simple("domain.com")` — matches `domain.com/anything`
- `pattern([[regex]])` — Lua pattern match on the full `host/path` string
- `blacklist("domain.com/path")` — blocks matching URLs

Patterns have `^` and `$` forced automatically.

## HELP US

[Help us make the  whitelist rules for all relatively safe services](https://github.com/Metastruct/gurl/edit/master/url_whitelist.lua)

If you believe something should or should not be in this list, make a pull request using the above link.
 
Coders: Help us code this thing and refine the system to better suit all external content features, either through pull requets or suggestions/issues


## License

This is free and unencumbered software released into the public domain. See LICENSE for details.


 
 
### Planned Features / TODO

 - Make detour system for HTTP()
   - Full URL parser to allow whitelisting
      - domain
      - subdomain
      - arbitrary regex
 - Whitelist pattern matching system
    - Whitelist itself of all possible services
 - Autoupdating?
 - Query dialog
   - NOTE: Aggregate list of URLs needed
   - "One or more network resources are being blocked for security reasons"
      - OK button / More info
   - Advanced button
      - Allow and remember this URL
      - Allow all
      - Disallow all
      - Notify of all URLs opened?
   - API
      - ```gurl/http . CanOpen("url")```
      - ```gurl/http . AskOpen("url",function(ok)  end)```
      
      