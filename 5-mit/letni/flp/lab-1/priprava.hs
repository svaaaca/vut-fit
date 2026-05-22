-- -*- coding: utf-8 -*-
-- ---
-- jupyter:
--   jupytext:
--     formats: hs:percent
--     text_representation:
--       extension: .hs
--       format_name: percent
--       format_version: '1.3'
--       jupytext_version: 1.19.1
--   kernelspec:
--     display_name: Haskell
--     language: haskell
--     name: haskell
-- ---

-- %% [markdown]
-- # Příprava 1: Základy Haskellu
--
-- Tento kód (notebook) je pokračováním studijního textu k první domácí přípravě.
--
-- V buňkách, kterým předchází text označený jako „Příklad“, se očekává vaše řešení zadané úlohy.
--
-- Pozor! Je zásadní, abyste z odpovědních buněk **nemazali** žádné komentáře `-- EX[číslo úlohy]`, jinak nebude úloha při automatickém testování nalezena a nebude ohodnocena!
--
-- Buňky můžete vyhodnocovat pomocí Shift+Enter. \
-- Abyste z toho něco měli, zkuste si ale **před samotným spuštěním každé buňky nejprve rozmyslet, co ta buňka vypíše!** U zkoušky (a někdy i v životě) nebudete mít po ruce ani překladač, ani ChatGPT – tímhle se to nejlíp trénuje.

-- %% [markdown]
-- **Příklad 1:** Co bylo výsledkem vyhodnocení `f 66` v sekci „Interaktivní prostředí GHCi“? (Akceptuje se výsledek před změnou funkce i po změně funkce.)

-- %%
-- EX01
67


-- %% [markdown]
-- **Příklad 2:** Vypište zredukovanou formu lambda výrazu (je to ten z předchozí části přípravy):
-- $$(\lambda xyz.x\ (y\ z)\ (\lambda t.\ xt))\ (\lambda ab.ax)\ (\lambda u.u)\ (\lambda v.vx)$$
-- Místo symbolu lambda napište vždy jen zpětné lomítko.

-- %% [raw]
-- -- EX02
-- x x

-- %% [markdown]
-- **Příklad 3:** Vymyslete odpovědi na otázky z videa [Essentials: Functional Programming's Y Combinator - Computerphile
-- ](https://youtu.be/9T8A89jgeTI?t=545) v čase 9:05.

-- %% [raw]
-- -- EX03
-- loop = rec (\x.x)
-- factorial = rec (\f.\n. if n == 0 then 1 else n * f (n - 1))

-- %% [markdown]
-- ---
-- # Haskell warm-up
--
-- V Haskellu je všechno buď **výraz**, nebo **deklarace**. Celý program je pak jeden velký výraz skládající se z menších výrazů. Deklaracemi pak můžeme libovolným výrazům dávat jména, abychom s nimi mohli lépe pracovat.

-- %%
2 -- hodnota samotná je výraz, po spuštění této buňky se jen vypíše

-- %%
1 + 1 -- operátor + je vestavěná funkce, která po vyhodnocení (redukci) sečte čísla

-- %% [markdown]
-- **Normální forma:** Výraz je v normální formě, pokud už jej nelze dál **zredukovat** (nezvládneme ho nijak dál *zjednodušit*). `1 + 1` není v normální formě – v jazyce existuje nějaký vyhodnocovací postup, který z toho udělá `2` – a to už v normální formě je, protože se to nijak dál upravit nedá.

-- %% [markdown]
-- **Funkce** je výraz, který lze vzít a aplikovat na nějaký jiný výraz (stejně jako v lambda kalkulu!). \
-- Pozor na **velikosti písmen**: funkce a názvy proměnných vždy musí začínat malým písmenem (velkými písmeny začínají jiné věci, ke kterým se dostaneme později).
--
-- **Konvence:**
-- - Pokud se název skládá z více slov, konvencí je použití camelCase.
-- - Pro proměnné se velmi často používají jednoznakové názvy začínající od *x*.

-- %%
minusFive x = x - 5
-- deklaruje funkci "minusFive",
-- její parametr se jmenuje "x", 
-- "=" zde říká, kde začíná tělo funkce,
-- "x - 5" je tělem funkce: výraz, ve kterém budeme při aplikaci nahrazovat "x" za argument

-- provedení této buňky nic nevypíše, protože se zde jen deklaruje funkce
-- (ta pak bude dostupná i ve všech následujících buňkách)

-- %%
minusFive 19

-- %% [markdown]
-- Zkuste si zde uvědomit souvislost s lambda kalkulem. Funkce minusFive by šla „symbolicky“ zapsat jako:
-- $$
-- minusFive \equiv \lambda x. x - 5
-- $$
-- Aplikace $(minusFive\ 19)$ je pak totéž jako $((\lambda x. x - 5)\,19)$, což lze $\beta$-zredukovat na $(19 - 5)$. V čistém lambda kalkulu samozřejmě žádná čísla ani odčítání sama o sobě nejsou, takže bychom tu skončili. V Haskellu však matematika je integrovaná, proto umí tento matematický výraz dál zjednodušit na $14$.

-- %% [markdown]
-- Jak jsem psal výše, deklarace je jen navázání nějakého výrazu na jméno a každá funkce je zároveň výraz. Můžu tak klidně svou funkci `minusFive` označit ještě jiným názvem nebo si vytvořit „funkci“ nefunkci, která je ve skutečnosti jen konstantní hodnota:

-- %%
thisIsUseless = minusFive
highFive = 5

thisIsUseless highFive  -- ekvivalentní s "minusFive 5"

-- %% [markdown]
-- Technicky vzato má každá funkce v Haskellu vždy právě jeden parametr a právě jeden výsledek. S tím by se nepracovalo příliš prakticky, využíváme proto (stejně jako v lambda kalkulu) tzv. **currying**. Podrobněji se na význam tohoto principu podíváme později, zatím se můžeme tvářit, že funkce může mít i víc parametrů:

-- %%
weirdOp x y = x * y - 2 + x

-- %%
weirdOp 5 23

-- %% [markdown]
-- Kdybychom něco takového chtěli napsat v lambda kalkulu, vypadalo by to asi takhle:
-- $$
-- weirdOp \equiv \lambda xy. x \cdot y - 2 + x
-- $$
-- Vzpomeňte, že ani v lambda kalkulu ve skutečnosti neexistují funkce o více parametrech, ve skutečnosti jde o lambda abstrakci, která vytváří další lambda abstrakci:
-- $$
-- weirdOp \equiv \lambda x.(\lambda y. (x \cdot y - 2 + x))
-- $$
-- Jak uvidíme do detailu v dalších cvikách, přesně takhle to funguje i v Haskellu.
--
-- ---
--
-- Máme dva způsoby zápisu funkcí: prefixový a infixový. V prefixovém zápisu se funkce, kterou budeme aplikovat, píše před argument (stejně jako výše `minusFive 19` nebo `weirdOp 5 23`). Infixové funkce jsou vlastně operátory:

-- %%
1 + 3
4 - 6
10 / 3
2 * 8

-- %% [markdown]
-- Infixové funkce se dají použít prefixovým způsobem takhle:

-- %%
(/) 10 5

-- %% [markdown]
-- A „binární funkce“ (později zjistíme, že to ve skutečnosti nejsou binární funkce), se dají infixově použít takhle:

-- %%
5 `weirdOp` 23

-- %% [markdown]
-- Může se to hodit třeba u funkcí pro celočíselné dělení, modulo. Rozdíl `div`/`quot` a `mod`/`rem` souvisí s chováním na záporných číslech, pro nás je to teď nedůležité.

-- %%
10 `div` 3 -- celočíselné dělení
10 `mod` 3 -- modulo
10 `quot` 3 -- celočíselné dělení s zaokrouhlováním k nule
10 `rem` 3 -- zbytek po dělení 

-- %% [markdown]
-- Jednou ze zajímavých věcí, kterou s funkcemi můžeme dělat, je tzv. **částečná aplikace**. Velmi to souvisí s curryingem, takže se k tomu ještě dostaneme, ale vězte, že lze udělat třeba toto:

-- %%
(*10) 6

-- %% [markdown]
-- V podstatě jsme vzali operátor, tedy funkci – a nahradili jsme v ní jen jeden z jejích parametrů konkrétní hodnotou 10. Ta závorka jako balíček pak tedy představuje funkci, která už má jen jeden parametr – a tu jsme aplikovali na hodnotu 6. Podobně bychom mohli takový balíček pojmenovat jako novou funkci:

-- %%
divideTenBy = (10/)
divideTenBy 5

-- %% [markdown]
-- Vidíme, že částečná aplikace jde udělat z obou stran (dosadit buď konkrétní levou, nebo pravou stranu). A když už jsme u toho, není to jen výsadou infixových funkcí. Vzpomeňme na `weirdOp` výše. Můžeme si třeba „předpřipravit“ ještě *užitečnější* funkci tak, že si „předaplikujeme“ pětku:

-- %%
evenWeirderOp = weirdOp 5
evenWeirderOp 23

-- %% [markdown]
-- Zatím to nevypadá příliš užitečně, ale brzy to využijeme!

-- %% [markdown]
-- U infixových operátorů se často hodí znát jejich **precedenci a asociativitu**. K jejich zjištění můžeme v GHCi využít GHCi `:info` (nebo zkráceně `:i`), který funguje i v prostředí Jupyteru:

-- %%
:i (+)
:i (*)

-- %% [markdown]
-- Na výpisů příkazů výše jsou zajímavé řetězce infix**l** 6 a infix**l** 7. L znamená, že jsou oba operátory levě asociativní, a číslo určuje precedenci – prioritu (`*` má vyšší precedenci než `+`, takže `5 + 6 * 3` se vyhodnotí jako `5 + (6 * 3)`, jak bychom čekali). Samozřejmě můžeme vždycky explicitně závorkovat.

-- %% [markdown]
-- **Příklad 5:** Vytvořte funkci `triArea` pro výpočet obsahu trojúhelníku. Použijte ji pro trojúhelník o straně délky 5 a výšce k této straně 4, a to prefixovým i infixovým způsobem. *Poznámka: příklad 4 neexistuje, nehledejte ho.*

-- %%
-- EX05
-- EX05a Funkce:
triArea x y = (x * y) / 2

-- EX05b Použití (prefix):
triArea 5 4

-- EX05c Použití (infix):
5 `triArea` 4


-- %% [markdown]
-- ### Závorkování

-- %% [markdown]
-- Aplikace funkce má nejvyšší prioritu a je zleva asociativní, takže `f a b` je totéž jako `(f a) b`. Závorky jsou proto potřeba vždy, když má být argument složený výraz: 

-- %%
minusFive 0 * 10
minusFive (0 * 10)

-- %% [markdown]
-- Trochu děsivou, ale po pochopení velmi praktickou pomůckou je operátor `$`. Používá se k nahrazení závorek při aplikaci funkce:

-- %%
minusFive $ 0 * 10

-- %% [markdown]
-- Je definován jako `f $ x = f x`, tudíž sám o sobě vlastně vůbec nic nedělá. Podstatné je, že má velmi nízkou prioritu a je zprava asociativní. Díky tomu se `f $ g x y` čte jako `f (g x y)`
--
-- Intuitivně lze $ číst jako „aplikuj funkci vlevo na celý výraz vpravo“ nebo taky „nejprve vyhodnoť všechno, co je ode mě napravo“. Řetězení funguje přirozeně: `f $ g $ h x` znamená `f (g (h x))`.

-- %%
round $ sqrt $ 2^10 + 6^5
sum $ map (^2) $ filter even [1..10]

-- Ekvivalentní, ale se závorkami potenciálně méně čitelné:
round (sqrt (2^10 + 6^5))
sum (map (^2) (filter even [1..10]))

-- %% [markdown]
-- ## Let, where a lambda výrazy

-- %% [markdown]
-- Často se (nejen pro přehlednost) hodí rozbíjet větší výrazy / funkce na menší jednotky. Zároveň ale nechceme z těchto pomocných drobků dělat samostatné funkce, které nemají nikde jinde smysl. Můžeme k tomu použít klíčová slova `let` nebo `where`. Začněme ukázkou:

-- %%
complexCalculation x = x + ((sqrt x^4) * (sqrt x^4)) + (42 - (sqrt x^4))

betterComplexCalculation x = x + (y * y) + (z - y)
    where y = sqrt x^4
          z = 42

-- %%
complexCalculation 3
betterComplexCalculation 3

-- %% [markdown]
-- Vidíme, že `where` naváže (pro účely předcházejícího výrazu) nějaké výrazy na dočasné názvy, což umožní celou funkci zpřehlednit a odstranit zbytečné opakování. S využitím klíčového slova `let` by to vypadalo takhle:

-- %%
betterComplexCalculation' x = let y = sqrt x^4
                                  z = 42
                              in x + (y * y) + (z - y)

-- %%
betterComplexCalculation' 3 

-- %% [markdown]
-- Vidíme, že tady se nejprve deklarují dočasné názvy a až potom následuje samotný výraz ke spočítání. Mezi těmito dvěma klíčovými slovy je jeden zásadní sémantický rozdíl, ale k tomu se dostaneme na cvičení.
--
-- Všimněte si, jak jsou jednotlivé části kódu v obou případech odsazené. **Vyzkoušejte si** různě upravovat mezery kolem `where`/`let`, abyste zjistili, jak je Haskell v některých případech citlivý na odsazení!
--
-- Rozpitvejme trochu, co `let` dělá. Níže máme funkci `simpleCalc`, která počítá `y * 66 + n`, přičemž to `y` si definuje bokem. Co kdybychom chtěli z té funkce osamostatnit pouze ten hlavní výpočet?

-- %%
simpleCalc n = let y = n + 2
               in y * 66

simpleCalcMain y = y * 66  -- hlavní část výpočtu simpleCalc
simpleCalc'    n = simpleCalcMain (n + 2) -- počítá totéž jako simpleCalc

-- zkusíme, zda to dává stejné výsledky
simpleCalc 6
simpleCalc' 6

-- %% [markdown]
-- Takhle jsme `simpleCalc` rozbili na hlavní výpočet, do kterého pak vstupuje nějaké pomocné `y` jako parametr. Kdybychom kvůli tomu nechtěli definovat globální název `simpleCalcMain`, můžeme použít **lambda funkci**:

-- %%
simpleCalc'' n = (\y -> y * 66) (n + 2)
simpleCalc'' 6

-- %% [markdown]
-- *Poznámka: zamyslete se nad upozorněním „Avoid lambda using infix“, které zde překladač vypíše. Vidíte, že překladač se snaží vás vést k psaní „hezčího“ kódu nahrazováním zbytečně ukecaných výrazů kompaktnějšími variantami, které mají stejnou sémantiku.*
--
-- Povšimněte si, že `(\y -> y * 66)` reprezentuje přesně tu samou funkci jako předtím `simpleCalcMain` – má jeden parametr `y` a tělo `y * 66`. Dokonce bychom mohli alternativně (pro trénink) zadefinovat `simpleCalcMain` (resp. jakoukoliv funkci) takto:

-- %%
simpleCalcMain' = \y -> y * 66

-- %% [markdown]
-- Po provedení buňky nebo ve VSCode vidíme, že to takhle nemáme dělat (je to syntakticky nepěkné), ale sémantika je opravdu stejná. Tímto způsobem tedy můžeme vytvářet nepojmenované funkce kdekoliv v kódu. Pokud bychom chtěli „funkci o více parametrech“ (curried funkci), stačí parametry oddělit mezerou: `(\x y z -> tělo)`.

-- %% [markdown]
-- **Příklad 6:** Zadefinujte pomocí lambda výrazu funkci ekvivalentní s `complexCalculation`.

-- %%
-- EX06
weirderComplexCalculation x = (\y z -> y + ((sqrt z) * (sqrt z)) + (42 - (sqrt z))) x (x^4)

-- %%
weirderComplexCalculation 3

-- %% [markdown]
-- **Příklad 7:** Zadefinujte funkci simpleCalc pomocí klíčového slova `where`.

-- %%
-- EX07
simpleCalcWhere n = y * 66
    where y = n + 2

-- %% [markdown]
-- ## Typy
--
-- Na závěr si jen velmi lehce přičichneme k typům v Haskellu. Doteď jsme pracovali jen s čísly, ale ta jsou zrovna na vysvětlení poněkud složitější. Asi nejjednodušším typem, se kterým můžeme pracovat, je znak – `Char`:

-- %%
favLetter = 'y'

favLetter

-- %% [markdown]
-- Velmi užitečný je příkaz GHCi (či Jupyter kernelu) `:type` (zkráceně `:t`), který vypíše typ výrazu. Často v Haskellu uvidíte zápis `výraz :: typ` – ty dvě dvojtečky čtěte jako „má typ“.

-- %%
:type favLetter

-- %% [markdown]
-- Můžeme to zkusit třeba i pro funkce. Následující buňka vypíše trochu zaklínadlo – můžete se zkusit zamyslet, co to znamená, ale podrobně si to rozebereme na cviku.

-- %%
:t minusFive
:t weirdOp
:t simpleCalc

-- %% [markdown]
-- Dalším dobře známým typem je `Bool`:

-- %%
:t True
:t False
not True
True || False
True && False
:t True || False

-- %% [markdown]
-- Prakticky pořád budeme v Haskellu pracovat se **seznamy**. Položky seznamu musí mít vždycky stejný typ:

-- %%
someEmptyList = []
someNonEmptyList = [1]
evenNonEmptierList = [True, False, False]

-- %%
:t someEmptyList
:t evenNonEmptierList

-- %% [markdown]
-- Anglický termín pro seznam je *list*. Pozor, hlavně ve zkouškách si dávejte bacha, ať v českých větách místo „seznam“ nepíšete „list“, protože české slovo „list“ označuje nejspodnější uzel stromu, ne seznam.
--
-- Často se hodí taky uspořádané n-tice, anglicky *tuple*. Prvky n-tice mohou být libovolných typů a občas se hodí i prázdné n-tice (believe me).

-- %%
aPair = (True, False, 'h')
aTriplet = (8, simpleCalcMain)
anEmptyTuple = ()

-- %%
:t aPair
:t aTriplet
:t anEmptyTuple

-- %% [markdown]
-- **Příklad 8:** Jaký bude typ výrazu `['a', 'h', 'o', 'j']`? A jaký bude typ výrazu `"ahoj"`? Jde o ekvivalentní výrazy (ano/ne)?

-- %% [raw]
-- -- EX08
-- -- EX08a Typ prvního výrazu:
-- [Char]
--
-- -- EX08b Typ druhého výrazu:
-- String
--
-- -- EX08c ano/ne:
-- ano

-- %% [markdown]
-- ---
-- # Procvičování
-- V této sekci je několik jednoduchých příkladů na procvičování vašeho uvažování nad haskellovým kódem. Zkuste si vždycky na otázky nejprve odpovědět v hlavě a pak si je zkuste opravdu nechat vyhodnotit Haskellem.

-- %% [markdown]
-- Jaký bude výsledek vyhodnocení následujících čtyř výrazů? Nastane v některém z nich chyba?

-- %%
x = 10
goo = x * 5
-- 10 + goo
-- (+10) goo
-- (-) 15 goo
-- (-) goo 15

-- %%
swagUp x = 3 * x
swagDown = (300/)
-- swagUp goo
-- swagDown goo
-- swagUp swagDown goo
-- swagUp $ swagDown goo

-- %% [markdown]
-- Zkuste tento výraz ručně postupně zredukovat (vyhodnotit) s vědomím, jak funguje operátor `$`. \
-- Pak jej přepište do podoby se závorkami.

-- %%
(2^) $ (+2) $ 3*2
(2^) ((+2) (3*2))

-- %% [markdown]
-- Tento výraz není korektní. Zkuste si jej ručně postupně zredukovat, abyste ověřili, že nedává smysl:

-- %%
(2^) $ 2 + 2 $ (*30)
(2^) (4 (30*))
