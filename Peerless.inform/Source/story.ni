"Peerless" by B David Paulsen
[Implements the galaxy generation algorithm from the original Elite.]

Part - Procedural generation

Chapter - Utility functions

To decide which number is (n1 - number) & (n2 - number): (- {n1} & {n2} -).
To decide which number is (n1 - number) | (n2 - number): (- {n1} | {n2} -).

To decide whether bit (s - a number) in (n - a number) is set:
	while s is greater than 1 begin;  let n be n divided by 2; decrement s; end while;
	decide on whether or not n is odd. [Since first bit set always means odd value, this lets us test if bit s is set.]

To decide which number is (n1 - number) ^ (n2 - number): [byte only!]
	let sum be 0; let i be 1; repeat with n running from 1 to 8 begin; if ((whether or not bit n in n1 is set) is not (whether or not bit n in n2 is set)), let sum be sum + i; let i be i * 2; end repeat; decide on sum.

To decide which number is the/a/-- byte-value of/-- (n - a number) left-shifted (s - a number) bit/bits: repeat with i running from 1 to s begin; let n be n multiplied by 2; end repeat; decide on n & 255. [keep first eight bits, clear the rest]
	
To decide which number is the/a/-- byte-value of/--  (n - a number) right-shifted (s - a number) bit/bits: repeat with i running from 1 to s begin; let n be n divided by 2; end repeat; decide on n.

[Symmetry suggests we don't stop at a measly one-step rotation.]
To decide which number is the/a/-- byte-value of/--  (n - a number) left-rotated (s - a number) bit/bits: repeat with i running from 1 to s begin; let carry be (n & 128); let carry be carry / 128; let n be a byte-value of n left-shifted 1 bit + carry; end repeat;  decide on n.


Chapter - Planets

Section - Name

Pairs is always "ABOUSEITILETSTONLONUTHNO..LEXEGEZACEBISOUSESARMAINDIREA.ERATENBERALAVETIEDORQUANTEISRION".

Section - Seeds

[Reasonably compact description of a planetary system. This actually isn't too bad.]
A fast-seed is a kind of thing. A fast-seed has numbers called a_, b_, c_, d_. 
seed_w0, seed_w1 and seed_w2 are numbers that vary.

There is a fast-seed called the random-seed. [rnd_seed in Text Elite]

Section - Planetary system

The currently chosen planet index is a number that varies. The currently chosen planet index is 8 [, meaning the planet Lave].
A person has numbers called the x-coordinate and the y-coordinate.

Last when play begins (this is the initialize coordinates by chosen planet rule): 
	choose row currently chosen planet index in the Table of Planetary Systems;
	now the x-coordinate of the player is the x entry;
	now the y-coordinate of the player is the y entry.

Table of Planetary Systems
name (text)	x (number)	y (number)	economy type (number)	government type (number)	tech level (number)	population (number)	productivity (number)	radius (number)	gssa (number)	gssb (number)	gssc (number)	gssd (number)
with 256 blank rows

[plansys makesystem(seedtype *s) function]
[Give planets an order -- we may, honestly, not need an index value, if we place it in a list, but hey]
This is the make a system from seed rule:
	choose a blank row in the Table of Planetary Systems;
	let longnameflag be (seed_w0) & 64;
	now the x entry is the byte-value of (seed_w1) right-shifted 8 bits;
	now the y entry is the byte-value of (seed_w0) right-shifted 8 bits;
	now the government type entry is the byte-value of (seed_w1) right-shifted 3 bits & 7;
	now the economy type entry is the byte-value of (seed_w0) right-shifted 8 bits & 7;
	if the government type entry is at most 1, now the economy type entry is the economy type entry | 2;
	now the tech level entry is ((the byte-value of (seed_w1) right-shifted 8 bits) & 3) + (economy type entry ^ 7);
	increase the tech level entry by the byte-value of government type entry right-shifted 1 bit;
	if the government type entry is odd, increment the tech level entry;
	now the population entry is (4 * (tech level entry)) + economy type entry + government type entry + 1; 
	now the productivity entry is ((the economy type entry ^ 7) + 3) * (the government type entry + 4) * (the population entry * 8);
	now the radius entry is (256 * ( ( (the byte-value of seed_w2 right-shifted 8 bits) & 15) + 11)) + the x entry;
	now the gssa entry is seed_w1 & 255;
	now the gssb entry is the byte-value of seed_w1 right-shifted 8 bits;
	now the gssc entry is seed_w2 & 255; 
	now the gssd entry is the byte-value of seed_w2 right-shifted 8 bits; 
	let using-long-name be whether or not longnameflag is not 0;
	now the name entry is pair-text using-long-name.


Chapter - Setup

[This phrase header is unidiomatic and confusing, and should be refactored.]
To decide which text is pair-text (ln - a truth state) (this is the pair-text phrase):
	let pair-base be 25;
	let result be a text;
	repeat with n running from 1 to 4:
		let pair be (((the byte-value of seed_w2 right-shifted 8 bits) & 31) * 2) + pair-base;
		let pair2 be pair + 1;
		let the result be "[result][character number pair in pairs][character number pair2 in pairs]";
		tweak the seed;
	if ln is false:
		replace character number 7 in result with ".";
		replace character number 8 in result with ".";
	replace the text "." in result with "";
	let result be result in sentence case;
	decide on result.

base0 is always 23114.
base1 is always 584.
base2 is always 46931.

Current galaxy is a number that varies. Current galaxy is initially 1.

To build (n - a number) (this is the galactic creation phrase):
	now seed_w0 is base0;
	now seed_w1 is base1;
	now seed_w2 is base2;
	let galaxy count be 1;
	while galaxy count is less than current galaxy:
		go to next galaxy;
		increment galaxy count;
	repeat with counter running from 0 to 255:
		follow the make a system from seed rule.

To go to next galaxy (this is the galactic hyperdrive phrase):
	now seed_w0 is the twisted seed_w0;
	now seed_w1 is the twisted seed_w1;
	now seed_w2 is the twisted seed_w2;
	blank out the whole of the Table of Planetary Systems;
	let next galaxy be current galaxy + 1;
	build next galaxy.

To decide which number is the/-- twisted (x - a number) (this is the twist function phrase):
	let part1 be the byte-value of x left-shifted 8 bits;
	let part1 be the byte-value of part1 left-rotated 1 bit;
	let part1 be part1 * 256;
	let part2 be x & 255;
	let part2 be the byte-value of part2 left-rotated 1 bit;
	decide on the remainder after dividing (part1 + part2) by 65536.

To tweak the seed (this is the seed-tweaking phrase):
	let temp be seed_w0 plus seed_w1 plus seed_w2;
	let temp be the remainder after dividing temp by 65536;
	now seed_w0 is seed_w1;
	now seed_w1 is seed_w2;
	now seed_w2 is temp.

When play begins (this is the initial galactic creation rule):
	build the current galaxy.


Chapter - Liquifying the goat

[The goat soup uses tables. Also goats.]

Section - I6 Inclusion

To say by column -- ending say_one_of with marker I7_SOO_BYCOL: 
	(- {-close-brace} -). 

Include (- 
[ I7_SOO_BYCOL oldval count; 
	if (count < (+ current column +)) return count; 
	return (+ current column +); ]; 
-) 

Section - Utensils for the soup

To decide which text is popped (t - a text):
	let result be a text;
	repeat with i running from 1 to the number of characters in t - 1:
		let result be "[result][character number i in t]";
	decide on result.

To decide which text is last character in (t - a text): decide on character number (number of characters in t) in t.

To decide which text is (t - a text)ian:
	if the last character in t is "e", let t be popped t;
	if the last character in t is "i", let t be popped t;
	decide on "[t]ian".

[Must find a way to prepare the numbers. Perhaps a phrase that takes a planetary name and derives the correct goat-soup seeds? No, better just to find it by planet-name index.]
Gsa, gsb, gsc, and gsd are numbers that vary.

To decide which number is the/-- pseudo-randomized number:
	let x_ be (gsa * 2) & 255;
	let a_ be x_ + gsc;
	if gsa is greater than 127, increment a_;
	now gsa is a_ & 255;
	now gsc is x_;
	let a_ be a_ / 256;
	let x_ be gsb;
	let a_ be (a_ + x_ + gsd) & 255;
	now gsb is a_;
	now gsd is x_;
	decide on a_.

To decide which number is col of (n - a number):
	let s be 1;
	repeat with i running from 1 to 5:
		if n is at least (i * 51), increment s;
	decide on s.

The current column is a number that varies.

To bleat (t - text):
	now the current column is the col of the pseudo-randomized number;
	say t.

Section - Soup ingredients

To decide which text is initial goat-soup string: 
	choose row (currently chosen planet index) in the Table of Planetary Systems;
	now gsa is the gssa entry;
	now gsb is the gssb entry;
	now gsc is the gssc entry;
	now gsd is the gssd entry;
	decide on "[Planet] is [general planetary descriptor]."

To decide which text is planet_name: 
	choose row (currently chosen planet index) in the Table of Planetary Systems;
	decide on the name entry.
	
To say known:  	[81] bleat "[one of]fabled[or]notable[or]well known[or]famous[or]noted[by column]".
To say slightly:  	[82] bleat "[one of]very[or]mildly[or]most[or]reasonably[or][by column]".
To say striking:  	[83] bleat "[one of]ancient[or][turbulent][or]great[or]vast[or]pink[by column]".
To say landmarks: 	[84] bleat "[one of][famously named] [crop] plantations[or]mountains[or][hazardous phenomenon][or][verdant] forests[or]oceans[by column]".
To say quirk:	[85] bleat "[one of]shyness[or]silliness[or]mating traditions[or]loathing of [oddly specific concept][or]love for [oddly specific concept][by column]".
To say oddly specific concept:	[86] bleat "[one of]food blenders[or]tourists[or]poetry[or]discos[or][fun activity][by column]".
To say flora-or-fauna:	[87] bleat "[one of]talking tree[or]crab[or]bat[or]lobst[or][random-name][by column]".
To say threatened:	[88] bleat "[one of]beset[or]plagued[or]ravaged[or]cursed[or]scourged[by column]".
To say malady:	[89] bleat "[one of][turbulent] civil war[or][murderous] [planetary adjective] [hazardous lifeform][or]a [murderous] disease[or][turbulent] earthquakes[or][turbulent] solar activity[by column]".
To say characteristic of planet: 	[8A] bleat "[one of]its [striking] [landmarks][or]the [planet_name ian] [planetary adjective] [hazardous lifeform][or]its inhabitants['] [venerable] [quirk][or][tourist draw][or]its [extraordinary] [fun activity][by column]".
To say beverage: 	[8B] bleat "[one of]juice[or]brandy[or]water[or]brew[or]gargle blasters[by column]".
To say name-drop: 	[8C] bleat "[one of][random-name][or][planet_name ian] [hazardous lifeform][or][planet_name ian] [random-name][or][planet_name] [murderous][or][murderous] [random-name][by column]".
To say extraordinary: 	[8D] bleat "[one of]fabulous[or]exotic[or]hoopy[or]unusual[or]exciting[by column]".
To say fun activity: 	[8E] bleat "[one of]cuisine[or]night life[or]casinos[or]sit coms[or][tourist draw][by column]".
To say planet: 	[8F] bleat "[one of][Planet_name][or]The planet [planet_name][or]The world [Planet_name][or]This planet[or]This world[by column]".
To say unpleasant: 	[90] bleat "[one of]n unremarkable[or] boring[or] dull[or] tedious[or] revolting[by column]".
To say place: 	[91] bleat "[one of]planet[or]world[or]place[or]little planet[or]dump[by column]".
To say bug: 	[92] bleat "[one of]wasp[or]moth[or]grub[or]ant[or][random-name][by column]".
To say nuisance:	[93] bleat "[one of]poet[or]arts graduate[or]yak[or]snail[or]slug[by column]".
To say verdant: 	[94] bleat "[one of]tropical[or]dense[or]rain[or]impenetrable[or]exuberant[by column]".
To say unusual: 	[95] bleat "[one of]funny[or]weird[or]unusual[or]strange[or]peculiar[by column]".
To say turbulent:	[96] bleat "[one of]frequent[or]occasional[or]unpredictable[or]dreadful[or]deadly[by column]".
To say general planetary descriptor: 	[97] bleat "[one of][slightly] [known] for [characteristic of planet][or][slightly] [known] for [characteristic of planet] and [characteristic of planet][or][threatened] by [malady][or][slightly] [known] for [characteristic of planet] but [threatened] by [malady][or]a[unpleasant] [place][by column]".
To say planetary adjective: 	[98] bleat "[one of][murderous][or]mountain[or]edible[or]tree[or]spotted[by column]".
To say hazardous lifeform: 	[99] bleat "[one of][creature-1][or][creature-2][or][flora-or-fauna]oid[or][nuisance][or][bug][by column]".
To say venerable: 	[9A] bleat "[one of]ancient[or]exceptional[or]eccentric[or]ingrained[or][unusual][by column]".
To say murderous: 	[9B] bleat "[one of]killer[or]deadly[or]evil[or]lethal[or]vicious[by column]".
To say hazardous phenomenon: 	[9C] bleat "[one of]parking meters[or]dust clouds[or]ice bergs[or]rock formations[or]volcanoes[by column]".
To say crop: 	[9D] bleat "[one of]plant[or]tulip[or]banana[or]corn[or][random-name]weed[by column]".
To say famously named: 	[9E] bleat "[one of][random-name][or][planet_name ian] [random-name][or][planet_name ian] [murderous][or]inhabitant[or][planet_name ian] [random-name][by column]".
To say creature-1: 	[9F] bleat "[one of]shrew[or]beast[or]bison[or]snake[or]wolf[by column]".
To say creature-2: 	[A0] bleat "[one of]leopard[or]cat[or]monkey[or]goat[or]fish[by column]".
To say tourist draw: 	[A1] bleat "[one of][name-drop] [beverage][or][planet_name ian] [creature-1] [cuisine][or]its [extraordinary] [creature-2] [cuisine][or][prefix to sport] [sport][or][name-drop] [beverage][by column]".
To say cuisine: 	[A2] bleat "[one of]meat[or]cutlet[or]steak[or]burgers[or]soup[by column]".
To say prefix to sport: 	[A3] bleat "[one of]ice[or]mud[or]Zero-G[or]vacuum[or][planet_name ian] ultra[by column]".
To say sport:	[A4] bleat "[one of]hockey[or]cricket[or]karate[or]polo[or]tennis[by column]".

To say random-name: 
	let t be text;
	let length be the pseudo-randomized number & 3;
	repeat with i running from 0 to length:
		let x be pseudo-randomized number & 62;
		let t be "[t][character number x + 1 in pairs][character number x + 2 in pairs]";
	let t be t in sentence case;
	replace the text "." in t with "";
	say t.


Chapter - Witch-space

A witch-space destination is a kind of thing. A witch-space destination has numbers called x and y. A witch-space destination has a real number called distance. A witch-space destination can be defined or undefined. A witch-space destination is usually undefined.

A witch-space destination has a number called the planetary identifier. [This will have to change. We will use x/y coordinates, not indices.]

There are 20 witch-space destinations. 
Elsewhere is a room. All witch-space destinations are in elsewhere.

Understand the printed name property as describing a witch-space destination.

[Poor form. The correct way to do this would be a phrase that finds a planet by name, and sets us as present there.]
Last when play begins (this is the provisional starting rule):
	update the stellar neighborhood for the Cobra Mk III.
	
To update the/-- stellar neighborhood for (actor - a person):
	materialize all planets in a 70 unit distance from coordinates (x-coordinate of the actor) and (y-coordinate of the actor).

[I've been meaning to determine why Bell and Braben squashed the y axis by the fudge factor 4. I can't say why, but it apparently yields the same results as we see in the game.]
To decide which real number is the distance from (x1 - a number) and (y1 - a number) to (x2 - a number) and (y2 - a number) (this is Ian Bell's peculiar variation on the Pythagoran Theorem phrase):
	decide on 4 multiplied by the square root of (((x1 - x2) * (x1 - x2)) plus ((y1 - y2) * (y1 - y2) divided by 4));

To decide which list of numbers is planet-entries in a/-- (r - a number) unit/units distance from coordinates (x - a number) and (y - a number):
	let L be a list of numbers;
	let coordinate radius be r / 4;
	let x1 be x minus (r / 4);
	let x2 be x plus (r / 4);
	let y1 be y minus (r / 2);
	let y2 be y plus (r / 2);
	let row-counter be 1;
	repeat through the Table of Planetary Systems:
		if the x entry is at least x1 and the x entry is at most x2:
			if the y entry is at least y1 and the y entry is at most y2:
				add the row-counter to L;
		increment the row-counter;
	decide on L.

To materialize the/all/-- planets in a/-- (r - a number) unit/units distance from coordinates (x - a number) and (y - a number) (this is the instantiate stellar neighborhood phrase):
	now every witch-space destination is undefined;
	let L be the planet-entries in a r unit distance from coordinates x and y;
	repeat with index running through L:
		choose row index in the Table of Planetary Systems;
		if there is an undefined witch-space destination (called the intended destination):
			now the printed name of the intended destination is "[name entry]";
			now the x of the intended destination is the x entry;
			now the y of the intended destination is the y entry;
			let d be the distance from x and y to x entry and y entry;
			now the distance of the intended destination is d;
			now the planetary identifier of the intended destination is the index;
			now the intended destination is defined.
					
Witch-space traveling to is an action applying to one visible thing. Understand "travel to [any thing]" as witch-space traveling to. Understand "jump to [any thing]" as witch-space traveling to.
Report witch-space traveling to:
	say "Space tears as you make the jump to witch-space. Moments later, you emerge into the [planet_name] system."

Rule for printing a parser error when the latest parser error is the noun did not make sense in that context error (this is the provisional error message for selecting unknown destination rule): 
	say "That destination is unavailable." instead. 

Check witch-space traveling to something that is not a witch-space destination (this is the illegal hyperspace destination rule): say "[The noun] [are] not a legal destination."
Check witch-space traveling to a witch-space destination that is undefined (this is the undefined destination rule): say "That destination isn't in the navigational computer." instead.
Check witch-space traveling to a witch-space destination when the distance of the noun is 0 (this is the must travel somewhere rule): say "You are already here." instead.

[This will have to change. The traveling must be done to x-y coordinates, and from thence find the planet in question.]
Carry out witch-space traveling to:
	now the currently chosen planet index is the planetary identifier of the noun;
	choose row currently chosen planet index in the Table of Planetary Systems;
	now the x-coordinate of the actor is the x entry;
	now the y-coordinate of the actor is the y entry;
	materialize all planets in a 70 unit distance from coordinates (x-coordinate of the actor) and (y-coordinate of the actor).

To map the stars (this is the provisional star-mapping rule):
	let L be the list of defined witch-space destinations;
	sort L in distance order;
	repeat with item running through L:
		if the distance of the item is 0, say bold type;
		if the distance of the item is greater than 70, say italic type;
		say "[printed name of the item] ([x of the item]x[y of the item]) -- [if the distance of the item is 0]current system[otherwise][distance of the item / 10] light years[end if][line break]";
		say roman type.
		
To decide which number is closest planet to coordinates (x - a number) and (y - a number) by index:
	let L be a list of numbers;
	let r be 10;
	while the number of entries in L is 0:
		let L be planet-entries in a r unit distance from coordinates x and y;
	let candidate be entry 1 in L;
	choose row 1 in the Table of Planetary Systems;
	let candidate-distance be the distance from x and y to x entry and y entry;
	repeat with index running through L:
		choose row index in the Table of Planetary Systems;
		let new-candidate-distance be the distance from x and y to x entry and y entry;
		if new-candidate-distance is less than candidate-distance:
			now candidate is the index;
	decide on the candidate.
	
[Possibly not needed, but it's nice to have.]
To say closest planet to coordinates (x - a number) and (y - a number):
	choose row (closest planet to coordinates x and y by index) in the Table of Planetary Systems;
	say the name entry.
		

Volume - Automatic tests (not for release)

[Well, this is a bigass table. It does work fairly well though. Essentially, this is a dump straight from Text Elite v5: all the planets of galaxy 1.]

Use MAX_PROP_TABLE_SIZE of 400000.

Table of Planetary Testing Data
name	x	y	gov	eco	tech	pop	prod	radius	goat soup
"TIBEDIED"	2	90	1	2	8	36	11520	4610	"This planet is most notable for Tibediedian Arnu brandy but ravaged by unpredictable solar activity."
"QUBE"	152	205	7	5	6	37	16280	5528	"Qube is reasonably well known for its great dense forests but scourged by deadly civil war."
"LELEER"	77	243	3	3	7	35	13720	3149	"The world Leleer is very noted for its pink Leleerian Itonthbi tulip plantations but plagued by a vicious disease."
"BIARGE"	83	208	2	0	11	47	22560	4435	"This world is very fabled for the Biargian edible poet."
"XEQUERIN"	180	131	4	3	6	32	14336	3508	"The world Xequerin is  fabled for its wierd volcanoes and the Xequerinian mountain lobstoid."
"TIRAOR"	172	176	4	0	9	41	26240	4780	"Tiraor is a revolting little planet."
"RABEDIRA"	69	249	2	1	8	36	15552	3909	"The planet Rabedira is  well known for its inhabitants' ancient loathing of sit coms but ravaged by dreadful civil war."
"LAVE"	20	173	3	5	4	25	7000	4116	"Lave is most famous for its vast rain forests and the Lavian tree grub."
"ZAATXE"	236	0	7	0	11	52	45760	4076	"This planet is mildly noted for the Zaatxian deadly Atlenooid but ravaged by lethal lethal yaks."
"DIUSREZA"	216	98	1	2	6	28	8960	6360	"This planet is mildly fabled for its inhabitants' eccentric love for tourists but beset by deadly edible moths."
"TEAATIS"	4	238	1	6	2	16	2560	5892	"Teaatis is mildly well known for Teaatisian vicious brew."
"RIINUS"	93	49	4	1	9	42	24192	6493	"This world is mildly famous for its vast rain forests and the Riinusian tree grub."
"ESBIZA"	244	40	2	0	8	35	16800	5364	"The planet Esbiza is most famous for its vast rain forests."
"ONTIMAXE"	84	164	6	4	6	35	16800	6740	"This planet is reasonably famous for its inhabitants' exceptional love for food blenders."
"CEBETELA"	194	11	0	3	6	28	6272	4290	"This world is most notable for its fabulous  Cebetelaian lethal brandy  but scourged by killer mountain Esbionoids."
"CEEDRA"	245	220	5	4	7	38	16416	4341	"This planet is most fabled for its inhabitants' ingrained silliness but scourged by deadly civil war."
"RIZALA"	178	84	5	4	8	42	18144	6578	"The planet Rizala is mildly notable for Rizalaian lethal brandy."
"ATRISO"	55	245	3	5	7	37	10360	3127	"Atriso is mildly well known for its exotic cuisine and its inhabitants' ingrained silliness."
"TEANREBI"	214	7	7	7	6	39	10296	6102	"This planet is plagued by frequent earthquakes."
"AZAQU"	6	110	6	6	6	37	11840	6662	"The planet Azaqu is most famous for its pink oceans and Zero-G cricket."
"RETILA"	175	218	0	2	8	35	8960	6575	"This world is ravaged by occasional solar activity."
"SOTIQU"	123	149	0	7	3	20	1920	4731	"The planet Sotiqu is  famous for its exotic goat soup but ravaged by a killer disease."
"INLEUS"	186	26	6	2	10	49	31360	6074	"The world Inleus is most famous for the Inleusian spotted wolf."
"ONRIRA"	22	232	7	0	13	60	52800	6678	"The world Onrira is mildly noted for the Onriraian deadly Seoid but cursed by dreadful solar activity."
"CEINZALA"	18	20	3	4	7	36	12096	4114	"This planet is most notable for vicious Numaab juice but cursed by unpredictable solar activity."
"BIISZA"	245	132	5	4	7	38	16416	4597	"The planet Biisza is most famous for its vast rain forests."
"LEGEES"	4	253	5	5	5	31	11160	3076	"This planet is most notable for its exotic night life but ravaged by frequent earthquakes."
"QUATOR"	14	137	0	3	6	28	6272	5390	"The world Quator is scourged by deadly edible arts graduates."
"AREXE"	164	89	6	1	9	44	31680	6820	"The world Arexe is  fabled for its exciting sit coms and its inhabitants' ancient loathing of sit coms."
"ATRABIIN"	96	130	2	2	6	29	11136	3168	"Atrabiin is cursed by killer edible Nuatoids."
"USANAT"	108	230	4	6	3	23	5888	4972	"The world Usanat is a boring world."
"XEESLE"	53	209	1	3	6	29	8120	3381	"The world Xeesle is a boring planet."
"ORESEREN"	206	1	1	3	7	33	9240	5326	"Oreseren is a revolting little planet."
"INERA"	82	16	7	0	13	60	52800	5970	"This planet is  noted for its exotic fish meat."
"INUS"	204	143	3	7	2	19	3192	6092	"This world is reasonably well known for the Inusian tree wolf but scourged by unpredictable earthquakes."
"ISENCE"	52	128	2	0	8	35	16800	6196	"The world Isence is very famous for its unusual casinos but beset by a evil disease."
"REESDICE"	149	101	4	5	5	30	9600	6549	"The world Reesdice is reasonably famous for the Reesdician deadly lobstoid."
"TEREA"	69	109	4	5	5	30	9600	5957	"This world is very fabled for the Tereaian edible poet."
"ORGETIBE"	26	47	2	7	3	22	3168	5146	"This planet is a dull world."
"REORTE"	19	151	3	7	5	31	5208	6419	"This planet is mildly fabled for its inhabitants' eccentric love for tourists but plagued by deadly earthquakes."
"QUQUOR"	164	220	7	4	7	40	21120	5540	"The planet Ququor is mildly well known for its exotic cuisine."
"GEINONA"	143	153	1	3	8	37	10360	3727	"This world is ravaged by unpredictable solar activity."
"ANARLAQU"	111	127	1	7	4	25	3000	5743	"This world is mildly famous for its hoopy night life and its exotic night life."
"ORESRI"	58	85	4	5	6	34	10880	5178	"The planet Oresri is cursed by dreadful civil war."
"ESESLA"	65	190	2	6	3	21	4032	5185	"This planet is  noted for Zero-G hockey."
"SOCELAGE"	104	85	6	5	5	32	12800	4712	"This planet is reasonably noted for its exotic goat meat."
"RIEDQUAT"	3	181	0	7	3	20	1920	6403	"This planet is most notable for its fabulous cuisine but beset by occasional civil war."
"GEREGE"	113	58	5	2	9	44	25344	3697	"The world Gerege is reasonably famous for the Geregian spotted wolf."
"USLE"	85	99	5	3	8	41	20664	4949	"This world is very notable for the Uslian tree ant and its inhabitants' exceptional loathing of sit coms."
"MALAMA"	234	32	3	0	11	48	26880	5866	"The planet Malama is mildly well known for its exotic cuisine."
"AESBION"	45	139	7	3	9	47	28952	6701	"The planet Aesbion is cursed by dreadful civil war."
"ALAZA"	223	6	6	6	7	41	13120	6879	"The world Alaza is scourged by a evil disease."
"XEAQU"	104	36	0	6	1	11	1408	3432	"The world Xeaqu is a dull place."
"RAOROR"	11	58	0	2	8	35	8960	3851	"This world is very fabled for its wierd volcanoes."
"ORORQU"	102	57	6	1	11	52	37440	5222	"The planet Ororqu is  well known for its inhabitants' ancient mating traditions but ravaged by unpredictable solar activity."
"LEESTI"	13	186	7	2	10	50	35200	3085	"The planet Leesti is reasonably fabled for Zero-G cricket and Leestian evil juice."
"GEISGEZA"	162	87	3	7	4	27	4536	3746	"This planet is  notable for its unusual oceans and the Geisgezaian mountain slug."
"ZAINLABI"	164	163	5	3	7	37	18648	4004	"This world is ravaged by unpredictable civil war."
"USCELA"	70	117	5	5	7	39	14040	4934	"The world Uscela is a boring world."
"ISVEVE"	227	149	0	7	3	20	1920	6371	"The planet Isveve is reasonably noted for its inhabitants' eccentric shyness and its inhabitants' eccentric shyness."
"TIORANIN"	202	86	6	6	6	37	11840	4810	"This world is most notable for Tioraninian vicious brew but ravaged by unpredictable civil war."
"LEARORCE"	108	27	2	3	5	26	8736	3180	"Learorce is reasonably notable for its great dense forests but scourged by deadly edible poets."
"ESUSTI"	133	121	4	1	9	42	24192	5253	"This world is very well known for its inhabitants' ancient loathing of discos and the Esustian spotted cat."
"USUSOR"	168	23	1	7	1	13	1560	5032	"This planet is very notable for its inhabitants' wierd shyness and the Ususorian edible poet."
"MAREGEIS"	73	121	1	3	6	29	8120	5705	"This world is  fabled for its ancient Maregeisian Onbidi tulip plantations."
"AATE"	253	35	7	3	9	47	28952	6909	"The world Aate is scourged by killer mountain lobstoids."
"SORI"	251	252	3	4	8	40	13440	4859	"The world Sori is beset by a evil disease."
"CEMAVE"	6	0	2	0	10	43	20640	4102	"The world Cemave is beset by dreadful earthquakes."
"ARUSQUDI"	39	22	4	6	6	35	8960	5415	"This world is very fabled for its unusual oceans."
"EREDVE"	205	250	4	2	8	39	19968	3021	"This planet is beset by a evil disease."
"REGEATGE"	159	54	2	6	5	29	5568	6559	"Regeatge is reasonably well known for its great dense forests but scourged by frequent civil war."
"EDINSO"	3	81	3	1	11	49	24696	4867	"This planet is mildly noted for its pink Edinsoian Ge Bemaarleweed plantations but ravaged by vicious mountain monkeys."
"RA"	12	135	7	7	4	31	8184	2828	"The world Ra is beset by deadly earthquakes."
"ARONAR"	53	160	1	2	7	32	10240	5429	"Aronar is most famous for the Aronarian deadly goat and its hoopy casinos."
"ARRAESSO"	138	223	1	7	3	21	2520	5514	"This planet is  notable for its unusual oceans and its inhabitants' exceptional loathing of food blenders."
"CEVEGE"	7	73	4	1	11	50	28800	4103	"This world is a revolting dump."
"ORTEVE"	63	35	2	3	8	38	12768	5183	"This world is  fabled for its fabulous  vicious Ougeza gargle blasters ."
"GEERRA"	108	214	6	6	4	29	9280	2924	"This planet is reasonably noted for its exotic goat soup."
"SOINUSTE"	244	48	0	2	5	23	5888	4852	"This planet is beset by deadly earthquakes."
"ERLAGE"	220	104	5	0	10	46	33120	3036	"This world is reasonably well known for the Erlagian tree ant but cursed by vicious mountain goats."
"XEAAN"	169	67	5	3	8	41	20664	3497	"This world is ravaged by unpredictable civil war."
"VEIS"	140	27	3	3	6	31	12152	4492	"The planet Veis is a boring world."
"ENSOREUS"	52	224	7	0	11	52	45760	3380	"This planet is a tedious little planet."
"RIVEIS"	168	110	6	6	4	29	9280	6568	"The world Riveis is most well known for its hoopy casinos."
"BIVEA"	210	61	0	7	2	16	1536	4562	"This planet is plagued by frequent solar activity."
"ERMASO"	139	175	0	7	3	20	1920	2955	"This planet is very notable for the Ermasoian edible grub and the Ermasoian tree ant."
"VELETE"	195	39	6	7	6	38	9120	4547	"Velete is a revolting dump."
"ENGEMA"	244	92	7	4	7	40	21120	3572	"The world Engema is beset by a evil disease."
"ATRIENXE"	226	107	3	3	8	39	15288	3298	"Atrienxe is an unremarkable dump."
"BEUSRIOR"	66	146	5	2	10	48	27648	3650	"The world Beusrior is a dull world."
"ONTIAT"	57	190	5	6	5	32	9216	6713	"The planet Ontiat is scourged by a evil disease."
"ATARZA"	168	113	0	3	4	20	4480	3240	"This world is plagued by occasional solar activity."
"ARAZAES"	160	36	6	4	6	35	16800	6816	"This planet is very notable for the Arazaesian tree ant and Arazaesian wolf meat."
"XEERANRE"	105	132	2	4	5	27	7776	3433	"Xeeranre is cursed by killer mountain Reetaboids."
"QUZADI"	78	219	4	3	8	40	17920	5454	"Quzadi is cursed by dreadful civil war."
"ISTI"	12	45	1	7	1	13	1560	6156	"The planet Isti is reasonably noted for its inhabitants' eccentric shyness and Zero-G hockey."
"DIGEBITI"	117	192	1	2	7	32	10240	6261	"Digebiti is cursed by killer mountain Seoids."
"LEONED"	151	6	7	6	8	46	16192	3223	"Leoned is reasonably well known for the Leonedian tree snake but scourged by unpredictable earthquakes."
"ENZAER"	217	56	3	0	10	44	24640	3545	"Enzaer is a revolting dump."
"TERAED"	199	80	2	0	11	47	22560	6087	"Teraed is an unremarkable dump."
"VETITICE"	105	152	4	0	10	45	28800	4457	"This world is very well known for Vetitician lethal brandy and its great parking meters."
"LAENIN"	69	87	4	7	3	24	4608	4165	"The planet Laenin is  famous for its inhabitants' ancient loathing of sit coms but cursed by a killer disease."
"BERAANXE"	212	12	2	4	4	23	6624	3796	"The world Beraanxe is reasonably noted for its inhabitants' exceptional love for tourists and its unusual oceans."
"ATAGE"	226	219	3	3	8	39	15288	3298	"Atage is an unremarkable planet."
"VEISTI"	35	3	7	3	11	55	33880	4387	"The planet Veisti is reasonably noted for its inhabitants' eccentric shyness and Zero-G cricket."
"ZAERLA"	203	119	1	7	4	25	3000	3019	"The planet Zaerla is mildly well known for its exotic cuisine."
"ESREDICE"	85	16	1	2	7	32	10240	5205	"The world Esredice is a boring planet."
"BEOR"	197	13	4	5	5	30	9600	3013	"Beor is an unremarkable dump."
"ORSO"	237	89	2	1	8	36	15552	5357	"The world Orso is reasonably fabled for its exciting sit coms and its inhabitants' exceptional love for food blenders."
"USATQURA"	97	39	6	7	4	30	7200	4961	"This planet is reasonably famous for its inhabitants' exceptional loathing of sit coms."
"ERBITI"	148	122	0	2	5	23	5888	2964	"The world Erbiti is most well known for its great dense forests."
"REINEN"	55	102	5	6	7	40	11520	6455	"This planet is a tedious little planet."
"ININBI"	173	242	5	2	9	44	25344	6061	"The world Ininbi is reasonably famous for its inhabitants' exceptional loathing of casinos."
"ERLAZA"	30	230	3	6	5	30	6720	2846	"The world Erlaza is mildly noted for its ancient mountains but plagued by a lethal disease."
"CELABILE"	235	4	7	4	10	52	27456	4331	"The planet Celabile is most famous for the Celabilian evil poet and Zero-G hockey."
"RIBISO"	97	166	6	6	5	33	10560	6497	"This planet is  fabled for its exciting  vacuum cricket ."
"QUDIRA"	236	39	0	7	0	8	768	5612	"The world Qudira is reasonably fabled for Qudiraian Ouarma gargle blasters and the Qudiraian evil talking treeoid."
"ISDIBI"	251	244	0	6	4	23	2944	6395	"The world Isdibi is scourged by deadly tree ants."
"GEQURE"	208	230	6	6	4	29	9280	3792	"This world is reasonably well known for the Gequrian tree ant but ravaged by dreadful civil war."
"RARERE"	203	206	7	6	8	46	16192	4043	"The planet Rarere is mildly notable for Rarerian lethal brandy."
"AERATER"	209	78	3	6	4	26	5824	6865	"Aerater is a revolting little planet."
"ATBEVETE"	208	81	5	1	9	43	27864	3280	"The planet Atbevete is mildly well known for killer Ou gargle blasters."
"BIORIS"	220	214	5	6	4	28	8064	4572	"Bioris is very fabled for the Biorisian edible poet."
"RAALE"	93	29	0	7	1	12	1152	3933	"This world is very fabled for the Raalian edible poet."
"TIONISLA"	38	193	6	1	11	52	37440	4646	"This world is very notable for its inhabitants' ingrained shyness."
"ENCERESO"	85	189	2	5	4	24	5760	3413	"Encereso is cursed by dreadful civil war."
"ANERBE"	199	14	4	6	6	35	8960	5831	"The world Anerbe is reasonably fabled for its exciting  vacuum karate  and its great volcanoes."
"GELAED"	95	19	1	3	8	37	10360	3679	"The planet Gelaed is very noted for its pink Gelaedian Ines Soweed plantations but ravaged by unpredictable civil war."
"ONUSORLE"	81	216	1	2	7	32	10240	6737	"This world is mildly well known for Onusorlian vicious brew and Onusorlian wolf cutlet."
"ZAONCE"	33	185	7	1	11	53	41976	3873	"This planet is a tedious place."
"DIQUER"	104	69	3	5	4	25	7000	6248	"The world Diquer is a dull place."
"ZADIES"	120	112	2	0	8	35	16800	3960	"The planet Zadies is  famous for its inhabitants' exceptional love for food blenders but scourged by dreadful solar activity."
"ENTIZADI"	91	233	4	1	11	50	28800	3419	"The planet Entizadi is  famous for its inhabitants' exceptional love for food blenders but scourged by dreadful solar activity."
"ESANBE"	173	132	4	4	6	33	12672	5293	"Esanbe is  famous for its inhabitants' ancient loathing of casinos but plagued by deadly earthquakes."
"USRALAAT"	184	179	2	3	5	26	8736	5048	"This planet is plagued by deadly earthquakes."
"ANLERE"	177	53	3	5	5	29	8120	5809	"Anlere is reasonably well known for the Anlerian spotted shrew but plagued by evil tree leopards."
"TEVERI"	235	78	7	6	8	46	16192	6123	"The world Teveri is reasonably fabled for Teverian evil juice and its inhabitants' ingrained shyness."
"SOTIERA"	81	30	1	6	3	20	3200	4689	"The world Sotiera is mildly fabled for the Sotieraian mountain poet but cursed by unpredictable earthquakes."
"EDEDLEEN"	207	16	1	2	9	40	12800	5071	"The planet Ededleen is mildly well known for its exotic cuisine."
"INONRI"	114	161	4	1	10	46	26496	6002	"This world is very well known for Inonrian wolf meat and its wierd volcanoes."
"ESBEUS"	75	94	2	6	5	29	5568	5195	"The world Esbeus is mildly noted for its ancient mountains but plagued by frequent earthquakes."
"LERELACE"	69	72	6	0	11	51	40800	3141	"This planet is a dull place."
"ESZARAXE"	229	149	0	7	1	12	1152	5349	"The planet Eszaraxe is most famous for the Eszaraxian spotted shrew and the Eszaraxian mountain poet."
"ANBEEN"	130	52	5	4	8	42	18144	5762	"Anbeen is reasonably notable for its great tropical forests but cursed by dreadful solar activity."
"BIORLE"	97	114	5	2	9	44	25344	4449	"The world Biorle is a dull world."
"ANISOR"	160	129	3	1	8	37	18648	5792	"This planet is very well known for its inhabitants' ancient mating traditions and its inhabitants' ancient loathing of casinos."
"USRAREMA"	81	249	7	1	11	53	41976	4945	"This world is very notable for the Usraremaian edible poet."
"DISO"	11	174	6	6	7	41	13120	6155	"This planet is mildly noted for its ancient Ma corn plantations but beset by frequent solar activity."
"RIRAES"	182	224	0	2	7	31	7936	6582	"The world Riraes is  fabled for its wierd rock formations and its pink oceans."
"ORRIRA"	92	9	0	3	4	20	4480	5212	"The planet Orrira is cursed by killer edible talking treeoids."
"XEER"	141	116	6	4	7	39	18720	2957	"This world is very well known for Xeerian wolf meat and its fabulous cuisine."
"CEESXE"	147	16	7	0	14	64	56320	4243	"The world Ceesxe is most well known for its vast rain forests."
"ISATRE"	113	2	3	2	8	38	17024	6257	"The world Isatre is a boring planet."
"AONA"	78	224	5	0	12	54	38880	2894	"This world is very well known for Aonaian lethal brandy and its great volcanoes."
"ISINOR"	47	191	5	7	6	37	7992	6191	"This world is very fabled for its unusual oceans."
"USZAA"	3	153	0	3	7	32	7168	4867	"The planet Uszaa is reasonably noted for its inhabitants' eccentric love for tourists and the Uszaaian tree grub."
"AANBIAT"	91	47	6	7	6	38	9120	6747	"This planet is  fabled for its ancient Aanbiatian Noin banana plantations."
"BEMAERA"	49	198	2	6	3	21	4032	3633	"Bemaera is most noted for the Bemaeraian deadly Xesooid and its inhabitants' unusual silliness."
"ININES"	239	16	4	0	12	53	33920	6127	"This world is a tedious place."
"EDZAON"	162	201	1	3	7	33	9240	5026	"This world is most notable for Edzaonian lethal water but plagued by occasional solar activity."
"LERITEAN"	221	191	1	7	2	17	2040	3293	"The planet Leritean is mildly well known for its exotic cuisine."
"VEALE"	155	60	7	4	10	52	27456	4507	"The world Veale is most well known for its vast dense forests."
"EDLE"	167	33	3	1	11	49	24696	5031	"Edle is  famous for its inhabitants' exceptional love for food blenders but scourged by frequent civil war."
"ANLAMA"	25	96	2	0	9	39	18720	5657	"This world is a tedious little planet."
"RIBILEBI"	252	11	4	3	6	32	14336	6652	"The planet Ribilebi is most famous for its vast oceans and its fabulous goat soup."
"RELAES"	6	129	4	1	10	46	26496	6406	"This world is a tedious place."
"DIZAONER"	77	41	2	1	8	36	15552	6221	"Dizaoner is ravaged by unpredictable solar activity."
"RAZAAR"	112	95	3	7	2	19	3192	3952	"The world Razaar is a dull place."
"ENONLA"	99	106	7	2	12	58	40832	3427	"Enonla is ravaged by dreadful civil war."
"ISANLEQU"	200	149	1	7	1	13	1560	6344	"This planet is beset by a evil disease."
"TIBECEA"	250	225	1	3	7	33	9240	4858	"Tibecea is very fabled for the Tibeceaian edible poet."
"SOTERA"	15	5	4	5	7	38	12160	4623	"Sotera is mildly notable for Soteraian lethal brandy."
"ESVEOR"	88	52	2	4	4	23	6624	5208	"Esveor is mildly famous for its pink oceans and Zero-G hockey."
"ESTEONBI"	25	57	6	1	10	48	34560	5145	"This planet is mildly fabled for its inhabitants' ingrained shyness but cursed by unpredictable solar activity."
"XEESENRI"	230	127	0	7	2	16	1536	3558	"Xeesenri is mildly notable for its inhabitants' wierd shyness."
"ORESLE"	190	210	5	2	10	48	27648	5310	"This world is reasonably notable for its great volcanoes but ravaged by a vicious disease."
"ERVEIN"	196	193	5	1	9	43	27864	3012	"Ervein is a revolting little planet."
"LARAIS"	19	236	3	4	8	40	13440	4115	"This world is a revolting dump."
"ANXEBIZA"	104	189	7	5	6	37	16280	5736	"The planet Anxebiza is an unremarkable dump."
"DIEDAR"	164	134	6	6	4	29	9280	6308	"This world is ravaged by dreadful civil war."
"ENINRE"	47	106	0	2	8	35	8960	3375	"The planet Eninre is cursed by deadly civil war."
"BIBE"	172	238	0	6	1	11	1408	4524	"This world is most fabled for Bibian lethal brandy but beset by a evil disease."
"DIQUXE"	249	211	6	3	8	42	23520	6393	"This planet is mildly noted for its ancient mountains but plagued by frequent earthquakes."
"SORACE"	74	34	7	2	11	54	38016	4682	"Sorace is cursed by deadly civil war."
"ANXEONIS"	193	133	3	5	5	29	8120	5825	"The planet Anxeonis is most famous for its vast rain forests."
"RIANTIAT"	189	63	5	7	4	29	6264	6589	"This planet is  notable for the Riantiatian edible grub and the Riantiatian spotted wolf."
"ZARECE"	49	119	5	7	4	29	6264	3889	"This planet is a tedious place."
"MAESIN"	152	229	0	7	0	8	768	5784	"The planet Maesin is an unremarkable dump."
"TIBIONIS"	65	108	6	4	7	39	18720	4673	"Tibionis is most noted for the Tibionisian deadly goat and its vast rain forests."
"GELEGEUS"	253	159	2	7	2	18	2592	3837	"Gelegeus is mildly notable for Gelegeusian Bidist brandy."
"DIORA"	200	227	4	3	6	32	14336	6344	"The planet Diora is an unremarkable planet."
"RIGETI"	213	79	1	7	2	17	2040	6613	"Rigeti is a revolting dump."
"BEGEABI"	24	119	1	7	1	13	1560	3608	"Begeabi is very notable for its inhabitants' wierd silliness."
"ORRERE"	6	143	7	7	6	39	10296	5126	"Orrere is mildly well known for Orrerian vicious brew."
"BETI"	150	206	3	6	5	30	6720	3734	"This planet is  fabled for its wierd volcanoes and the Betian mountain lobstoid."
"GERETE"	171	32	2	0	11	47	22560	3755	"This world is most fabled for Zero-G cricket but cursed by unpredictable solar activity."
"QUCERERE"	78	252	4	4	7	37	14208	5454	"This planet is a tedious place."
"XEONER"	78	78	4	6	5	31	7936	3406	"The world Xeoner is a dull world."
"XEZAOR"	146	112	2	0	10	43	20640	3474	"The world Xezaor is most well known for its hoopy casinos."
"RITILA"	32	89	3	1	8	37	18648	6432	"The world Ritila is very famous for its hoopy casinos but beset by a evil disease."
"EDORTE"	139	85	7	5	9	49	21560	5003	"The planet Edorte is an unremarkable dump."
"ZAALELA"	46	220	1	6	4	24	3840	3886	"This world is  noted for its fabulous goat soup."
"BIISORTE"	213	129	1	3	6	29	8120	4565	"This world is most notable for its fabulous  Biisortian lethal water  but beset by a lethal disease."
"BEESOR"	156	57	4	1	8	38	21888	3740	"This world is plagued by deadly earthquakes."
"ORESQU"	22	217	2	1	9	40	17280	5142	"Oresqu is mildly notable for its inhabitants' unusual mating traditions."
"XEQUQUTI"	221	250	6	2	9	45	28800	3549	"This planet is beset by dreadful earthquakes."
"MAISES"	151	58	0	2	8	35	8960	5783	"Maises is reasonably notable for its fabulous  Maisesian lethal water  but beset by a lethal disease."
"BIERLE"	233	64	5	0	11	50	36000	4585	"The planet Bierle is most famous for the Bierlian deadly Inoid and its inhabitants' ingrained silliness."
"ARZASO"	216	225	5	1	9	43	27864	5592	"Arzaso is an unremarkable planet."
"TEEN"	117	39	3	7	3	23	3864	2933	"Teen is cursed by deadly civil war."
"RIREDI"	47	82	7	2	12	58	40832	6447	"This world is very fabled for the Riredian mountain slug."
"TEORGE"	45	46	6	6	5	33	10560	5933	"This planet is a tedious little planet."
"VEBEGE"	89	195	0	3	5	24	5376	4441	"The world Vebege is mildly fabled for the Vebegian mountain lobstoid but beset by deadly solar activity."
"XEENLE"	236	163	0	3	4	20	4480	3564	"This planet is mildly noted for its ancient mountains but plagued by a lethal disease."
"ARXEZA"	22	1	6	1	11	52	37440	5398	"The world Arxeza is beset by dreadful earthquakes."
"EDREOR"	241	4	7	4	8	44	23232	5105	"The world Edreor is reasonably fabled for its fabulous  killer Sese juice  and its ancient Edreorian Us plant plantations."
"ESGEREAN"	193	217	3	1	9	41	20664	5313	"This planet is plagued by occasional solar activity."
"DITIZA"	27	110	5	6	7	40	11520	6171	"The planet Ditiza is reasonably fabled for Ditizaian evil juice and its inhabitants' ingrained silliness."
"ANLE"	228	0	5	0	10	46	33120	5860	"The world Anle is  notable for its great tropical forests and Anlian evil brandy."
"ONISQU"	29	1	0	3	5	24	5376	6685	"This planet is a dull place."
"ALEUSQU"	215	122	6	2	11	53	33920	6871	"This world is reasonably notable for its great volcanoes but ravaged by vicious vicious shrews."
"ZASOCEAT"	186	72	2	0	10	43	20640	4026	"Zasoceat is a revolting dump."
"RILACE"	81	133	4	5	5	30	9600	6481	"The world Rilace is a dull world."
"BEENRI"	249	165	1	7	2	17	2040	3833	"This planet is mildly noted for the Beenrian mountain Esseinaoid but scourged by frequent civil war."
"LAEDEN"	4	254	1	6	2	16	2560	4100	"The planet Laeden is reasonably fabled for its exciting sit coms and its inhabitants' exceptional love for food blenders."
"MARIAR"	96	178	7	2	9	46	32384	5728	"This world is  fabled for its unusual tropical forests."
"RIISER"	52	74	3	2	7	34	15232	6452	"Riiser is cursed by dreadful civil war."
"QUTIRI"	44	176	2	0	8	35	16800	5420	"The world Qutiri is mildly noted for its ancient mountains but plagued by deadly earthquakes."
"BIRAMABI"	80	190	4	6	3	23	5888	4432	"The world Biramabi is a dull world."
"SOORBI"	134	235	4	3	8	40	17920	4742	"The planet Soorbi is an unremarkable dump."
"SOLAGEON"	135	134	2	6	5	29	5568	4743	"This world is very well known for Solageonian lethal water and the Solageonian tree wolf."
"TIQUAT"	191	35	3	3	9	43	16856	4799	"This world is reasonably well known for its great parking meters but cursed by unpredictable earthquakes."
"REXEBE"	98	17	7	1	12	57	45144	6498	"This world is mildly famous for its hoopy night life and its exotic cuisine."
"QUBEEN"	132	243	1	3	5	25	7000	5508	"This world is ravaged by unpredictable civil war."
"CETIISQU"	96	242	1	2	6	28	8960	4192	"This planet is reasonably famous for the Cetiisquian evil Stoid."
"REBIA"	26	61	4	5	6	34	10880	6426	"Rebia is very notable for its inhabitants' wierd shyness."
"ORDIMA"	132	79	2	7	1	14	2016	5252	"This planet is reasonably noted for its exotic goat soup."
"ARUSZATI"	146	139	6	3	9	46	25760	5522	"This planet is  noted for Zero-G cricket."
"ZALERIZA"	247	196	0	6	4	23	2944	4087	"This world is a tedious place."
"ZASOER"	4	126	5	6	4	28	8064	3844	"Zasoer is mildly well known for its exotic night life."
"RALEEN"	156	208	5	0	10	46	33120	3996	"This planet is  notable for the Raleenian tree grub and its inhabitants' unusual silliness."
"QURAVE"	199	50	3	2	10	46	20608	5575	"The planet Qurave is mildly notable for Quravian Zaaronen brandy."
"ATREBIBI"	166	182	7	6	7	42	14784	3238	"The world Atrebibi is most famous for the Atrebibian deadly monkey."
"TEESDI"	166	166	6	6	6	37	11840	6054	"Teesdi is  famous for Teesdian shrew cutlet but ravaged by occasional solar activity."
"ARARUS"	51	237	0	7	3	20	1920	5427	"Ararus is most famous for its pink Esoneril tulip plantations and its wierd exuberant forests."
"ARA"	28	40	0	2	5	23	5888	6684	"The world Ara is scourged by a evil disease."
"TIANVE"	227	0	6	0	13	59	47200	4835	"The planet Tianve is reasonably noted for its inhabitants' exceptional loathing of food blenders and Zero-G cricket."
"QUORTE"	136	182	7	6	5	34	11968	5512	"Quorte is  well known for the Quortian tree wolf but scourged by dreadful solar activity."
"SOLADIES"	112	252	3	4	5	28	9408	4720	"This planet is  fabled for its exciting  Soladiesian evil brandy ."
"MAXEEDSO"	105	109	5	5	6	35	12600	5737	"This world is mildly famous for its vast rain forests and the Maxeedsoian tree wolf."
"XEXEDI"	71	88	5	0	13	58	41760	3399	"The planet Xexedi is scourged by a deadly disease."
"XEXETI"	146	237	0	7	2	16	1536	3474	"This planet is  notable for the Xexetian edible arts graduate and its great volcanoes."
"TIINLEBI"	29	87	6	7	4	30	7200	4637	"The planet Tiinlebi is most noted for the Tiinlebian mountain slug and its inhabitants' exceptional loathing of food blenders."
"RATEEDAR"	102	193	2	1	9	40	17280	3942	"Rateedar is cursed by dreadful civil war."
"ONLEMA"	138	248	4	0	11	49	31360	6794	"This world is plagued by frequent solar activity."
"ORERVE"	12	203	1	3	5	25	7000	5132	"This planet is a dull place."


Errors is a list of texts that varies.

To error-check (title - a text) for (t1 - a text) and (t2 - a text):
	unless "[t1]" exactly matches the text t2, add "[title] ('[t1]', should be '[t2]')" to errors;

To error-check (title - a text) for (n1 - a number) and (n2 - a number):
	if n1 is not n2, add "[title] ([n1], should be [n2])" to errors;

Last when play begins (this is the galaxy generator test rule):
	repeat with i running from 1 to the number of rows in the Table of Planetary Systems:
		choose row i in the Table of Planetary Systems;
		let name be the name entry;
		let x be the x entry;
		let y be the y entry;
		let economy type be the economy type entry;
		let government type be the government type entry;
		let tech level be the tech level entry;
		let population be the population entry;
		let productivity be the productivity entry;
		let radius be the radius entry;
		choose row i in the Table of Planetary Testing Data;
		error-check "planet name" for the name and the name entry in sentence case;
		error-check "x" for the x and the x entry;
		error-check "y" for the y and the y entry;
		error-check "government type" for the government type and the gov entry;
		error-check "tech level" for the tech level and the tech entry;
		error-check "population" for the population and the pop entry;
		error-check "productivity" for the productivity and the prod entry;
		error-check "radius" for the radius and the radius entry;
		if errors is not empty:
			say "[bold type][name entry] (SYSTEM [i - 1]) ERROR[if the number of entries in errors is not 1]S[end if]![roman type] [errors].";
		now errors is { }.


Volume - The Game

Chapter - Star Travel

The Cobra Mk III is a neuter person. The player is the Cobra Mk III. Understand "Cobra" or "Mk" or "III" as the Cobra Mk III. The description is "The Cobra MK III is described as the pinnacle of medium-range, medium capacity fighter-traders. In shape, it resembles a flat-topped pentagonal pyramid cut squarely in half. Yours is painted gunmetal gray, with blue trimmings."

The print empty inventory rule response (A) is "Your cargo hold is empty."

Short-range scanning is an action applying to one thing. Understand "scan [something]" as short-range scanning. Understand the command "map" as "scan".

Rule for supplying a missing noun while short-range scanning (this is the if in doubt scan the stars rule):
	now the noun is the stars.

Carry out short-range scanning (this is the display map of stellar neighborhood rule): 
	say "You glance at the local systems screen.[paragraph break]";
	map the stars.
	
Chapter - The Game

Space is a room. "Deep space surrounds you."
Some stars are backdrop. The stars are scenery in space. The description of the stars is "Pinpricks in the infinite dark." Understand "nearby/local" or "systems" as the stars.

The player is in space. 
