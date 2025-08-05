import datetime as dt
import requests 

BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
API_KEY = "704bd5251017df351ddd36cabc695cff"

def kelvin_to_celsius_fahrenheit(kelvin): 
    celsius = kelvin - 273.15  # Fixed: should be 273.15, not 273.16
    fahrenheit = celsius * (9/5) + 32
    return celsius, fahrenheit

def get_weather_info():
    try:
        CITY = input("Which city do you want to know about: ")
        
        if not CITY.strip():
            print("Error: City name cannot be empty. Please enter a valid city name.")
            return
        
        url = BASE_URL + "appid=" + API_KEY + "&q=" + CITY
        
        # Make API request with timeout
        response = requests.get(url, timeout=10)
        
        # Check if the request was successful
        if response.status_code == 200:
            data = response.json()
            
            # Extract weather data
            temp_kelvin = data['main']['temp']
            temp_celsius, temp_fahrenheit = kelvin_to_celsius_fahrenheit(temp_kelvin)
            
            feels_like_kelvin = data['main']['feels_like']
            feels_like_celsius, feels_like_fahrenheit = kelvin_to_celsius_fahrenheit(feels_like_kelvin)
            
            wind_speed = data['wind']['speed']
            humidity = data['main']['humidity']
            description = data['weather'][0]['description']
            timezone_offset = data['timezone']
            pressure = data['main']['pressure']
            visibility = data.get('visibility', 'N/A')
            cloudiness = data['clouds']['all']
            rain = data.get('rain', {}).get('1h', 0)
            snow = data.get('snow', {}).get('1h', 0)
            
            sunrise_time = dt.datetime.utcfromtimestamp(data['sys']['sunrise'] + data['timezone'])
            sunset_time = dt.datetime.utcfromtimestamp(data['sys']['sunset'] + data['timezone'])
            local_time = dt.datetime.now(dt.timezone(dt.timedelta(seconds=timezone_offset)))
            
            # Display weather information
            print(f"\nWeather Information for {CITY}:\n")
            print(f"Temperature in {CITY}: {temp_celsius:.2f}°C or {temp_fahrenheit:.2f}°F")
            print(f"Temperature in {CITY} feels like: {feels_like_celsius:.2f}°C or {feels_like_fahrenheit:.2f}°F")
            print(f"Local Time: {local_time.strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"Humidity in {CITY}: {humidity}%")
            print(f"Wind Speed in {CITY}: {wind_speed} m/s")
            print(f"General Weather in {CITY}: {description}")
            print(f"Pressure in {CITY}: {pressure} hPa")
            
            if visibility != 'N/A':
                print(f"Visibility in {CITY}: {visibility/1000:.1f} km")
            else:
                print("Visibility data not available")
                
            print(f"Cloudiness in {CITY}: {cloudiness}%")
            print(f"Rain volume in {CITY}: {rain} mm in the last hour")
            print(f"Snow volume in {CITY}: {snow} mm in the last hour")
            print(f"Sun rises in {CITY} at {sunrise_time.strftime('%H:%M:%S')} local time")
            print(f"Sun sets in {CITY} at {sunset_time.strftime('%H:%M:%S')} local time")
            
        elif response.status_code == 404:
            print(f"Error: City '{CITY}' not found. Please check the spelling and try again.")
        elif response.status_code == 401:
            print("Error: Invalid API key. Please check your API key.")
        else:
            print(f"Error: Unable to fetch weather data. Status code: {response.status_code}")
            
    except requests.exceptions.ConnectionError:
        print("Error: Unable to connect to the weather service. Please check your internet connection.")
    except requests.exceptions.Timeout:
        print("Error: Request timed out. Please try again later.")
    except requests.exceptions.RequestException as e:
        print(f"Error: An error occurred while making the request: {e}")
    except KeyError as e:
        print(f"Error: Missing expected data in the response. Key not found: {e}")
    except ValueError as e:
        print(f"Error: Invalid data received from the API: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def main():
    while True:
        get_weather_info()
        
        retry = input("\nWould you like to check weather for another city? (y/n): ").lower().strip()
        if retry not in ['y', 'yes']:
            print("Thank you for using the Weather App!")
            break

if __name__ == "__main__":
    main()