GUrl
==========

Make client IPs private again by whitelisting URLs that do not leak IPs.


 
 
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
      
      
### URLs

 - 
