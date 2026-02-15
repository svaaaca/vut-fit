import re
import urllib.request
from bs4 import BeautifulSoup
from sys import stderr


def go_to_site(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                      "AppleWebKit/537.36 (KHTML, like Gecko)"
                      "Chrome/124.0.0.0 Safari/537.36"
    }

    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            html = response.read().decode("utf-8", errors="ignore")

    except Exception as e:
        print("Failed:", url, e, file=stderr)
        return []

    soup = BeautifulSoup(html, "html.parser")
    products = [a["href"] for a in soup.find_all("a", href=re.compile("oferta"))]

    return set(products)


def main():
    base_url = "https://www.otomoto.pl/osobowe?search%5Border%5D=relevance_web"
    page_count = 6
    all_products = []
    for i in range(page_count):
        final_url = base_url+f"&page={i+1}"
        all_products += go_to_site(final_url)

    all_products = set(all_products)
    for product_link in all_products:
        print(product_link)


if __name__ == "__main__":
    main()
