# Adaptivní neuro-fuzzy systém aplikovaný např. v klasifikaci nebo řízení

- **Autor:** David Kvaček (xkvace00@stud.fit.vutbr.cz)
- **Datum:** 01.12.2025

### Úvod

Cílem tohoto projektu je **implementace Adaptivního Neuro-Fuzzy Inferenčního Systému (ANFIS)** v programovacím jazyce Python.
Systém je navržen pro řešení *binární klasifikace* na synteticky generovaných 2D datech.
Projekt zahrnuje návrh fuzzy pravidel, realizaci všech architektonických vrstev ANFIS a vyhodnocení naučené rozhodovací hranice a přesnosti modelu.

### Teoretický základ

*Fuzzy logika* je rozšířením Booleovské logiky, která umožňuje proměnným nabývat stupně členství v množině, reprezentovaného hodnotou v intervalu $\langle 0, 1 \rangle$.
Tato schopnost modelovat neurčitost je klíčová pro Neuro-Fuzzy systémy.
ANFIS kombinuje principy Fuzzy Inferenčního Systému (FIS) typu Sugeno s architekturou Umělé Neuronové Sítě (ANN).
Tato hybridní struktura umožňuje systému učit se parametry členských funkcí a lineární parametry z trénovacích dat.
ANFIS je typicky realizován v pěti vrstvách:

| Vrstva | Název | Funkce | Parametry |
| :--- | :--- | :--- | :--- |
| **L1** | Fuzzifikace | Převádí ostré vstupy na stupně členství $\mu$ (použita Gaussova funkce). | Antecedentní ($\mu, \sigma$) |
| **L2** | T-Norm | Vypočítá sílu aktivace pravidla ($w_i$) jako součin stupňů členství. | Bez parametrů |
| **L3** | Normalizace | Normalizuje sílu aktivace pravidla ($\bar{w}_i = w_i / \sum w_i$). | Bez parametrů |
| **L4** | Konsekventy | Vypočítá výstup každého pravidla (lineární model $f_i = p_i x_1 + q_i x_2 + r_i$). | Konsekventní ($p_i, q_i, r_i$) |
| **L5** | Defuzzifikace | Sumarizuje vážené výstupy pravidel na finální ostrý výstup ($Y = \sum \bar{w}_i f_i$). | Bez parametrů |

Implementace používá fuzzy pravidla typu Sugeno 1. řádu s Gaussovskými členskými funkcemi.

### Implementace

Projekt je realizován v **Pythonu 3** a využívá knihovny *NumPy* a *Matplotlib*.

| Soubor | Účel |
| :--- | :--- |
| `generator.py` | Generuje syntetická data a ukládá je do `train.txt` a `test.txt`. |
| `anfis.py` | Obsahuje třídu `ANFIS` s architekturou a logikou modelu. |
| `main.py` | Trénovací skript: Trénuje model, vyhodnocuje a generuje `mse.png` a `test.png`. |
| `run.sh` | Spouštěcí skript pro trénování s parametry (`--epochs`, `--lr`, `--samples`). |
| `test.sh` | Skript pro testování naučeného modelu (`model.json`) na nově generované sadě dat. |
| `clean.sh` | Skript pro smazání všech generovaných souborů. |

### Generování dat
* **Klasifikační pravidlo:** $Y = 1$ pokud $(X_1 + X_2) \geq 1.0$, jinak $Y = 0$.
* **Rozdělení dat:** 80% trénovací (`train.txt`) a 20% testovací (`test.txt`).
Model je navržen pro 2 vstupy ($X_1, X_2$) s 2 členskými funkcemi pro každý vstup, což vede k celkovému počtu 4 fuzzy pravidel.
