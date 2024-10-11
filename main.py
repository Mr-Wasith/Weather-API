import datetime as dt
import requests 

BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
API_KEY ="704bd5251017df351ddd36cabc695cff"

CITY = input("Which city do you want to know about: ");

def kelvin_to_celsius_fahrenheit(kelvin): 
    celsius = kelvin - 273.16
    fahrenheit = celsius * (9/5) + 32
    return celsius,fahrenheit

url = BASE_URL + "appid=" + API_KEY + "&q=" + CITY
response = requests.get(url).json()


temp_kelvin = response['main']['temp']
temp_celsius,temp_fahrenheit = kelvin_to_celsius_fahrenheit(temp_kelvin)
feels_like_kelvin = response['main']['feels_like']
feels_like_celsius,feels_like_fahrenheit = kelvin_to_celsius_fahrenheit(feels_like_kelvin)
local_time = response['timezone']
wind_speed = response['wind']['speed']
humidity = response['main']['humidity']
description = response['weather'][0]['description']
timezone_offset = response['timezone']
pressure = response['main']['pressure']
visibility = response.get('visibility', 'N/A')
cloudiness = response['clouds']['all']
rain = response.get('rain', {}).get('1h', 0)
snow = response.get('snow', {}).get('1h', 0) 
sunrise_time = dt.datetime.utcfromtimestamp(response['sys']['sunrise']+response['timezone'])
sunset_time = dt.datetime.utcfromtimestamp(response['sys']['sunset']+response['timezone'])
local_time = dt.datetime.now(dt.timezone(dt.timedelta(seconds=timezone_offset)))


print(f"Weather Information for {CITY}:\n")
print(f"Temperature in {CITY}: {temp_celsius:.2f}°C or {temp_fahrenheit:.2f}°F")
print(f"Temperature in {CITY} feels like: {feels_like_celsius:.2f}°C or {feels_like_fahrenheit:.2f}°F")
print(f"Local Time: {local_time.strftime('%Y-%m-%d %H:%M:%S')}")
print(f"Humidity in {CITY}: {humidity}%")
print(f"Wind Speed in {CITY}: {wind_speed} m/s")
print(f"General Weather in {CITY}: {description}")
print(f"Pressure in {CITY}: {pressure} hPa")
print(f"Visibility in {CITY}: {visibility/1000} km" if visibility != 'N/A' else "Visibility data not available")
print(f"Cloudiness in {CITY}: {cloudiness}%")
print(f"Rain volume in {CITY}: {rain} mm in the last hour")
print(f"Snow volume in {CITY}: {snow} mm in the last hour")
print(f"Sun rises in {CITY} at {sunrise_time} local time.")
print(f"Sun sets in {CITY} at {sunset_time} local time.")