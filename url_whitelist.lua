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
---  


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
---  


-- bitbucket
--- Examples: 
---  


-- pomf
--- Examples: 
---  


-- TinyPic
--- Examples: 
---  


-- paste.ee
--- Examples: 
---  


-- hastebin
--- Examples: 
---  

return list
