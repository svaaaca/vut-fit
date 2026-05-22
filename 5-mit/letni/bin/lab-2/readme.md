# Laboratorní cvičení BIN2 : Statistické vyhodnocení experimentů

Cílem druhého cvičení v předmětu BIN je seznámit se s možnostmi statistického vyhodnocení experimentů.

## Zadání
CGP z minulého cvičení běželo po 90 nezávislých běhů návrhu 4bitové sčítačky pro různá nastavení 
- počtu mutací,
- parametru λ (velikost populace),
- počtu sloupců.


Ukázku logovacího souboru naleznete v [example.log](example.log).

Bude nás zajímat rychlost (doba trvání) návrhu pro vybraná nastavení a také vývoj fitness (konvergence).


## Vlastní spuštění a testování 
Pro spuštění máte několik možností:

* __DOPORUČENO__: stáhnout notebook na [Google CoLab](https://colab.research.google.com/notebook), můžete otevřít projekt přímo z Githubu (nutné zadat `mrazekv/bin-lab-stat` a notebook _lab.ipynb_). Potom kliknete do boxu s kódem (kde můžete dělat změny) a pomocí Shift+Enter spustit daný blok. Pozor, je nutné postupovat postupně a nepřeskakovat kernely.

* z repozitáře https://github.com/mrazekv/bin-lab-stat si stáhnout notebooky lokálně a pustit např. ve VS Code.

Normálně by notebooky byly 3 - načtení dat, analýza běhů a konvergenční analýza. Zejména načítání dat je vhodné dělat samostatně a výsledky si uložit z důvodu zrychlení kódu. Při práci s VS code či PyCharm nemusíte při projektech používat notebooky, ale normální python skripty, kdy jednotlivé části (buňky) budou odděleny řetězcem `#%%%`.


## Úkoly 
Projděte si notebook a vyřešte všechny úkoly.
