#import "@preview/wrap-it:0.1.1": wrap-content

#let w = 2.7396in

#let fig = stack(
  spacing: 0.3em,
  image("media/Symbol-Linux Kernel.jpg", width: w),

  // Caption auf Bildbreite begrenzen + darin ausrichten
  block(width: w)[
    #align(center)[
      #text(size: 9pt)[Abbildung 1: Linux Logo [1]]
    ]
  ],
)

#wrap-content(
  box(fig, inset: 0.25em),
  [
    *1.1 Was ist der Linux-Kernel*

    Im Folgenden wird der Linux-Kernel als technische Grundlage für die Analyse
    der Sicherheitslücke Dirty COW (CVE-2016-5195) eingeführt.
    
    Der Linux Kernel bildet den zentralen Bestandteil des Betriebssystems. Und ist somit verantwortlich für die Abstraktion der Hardware, Verwaltung von Prozessen und Threads, Koordination der Speicherzugriffe, Organisation von Ein- und Ausgaben über Gerätetreiber und Dateisysteme, sowie die Festlegung und Durchsetzung von Zugriffsrechten und Privilegien Grenzen [vgl. 2]. Der Kernel lässt sich als Sammlung eng verzahnter Subsysteme beschreiben, welche gemeinsam für eine unabhängige und isolierte Ausführung vieler Prozesse auf derselben Hardware sorgen [vgl. 1].
  ],
  align: top + right,
  column-gutter: 1em,
)

[1] Bovet, Daniel P.; Cesati, Marco: #emph[Understanding the Linux Kernel];. 3rd ed. Sebastopol, CA: O’Reilly Media, 2006
