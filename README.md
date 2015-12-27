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
      
      
### HELP US

[Help us make the  whitelist rules for all relatively safe services](https://github.com/Metastruct/gurl/edit/master/url_whitelist.lua)

If you believe something should or should not be in this list, make a pull request using the above link.
 
Coders: Help us code this thing and refine the system to better suit all external content features, either through pull requets or suggestions/issues
