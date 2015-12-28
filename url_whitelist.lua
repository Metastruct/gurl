local list = {}

local TYPE_SIMPLE=1
local TYPE_PATTERN=2

local function pattern(pattern)
  list[#list+1]={TYPE_PATTERN,pattern}
end
local function simple(txt)
  list[#list+1]={TYPE_SIMPLE,txt}
end


-- Dropbox
--- Examples: 
---  https://dl.dropboxusercontent.com/u/12345/abc123/abc123.bin
---  https://www.dropbox.com/s/abcd123/efg123.txt?dl=0
---  https://dl.dropboxusercontent.com/content_link/abc123/file?dl=1

simple [[www.dropbox.com/s/]]
simple [[https://dl.dropboxusercontent.com/]]

-- OneDrive
--- Examples: 
---  https://onedrive.live.com/redir?resid=123!178&authkey=!gweg&v=3&ithint=abcd%2cefg

simple [[onedrive.live.com/redir]]

-- Google Drive
--- Examples: 
---  https://docs.google.com/uc?export=download&confirm=UYyi&id=0BxUpZqVaDxVPeENDM1RtZDRvaTA

simple [[docs.google.com/uc]]

-- Imgur
--- Examples: 
---  http://i.imgur.com/abcd123.xxx

simple [[i.imgur.com/]]


-- Google
--- Examples: 
---  


-- box.com
--- Examples: 
---  


-- ImageShack
--- Examples: 
---  


-- Flickr
--- Examples: 
---  


-- pastebin
--- Examples: 
---  http://pastebin.com/abcdef

simple [[pastebin.com/]]

-- Twitter?
--- Examples: 
---  


-- Copy
--- Examples: 
---  


-- S3
--- UNSAFE?: Can hoster see the IP?
--- Examples: 
---  


-- github / gist
--- Examples: 
---  https://gist.githubusercontent.com/LUModder/f2b1c0c9bf98224f9679/raw/5644006aae8f0a8b930ac312324f46dd43839189/sh_sbdc.lua
---  https://raw.githubusercontent.com/LUModder/FWP/master/weapon_template.txt

simple [[raw.githubusercontent.com/]]
simple [[gist.githubusercontent.com/]]

-- bitbucket
--- Examples: 
---  


-- pomf
-- note: there are a lot of forks of pomf so there are tons of sites. I only listed the mainly used ones. --Flex
--- Examples: 
---  https://my.mixtape.moe/gxiznr.png
---  http://a.1339.cf/fppyhby.txt
---  http://b.1339.cf/fppyhby.txt
---  http://a.pomf.cat/jefjtb.txt

simple [[my.mixtape.moe/]]
simple [[a.1339.cf/]]
simple [[b.1339.cf/]]
simple [[a.pomf.cat/]]

-- TinyPic
--- Examples: 
---  


-- paste.ee
--- Examples: 
---  


-- hastebin
--- Examples: 
---  http://hastebin.com/icuvacogig.txt

simple [[hastebin.com/]]

return list
