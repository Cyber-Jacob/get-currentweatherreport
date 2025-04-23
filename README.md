# Get-CurrentWeatherReport

This powershell module is intended to use the Invoke-RestMethod command to string together a couple of different OpenAPIs to get the current weather report for your locale based on your publicly available WAN ip. Sometimes you may be curious about the weather from my current VPN endpoint, and it is useful when communicating with remote worker peers. The formatting of PSObjects is satisfying to work with, and it is nice to simply have your current weather report available from the terminal.

## Usage
`Get-CurrentWeatherReport -OpenWeatherApiKey $apikey` is the base usage.

As a Powershell user, the best use of this command is more akin to this:

`$weatherreport = Get-CurrentWeatherReport -OpenWeatherApiKey $apikey`
and from here we can do more powershell object oriented things like `$weatherreport.Weather_Summary` or `$weatherreport.FeelsLike_F`. 

I won't oversell it; this is a fairly barebones module. 

## Authentication
An OpenWeatherMap.org api key is required, so there is an authentication component. The free version grants access to:

- 3 hour forceast for 5 days API
- Current weather report API
- Air pollution API 
- Geocoding API

