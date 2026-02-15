import sys
import urllib.request
from bs4 import BeautifulSoup


def get_attr_value(soup, div_id) -> str:
    """returns value of the attribute or empty string if the attribute is not found

    Args:
        soup (BeautifulSoup): object with html to search in
        div_id (str): id of the data-testid attribute on the site
    """
    div = soup.find("div", attrs={"data-testid":div_id})
    attr_value = div.find("p", class_="ekybgc111 ooa-ugve4x").text if div else ""
    return attr_value


def get_product_info(url):
    """Function description"""
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
        print("Failed:", url, e, file=sys.stderr)
        return []

    soup = BeautifulSoup(html, "html.parser")
    product_name = soup.find("h1", class_="offer-title big-text eng3xoo2 ooa-ev3vab").text
    product_price = soup.find("span", class_="offer-price__number").text

    info_value = []
    car_brand = get_attr_value(soup, "make")
    car_model = get_attr_value(soup, "model")
    car_color = get_attr_value(soup, "color")
    door_count = get_attr_value(soup, "door_count")
    nr_seats = get_attr_value(soup, "nr_seats")
    year = get_attr_value(soup,"year")
    info_value.append(car_brand)
    info_value.append(car_model)
    info_value.append(car_color)
    info_value.append(door_count)
    info_value.append(nr_seats)
    info_value.append(year)
    info_value.insert(0, product_price) # add price to start
    info_value.insert(0, product_name)
    info_value.insert(0, url)

    return info_value


def main():
    for line in sys.stdin:
        info = get_product_info(line)
        for i in info:
            print(i.strip(), end="\t")

        print("")


if __name__ == "__main__":
    main()
