#import "@preview/wrap-it:0.1.1": wrap-content

#let w = 2.7396in

// optional: deutsches "Abbildung" statt "Figure"
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

    Im Folgenden wird der Linux-Kernel siehe @fig:linux-logo als technische Grundlage für die weitere Analyse,
    der von uns gewählten Sicherheitslücke, eingeführt.

    Der Linux-Kernel bildet den zentralen Bestandteil des Betriebssystems und ist somit
    verantwortlich für die Abstraktion der Hardware, Verwaltung von Prozessen und Threads,
    Koordination der Speicherzugriffe, Organisation von Ein- und Ausgaben über Gerätetreiber
    und Dateisysteme, sowie die Festlegung und Durchsetzung von Zugriffsrechten und Privilegiengrenzen @linux_os.
    
    Der Kernel lässt sich als Sammlung eng verzahnter Subsysteme beschreiben,
    welche gemeinsam für eine unabhängige und isolierte Ausführung vieler Prozesse auf derselben
    Hardware sorgen @linux_kernel.
  ],
  align: top + right,
  column-gutter: 1em,
)
