#import "@preview/wrap-it:0.1.1"

== Was ist Dirty COW
#let cow = figure(
  image("../../cow.svg", width: 100%),
  caption: [Dirty COW Logo],
)
#let text = [@cve:short -2016-5195 oder auch bekannt als \"Dirty @cow:short\", ist eine kritische Sicherheitslücke im Linux-Kernel, die 2016 entdeckt wurde. Die Lücke ermöglicht es einem angreifenden Benutzer, schreibbare Bereiche des Systems zu manipulieren, ohne über die notwendigen Berechtigungen zu verfügen. Der Name \"Dirty @cow:short\" und das Logo(@cow) leitet sich von der Funktionsweise des @cow:both Mechanismus ab, bzw von einer Schwachstelle @cow:short Speichersystems.]
#wrap-it.wrap-content(cow, text, align: top + right)

Bei der Ausnutzung dieser Schwachstelle kommt es zu einer Race Condition im @cow:short Machanismus des Kernels, wodurch ein Angreifer eine schreibbare Referenz auf eigentlich schreibgeschützte, private Speicherbereiche erhält bevor @cow:short erfolgreich ausgeführt werden konnte.
Praktisch bedeutet das Angreifer ihre Berechtigungen auf dem System erhöhen können um sich z.B. Root-Zugriff zu verschaffen.

Die Schwachstelle wurde von Phil Oester entdeckt und im gleichen Jahr behoben, jedoch wurde dieser Patch im Jahr 2017 rückgängig gemacht, da der Patch eine neue Sicherheitslücke im Kernel verursachte.
@home @dirtycowarticle
