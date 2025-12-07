#set page("a4", margin: 20mm)
#import "@preview/glossy:0.9.0": *
#show: init-glossary.with(yaml("glossary.yaml"))
#include("title_page.typ")
#pagebreak()


#set par(
  spacing: 1.5em,
  leading: 1.2 * 11pt,
  justify: true,
)

#set text(font: "Arial", lang:"de", size: 11pt)

#outline(title: "Inhaltsverzeichnis")
#pagebreak()

#glossary(title: "Abkürzungen")
#pagebreak()
#set heading(numbering: "1.")

#set page(footer: context [
  #h(1fr)
  #counter(page).display(
    "1/1",
    both: true,
  )
])


= Einführung
#include("data/einfuehrung/kernel_summary.typ")
#v(1em)
#include("data/einfuehrung/kernel_usage.typ")
#v(1em)
#include("data/einfuehrung/dirty_cow.typ")
#v(1em)
#include("data/einfuehrung/thread_assement.typ")
#v(1em)
#include("data/einfuehrung/history.typ")
#v(1em)
= Hintergrund
#include("data/hintergrund/privelage_escalation.typ")
#include("data/hintergrund/linux_file_pemission.typ")
#include("data/hintergrund/kernel.typ")
#include("data/hintergrund/race_condition.typ")
#v(1em)
= CVE-2016-5195: Dirty COW
== Details der Schwachstelle
#include("data/cve/summary.typ")
#include("data/cve/tec_details.typ")
#include("data/cve/origin.typ")
#include("data/cve/abuse.typ")
#include("data/cve/protection.typ")

= Verwandte Arbeiten
= Fazit

#bibliography("refs.bib", title: "Literatur")
