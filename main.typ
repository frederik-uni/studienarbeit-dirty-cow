#set page("a4", margin: 20mm)

#include("title_page.typ")
#pagebreak()


#set par(
  spacing: 10em,
  leading: 1.2 * 11pt,
  justify: true,
)
#set heading(numbering: "1.")
#set text(font: "Arial", lang:"de", size: 11pt)



#outline(title: "Inhaltsverzeichnis")
#pagebreak()
#set page(footer: context [
  #h(1fr)
  #counter(page).display(
    "1/1",
    both: true,
  )
])


= Einführung
#include("data/einfuehrung/kernel_summary.typ")
#include("data/einfuehrung/kernel_usage.typ")
#include("data/einfuehrung/dirty_cow.typ")
#include("data/einfuehrung/thread_assement.typ")
#include("data/einfuehrung/history.typ")

= Hintergrund
#include("data/hintergrund/privelage_escalation.typ")
#include("data/hintergrund/kernel.typ")
#include("data/hintergrund/race_condition.typ")

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
