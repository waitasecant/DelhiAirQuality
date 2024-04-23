import tweepy
import os
import pytz
from dotenv import load_dotenv
from datetime import datetime

sites = [
    "Bawana",
    "Nehru Nagar",
    # "Jawaharlal Nehru Stadium",
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
    "R K Puram"
]
IST = pytz.timezone('Asia/Kolkata')
load_dotenv()

auth = tweepy.OAuthHandler(
    consumer_key=os.getenv("API_KEY"), consumer_secret=os.getenv("API_SECRET")
)

auth.set_access_token(os.getenv("ACCESS_TOKEN"), os.getenv("ACCESS_TOKEN_SECRET"))
api = tweepy.API(auth, wait_on_rate_limit=True)

client = tweepy.Client(
    consumer_key=os.getenv("API_KEY"),
    consumer_secret=os.getenv("API_SECRET"),
    access_token=os.getenv("ACCESS_TOKEN"),
    access_token_secret=os.getenv("ACCESS_TOKEN_SECRET")
)

for j in sites:
    media_ids = []
    params = []
    for i in ["PM2.5", "PM10", "NH3", "SO2"]:
        if os.path.exists(f"data//{i}//{j}.png"):
            media = api.media_upload(filename=f"data//{i}//{j}.png").media_id_string
            media_ids.append(media)
            params.append(i)
    st ="#"+"".join(j.split(" "))
    st = st.replace(".", "")
    st = st.replace("-", "")
    text = f"Last 24-hr {', '.join(params)} concentration at {j}, Delhi\n{datetime.strftime(datetime.now(IST), '%d %B %Y, %H:%M')}\nColor-Coded according to NAAQS https://t.ly/UIKC5\n{st}"
    client.create_tweet(text=text, media_ids=media_ids)

    media_ids = []
    params = []
    for i in ["AQI"]:
        if os.path.exists(f"data//{i}//{j}.png"):
            media = api.media_upload(filename=f"data//{i}//{j}.png").media_id_string
            media_ids.append(media)
            params.append(i)
    st ="#"+"".join(j.split(" "))
    st = st.replace(".", "")
    st = st.replace("-", "")
    text = f"Last 24-hr {', '.join(params)} concentration at {j}, Delhi\n{datetime.strftime(datetime.now(IST), '%d %B %Y, %H:%M')}\nColor-Coded according to NAAQS https://t.ly/UIKC5\n{st}"
    client.create_tweet(text=text, media_ids=media_ids)