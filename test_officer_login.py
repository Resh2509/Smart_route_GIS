import requests

URL = "http://127.0.0.1:8000/api/auth/login"

officers = [
    "murugan.officer@gcc.gov.in",
    "kumar.officer@gcc.gov.in",
]

for email in officers:
    response = requests.post(
        URL,
        json={
            "email": email,
            "password": "admin123",
            "portal_type": "municipal",
        },
        timeout=10,
    )

    print(f"\nEmail: {email}")
    print(f"HTTP status: {response.status_code}")

    try:
        data = response.json()
        print("Login successful:", response.status_code == 200)

        if response.status_code == 200:
            print("Returned fields:", list(data.keys()))
            print("Profile:", data.get("user", data.get("profile", "Inspect returned fields above")))
        else:
            print("Response:", data)
    except ValueError:
        print("Response:", response.text)

