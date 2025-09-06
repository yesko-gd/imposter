# Spiel

Ein Imposter-Spiel, stark inspiriert vom Spiel "Finde den Imposter" bei **Splash - Party Spiele**.

## Regeln:

**Ich verwende der Einfachheit das generische Maskulinum; jedes männliche Pronomen/Nomen umfasst *alle* Geschlechter.**

### Ziel

Es gibt **Unschuldige** und **Imposter**; diese Rollen werden zufällig aufgeteilt. In jeder Runde gibt es ein zufälliges Nomen, das jeder Spieler außer den Impostern angezeigt bekommt. Die Imposter müssen herausfinden, was dieses Wort ist, bevor sie von den Unschuldigen erkannt werden.

### Ablauf

Sobald der Timer losgeht, sagen alle Spieler (auch die Imposter) reihum jeweils ein Wort, das zum Lösungswort passt. Für alle Unschuldigen gilt:
1. kein Teil des gesagten Wortes darf in der gleichen Wortfamilie sein wie ein Teil des Lösungswortes, oder eine Übersetzung davon sein. Beispiele mit dem Lösungswort "Industriezucker":

```
✔ süß
✔ Insulin
✕ sugar
✕ Industrialisierung
```

2. Außerdem darf kein bereits gesagtes Wort verwendet werden.

Wird Regel (2) gebrochen, muss der Spieler ein weiteres Wort sagen. Für Regel (1) siehe **Spielende**.

### Spielende

Die Spieler können sich jederzeit darauf einigen, abzustimmen, wer der Imposter ist. Dann wird der Timer für die Dauer der Abstimmung pausiert. Der Spieler, für den gestimmt wird, scheidet aus dem Spiel aus.
Wenn der Timer abgelaufen ist, müssen die Spieler abstimmen.

**Wenn ein Spieler, unabhängig von seiner Rolle, in seinem Zug ein Wort sagt, das nach der oben genannten Regel (1) nicht erlaubt ist, ist das Spiel beendet und die Imposter haben gewonnen.**

**Sobald keine Imposter mehr im Spiel sind, haben die Unschuldigen gewonnen. Sobald nur noch Imposter im Spiel sind, haben die Imposter gewonnen.**

# Programm

Das Spiel wird in Godot gemacht, d.h. um es zu spielen kann man es einfach in den [Godot Editor](https://godotengine.org/download/) importieren.

Releases sind leider noch nicht verfügbar und das Spiel ist noch ein Prototyp. Deshalb gibt es auch im Moment nur ein einziges Wort; um es zu spielen müsste man seine eigenen hinzufügen.
