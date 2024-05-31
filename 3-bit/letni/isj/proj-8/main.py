#!/usr/bin/env python3

import asyncio
import aiohttp

async def get_status(session, url):
    try:
        async with session.get(url) as response:
            return response.status, url
    except aiohttp.ClientError:
        return 'aiohttp.ClientError', url

async def get_urls(urls):
    async with aiohttp.ClientSession() as session:
        status = [get_status(session, url) for url in urls]
        result = await asyncio.gather(*status)
        return result

if __name__ == '__main__':
    urls = ['https://www.fit.vutbr.cz', 'https://www.szn.cz', 'https://office.com']
    res = asyncio.run(get_urls(urls))
    print(res)
