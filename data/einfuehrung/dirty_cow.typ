#import "@preview/wrap-it:0.1.1"

== Was ist Dirty COW
#let cow = figure(
  image("../../cow.svg", width: 100%),
  caption: [Dirty COW Logo],
)
#let text = [CVE-2016-5195 oder auch bekannt als \"Dirty @cow:short\", ist eine kritische Sicherheitslücke im Linux-Kernel, die 2016 entdeckt wurde. Die Lücke ermöglicht es einem angreifenden Benutzer, schreibbare Bereiche des Systems zu manipulieren, ohne über die notwendigen Berechtigungen zu verfügen. Der Name \"Dirty @cow:short\" und das Logo(@cow) leitet sich von der Funktionsweise des @cow:both Mechanismus ab, bzw. von einer Schwachstelle @cow:short Speichersystems und der Kernel-Funktion Dirty Bit]
#wrap-it.wrap-content(cow, text, align: top + right)

Bei der Ausnutzung dieser Schwachstelle kommt es zu einer Race Condition im @cow:short Machanismus des Kernels, wodurch ein Angreifer eine schreibbare Referenz auf eigentlich schreibgeschützte, private Speicherbereiche erhält bevor @cow:short erfolgreich zurückgegeben werden konnte.
Praktisch bedeutet das Angreifer ihre Berechtigungen auf dem System erhöhen können um sich z.B. Root-Zugriff zu verschaffen.

Die Schwachstelle wurde im Jahr 2016 von Phil Oester entdeckt und im gleichen Jahr von Linus Torvalds behoben, jedoch wurde dieser Patch im Jahr 2017 rückgängig gemacht, da der Patch eine neue Sicherheitslücke im Kernel verursachte.
@home @dirtycowarticle Nach Aussagen von Linus Torvalds handlete es sich bei diesem Bug um einen alten Bug, der bereits 11 Jahre zuvor entedeckt und (schlecht) behoben wurde, jedoch wurde dieser Fix auch rückgängig gemacht, da dies Probleme mit IBM System/390 verursachte.@linux_mm_remove_gup_flags_2016
