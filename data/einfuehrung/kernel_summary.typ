#import "@preview/wrap-it:0.1.1": wrap-content

#let w = 2.7396in


#set figure(supplement: [Abbildung])

#let fig = block(width: w)[
  #figure(
    image("media/Symbol-Linux Kernel.jpg", width: w),
    caption: [Linux Logo],
  ) <fig:linux-logo>
]

#wrap-content(
  box(fig, inset: 0.25em),
  [
    == Was ist der Linux-Kernel

    Im Folgenden wird der Linux-Kernel (siehe @fig:linux-logo) als technische Grundlage für die weitere Analyse
    der von uns gewählten Sicherheitslücke eingeführt.

    Der Linux-Kernel ist der zentrale Bestandteil des Betriebssystems. Er abstrahiert die Hardware, verwaltet
    Prozesse und Threads, koordiniert Speicherzugriffe und organisiert Ein- und Ausgaben über Gerätetreiber und
    Dateisysteme. Zudem legt er Zugriffsrechte und Privilegiengrenzen fest und setzt diese durch @linux_os.

    Der Kernel lässt sich als Sammlung eng verzahnter Subsysteme beschreiben. Gemeinsam ermöglichen sie die
    parallele und isolierte Ausführung vieler Prozesse auf derselben Hardware @linux_kernel.
  ],
  align: top + right,
  column-gutter: 1em,
)
