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
-- # Příprava 2
--
-- Zdravím vás, vítejte u další přípravy do FLP. Dnes budeme pokračovat poutí typovým systémem, kterou jsme odstartovali na cviku, a pronikneme do tajů *pattern matchingu*, díky kterému začneme konečně psát nějaké pořádné funkce. Pro začátek si ale dovolím zopakovat pár pojmů z cvika a doplním několik věcí, které jsem na cviku nestihl.
--
-- Instrukce:
-- - V buňkách, které začínají komentářem `-- EX[N]` a kterým předchází text označený jako „**Příklad N:**“, se očekává vaše řešení zadané úlohy.
-- - Je zásadní, abyste z odpovědních buněk **nemazali** žádné komentáře `-- EX[N]`, jinak nebude úloha při automatickém testování nalezena a nebude ohodnocena!
-- - Některé buňky začínají textem „**Cvičení:**“. V nich se nachází **ne**hodnocené příklady k vašemu zamyšlení a procvičení. Samozřejmě vás ne(do)nutím je dělat, ale doporučoval bych to.
-- - Buňky můžete vyhodnocovat pomocí Shift+Enter.
-- - Abyste z toho něco měli, zkuste si ale **před samotným spuštěním každé buňky nejprve rozmyslet, co ta buňka vypíše!** U zkoušky (a někdy i v životě) nebudete mít po ruce ani překladač, ani ChatGPT – tímhle se to nejlíp trénuje.
-- - Pokud vám něco nebude jasné, ozvěte se. Za dobré dotazy nebo upozornění na chyby v přípravě rozdávám drobné bonusové body.
--
-- ---

-- %% [markdown]
-- **Každý** výraz v Haskellu má nějaký **typ** a nějakou **hodnotu**:

-- %%
val = True -- hodnota
:t val -- typ

val = "ahoj" -- hodnota
:t val -- typ

val = take -- funkce je taky hodnota
:t val -- typ

-- %% [markdown]
-- Mimochodem, viděli jsme i jednu výjimku. Existují i *nedefinované výrazy*, jako třeba `head []` – ty stále mají typ, ale nemají hodnotu, a proto pokus o vyhodnocení končí chybou. Někdy se říká, že tyto výrazy bez hodnoty jsou „bottom“, značí se jako $\bot$, tedy můžeme obrazně říct, že `head [] = ⊥` (korektněji: výraz `head []` *značí* $\bot$).

-- %%
:t head []
head []

-- %% [markdown]
-- Při definici funkcí se snažíme o co nejvyšší „míru abstrakce“ – chceme, aby byly funkce pokud možno univerzální. Proto třeba funkce `(++)`, která spojuje dva seznamy, nemá typ např. `[Char] -> [Char] -> [Char]`, ale:

-- %%
:t (++)

-- %% [markdown]
-- Kdybychom chtěli signaturu explicitně uzávorkovat, dostali bychom `[a] -> ([a] -> [a])`. Funkce v Haskellu mají právě jeden parametr. Pokud se chceme tvářit, že jich má víc, ve skutečnosti jde o funkci, která vytvoří další funkci. (Side quest: najděte v centru Prahy *gift shop*, který neprodává matrjošky. Funkce v Haskellu jsou takové matrjošky.) Tomuto principu se říká **currying**.
--
-- V typové signatuře je místo konkrétního typu (poznáme tak, že začíná velkým písmenem) použita tzv. **typová proměnná** `a`. Ta značí „na tomto místě může být libovolný typ“, ovšem když je v jedné signatuře to `a` víckrát, samozřejmě pak bude muset na všech místech být stejný typ. Signatura `(++)` tedy říká „vezmu seznam libovolného typu, pak vezmu další seznam *toho samého* typu a vrátím seznam *toho samého* typu. Pokud bych `(++)` částečně aplikoval – aplikoval na jeden argument, výsledkem bude nová funkce:

-- %%
:t ((++) "someStr")

-- %% [markdown]
-- Všimněme si, že zde už typová proměnná není. Původní `(++)` mělo typ `[a] -> (něco)`. Ve výrazu `(++) "someStr"` (jehož výsledek bude mít ten typ `(něco)`) tedy Haskell zjistil, že `a` bude odpovídat typu `Char`. Nu a to `(něco)` bylo původně `([a] -> [a])`, takže Haskell doplní `Char` na místa `a` i tady. Dává to smysl: pomocí `(++) "someStr"` jsme „zapekli do funkce `(++)` jako první argument řetězec“, tudíž výsledná funkce už může připojit opět jen řetězec, a ne třeba seznam čísel.

-- %% [markdown]
-- **Cvičení:**
-- 1. Nechť existuje funkce `f :: a -> a -> a -> a` a konstanta `x :: Char`. Co bude typem `f x`?
-- 2. Nechť existuje `g :: a -> b -> c -> b`. Co bude typem `g 0 'c' "hello"`?

-- %% [markdown]
-- Zde je ještě jedna demonstrace toho, jak postupně aplikací hodnot zužujeme typ celého výrazu.

-- %%
-- obecná definice (==)
(==)     :: Eq a => a      -> a      -> Bool
-- nyní řekněme, že budeme chtít porovnávat řetězce
-- tento řádek je jen demonstrativní – představme si ho jako něco, co si
-- Haskell pro nějaký konkrétní případ může interně vyvěštit
(==)             :: [Char] -> [Char] -> Bool
(==) "cat"       ::           [Char] -> Bool
(==) "cat" "cat" ::                     Bool

-- %% [markdown]
-- ### Typové třídy
--
-- Velmi často ale nemůžou naše funkce pracovat s úplně libovolným typem. Uvažme třeba funkci numerického sčítání `(+)`. Ta jistě nemůže být definovaná pomocí jednoho konkrétního typu, protože můžeme chtít sčítat dvě hodnoty `Int` nebo dvě hodnoty `Float`. Zároveň ale nemůžeme říct, že `(+) :: a -> a -> a`, protože bychom pak mohli psát třeba `True + False + True`... a to nezní příliš numericky. Z tohoto důvodu umožňuje Haskell *omezovat* typové proměnné pomocí **typových tříd**.

-- %%
:t (+)

-- %% [markdown]
-- V typové signatuře `(+)` sice tu část `a -> a -> a` vidíme, ale zároveň jí předchází část `Num a =>`. Ta říká, že typ `a` musí být instancí typové třídy `Num`. Ve zkratce – typová třída definuje, že pro její instance musí být definovány nějaké funkce.

-- %%
:i Num

-- %% [markdown]
-- Z informací o typové třídě `Num` vyčteme, že pokud má být jistý typ `a` instancí `Num`, pak pro něj musí existovat (resp. bude existovat) implementace funkcí `(+)`, `(-)`, `(*)`, `negate`, `abs`, `signum` a `fromInteger`. Níže pak vyčteme, že instancemi této typové třídy jsou typy `Double`, `Float`, `Int`, `Integer` a `Word`. Typové třídy se podobají *rozhraním* z objektově orientovaných jazyků.

-- %% [markdown]
-- #### Porovnávání
-- Snad vás nepřekvapí, že v Haskellu najdete standardní porovnávací operátory:

-- %%
x :: Int
x = 10

x == 10
x > 6
x < 2
x /= 10

-- %% [markdown]
-- Taky už asi čekáte, že porovnávací operátory taky nebudou definovány pro jeden konkrétní typ:

-- %%
:t (<)
:t (<=)

-- %% [markdown]
-- Tyhle typové signatury říkají `<` i `<=` jsou funkce, které pracují s téměř libovolným typem `a` – omezený je tak, že musí být instancí typové třídy `Ord`. Když ji pomocí následujícího příkazu prozkoumáme, hned na začátku uvidíme, jaké funkce musí všechny porovnatelné typy definovat. Níže pak uvidíme dloouhý seznam různých typů ze standardní knihovny, které jsou porovnatelné.

-- %%
:i Ord

-- %% [markdown]
-- Zajímavá je hned první požadovaná funkce: `compare :: a -> a -> Ordering`. Jde o funkci, která vezme dvě hodnoty nějakého stejného typu `a` (který je `Ord`!) a vrátí hodnotu typu `Ordering`. Podívejme se, co je tedy `Ordering` (pozn.: začíná to velkým písmenem $\rightarrow$ je to typ $\rightarrow$ používáme `:i`):

-- %%
:i Ordering

-- %% [markdown]
-- Důležitý je druhý řádek: `data Ordering = LT | EQ | GT`. Jde tedy o jednoduchý výčtový typ, který definuje tři možné datové hodnoty `LT`, `EQ` a `GT`. `compare` tedy jednoduše vyhodnotí uspořádání dvou hodnot.

-- %%
compare 123 789
compare True False
compare 'a' 'a'

-- %% [markdown]
-- Poznámka: V tom výpisu `:i Ord` výše je každé `a` nutně `Ord`, protože se díváme na výpis pro třídu `Ord`! Proto v popisu té funkce `compare` výše už není znovu napsané `Ord a =>`. Kdybychom použili `:t compare`, bude tam na začátku i ta část `Ord a =>`.

-- %% [markdown]
-- Zajímavý je také hned druhý řádek z výpisu: `class Eq a => Ord a where`. Ten říká, že každý typ `a`, který má být `Ord`, musí být nejprve `Eq`. Tohle se tedy zase lehce podobá jakési dědičnosti v OO jazycích. `Eq` je typová třída, která říká, že její instance podporují operátor `(==)` (a taky `(/=)`. Následující výpis bude opravdu dlouhý, protože porovnávat lze _skoro všechno_ – ale ne všechno (např. porovnávat funkce nedává příliš smysl).

-- %%
:i Eq

-- %% [markdown]
-- **Příklad 1:** Napište funkci `isPalindrome` (vč. typové anotace!), která řekne, zda je daný seznam palindrom (stejný odpředu i odzadu). Využijte k tomu vestavěnou funkci `reverse`. V komentáři pod funkcí pak slovy „převyprávějte“ typovou anotaci (jako byste ji někomu četli) a přitom **stručně** vysvětlete, proč tam jednotlivé části musí být.

-- %%
:t reverse
reverse "ahoj"

-- %%
-- EX01
isPalindrome :: Eq a => [a] -> Bool
isPalindrome x = x == reverse x
-- funkce má jeden parametr v podobě seznamu položek libovolného typu, který lze porovnat a výsledkem je pravdivostní hodnota

-- %% [markdown]
-- Pro zajímavost, `Ord` implementují i typy `Bool` a `[a]`:

-- %%
True > False
[2, 1] > [1, 1]

-- %% [markdown]
-- Typově je to s těmi seznamy složitější. Aby dávalo smysl porovnávat seznamy, musí být porovnatelné i jejich prvky. Někde v tom předchozím výpisu `:i Ord` byste proto našli řádek:
--
-- `instance Ord a => Ord [a] -- Defined in ‘GHC.Classes’`
--
-- Ten se dá přečíst jako: „Instancí `Ord` jsou seznamy `[a]` s prvky jakéhokoliv typu `a`, který je ale omezený tím, že sám musí být `Ord`.“ (A proto tedy můžeme tyto seznamy porovnávat, jupí.)

-- %% [markdown]
-- Proč jsou třídy `Eq` a `Ord` zvlášť? Některé věci mohou jít testovat na rovnost, ale není mezi nimi uspořádání. Příkladem takové věci jsou třeba komplexní čísla:

-- %%
import Data.Complex
:i Complex

-- %%
(3 :+ 1) == (3 :+ 1)
(3 :+ 1) > (3 :+ 1)

-- %% [markdown]
-- **Příklad 2:**
-- - a) Nechť existuje funkce `h :: (Num a, Num b) => a -> b -> b`. Co bude typem `h 1.0 2`?
-- - b) Co bude typem `h 1 (6.2::Double)`?
-- - c) Nechť existuje funkce `j :: (Ord a, Eq b) => a -> b -> a`. Co bude typem `j "hello"`?
-- - d) Nechť existuje funkce `k :: (Ord a, Num b) => a -> b -> a`. Co bude typem `k 1 (2::Integer)`?
-- - e) Co bude typem `k (1::Integer) 2`?

-- %% [raw]
-- -- EX02
-- -- EX02a
-- Num b => b
--
-- -- EX02b
-- Double
--
-- -- EX02c
-- Eq b => b -> String
--
-- -- EX02d
-- Integer
--
-- -- EX02e
-- Num b => Integer

-- %% [markdown]
-- #### Polymorfismus
--
-- Slovo _polymorfismus_ – krásný český obrozenecký termín by mohl být „mnohopodobenství“ – je všeobjímající termín pro různé mechanismy, které umožňují zdánlivě jedné věci přisuzovat různé formy chování. V Haskellu se dá konkrétněji říct, že hodnota je polymorfní, pokud může mít více různých typů.
--
-- Haskell využívá dva druhy polymorfismu. **Parametrický** polymorfismus znamená jednoduše to, že se nám mohou někde v typových signaturách hodnot objevovat neomezené „typové proměnné“. Například funkce identity:

-- %%
:t id

-- %% [markdown]
-- je opravdu „brutálně polymorfní“ – pracuje s hodnotou úplně libovolného typu (označen jako `a`). Obecněji už to nejde – a to je dobré, protože díky tomu je tahle funkce velmi univerzální.
--
-- Naopak, pokud by někdo akceptoval jako svou hodnotu třeba konkrétní typ (`Char -> Char`), můžu mu poslat tuto funkci `id`, protože typový systém je schopen dosadit na místa těch `a` cokoliv, tedy i právě `Char`, čímž mu požadované `Char -> Char` vznikne:

-- %%
-- tahle funkce požaduje jako svůj parametr funkci (Char -> Char) a vrací Char
makeNiceBeautifulChar :: (Char -> Char) -> Char
-- funguje tak, že tu funkci, kterou dostane, aplikuje na hodnotu 'a'
makeNiceBeautifulChar f = f 'a'

-- tahle funkce vyrábí z jednoho Charu druhý Char
someMappingCharFn :: Char -> Char
-- funguje tak, že se podívá na hodnotu argumentu x
-- a pokud je menší než 'd', vrátí 'b', jinak vrátí 'u'
someMappingCharFn x = if x < 'd' then 'b' else 'u'

-- zde vyhodnocuji makeNiceBeautifulChar s tím, že jí jako argument posílám funkci someMappingCharFn
-- z typových signatur přímo vidím, že to funguje – mNBC vyžaduje argument typu (Char -> Char)
-- a sMCF je přesně taková funkce
makeNiceBeautifulChar someMappingCharFn
-- zde ale posílám to mNBC funkci typu (a -> a). Díky svému neomezenému parametrickému polymorfismu
-- ale i takovou funkci mohu poslat někomu, kdo očekává (Char -> Char)
makeNiceBeautifulChar id

-- %% [markdown]
-- Jistým důsledkem tohoto jevu je, že ta hodnota (funkce) nic *neví* o typu, se kterým pracuje, a proto se taky musí chovat pro všechny možné typy **úplně stejně** (tomu se říká *parametricita*). To je ale zároveň hodně omezující: funkce se signaturou `a -> a` v zásadě nemůže vypadat nijak jinak než právě identita. Mám tedy ohromně univerzální funkci, která pracuje s hodnotou libovolného typu, ale množina věcí, které s ní může udělat, je velmi úzká.

-- %%
sadFn :: a -> a
sadFn x = x -- co můžu na tomhle místě napsat?
-- o "x" nevím VŮBEC NIC – netuším, jaké operace s tím jdou dělat,
-- když to může být úplně jakýkoliv typ... jenže mým výsledkem musí být hodnota
-- toho samého typu, takže jediné, co zmůžu, je, že vrátím to, co jsem dostal :/

-- %% [markdown]
-- _Poznámka pro korektnost a fanoušky teoretické informatiky:_ Tvrzení výše (a to v následujícím příkladu) je poněkud zjednodušené. Platí jen v případě, že uvažujeme úplné funkce, tj. funkce, které nemohou vrátit *bottom*. Kvůli/díky inherentní _laziness_ Haskellu, možnostem donutit něco vyhodnotit striktně a existenci ne-hodnoty *bottom* existuje ještě pár implementací funkce `a -> a`, které se při vyhodnocení budou lišit v zásadě podle toho, kdy se na *bottom* přijde. To zatím ale vůbec nemusíte řešit.

-- %% [markdown]
-- **Příklad 3:** Pokud řeknu, že funkce má typovou signaturu `a -> a -> a`, aniž bych o typu `a` řekl cokoliv dalšího, můžou existovat právě dvě implementace takové funkce. Napište je:

-- %%
-- EX03
-- EX03a
tightFun1 :: a -> a -> a
tightFun1 x y = x
-- EX03b
tightFun2 :: a -> a -> a
tightFun2 x y = y

-- %% [markdown]
-- **Příklad 4:** Podle typové anotace doplňte funkci `f`. Využijte funkce `fst`/`snd`, které vrací první/druhý prvek z dvojice.

-- %%
-- Demonstrace
:t fst
:t snd
fst (7889, 53)

-- %%
-- EX04
f :: (a, b) -> (c, d) -> ((d, b), (a, c))
f x y = ((snd y, snd x), (fst x, fst y))

-- %%
-- Pro ověření – musí vyjít True
f (10, 20) (70, 60) == ((60, 20), (10, 70))

-- %% [markdown]
-- Typové třídy vnášejí do Haskellu tzv. **ad-hoc polymorfismus** (nebo taky polymorfismus s omezeními). Tento termín označuje skutečnost, kdy nějaká hodnota může nabývat různých typů, protože někde existuje definice říkající, jak se má pro konkrétní typy ta hodnota chovat. Díky nim tedy sice omezujeme množinu typů, se kterými může (třeba) funkce pracovat, ale naopak výrazně zvětšujeme množinu oprací, které s ní můžeme dělat. Typovou proměnnou mohu omezit mnoha typovými třídami – např. můžu říct, že chci, aby moje funkce funovala s čímkoliv, co jde porovnat a zobrazit (resp. převést na String):

-- %%
myFn :: (Eq a, Show a) => a -> a -> String
myFn x y = if x /= y 
           then show x 
           else "they're the same"

myFn 13 18
myFn 13 13
myFn "ahoj" "neahoj"

-- %% [markdown]
-- Efekty typových tříd se tedy „sčítají“ – čím víc mám omezení, tím víc operací s těmi hodnotami můžu dělat. Zde jsem porovnával a zobrazoval. Kdybych z typové anotace smazal `Show a`, skončí to chybou – zkuste to.

-- %% [markdown]
-- **Příklad 5:** Podívejte se na následující typové signatury. K jednotlivým typům určete, jestli jde o (plně) polymorfní typovou proměnnou (PAR), omezenou polymorfní typovou proměnnou (CONSTR), nebo o konkrétní typový konstruktor (TYP). Příklad: `f :: Num a => a -> b -> Int -> Int`, odpověď: `CONSTR -> PAR -> TYP -> TYP`
-- - a) `f :: woo -> Woo -> Hah`
-- - b) `f :: Enum b => a -> b -> c`
-- - c) `f :: f -> g -> C`
-- - d) `f :: (Ord a, Enum b) => a -> b -> c -> Int -> a`

-- %% [raw]
-- -- EX05
-- -- EX05a
-- PAR -> TYP -> TYP
--
-- -- EX05b
-- PAR -> CONSTR -> PAR
--
-- -- EX05c
-- PAR -> PAR -> TYP
--
-- -- EX05d
-- CONSTR -> CONSTR -> PAR -> TYP -> CONSTR

-- %% [markdown]
-- #### Instance typových tříd
--
-- Typová třída definuje, jaké **operace** musí být pro nějaký typ definovány, aby tento typ mohl být považován za instanci této typové třídy. **Instance typové třídy** je konkrétní způsob, jakým nějaký typ implementuje typovou třídu. Ve standardním Haskellu (mimo nějaká rozšíření překladače) stačí uvažovat, že pro jeden typ může existovat maximálně jedna instance jisté typové třídy. Demonstrujeme to na příkladu.
--
-- Níže si vytvářím vlastní datový typ `Trivial`, který má právě jednu možnou hodnotu `TrivialVal` (není to příliš užitečný typ):

-- %%
data Trivial = TrivialVal

-- %% [markdown]
-- Asi dává smysl, aby platilo, že `TrivialVal == TrivialVal`. To ale teď udělat nemůžeme, protože už víme, že `(==)` je definováno pro typovou třídu `Eq`:

-- %%
:t (==)

-- %% [markdown]
-- jenže náš vlastní typ nemá instanci Eq:

-- %%
:i Trivial

TrivialVal == TrivialVal

-- %% [markdown]
-- Nyní tedy vytvoříme instanci `Eq` pro náš typ, ve které zadefinujeme funkci (==) konkrétně pro tento typ:

-- %%
instance Eq Trivial where
  (==) TrivialVal TrivialVal = True

-- %% [markdown]
-- Ověřme, že teď už instance `Eq` pro `Trivial` existuje:

-- %%
:i Trivial

-- %% [markdown]
-- A nyní už bude fungovat (==):

-- %%
TrivialVal == TrivialVal

-- %% [markdown]
-- Sledujme ale, že funguje i operátor /=, který jsme nikde nezadefinovali:

-- %%
TrivialVal /= TrivialVal

-- %% [markdown]
-- Typové třídy totiž mohou definovat výchozí implementace funkcí. Když si znovu spustíte `:i Eq`, uvidíte tam řádek `{-# MINIMAL (==) | (/=) #-}`. Ten určuje _minimální nutnou implementaci_: říká, že stačí, aby instance zadefinovala buď `(==)`, nebo `(/=)`. Typová třída `Eq` je ve standardní knihovně definována (+-) takhle – povšimněte si, že výchozí implementace se pro ty dvě funkce používají navzájem, z čehož logicky vyplývá, že instance (implementace pro konkrétní typ) musí aspoň jednu z nich nahradit něčím rozumným.
--
-- ```haskell
-- class Eq a where
--     (==)  :: a -> a -> Bool
--     (/=)  :: a -> a -> Bool
--
--     x /= y  = not (x == y)
--     x == y  = not (x /= y)
--     {-# MINIMAL (==) | (/=) #-}
-- ```

-- %% [markdown]
-- Poznámka: výše jsem přirovnával typové třídy k rozhraním v OO jazycích. Je to pěkná paralela, taky jde o typ polymorfismu, ale zároveň jsou mezi tím značné rozdíly. Pokud máte nějakou elementární znalost Javy, C# nebo obdobných jazyků, přečtěte si prosím [**tento krátký článek**](https://diogocastro.com/blog/2018/06/17/typeclasses-in-perspective/), který ty rozdíly na příkladech pěkně demonstruje.

-- %% [markdown]
-- ### Píšeme funkce
--
-- Teď se chvíli přestaneme brodit typovým systémem a podíváme se na různé syntaktické prostředky, které potřebujeme, abychom v tom jazyce byli schopni něco rozumného napsat.

-- %% [markdown]
-- #### if, then, else
-- I ve světě vyhodnocování funkcí dává smysl konstrukce pokud něco – pak použij tento výraz – jinak použij tento výraz:

-- %%
if True then "gde" else "body"

-- %% [markdown]
-- Je dobré si uvědomit, že to celé je zase jenom výraz, který „vrací“ hodnotu (lépe „vyhodnotí se“). To taky znamená, že část *then* i část *else* musí být přítomny a musí být stejného typu.
--
-- Mohli bychom to celé obalit do funkce:

-- %%
ifFun :: Bool -> a -> a -> a
ifFun cond a b = if cond then a else b

-- %%
ifFun True "gde" "body"
ifFun False "gde" "body"

-- %% [markdown]
-- **Cvičení:** Co se stane, když v typové signatuře funkce `ifFun` změním `Bool` za `a`?

-- %% [markdown]
-- #### Pattern matching
--
-- Jedním z důležitých a zcela nepostradatelných vyjadřovacích mechanismů Haskellu je **pattern matching**. Díky němu jsme schopni efektivně definovat (mimo jiné) funkce, které se chovají různě podle konkrétní datové hodnoty. Vzpomeňte na cviko, kde jsem definoval vlastní typ podobný `Bool` a pro něj potom negační funkci `not`:

-- %%
data MyBool = MyTrue | MyFalse deriving Show
     -- typový konstruktor
              -- datové konstruktory

not' :: MyBool -> MyBool
not' MyTrue = MyFalse
not' MyFalse = MyTrue

not' MyTrue

-- %% [markdown]
-- Vidíte, že funkci `not'` nedefinuju „matematicky“ ve tvaru `not' x = (něco, co pracuje s x)`. Místo toho na místě „proměnné“ v definici funkce používám už konkrétní „datovou hodnotu“ a v podstatě definuju funkci `not'` dvakrát: jednou pro případ, kdy je datová hodnota na místě prvního parametru `MyTrue`, a podruhé pro případ, kdy tam přijde `MyFalse`.
--
-- Tohle je přesně pattern matching – když se snaží Haskell vyhodnotit výraz `not' MyTrue`, dívá se na všechny definice funkce `not'` a snaží se na ně vyhodnocovaný výraz „napasovat“ *(it tries to match the pattern)*. Podobně to funguje i s jinými typy dat:

-- %%
isTwo :: Int -> Bool
isTwo 2 = True
isTwo _ = False

-- %%
isTwo 42
isTwo 2

-- %% [markdown]
-- Použil jsem zde speciální vzor `_`, který říká „jakákoliv hodnota“. Je důležité vždycky pokrýt **všechny možné případy**. Pokud na nějaký zapomeneme, vytvořili jsme _nedefinovaný výraz_, jehož ne-hodnotou bude bottom:

-- %%
isTwo' :: Int -> Bool
isTwo' 2 = True

-- %%
isTwo' 2

-- %%
isTwo' 3  -- vyhodí výjimku

-- %% [markdown]
-- Pattern matching se pokouší „přikládat“ naši hodnotu na definice v jejich pořadí. Pokud tedy nejprve nadefinuju funkci pro catch-all vzor `_`, budou všechny ostatní definice k ničemu:

-- %%
isTwo'' :: Int -> Bool
isTwo'' _ = False
isTwo'' 2 = True

-- %%
isTwo'' 2

-- %% [markdown]
-- #### Pattern matching proti datovým konstruktorům

-- %% [markdown]
-- Hlavním důvodem k použití pattern matchingu je schopnost vytahovat data ze složených datových typů... tudíž si musíme první vysvětlit, co jsou složené datové typy. Už tady párkrát padl termín „datový konstruktor“, ale zatím jsme pracovali jen s jednoduššími typy, které vypadaly jako výčet hodnot, takže to nevypadalo, že se tam něco _konstruovalo_. Pojďme to změnit:

-- %%
-- tohle je jednoduchý „výčtový“ typ: definuje čtyři datové konstruktory, které nenesou žádná další data
data Planet = Mercury | Venus | Earth | Mars -- ain't got no time for more planets
    deriving (Show, Eq)  -- drahý překladači, prosím, vyvěšti mi, jak mohu hodnoty typu Planet reprezentovat
                         -- jako řetězce a jak je mohu porovnávat, abych to nemusel psát ručně

-- tento typ Inhabitant má jeden datový konstruktor Human, 
-- který je složený ze dvou kousků dat – jednoho typu Planet a jednoho typu String
-- první položka značí planetu, kterou konkrétní Human obývá,
-- druhá položka značí třeba jméno
data Inhabitant = Human Planet String
    deriving (Show, Eq)

-- %% [markdown]
-- Teď už je možná trochu víc vidět, proč se tomu říká datový *konstruktor*. Ve skutečnosti jde totiž o jakousi funkci, která vytváří datové hodnoty – připomíná to instance nějakých struktur:

-- %%
leo :: Inhabitant
leo = Human Earth "LeO"

weirdo :: Inhabitant
weirdo = Human Mars "Elon"

leo
weirdo

-- %% [markdown]
-- Můžeme se podívat i na typ toho datového konstruktoru `Human` – vidíme, že se opravdu chová jako funkce, která vezme nejprve hodnotu typu `Planet`, pak hodnotu typu `String` a vrátí hodnotu typu `Inhabitant`:

-- %%
:t Human

-- %% [markdown]
-- A jak se nyní dá uvnitř funkcí s takovou „složenou“ datovou hodnotou pracovat? Můžeme z ní vytáhnout konkrétní hodnoty právě pomocí pattern matchingu (ten je v buňce „podtržený“):

-- %%
humanName :: Inhabitant -> String
humanName (Human _ name) = name
--        --------------

humanName leo

-- %% [markdown]
-- Pokud vám není jasné, co se tady teď stalo, zkuste si pod sebe napsat definici té funkce a definici konkrétní hodnoty, která je navázaná na název `leo`:
-- ```haskell
-- humanName (Human  _      name ) = name
--           (Human  Earth  "LeO")
--
-- ```
-- Mechanismus pattern matchingu tedy vezme hodnotu `(Human Earth "LeO")` a pokusí se ji _přiložit_ na vzor určený definicí funkce. Vypadne mu z toho, že vnitřní hodnotu `Earth` má navázat na `_` (čili zahodit) a hodnotu `LeO` má **navázat na proměnnou** `name`. S touto proměnnou pak může uvnitř těla funkce normálně pracovat.

-- %%
nameLen :: Inhabitant -> Int
nameLen (Human _ name) = length name

nameLen weirdo

-- %% [markdown]
-- Samozřejmě nemusím vázat ty vnitřní hodnoty na proměnné, ale můžu definovat i vzory s konkrétními hodnotami:

-- %%
isLeO :: Inhabitant -> Bool
isLeO (Human _ "LeO") = True
isLeO _ = False

isLeO leo
isLeO weirdo

-- %% [markdown]
-- Povšimněte si, že i když definuju catch-all vzor `isLeO _`, nemůžu tu funkci vyhodnotit s něčím úplně nesmyslným:

-- %%
isLeO 1023

-- %% [markdown]
-- Stále zde funguje typový systém – na místě parametru funkce `isLeO` nemůže být hodnota žádného jiného typu než `Inhabitant`.

-- %% [markdown]
-- **Příklad 6:** Nadefinujte funkci `isEarthling`, která vrátí `True`, pokud jí předám datovou hodnotu `Human` s hodnotou první vnořené položky `Earth`.

-- %%
-- EX06
isEarthling :: Inhabitant -> Bool
isEarthling (Human Earth _) = True
isEarthling _ = False

-- %% [markdown]
-- #### Více datových konstruktorů!
--
-- Už jsme viděli, že pomocí vlastních datových typů (definovaných pomocí `data`) můžeme vyjádřit výčty (jeden typ, mnoho různých jednoduchých hodnot) a nějaké složené struktury (jeden typ, jehož instance nesou nějaká další vnořená data).

-- %%
data Planet = Mercury | Venus | Earth | Mars
    deriving (Show, Eq)

data Inhabitant = Human Planet String
    deriving (Show, Eq)

-- %% [markdown]
-- Snad vás tedy nepřekvapí, že ve skutečnosti může jeden typ (`Inhabitant`) nabývat různých „druhů“ datových instancí, kde každý z nich může mít úplně jiný tvar:

-- %%
data Inhabitant = Human Planet String | InterplanetaryQuantumFlower Planet Planet Int
    deriving (Show, Eq)

-- %%
Human Mercury "Dave"
InterplanetaryQuantumFlower Venus Mars 45567

-- %% [markdown]
-- Haskell nám takto dovoluje elegantně definovat i složité datové struktury. Zkuste si jen představit, jak byste něco takového definovali třeba v C:
--
-- ```c
-- typedef enum {
--   INHABITANT_HUMAN,
--   INHABITANT_IQF
-- } InhabitantType;
--
-- typedef struct {
--   Planet planet;
--   const char *name;
-- } InhabitantHuman;
--
-- typedef struct {
--   Planet planetA;
--   Planet planetB;
--   int flowerIdentifier;
-- } InhabitantInterplanetaryQuantumFlower;
--
-- typedef struct {
--   InhabitantType type;
--   union { 
--     InhabitantHuman human; 
--     InhabitantInterplanetaryQuantumFlower iqf;
--   } data;
-- } Inhabitant;
-- ```
--
-- Nehledě na skutečnost, že byste při každém použití hodnoty typu `Inhabitant` prováděli nějakou kontrolu typu `if (inh.type == INHABITANT_HUMAN) { ... } else if (inh.type == INHABITANT_IQF) { ... }` – a nedejbože, kdybych chtěl později přidat nějakou třetí variantu a někde zapomněl přidat další elseif. V Haskellu použiju pattern matching:

-- %%
inhabitantIdentifier :: Inhabitant -> String
inhabitantIdentifier (Human _ name) = name
inhabitantIdentifier (InterplanetaryQuantumFlower _ _ fid) = show fid

inhabitantIdentifier $ Human Mercury "Dave"
inhabitantIdentifier $ InterplanetaryQuantumFlower Venus Mars 45567

-- %% [markdown]
-- Co kdybychom chtěli uvnitř `inhabitantIdentifier` použít i celou původní hodnotu `Inhabitant`, kterou funkce dostala – třeba abychom ji mohli nejprve předat někam dál?

-- %%
inhabitantPrefix :: Inhabitant -> String
inhabitantPrefix (Human _ _) = "this is a hooman: "
inhabitantPrefix (InterplanetaryQuantumFlower p1 p2 _) 
    = "this is a " ++ show p1 ++ "/" ++ show p2 ++ " quantum plant: "

-- %% [markdown]
-- Jednoduchým řešením by bylo znovu si ji poskládat:

-- %%
inhabitantIdentifier2 :: Inhabitant -> String
inhabitantIdentifier2 (Human p name)
    = inhabitantPrefix (Human p name) ++ name
    
inhabitantIdentifier2 (InterplanetaryQuantumFlower p1 p2 fid) 
    = inhabitantPrefix (InterplanetaryQuantumFlower p1 p2 fid) ++ show fid

inhabitantIdentifier2 $ Human Mercury "Dave"
inhabitantIdentifier2 $ InterplanetaryQuantumFlower Venus Mars 45567

-- %% [markdown]
-- To je ale dost ošklivé. Zaprvé musíme psát to samé dokola, zadruhé musíme definovat proměnné pro všechny podhodnoty našich dat, i když je vlastně v naší funkci nepotřebujeme. Hezčím řešením je celý vzor „pojmenovat“ pomocí syntaxe `promenna@(vzor)`:

-- %%
inhabitantIdentifier3 :: Inhabitant -> String
inhabitantIdentifier3 h@(Human _ name) 
    = inhabitantPrefix h ++ name
inhabitantIdentifier3 f@(InterplanetaryQuantumFlower _ _ fid)
    = inhabitantPrefix f ++ show fid

inhabitantIdentifier3 $ Human Mercury "Dave"
inhabitantIdentifier3 $ InterplanetaryQuantumFlower Venus Mars 45567

-- %% [markdown]
-- Vidíte, že Haskell zároveň naváže na proměnnou `h` (či `f`) celou předanou datovou hodnotu a zároveň do proměnných uvnitř vzoru naváže jednotlivé podhodnoty, které potřebujeme.

-- %% [markdown]
-- K definicím datových typů se ještě vrátíme, ale tohle má být hlavně o pattern matchingu. Naznačil jsem tady existenci nějakých složených datových typů, abychom se mohli oklikou vrátit ke standardnímu haskellovému seznamu a k n-ticím. Podívejme se, jak je definovaná dvojice:

-- %%
:i (,)

-- %% [markdown]
-- Z dosavadních znalostí byste už mohli zvládnout dešifrovat ten podstatný druhý řádek:\
-- `data (,) a b = (,) a b`
--
-- Pojďme si tuto definici rozparsovat:
-- - `data (,) a b`: část před `=` definuje typový konstruktor. Tady vidíme kromě názvu typu `(,)` i nějaké typové proměnné: tímhle způsobem právě vyjadřujeme, že uvnitř dvojice se budou vyskytovat hodnoty _nějakých_ dvou libovolných typů `a` a `b`.
-- - `=`: odtud dál už následují datové konstruktory
-- - `(,) a b` definuje jediný datový konstruktor, který je složený z dvou položek – jedna je typu `a`, druhá `b`.
--
-- Povšimněte si, že typový konstruktor se jmenuje stejně jako datový. Tohle je v Haskellu celkem běžné, pokud má typ právě jednu možnou realizaci (ale je to jen konvence, nemá to žádný smysl, naopak to může být trochu matoucí, protože není na první pohled vidět, kde se pracuje s _typy_, a kde s _daty_).
--
-- Kdybychom to nechtěli se syntaktickým cukrem, mohli bychom si úplně stejně definovat vlastní typ pro dvojici:

-- %%
data MyTupleType a b = MyTupleData a b
  deriving (Eq, Ord, Show)

-- případně více „haskellovsky“, kdy jsem stejně pojmenoval typový i datový konstruktor
-- ale pro demonstrační účely níž používám tu předchozí verzi, aby byl rozdíl zřetelnější
data MyTuple a b = MyTuple a b
  deriving (Eq, Ord, Show)

-- %% [markdown]
-- A pomocí pattern matchingu teď můžeme zadefinovat třeba ekvivalenty funkcí `fst`, `snd`, které ze standardních dvojic tahají první, resp. druhý prvek:

-- %%
myFst :: MyTupleType a b -> a
myFst (MyTupleData x _) = x

mySnd :: MyTupleType a b -> b
mySnd (MyTupleData _ y) = y

tup = MyTupleData "ahoj" 2324
myFst tup
mySnd tup

-- %% [markdown]
-- A takhle by to vypadalo, kdybychom chtěli ty funkce zadefinovat pro vestavěné dvojice, ne pro náš typ:

-- %%
myFst :: (a, b) -> a
myFst (x, _) = x

mySnd :: (a, b) -> b
mySnd (_, y) = y

myFst ("ahoj", 2543)

-- %% [markdown]
-- Povšimněte si, že syntaxe typů pro n-tice a datových hodnot pro n-tice je prakticky stejná. Všechno to je ale jen syntaktický cukr, který má přesně stejný význam jako náš `MyTuple` (příp. `MyTupleType`) výše.
--
-- O realizaci seznamů v Haskellu si více povíme na cviku. Tady si jen ukážeme, jak nad nimi můžeme provádět pattern matching. Řekněme, že chceme vytvořit funkci, která rozdělí seznam na hlavičku a zbytek – a toto vrátí jako dvojici.

-- %%
headTail :: [a] -> (a, [a])
headTail (x:xs) = (x, xs)

-- %%
headTail [1, 2, 3, 4]

-- %% [markdown]
-- **Cvičení:** Podívejte se na definici typu seznam (`:i []`) a zkuste podle dosavadních znalostí rozklíčovat, proč pattern matching nad seznamy vypadá tak, jak vypadá.

-- %% [markdown]
-- Co se stane, když vyhodnotíme funkci `headTail` s prázdným seznamem?

-- %%
headTail []

-- %% [markdown]
-- Opět jsme vytvořili nedefinovaný výraz – zavedli jsme totiž vzor jen pro případ, kdy seznam má nějakou hlavičku. Je to podobné jako se standardní funkcí `head`. Dalo by se to nějak „opravit“?

-- %%
headTail :: [a] -> (a, [a])
headTail (x:xs) = (x, xs)
headTail []     = ????

-- %% [markdown]
-- Vzor pro prázdný seznam sice zadefinovat umíme, ale v tomhle případě nám to k ničemu není.
--
-- **Příklad 7:** Zkuste experimentovat s tím, co by se dalo doplnit na místo ????, aby tahle funkce něco pěkného vracela pro prázdný seznam... a pak popište, proč to nejde.
--
-- <details>
--     <summary>Hint:</summary>
--     Souvisí to s typovou anotací a charakterem polymorfismu v typové proměnné <code>a</code>.
-- </details>

-- %% [raw]
-- -- EX07
-- Výsledná hodnota pro prázdný seznam musí být nutně dvojice, přičemž druhý prvek této dvojice může být prázdný seznam, avšak první prvek musí být typu a, což vzhledem k prázdnému seznamu na vstupu není možné určit. Další možností je změna návratového typu na Maybe s tím, že pro prázdný seznam bude výsledkem Nothing.

-- %% [markdown]
-- #### Case výraz

-- %% [markdown]
-- Zatím jsme pattern matching viděli jen na úrovni definic funkcí. Opět připomenu naši funkci `not'`:

-- %%
data MyBool = MyTrue | MyFalse deriving Show
not' :: MyBool -> MyBool
not' MyTrue = MyFalse
not' MyFalse = MyTrue

-- %% [markdown]
-- Co kdybychom přece jen chtěli tu funkci zadefinovat ve tvaru `not' x = něco`, tedy v definici mít proměnnou a až v těle funkce nějak určovat, co je `x`? Uvnitř výrazů můžeme používat pattern matching pomocí klíčového slova **case**:

-- %%
not'' x =
  case x of
    MyTrue -> MyFalse
    MyFalse -> MyTrue

-- %%
not'' MyFalse

-- %% [markdown]
-- V tomto případě jde o vcelku hloupé použití, pro které je určitě lepší (ačkoliv sémanticky ekvivalentní) použít pattern matching na úrovni funkcí. *Case* se hodí:
--  1. proto, že můžeme dělat pattern matching na výsledku libovolného výrazu,
--  2. protože jako celek tvoří *výraz* (tedy dá se použít uprostřed jiného výrazu).
--
-- V příkladu níže jsem explicitně uvedl závorky (na což mě překladač náležitě upozorní), aby to bylo vidět, ale ani jeden pár kulatých závorek by tam být nemusel:

-- %%
httpMsg :: Int -> String
httpMsg code = "HTTP response code is from category " ++
  (case (code `div` 100) of  -- pattern matching se bude provádět proti výsledku (code `div` 100)
    1 -> "informational"
    2 -> "success"
    3 -> "redirect"
    4 -> "client error"
    5 -> "server error"
    _ -> "non-standard")

httpMsg 200
httpMsg 404

-- %% [markdown]
-- **Příklad 8:** Implementujte s využitím **case** funkci `signum'` (vrací `Int` -1, pokud je číslo záporné, 0, pokud je 0, a 1, pokud je kladné).
--
-- <details>
--     <summary>Hint:</summary>
--     Budete provádět pattern matching na výrazu <code>compare x 0</code>.
-- </details>

-- %%
-- EX08
signum' :: (Num a, Ord a) => a -> Int
signum' x =
    case compare x 0 of
        LT -> -1
        EQ -> 0
        GT -> 1

-- %% [markdown]
-- ---
--
-- **Příklad 9 (závěrečný):** Implementujte:
-- - a) Earth check: `isEarthling` vrátí `True` jen tehdy, pokud je obyvatel (alespoň částečně) ze Země,
-- - b) transport: `moveTo` vytvoří pro `Human` nového člověka s jinou planetou; a pro `...Flower` novou kvantovou kytičku, jejíž první planetou bude původně druhá planeta a druhou planetou bude určená planeta,
-- - c) instanci typové třídy `Ord` pro `Inhabitant`, která bude řadit obyvatele takhle:
--     - člověk bude vždy menší než kytička,
--     - člověk je řazen nejprve podle planety, pak podle jména,
--     - kytky jsou řazeny nejprve podle ID, pak podle planety 1, pak podle planety 2.
--
-- <details>
--     <summary>Hint:</summary>
--     Ve všech úkolech vám bude stačit pattern matching. Pro vytvoření instance typové třídy <code>Ord</code> stačí zadefinovat jednu jedinou funkci <code>compare</code> – opět je vhodné využít pattern matching, takže tam budete mít <code>compare (něco)</code> víckrát pod sebou.
-- </details>

-- %%
data Planet = Mercury | Venus | Earth | Mars
  deriving (Show, Eq, Ord)

data Inhabitant
  = Human Planet String
  | InterplanetaryQuantumFlower Planet Planet Int
  deriving (Show, Eq)

-- %%
-- EX09
-- EX09a
isEarthling :: Inhabitant -> Bool
isEarthling (Human Earth _) = True
isEarthling (InterplanetaryQuantumFlower Earth _ _) = True
isEarthling (InterplanetaryQuantumFlower _ Earth _) = True
isEarthling _ = False

-- EX09b
moveTo :: Planet -> Inhabitant -> Inhabitant
moveTo p (Human p1 s) = Human p s
moveTo p (InterplanetaryQuantumFlower _ p2 i) = InterplanetaryQuantumFlower p2 p i

-- EX09c
instance Ord Inhabitant where
    compare (Human p1 n1) (Human p2 n2) = compare (p1, n1) (p2, n2)
    compare (InterplanetaryQuantumFlower p11 p12 i1) (InterplanetaryQuantumFlower p21 p22 i2) = compare (i1, p11, p12) (i2, p21, p22)
    compare (Human _ _) (InterplanetaryQuantumFlower _ _ _) = LT
    compare (InterplanetaryQuantumFlower _ _ _) (Human _ _) = GT


-- %% [markdown]
-- **Příklad 10 (závěrečný):** Viděli jsme, že datové typy jdou nadefinovat tak, že jejich hodnoty jsou složeny z hodnot jiných typů (`Human` je složen z `Planet` a `String`). Taky jsme viděli, že jde udělat obecný typ, do kterého se dá strčit cokoliv (typ dvojice je definován jako `data (,) a b = (,) a b`). Mohli bychom tedy nadefinovat nějaký nic moc nedělající typ, jehož hodnota bude jen obalovat cokoliv jiného:
-- ```haskell
-- data Box a = Box a
-- ```
--
-- Přidejte do typu `Box a` další datový konstruktor `EmptyBox`, který bude reprezentovat, že je krabice prázdná (vevnitř není žádná hodnota). Poté implementujte funkci `safeHead`, která bude fungovat podobně jako běžná `head`, ale nebude způsobovat výjimky: pokud seznam má první prvek, zabalí ho do krabice, a pokud ho nemá, vrátí `EmptyBox`.
--
-- <details>
--     <summary>Hint:</summary>
--     Funkce bude definovaná pro dva vzory: <code>(x:_)</code> a <code>[]</code>.
-- </details>

-- %%
-- EX10
data Box a = Box a | EmptyBox

safeHead :: [a] -> Box a
safeHead (x:_) = Box x
safeHead [] = EmptyBox

