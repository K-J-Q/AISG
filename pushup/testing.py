import requests

activity = 'pushups'
duration = 30
api_url = 'https://api.api-ninjas.com/v1/caloriesburned?activity={}'.format(activity)
# api_url = 'https://api.api-ninjas.com/v1/caloriesburned?activity={}&duration={}'.format(activity, duration)
response = requests.get(api_url, headers={'X-Api-Key': 'npxqqF9U4iU6Uxuhnggp1g==0HVdbym8yDGa61sr'})
if response.status_code == requests.codes.ok:
    print(response.text)
else:
    print("Error:", response.status_code, response.text)