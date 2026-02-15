# Projekt, 2. část: ukládání rozsáhlých dat v NoSQL databázích

**Název týmu:** Tým xkaska02

**Řešitelé:**
- Martin Burian (xburiam00)
- Karel Kaska (xkaska02)
- David Kvaček (xkvace00)

## Databáze časových řad

- **Název zvolené datové sady:** Bolevák – hladina vody (https://opendata.plzen.eu/public/opendata/detail/182)
- **Distribuce dané datové sady:** CSV
- **Zvolený druh NoSQL databáze:** InfluxDB

### Popis a struktura datové sady

Datová sada obsahuje časovou řadu hodnot hladiny vody měřené na rybníku Bolevák.
Katalog poskytuje pouze *CSV distribuci* následující struktury:

```csv
time,value
2022-12-14 09:00:00,311.13
```

kde:
- `time` je časový údaj ve formátu YYYY-MM-DD HH:MM:SS,
- `value` je hodnota hladiny vody v metrech jako desetinné číslo.

Jedná se tedy o jednoduchou, pravidelně se měnící časovou řadu s jediným měřeným atributem.

### Vysvětlení výběru NoSQL databáze InfluxDB

InfluxDB je optimalizovaná pro:

- rychlé ukládání a dotazování *časových řad*,  
- vysoké frekvence zápisu,  
- rychlé agregace nad časem,  
- retence dat (možnost automatického odmazávání starých dat),  
- downsampling (automatické vytváření agregovaných verzí dat),  
- dotazy nad časem v jazyce `Flux`.

Zvolená datová sada **Bolevák – hladina vody** obsahuje data v podobě čisté časové řady s pravidelně měřenými hodnotami jediného senzoru.
Dotazy nad těmito daty jsou ryze časového typu, tj. průměry, minima, maxima, trendy v čase atd.
InfluxDB ukládá data efektivně pomocí časového indexu, což umožňuje velmi rychlé dotazy nad časovými intervaly bez nutnosti číst celý dataset.
Zároveň je možné využít automatického `UPSERT` chování, kdy se při opětovném zápisu stejného časového bodu data interně nahradí.

V porovnání s jinými NoSQL databázemi je InfluxDB jednoznačně nejvhodnější volbou pro tento typ dat.
Navzdory tomu, že je *Apache Cassandra* vhodná pro logy, tak nemá specializované funkce pro časové řady.
*MongoDB* není optimalizovaná pro velmi rychlé dotazování nad časovými intervaly, přičemž zde chybí nativní retence.
Vybraná datová sada rovněž neobsahuje žádné vztahy, grafový model s využitím *Neo4J* nedává smysl.

### Návrh schématu v InfluxDB

InfluxDB používá *bucket* (ekvivalent databáze) a uvnitř *measurements*.
Vhodně nastavená retence zabraňuje neřízenému růstu dat a odpovídá dlouhodobému charakteru datasetu.
Indexované položky `tag` určují unikátní časové řady, zde je použití užitečné i v případě existence jediného senzoru, protože umožňuje případné budoucí rozšíření datové sady.
Neindexované položky `field` slouží k uchování samotných hodnot (časová razítka, hladiny vody).

### Příkaz pro vytvoření bucketu (InfluxDB CLI)

```bash
influx bucket create \
  --name "bolevakWaterlevel" \
  --retention 5y
```

### Ukázka a popis importu dat

```python
import csv
import requests
from datetime import datetime

BUCKET = "bolevakWaterlevel"
ORG = "org"
TOKEN = "TOKEN"
URL = f"http://localhost:8086/api/v2/write?org={ORG}&bucket={BUCKET}&precision=ns"

headers = {
    "Authorization": f"Token {TOKEN}",
    "Content-Type": "text/plain; charset=utf-8"
}

batch = []

with open("data-bolevakHladina.csv", "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        ts = int(datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S").timestamp() * 1e9)
        value = float(row["value"])
        batch.append(f"waterlevel, sensor=bolevak value={value} {ts}")

# odeslání dávky
data = "\n".join(batch)
resp = requests.post(URL, headers=headers, data=data)
print(resp.status_code, resp.text)
```

Datová sada se aktualizuje přidáváním nových řádků.
Pravidelně stahovat aktualizované CSV, vytvořit množinu časových razítek existujících dat (např. uložením posledního časového razítka, nebo dotazem InfluxDB), následně pro každý nový řádek vykonat obyčejný `IMPORT`, pokud je aktuální časové razítko větší než poslední importované, jinak položit časové razítko již existujícímu a provést `UPSERT`, tj. přepsání hodnoty, a nakonec odeslat opět přes *line* protokol.

### Dotaz v jazyce daného databázového produktu

```sql
from(bucket: "bolevakWaterlevel")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "waterlevel")
  |> filter(fn: (r) => r.sensor == "bolevak")
  |> mean()
```

- `range(start: -24h)` – server okamžitě omezí dotaz na zvolený časový interval,
- `filter(fn: (r) => r.sensor == "bolevak"` – použití indexu `tag`,
- `mean()` – agregace nad hodnotami `_value`,
- výsledkem je jediná hodnota reprezentující průměrnou hladinu vody za posledních 24 hodin (desetinné číslo).

Při vykonání výše uvedeného dotazu provede InfluxDB následující kroky:

1. nalezení shardů – bucket má retenci 5 let, takže časové okno -24h spadá do jediného shardu, samostatného fyzického adresáře se soubory,
2. použití indexu `tag` – okamžité vyhledání všech záznamů s tagem `sensor=bolevak`, které odpovídají zvolenému dotazu,
3. načtení pouze relevantních časových řad – InfluxDB načte pouze bloky překrývající interval posledních 24 hodin,
4. výpočet agregace – průběžný výpočet průměru nad hodnotami `_value` bez nutnosti načítat všechny hodnoty do paměti,
5. vrácení výsledku – jediná hodnota jako výsledek dotazu.

## Dokumentová databáze

- **Název zvolené datové sady:** Parkovací automaty (https://opendata.plzen.eu/public/opendata/detail/131)
- **Distribuce dané datové sady:** GeoJSON
- **Zvolený druh NoSQL databáze:** MongoDB

### Popis a struktura datové sady

- **~70 parkovacích automatů** v centru města Plzně,
- **heterogenní geometrie:** každý automat má různý počet geometrických objektů (LineString, Polygon, GeometryCollection),
- **formát GeoJSON:** nativní podpora prostorových dat s vnořenými souřadnicemi,
- **metadata:** ID_PA, ZONA (A, B, C), OBJEKT, typ geometrie.

```json
{
  "type": "Feature",
  "id": "parkomaty.12211161",
  "geometry": {
    "type": "GeometryCollection",
    "geometries": [
      {"type": "LineString", "coordinates": [[13.373, 49.749], ...]},
      {"type": "Polygon", "coordinates": [[[13.373, 49.749], ...]]},
    ]
  },
  "properties": {
    "OBJEKT": "Parkovací automat",
    "ID_PA": "69",
    "ZONA": "B"
  }
}
```

### Vysvětlení výběru NoSQL databáze MongoDB

- **nativní podpora GeoJSON:** přímý import bez transformace dat,
- **flexibilní schéma:** různý počet geometrií na automat bez nutnosti migrace,
- **denormalizace:** jeden dokument odpovídá celému automatu (geometrie, metadata a historie plateb),
- **indexy geospatial:** vestavěná podpora indexů 2dsphere pro prostorové dotazy,
- **atomické operace:** aktualizace celého automatu v jedné transakci.

### Srovnání s PostgreSQL + PostGIS

| Vlastnost | MongoDB | PostgreSQL + PostGIS |
|-----------|---------|---------------------|
| **Import** | Přímý import GeoJSON | Transformace GeoJSON → WKT → PostGIS |
| **Schéma** | Flexibilní | Rigidní - vyžaduje ALTER TABLE |
| **Dotazy** | Jeden query, JSON výstup | JOINy přes více tabulek |
| **Škálování** | Horizontální sharding | Vertikální škálování |

**Konkrétní příklad:**

Dotaz: "Najdi všechny automaty v okruhu 500m od souřadnic [13.377, 49.748] v zóně B"

```javascript
db.parking_meters.find({
  "properties.ZONA": "B",
  "geometry": {
    $near: {
      $geometry: {type: "Point", coordinates: [13.377, 49.748]},
      $maxDistance: 500
    }
  }
})
```

**PostgreSQL + PostGIS:**
```sql
SELECT pa.*, g.geometry, z.tarif 
FROM parking_automats pa
JOIN geometries g ON pa.id = g.automat_id
JOIN zones z ON pa.zone_id = z.id
WHERE z.name = 'B' 
  AND ST_DWithin(g.geometry::geography, 
                  ST_SetSRID(ST_Point(13.377, 49.748), 4326)::geography, 500);
```

---

### Vnořené dokumenty a denormalizace

```json
{
  "_id": ObjectId("507f1f77bcf86cd799439011"),
  "properties": {
    "ID_PA": "69",
    "ZONA": "B",
    "address": "Americká 23, Plzeň"
  },
  "geometry": {
    "type": "GeometryCollection",
    "geometries": [...]
  },
  "payment_history": [
    {
      "timestamp": ISODate("2024-11-15T10:30:00Z"),
      "amount": 30,
      "duration_minutes": 60,
      "payment_method": "card"
    }
  ],
  "maintenance": {
    "last_service": ISODate("2024-10-01"),
    "status": "operational"
  }
}
```

**Výhody:**
- **Atomické zápisy:** Jeden query pro update automatu + přidání platby
- **Eliminace JOINů:** Všechna data v jednom dokumentu
- **Embedding vs. Referencing:** Historie embedována pro rychlý přístup

### Write-heavy workload

**Charakteristika zátěže:**
- 70 automatů × 10 plateb/hodinu = **700 writes/hodinu**
- Heterogenní události: platby kartou, mobilní aplikací, SMS

**Výhody MongoDB:**
- **Flexible schema:** Různé typy plateb bez migrace schématu
- **Array operations:** $push s $slice pro efektivní správu historie
- **Document-level locking:** Paralelní updates bez contention

### Horizontální škálování

**Sharded Cluster:**
```
Shard 1: Zóna A (centrum - ID_PA 1-23)
Shard 2: Zóna B (střed - ID_PA 24-46)  
Shard 3: Zóna C (periferie - ID_PA 47-70)

Shard Key: {"properties.ZONA": 1, "_id": 1}
```

**Optimalizované queries:**
- Proximita search pro mobilní aplikace
- Zone-based agregace s paralelním zpracováním
- Geo-fencing pro notifikace

### Příkazy pro definici úložiště

```javascript
use plzen_parking

db.createCollection("parking_meters", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["type", "geometry", "properties"],
      properties: {
        type: {enum: ["Feature"]},
        geometry: {required: ["type"]},
        properties: {
          required: ["ID_PA", "ZONA"],
          properties: {
            ZONA: {enum: ["A", "B", "C"]}
          }
        }
      }
    }
  }
})

db.parking_meters.createIndex({"geometry": "2dsphere"})
db.parking_meters.createIndex({"properties.ID_PA": 1}, {unique: true})
db.parking_meters.createIndex({"properties.ZONA": 1})
```

### Popis importu dat

```python
from pymongo import MongoClient
import json

client = MongoClient('mongodb://localhost:27017/')
db = client['plzen_parking']
collection = db['parking_meters']

with open('parkomaty.geojson', 'r', encoding='utf-8') as file:
    geojson_data = json.load(file)

for feature in geojson_data['features']:
    feature['payment_history'] = []
    feature['maintenance'] = {'status': 'operational'}
    
    collection.update_one(
        {'properties.ID_PA': feature['properties']['ID_PA']},
        {'$set': feature},
        upsert=True
    )
```

### Dotazy v MongoDB

Využití unique indexu → O(log n) přístup k dokumentu.

```javascript
db.parking_meters.findOne({"properties.ID_PA": "69"})
```

2dsphere index → proximity search s automatickým řazením podle vzdálenosti.

```javascript
db.parking_meters.find({
  geometry: {
    $near: {
      $geometry: {type: "Point", coordinates: [13.377, 49.748]},
      $maxDistance: 1000
    }
  }
}).limit(5)
```

Paralelní zpracování na sharded clusteru s finální merge fází.

```javascript
db.parking_meters.aggregate([
  {$unwind: "$payment_history"},
  {$match: {
    "payment_history.timestamp": {
      $gte: new Date(new Date().setMonth(new Date().getMonth() - 1))
    }
  }},
  {$group: {
    _id: "$properties.ZONA",
    total_revenue: {$sum: "$payment_history.amount"},
    payment_count: {$sum: 1}
  }},
  {$sort: {total_revenue: -1}}
])
```

## Grafová databáze

- **Název zvolené datové sady:** Archeologie (https://opendata.plzen.eu/public/opendata/detail/44)
- **Distribuce dané datové sady:** GeoJSON
- **Zvolený druh NoSQL databáze:** Neo4J

### Vhodná distribuce datové sady pro grafovou databázi

GeoJSON formát je vhodný, protože umožňuje přirozeně modelovat geografické objekty a jejich prostorové vztahy ve formě uzlů a hran.
Prvky lze jednoduše převést na uzly s geometrickými vlastnostmi, zatímco vztahy mezi objekty lze odvodit z jejich prostorové struktury.
Grafová databáze tak dokáže reprezentovat sousednost, překryvy, hierarchii nebo blízkost jednotlivých oblastí, což jsou vztahy, které běžné tabulkové databáze nezachycují přirozeně.
Díky tomu lze nad geografickými daty efektivně provádět analýzy, jako je hledání blízkých lokalit, nebo zjišťování sousedících oblastí.

### Volba grafové databáze

Je zvolena proto, že umožňuje modelovat vztahy mezi jednotlivými územními celky. 
V grafové databázi lze provádět komplexní dotazy nad těmito vztahy, které jsou v ostaních NoSQL databázích velmi obtížné, nebo neefektivní.
Databáze časových řad je určená pro měření v čase, což zde neplatí.
Wide-column databáze neumí prostorové joiny a dotazy na průchod grafem. 

### Příkazy pro definici úložiště

```sql
// Vytvoření indexu pro rychlé hledání podle ID
CREATE INDEX site_id_index IF NOT EXISTS
FOR (s:Site)
ON (s.id);

// Vytvoření indexu pro vyhledávání podle názvu
CREATE INDEX site_name_index IF NOT EXISTS
FOR (s:Site)
ON (s.name);
```

###  Popis importu dat

```
1. Načti soubor JSON:
    data := LOAD_JSON("file:///archeology.geojson")

2. Získej pole všech prvků typu Feature:
    features := data.features

3. PRO každý prvek feature v features:
    properties := feature.properties
    geometry := feature.geometry

    id := properties.id
    name := properties.name
    code := properties.number

    coordinates := geometry.coordinates[0]   // polygonová data

    centroid := VYPOCITEJ_CENTROID(coordinates)

    Vytvoř nový uzel Site v Neo4j:
            CREATE_NODE("Site", {
                "id": id,
                "name": name,
                "code": code,
                "boundary": coordinates,
                "centroid": centroid
            })

   KONEC PRO

  5. Vytvoř vztahy mezi lokalitami:
        PRO každý pár uzlů (A, B):
            POKUD A.boundary se dotýká B.boundary:
                  CREATE_REL(A, "ADJACENT_TO", B)
            KONEC POKUD

            POKUD vzdálenost(A.centroid, B.centroid) < 500:
                  CREATE_REL(A, "NEAR", B)
            KONEC POKUD
        KONEC PRO

```

### Dotaz v jazyce daného databázového produktu

Najdi všechny lokality podle jména

```
MATCH (s:Site)
WHERE s.name CONTAINS "hrad"
RETURN s.id, s.name;
```

Najdi všechny archeologické lokality v okruhu 500 metrů

```
MATCH (a:Site {id: 123}), (b:Site)
WHERE a <> b AND distance(a.centroid, b.centroid) < 500
RETURN b.name AS NearbySites;
```

## Sloupcová wide-column databáze

- **Název zvolené datové sady:** Dopravní detektory - data (https://opendata.plzen.eu/public/opendata/detail/160)
- **Distribuce dané datové sady:** CSV
- **Zvolený druh NoSQL databáze:** Apache Cassandra

### Vhodná distribuce datové sady pro databázi wide-column

CSV formát umožňuje efektivní import masivního objemu dat z tisíce detektorů do wide-column struktury.
Data lze organizovat do **column families** podle úrovně granularity (surová měření 90s, profilové agregace, hodinové statistiky) s **partition key** na základě `detector_id` nebo `zone_id`, což zajišťuje distribuci dat napříč clustery a paralelní zpracování dotazů na různé detektory.

### Volba wide-column databáze

### 1. Masivní objem heterogenních dat

**Charakteristiky datasetu:**
- **~1000 detektorů** měřících každých 90 sekund = ~960 000 měření/den
- **307 profilových úseků** (agregace více detektorů) s hierarchickou strukturou
- Různé detektory poskytují různé atributy: některé jen `intensity`, jiné i `occupancy`, `speed`, `vehicle_class`

**Proč wide-column:**
- **Sparse data handling:** Detektory s chybějícími senzory (rychlost, třída vozidla) neukládají NULL hodnoty → úspora až 40% storage
- **Flexibilní schéma:** Přidání nových typů měření (např. elektrické nabíječky, emisní data) bez migrace miliardy existujících řádků
- **Partition strategy:**
  ```
  PRIMARY KEY ((zone_id, detector_id), timestamp)
  ```
  Každá městská zóna (Centrum, Sever, Jih) = samostatná partice → paralelní writes bez contention

### 2. Výhody oproti time-series
Oproti Time-Series databázím nemá overhead při ukládání dat (wide column neukládá NULL hodnoty).
Time series je spíše určená pro data z jednoho místa o stejné struktuře. Wide column je dělána na dlouhodobé uložení obrovského množství dat z více detektorů.


### 3. Multi-level agregace přes column families

**Strategie ukládání pro různé use-cases:**

```
Column Family "raw_measurements":
  PRIMARY KEY ((detector_id), timestamp)
  TTL: 30 dní
  → Real-time monitoring, odstranění starých dat automaticky

Column Family "hourly_aggregates":
  PRIMARY KEY ((profile_id), hour_timestamp)
  TTL: 2 roky
  → Historické analýzy, pre-počítané průměry/maxima

Column Family "daily_statistics":
  PRIMARY KEY ((zone_id), date)
  TTL: 10 let
  → Long-term trendy, compliance reporting
```

**Výhody:**
- **Různá retence dat** podle důležitosti (raw data 30d vs. statistiky 10 let)
- **Optimalizované read patterns:** Real-time dashboard čte z `raw_measurements`, reporty z `daily_statistics`
- **Incremental aggregation:** Materialized views automaticky agregují surová data do vyšších úrovní

### 4. Write-heavy workload optimalizace

**LSM-tree (Log-Structured Merge-tree) výhody:**
- 1000 detektorů × 40 měření/hodinu = **40 000 writes/hodinu** kontinuálně
- **Sekvenciální zápisy:** Všechny writes do MemTable → flush jako immutable SSTable → žádné random I/O
- **Batch efficiency:** Cassandra zvládne 50 000+ writes/sec na commodity hardware (vs. PostgreSQL ~5 000 writes/sec)

### 5. Škálovatelnost pro Smart City ekosystém

**Horizontální distribuce:**
```
Cluster (3 nodes):
  Node 1: Zóna Centrum + Plzeň 1 (detektory 1-333)
  Node 2: Plzeň 2-3 (detektory 334-666)
  Node 3: Plzeň 4 + periferie (detektory 667-1000)

Replication Factor = 3 → každá partice na všech 3 nodech
```

**Výhody pro dotazy:**
- **Token-aware routing:** Dashboard query pro "Centrum" jde přímo na Node 1 → <5ms latence
- **Paralelní agregace:** "Průměrná intenzita celého města" = distribuovaný query na všech 3 nodech → výsledek v ~50ms
- **Fault tolerance:** Výpadek 1 nodu = zero downtime, replikace zajišťuje dostupnost

**Budoucí integrace:**
Wide-column cluster může hostit další Smart City datasety:
- `traffic_incidents` (nehody, uzavírky)
- `air_quality` (kvalita ovzduší korelovaná s dopravou)
- `parking_occupancy` (parkovací domy + ulice)
→ Cross-dataset korelační analýzy bez ETL pipeline

### Příkazy pro definici úložiště

```sql
CREATE KEYSPACE IF NOT EXISTS traffic_detectors WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};
DESCRIBE KEYSPACE traffic_detectors;
USE traffic_detectors;
```

```sql
CREATE TABLE IF NOT EXISTS detectors (
    ID_DETEKTOR text,
    UTCTIMESTAMP timestamp,
    V_VALUE int,
    OBSAZENOST int,
    INTERVAL_ int,
    INTENZITA int,
    TIMESTAMP_ timestamp
    PRIMARY KEY (
        ID_DETEKTOR,
        UTCTIMESTAMP
    )
);
DESCRIBE detectors;
```

### Popis importu dat

```
for each line in csv:
  INSERT INTO detectors VALUES (line.ID_DETEKTOR, line.UTCTIMESTAMP, line.V_VALUE, line.OBSAZENOST, line.INTERVAL_, line.INTENZITA, line.TIMESTAMP_);
```

### Dotaz v jazyce daného databázového produktu

```sql
SELECT * FROM detectors WHERE ID_DETEKTOR = 'FD117_D1';
```

Nalezení bude rychlé, protože se hledá podle partitioning klíče. Vrátí se všechny hodnoty pro daný detektor.
