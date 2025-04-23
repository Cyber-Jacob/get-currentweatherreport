function Get-CurrentWeatherReport {
    param (
        [Parameter(Mandatory)]
        [string]$OpenWeatherApiKey
    )

    # Get current IP info; ipinfo returns lat and long associated with IP addresses. 
    $ipinfo = Invoke-RestMethod 'https://ipinfo.io'
    if (-not $ipinfo.loc) {
        throw "Unable to obtain location from ipinfo.io."
    }

    # This logic takes the location data from Ipinfo.io and splits it into an array, calling latitude and longitude from their oridnal positions.
    $locData  = $ipinfo.loc -split ','
    $latitude = $locData[0]
    $longitude = $locData[1]

    # Call OpenWeatherMap with extracted lat and long coords.
    $weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$OpenWeatherApiKey"
    $weatherResponse = Invoke-RestMethod $weatherUrl

    # Get the relevant weather data from the openweathermap api response.
    $main = $weatherResponse.main
    if (-not $main) {
        throw "No 'main' object found in weather API response."
    }

    # Convert values from Kelvin to fahrenheit (American dev, sorry) and Pascals to Bar. 
    $K_To_F = { param($k) return [math]::Round((($k * 9/5) - 459.67),2) }
    $hPa_To_Bar = { param($hPa) return [math]::Round(($hPa / 1000),4) }

    $tempF = & $K_To_F $main.temp
    $feelsLikeF = & $K_To_F $main.feels_like
    $tempMinF = & $K_To_F $main.temp_min
    $pressureBar = & $hPa_To_Bar $main.pressure

    # Formatted output to a PSCustomObject because P$. 

    [PSCustomObject]@{
        Location         = "$($ipinfo.city), $($ipinfo.region), $($ipinfo.country)"
        Coords           = "$latitude, $longitude"
        Temperature_F    = $tempF
        FeelsLike_F      = $feelsLikeF
        TempMin_F        = $tempMinF
        Pressure_Bar     = $pressureBar
        Humidity_Percent = $main.humidity
        Weather_Summary  = ($weatherResponse.weather[0].description -join ', ')
        Source_IP        = $ipinfo.ip
    }
}

# Usage:
# $report = Get-CurrentWeatherReport -OpenWeatherApiKey 'YOUR_API_KEY'
# $report | Format-List
