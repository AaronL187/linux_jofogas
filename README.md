

<h2 class="code-line" data-line-start=2 data-line-end=3 ><a id="Script_neve_jofogassh_2"></a>Script neve: <a href="http://jofogas.sh">jofogas.sh</a></h2>
<p class="has-line-data" data-line-start="4" data-line-end="5">Ez a szkript a <a href="http://www.jofogas.hu">www.jofogas.hu</a> weboldalon végzett keresések eredményeit dolgozza fel. A szkript egy kulcsszó és egy maximális ár megadásával hajt végre keresést, majd kiírja az összes talált hirdetést, amelynek az ára nem haladja meg a maximális árat.</p>
<h3 class="code-line" data-line-start=6 data-line-end=7 ><a id="Hasznlat_6"></a>Használat:</h3>
<pre><code class="has-line-data" data-line-start="8" data-line-end="10">./jofogas.sh &lt;kulcsszó&gt; &lt;maximális_ár&gt;
</code></pre>
<h3 class="code-line" data-line-start=11 data-line-end=12 ><a id="Paramterek_11"></a>Paraméterek:</h3>
<ul>
<li class="has-line-data" data-line-start="12" data-line-end="13"><code>&lt;kulcsszó&gt;</code>: a kereséshez használt kulcsszó.</li>
<li class="has-line-data" data-line-start="13" data-line-end="15"><code>&lt;maximális_ár&gt;</code>: a keresési eredmények közül kiválasztott hirdetések maximális ára.</li>
</ul>
<h3 class="code-line" data-line-start=15 data-line-end=16 ><a id="Fggvnyek_15"></a>Függvények:</h3>
<ol>
<li class="has-line-data" data-line-start="16" data-line-end="17"><code>getPage</code>: Az adott kulcsszóhoz tartozó keresési eredményeket kéri le a <a href="http://jofogas.hu">jofogas.hu</a> weboldalról és menti azokat egy “jofogas.html” nevű fájlba.</li>
<li class="has-line-data" data-line-start="17" data-line-end="18"><code>getAllLinks</code>: Az összes releváns linket kinyeri a letöltött html fájlból és elmenti azokat egy “alllinks.csv” nevű fájlba.</li>
<li class="has-line-data" data-line-start="18" data-line-end="19"><code>getWorkingLinks</code>: Csak a munkafeldolgozók által feldolgozható linket kinyeri a letöltött html fájlból és elmenti azokat egy “workinglinks.csv” nevű fájlba.</li>
<li class="has-line-data" data-line-start="19" data-line-end="21"><code>loopLinks</code>: Végigmegy az összes “workinglinks.csv” fájlban szereplő linken, megszerzi az árat és a hirdetési dátumot, majd kiírja azokat a konzolra és egy “ads.csv” nevű fájlba.</li>
</ol>
<h3 class="code-line" data-line-start=21 data-line-end=22 ><a id="Kimenet_21"></a>Kimenet:</h3>
<p class="has-line-data" data-line-start="22" data-line-end="23">A szkript a talált hirdetések listáját írja ki a konzolra a következő formátumban:</p>
<pre><code class="has-line-data" data-line-start="24" data-line-end="26">sorszám | hirdetési link | ár | dátum
</code></pre>
<p class="has-line-data" data-line-start="26" data-line-end="27">Ezen kívül az eredmények egy “ads.csv” nevű fájlba is mentésre kerülnek ugyanebben a formátumban.</p>

