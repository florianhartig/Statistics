# Übung zur Vorlesung 3 - Hypothesentests
Florian Hartig  
20 Nov 2016  

# Variabilität 

Machen wir uns noch mal klar dass durch zufällige Variabilität Muster in Daten entstehen können die zwar aussehen wie ein Effekt, aber nicht systematisch sind. Hier das Beispiel eines Experimentes in dem der Erfolg eines Medikamentes getestet wurde. Es gibt 2 Gruppen, einmal die Kontrolle (kein Medikament), und zum zweiten die Behandlung. Ich habe den Zufallsgenerator aber so programmiert dass beide Gruppen den gleichen Behandlungserfolg haben. Trotzdem sehen ist der gemessene Erfolg in der Behandlungsgruppe höher



```r
set.seed(123)
Daten = data.frame(Geheilt = rbinom(50, 1, 0.5), Behandlung = rep(c("Kontrolle", "Behandlung"), each = 25))
x = table(Daten$Geheilt, Daten$Behandlung)
barplot(x)
```

![](Uebung3_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

Wenn wir viele Computerexperiment machen sehen wir aber dass dass ein solches Ergebnis nicht außergewöhnlich ist, sondern im Rahmen der normal erwarteten Streuung einer solchen, relativ kleinen Stichprobe liegt. Wenn sie die folgende Animation zu Hause sehen wollen müssten Sie das in R laufen lassen.



```r
library(animation)

oopt = ani.options(interval = 0.5, nmax = 50)
## use a loop to create images one by one
for (i in 1:ani.options("nmax")) {
    Daten = data.frame(Geheilt = rbinom(50, 1, 0.5), Behandlung = rep(c("Kontrolle", "Behandlung"), each = 25))
    xn = table(Daten$Geheilt, Daten$Behandlung)
    barplot(xn)
    ani.pause()  ## pause for a while ('interval')
}
## restore the options
ani.options(oopt)
```

# Hypothesentests

Die Frage die wir uns also stellen wenn wir beobachtete Daten bekommen: zeigen diese einen eindeutigen systematische Effekt an, oder könnten die Daten genausogut durch Zufall entstanden sein?

Hypothesentests beantworten diese Frage durch den folgenden Ansatz

1. Wir denken uns erst mal ein Modell M für die Streuung der Daten aus
2. Dann erstellen wir eine Nullhypothese H0, typischerweise dass es keine systematischen Effekte gibt und die Variabilität in den Daten nur durch die zufällige Streuung kommt die in M beschrieben wird (H0 beinhaltet M)
3. Dann denken wir uns eine Teststatistik aus die den untersuchten Effekt beschreibt
4. Jetzt benutzen wir H0 mit M und überlegen uns was wir für Werte für die Teststatistik erwarten würden wenn H0 wahr wäre - der p-Wert ist dann definiert als p(d >= D| M, H0), also die Wahrscheinlichkeit dass die beobachteten Daten D gleich oder größer sind als die Daten d die unter M, H0 erwartet werden. >= ist in Bezug auf die Teststatistik
5. Wenn p < 0.05 wird sagen wir der Effekt ist signifikant, und wir können die Nullhypothese ablehnen

## Beispiel Medikament

Gehen wir das mal durch für unser Beispiel

1. Modell ist das Binominialmodell - Münzwurf mit einer festen Wahrscheinlichkeit von Behandlungserfolg p
2. H0: p ist identisch für Behandlung und Kontrolle
3. Teststatistik: Unterschied in den Proportionen
4. Wahrscheinlichkeit - die kann man exakt ausrechenen (wie gesagt, die Binominialformel war ja eigentlich Abistoff). In R bekommen Sie die Wahrscheinlichkeit mit der prop.test funktion
5. Wenn es < 0.05 ist sagen wir es ist signifikant - dann schauen wir doch mal für die Daten oben 


```r
prop.test(x)
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  x
## X-squared = 2.88, df = 1, p-value = 0.08969
## alternative hypothesis: two.sided
## 95 percent confidence interval:
##  -0.02609353  0.58609353
## sample estimates:
## prop 1 prop 2 
##   0.64   0.36
```

der p-Wert ist also 0.09 ... das ist ...

Genau, nicht signifikant.

Was sagt uns das?

Richtige Antwort: ein signifikanter Effekt konnte nicht nachgewiesen werden. Das ist aber kein Beweis dafür dass kein Effekt da ist.

Falsche Antwort: der p-Wert > 0.05, also sind wir sicher dass es keinen Effekt gibt. Merken Sie sich: wenn das Ergebnis nicht signifikant ist können Sie nichts sagen. 

Wenn sie genau auf das Ergebnis schauen sehen Sie die Bemerkung "alternative hypothesis: two.sided" - das heißt dass der Test sowohl testet ob mit dem Medikament eventuell MEHR also auch WENIGER Patienten geheilt werden als in der Kontrolle. 

Wenn Sie sicher sind dass das Medikament nur eine positive Wirkung haben kann könnten Sie die Nullhypothese auch genauer fassen und sagen sie wollen nur auf positive Abweichungen testen


```r
prop.test(x, alternative = "greater")
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  x
## X-squared = 2.88, df = 1, p-value = 0.04484
## alternative hypothesis: greater
## 95 percent confidence interval:
##  0.01668727 1.00000000
## sample estimates:
## prop 1 prop 2 
##   0.64   0.36
```

Jetzt wäre der Test signifikant. Das liegt daran dass wir eine spezifischere Nullhypothese testen. Man sagt der Einseitige Test hat eine größere Power. 

**Vorsicht:** Jetzt könnten Sie doch denken: super, der einseitige Test hat mehr Power, dann mache ich es doch so: ich schaue mir erst mal die Daten an in welche Richtung der Effekt geht, und wenn ich sehe die Behandlung ist größer als die Kontrolle dann teste ich in die eine Richtung, und wenn die Behandlung kleiner ist dann teste ich in die andere - ** Das ist SEHR SEHR FALSCH ** - Wenn Sie ihre Nullhypothese gezielt auf die Daten anpassen können Sie immer signifikanz erzeugen. Sie können gerne einseitig testen, aber Sie müssen diese Entscheidung fällen bevor Sie sich die Daten angeschaut haben (siehe auch Bemerkung in der Vorlesung nächste Woche). 


## Typ I Fehler 

Ich wollte Ihnen noch mal zeigen dass es wiklich so ist das bei wiederholten Experimenten genau 5% falsche positive Entstehen - hier eine Wiederholung von 1000 Experimenten mit je 10.000 Teilnehmer, und einem Medikament dass keinen Effekt hat. Trotzdem entstehen 5% falsche positive.



```r
p = rep(NA, 1000)

for (i in 1:1000){
  Daten = data.frame(Geheilt = rbinom(10000, 1, 0.5), Behandlung = rep(c("Kontrolle", "Behandlung"), each = 5000))
  xn = table(Daten$Geheilt, Daten$Behandlung)
  test = prop.test(xn)
  p[i] = test$p.value
}
hist(p, breaks = 100)
```

![](Uebung3_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
mean(p < 0.05) 
```

```
## [1] 0.049
```


## Power

Wir hatten bei unserem Experiment ja keinen Effekt. Vielleicht lag es ja daran dass wir nicht genug Samples hatten. Nehmen wir mal an der Effekt den wir gesehen hatten war echt - zur Erinnerung, das waren die Daten


```r
x
```

```
##    
##     Behandlung Kontrolle
##   0         16         9
##   1          9        16
```

mit den Proportionen 


```r
prop.test(x, alternative = "greater")
```

```
## 
## 	2-sample test for equality of proportions with continuity
## 	correction
## 
## data:  x
## X-squared = 2.88, df = 1, p-value = 0.04484
## alternative hypothesis: greater
## 95 percent confidence interval:
##  0.01668727 1.00000000
## sample estimates:
## prop 1 prop 2 
##   0.64   0.36
```

wenn die Propotionen wirklich so wären, wie viele Daten bräuchte man denn um einen Effekt zu sehen? Das sagt uns die Poweranalyse. R hat dafür die funktion 


```r
power.prop.test(n = 25, p1 = 0.64, p2 = 0.36)
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 25
##              p1 = 0.64
##              p2 = 0.36
##       sig.level = 0.05
##           power = 0.5082837
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

Mit unsere Stichprobengröße hatten wir als 50% power, d.h. 50% Wahrscheinlichkeit einen Effekt zu sehen (wenn 64/36 die wahren Propotionen sind, was man im Allgemeinen natürlich nicht weiß). Wie viele Daten bräuchten wir denn für 95% Power?


```r
power.prop.test(power = 0.95, p1 = 0.64, p2 = 0.36)
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 79.87685
##              p1 = 0.64
##              p2 = 0.36
##       sig.level = 0.05
##           power = 0.95
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

80 Beobachtugen pro Gruppe ... das ist schon deutlich mehr. 

## False Discovery Rate FDR

Stellen Sie sich vor wir testen 1000 Wirkstoffe gegen Krebs mit unserer vorherigen Stichprobengröße. Nehmen wir mal an dass 95% der Mittel nicht wirken, aber wenn sie wirken dann bewirken sie eine Heilungsrate von 85%, gegenüber 75% ohne das Medikament. Sie testen ihren ersten Wirkstoff und er kommt signifikant zurück. Was ist die Wahrscheinlichkeit dass er wirklich wirkt?

Antwort: rechen wir erst mal die Power aus:


```r
power.prop.test(n = 25, p1 = 0.85, p2 = 0.75)
```

```
## 
##      Two-sample comparison of proportions power calculation 
## 
##               n = 25
##              p1 = 0.85
##              p2 = 0.75
##       sig.level = 0.05
##           power = 0.1390523
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

Power ist 13%. Also, 13% der Stoffe die wirklich wirken kommen signifikant zurück, aber auch 5% der Stoffe die nicht wirken. Leider gibt es viel mehr Stoffe die nicht wirken. Also ist die Wahrscheinlichkeit dass ihr signifikantes Ergebnis in wirklichkeit eine "Niete" ist


```r
0.95*0.05 / (0.95*0.05  + 0.05*0.13)
```

```
## [1] 0.8796296
```

Wenn uns das zu niedrig ist können haben wir 2 Möglichkeiten. Welche?

1. Stichprobengröße erhöhen, das erhöht die Power
2. Siginfikanzlevel verringert, das verringert die falschen Positiven


# Andere Tests mit den Daten des Kurses


```r
Klasse <- read.delim("~/Home/Teaching/Vorlesungen/Statistik/Vorlesungen/16-11-Biostatistik/Biostatistik Vorlesung.csv", na.strings = "")
attach(Klasse)
```

## Numerisch - Kategorial: der t-Test

Fangen wir doch mal an mit 


```r
boxplot(Körpergröße ~ Geschlecht)
```

![](Uebung3_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

Numerische Abhängige Variable, kategorialer Prädiktor - was kann man da nehmen? 

Genau, t-test ... solange?

Genau, Normalverteilung der Gruppen. Schauen wir doch mal optisch

![](Uebung3_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

also, diese Ausreißer mit 300 wären nicht gut. Die nehme ich daher für den t-test raus. 

![](Uebung3_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

So sieht es schon besser aus. Aber sind die jetzt wirklich normalverteil? Wie könnte man das denn testen?

Genau, mit einem Test auf Normalverteilung. Da gibt es den Shapiro-Wilk test


```r
shapiro.test(Körpergröße[Geschlecht == "Weiblich" & Körpergröße < 220])
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  Körpergröße[Geschlecht == "Weiblich" & Körpergröße < 220]
## W = 0.96262, p-value = 0.5705
```

```r
shapiro.test(Körpergröße[Geschlecht == "Männlich" & Körpergröße < 220])
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  Körpergröße[Geschlecht == "Männlich" & Körpergröße < 220]
## W = 0.79663, p-value = 0.0548
```

Was heißt das?

Wir können keine signifikante Abweichung von der Normalverteilung nachweisen. Bei den Männern ist es aber knapp. 

Bemerkung: die Siginfikanz ist kein strenges Kriterium für die Anwendung des t-tests, nur ein Indikator. Es kann durchaus sein dass man trotz signifikanter Abweichungen von der Normalverteilung den t-test anwendet. Aber diese Entscheidungen können wir hier nicht im Detail diskutieren. Ich zeige ihnen jetzt einfach mal das Ergebnis des t-tests


```r
t.test(Körpergröße[Geschlecht == "Männlich" & Körpergröße < 220], Körpergröße[Geschlecht == "Weiblich" & Körpergröße < 220])
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  Körpergröße[Geschlecht == "Männlich" & Körpergröße < 220] and Körpergröße[Geschlecht == "Weiblich" & Körpergröße < 220]
## t = 5.7724, df = 11.095, p-value = 0.0001201
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##   7.517661 16.768053
## sample estimates:
## mean of x mean of y 
##  179.0000  166.8571
```

und das ist klar signifikant. War ja auch zu erwarten. Wie sieht es denn aus mit der Beziehung zwischen Körpergröße und Transportmitte? 


```r
boxplot(Körpergröße ~ Transport)
```

![](Uebung3_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

Ich test mal gegen Auto / Bus, die anderen beiden sind ja sinnlose weil zu wenige Daten


```r
t.test(Körpergröße[Transport == "Bus" & Körpergröße < 220], Körpergröße[Transport == "Auto" & Körpergröße < 220])
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  Körpergröße[Transport == "Bus" & Körpergröße < 220] and Körpergröße[Transport == "Auto" & Körpergröße < 220]
## t = 1.2939, df = 15.766, p-value = 0.2143
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -2.56592 10.58063
## sample estimates:
## mean of x mean of y 
##  170.8824  166.8750
```

nein, einen siginfikanten Effek können wir hier nicht nachweisen. 


### Numerisch-Numerisch: Test auf Signifikanz der Korrelation

Frage: was ist H0?

Antwort: keine Korrelation. Diese Nullhypothese können Sie so testen


```r
plot(Körpergröße, Distanz)
```

![](Uebung3_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

```r
cor.test(Körpergröße, Distanz)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  Körpergröße and Distanz
## t = 1.4643, df = 27, p-value = 0.1547
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  -0.1057770  0.5800824
## sample estimates:
##       cor 
## 0.2712442
```

### Kategorial-Kategorial: Test auf Assoziation in Kontingenztabellen

Frage: was ist H0?

Antwort: keine Assoziation

Der Standardtest hierfür ist der Pearson's Chi-Quadrat Test


```r
chisq.test(table(Geschlecht, Augenfarbe))
```

```
## Warning in chisq.test(table(Geschlecht, Augenfarbe)): Chi-squared
## approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(Geschlecht, Augenfarbe)
## X-squared = 1.2072, df = 2, p-value = 0.5468
```

Allerdings bekommen wir hier eine Warnung ... die kommt weil wir eine sehr kleine Stichprobebgröße haben, hierfür ist der Test nicht ausgelegt. In dem Fall ist der Test von Fischer besser



```r
fisher.test(table(Geschlecht, Augenfarbe))
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  table(Geschlecht, Augenfarbe)
## p-value = 0.6294
## alternative hypothesis: two.sided
```

Aber auch der ist nicht signifikant









