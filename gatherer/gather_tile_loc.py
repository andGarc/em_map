import asyncio
import pandas as pd
from aiohttp import ClientSession
from pytile import async_login
from sqlalchemy import create_engine
from datetime import datetime, timedelta


def upload(df):
    engine = create_engine('postgresql://postgres:<user>@<host>:<port>/postgres')
    df.to_sql('<table>', engine, schema='public', if_exists='append', index=False)
    df.to_csv("./locations/locations.csv", index=False)


async def main() -> None:
    """Run!"""
    async with ClientSession() as session:
        api = await async_login("<user>", "<pass>!", session)

        tiles = await api.async_get_tiles()
        for tile_uuid, tile in tiles.items():
            if 'Keys' in tile.name:
                print(f"Lat: {tile.latitude}")
                print(f"Lng: {tile.longitude}")
                timestamp = datetime.now()
                timestamp = "{:d}:{:02d}:{:02d}".format(timestamp.hour, timestamp.minute, timestamp.second)

                coors = {'lat': [tile.latitude], 'lon': [tile.longitude], 
                'timestamp': [timestamp]}
                upload(pd.DataFrame(data=coors))
                
asyncio.run(main())