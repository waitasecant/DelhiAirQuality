import tweepy
import os

from dotenv import load_dotenv

sites = [
    "Bawana",
    "Nehru Nagar",
    "Jawaharlal Nehru Stadium",
    "Dr. Karni Singh Shooting Range",
    "Major Dhyan Chand National Stadium",
    "Patparganj",
    "Vivek Vihar",
    "Sonia Vihar",
    "Narela",
    "Najafgarh",
    "Rohini",
    "Okhla Phase-2",
    "Ashok Vihar",
    "Wazirpur",
    "Jahangirpuri",
    "Dwarka Sector-8",
    "Alipur",
    "Pusa",
    "Sri Aurobindo Marg",
    "Mundka",
    "Anand Vihar",
    "Mandir Marg",
    "Punjabi Bagh",
    "R K Puram",
]


load_dotenv()

auth = tweepy.OAuth1UserHandler(
    consumer_key=os.getenv("api_key"), consumer_secret=os.getenv("api_secret")
)

auth.set_access_token(os.getenv("access_token"), os.getenv("access_token_secret"))
api = tweepy.API(auth, wait_on_rate_limit=True)

client = tweepy.Client(
    consumer_key=os.getenv("api_key"),
    consumer_secret=os.getenv("api_secret"),
    access_token=os.getenv("access_token"),
    access_token_secret=os.getenv("access_token_secret"),
)

for j in sites:
    media_ids = []
    params = []
    for i in ["PM2.5", "PM10", "NH3", "SO2"]:
        if os.path.exists(f"{i}\\{j}.png"):
            media = api.media_upload(filename=f"{i}\\{j}.png").media_id_string
            media_ids.append(media)
            params.append(i)

    text = f"Last 24-hr {', '.join(params)} concentration at {j}, Delhi"
    client.create_tweet(text=text, media_ids=media_ids)
