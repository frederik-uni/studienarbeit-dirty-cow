#set page("a4", margin: 20mm)
#set text(lang:"de")
#import "@preview/glossy:0.9.0": *
#show: init-glossary.with(yaml("glossary.yaml"))
#include("title_page.typ")
#pagebreak()


#set par(
  spacing: 1.2em,
  leading: 1.2 * 11pt,
  justify: true,
)

#set text(font: "Arial", lang:"de", size: 12pt)

#outline(title: "Inhaltsverzeichnis")
#pagebreak()

#glossary(title: "Abkürzungen")
#v(1em)
#outline(
  title: "Abbildungsverzeichnis",
  target: figure.where(kind: image),
)
#v(1em)
#outline(
  title: "Auflistungsverzeichnis",
  target: figure.where(kind: raw),
)
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
#include("data/einfuehrung/dirty_cow.typ")
#v(1em)
#include("data/einfuehrung/kernel_summary.typ")
#v(1em)
#include("data/einfuehrung/thread_assement.typ")
#v(1em)
#include("data/einfuehrung/history.typ")
#v(1em)
= Hintergrund
#include("data/hintergrund/privelage_escalation.typ")
#v(1em)
#include("data/hintergrund/kernel.typ")
#v(1em)
#include("data/hintergrund/race_condition.typ")
#v(1em)
= CVE-2016-5195: Dirty COW
== Details der Schwachstelle
#include("data/cve/summary.typ")
#v(1em)
#include("data/cve/tec_details.typ")
#v(1em)
#include("data/cve/origin.typ")
#v(1em)
#include("data/cve/abuse.typ")
#v(1em)
#include("data/cve/protection.typ")
#v(1em)

= Verwandte CVEs
#v(1em)
Im Zuge der Behebung der Schwachstelle Dirty COW wurde mit CVE‑2017‑1000405 eine weitere sicherheitsrelevante Schwachstelle eingeführt, was die Fehleranfälligkeit des Kernel‑Fixes verdeutlicht @yet_another. Dirty COW ist ein lokaler Privilegieneskalations‑Exploit im COW-Mechanismus, während Dirty Pipe (CVE‑2022‑0847) einen Fehler in der Pipe‑Implementierung ausnutzt, um ebenfalls schreibgeschützte Dateien im Page Cache zu modifizieren @pipe. Obwohl Dirty COW selbst ausschließlich lokal ausnutzbar ist, steigt seine Gefährlichkeit erheblich, wenn er mit Remote‑Code‑Execution‑Exploits (@rce:short) kombiniert wird, da dadurch ein externer Angreifer zunächst beliebigen Code ausführen und anschließend durch Privilegieneskalation vollständige Systemkontrolle erlangen kann.
= Fazit
#v(1em)
#include("data/fazit.typ")
#pagebreak()

#bibliography("refs.bib", title: "Literatur")
