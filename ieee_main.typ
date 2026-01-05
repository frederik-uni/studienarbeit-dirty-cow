#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/glossy:0.9.0": *

#show: ieee.with(
  title: [A typesetting system to untangle the scientific writing process],
  abstract: [
    Die Studienarbeit im Rahmen des Wahlmoduls IT-Sicherheit greift die 2016 unter dem Namen Dirty COW bekannt gewordene Sicherheitslücke im Linux-Kernel auf. Bei dieser Schwachstelle handelt es sich um eine Race-Condition im Speichermechanismus Copy-on-Write, durch die ein lokaler, nicht privilegierter Benutzer schreibgeschützte, dateibasierte Speicherseiten überschreiben und dadurch eine Privilegieneskalation bis hin zu Root-Rechten erreichen kann. Besonders kritisch ist hierbei, dass der zugrundeliegende Exploit über viele Jahre im Kernel-Quellcode vorhanden war. Sie wurde zwar zuerst 2016 öffentlich gemacht, betraf jedoch Kernel-Versionen seit Linux 2.6.22 und war damit rund neun Jahre in einer Vielzahl linuxbasierter Systeme enthalten. Die Kritikalität ergibt sich somit aus der Kombination aus langjähriger Präsenz im Code, der massiven Verbreitung von Linux und der Möglichkeit, durch die Ausnutzung beliebige Systemrechte zu erlangen.
  ],
  authors: (
    (
      name: "Frederik Schwarz(00514322)",
      department: [Informatik],
      organization: [Hochschule Hof],
    ),
    (
      name: "Lars- Johan Schrenk",
      department: [],
      organization: [Hochschule Hof],

    ),
  ),
  index-terms: ("Scientific writing", "Typesetting", "Document creation", "Syntax"),
  bibliography: bibliography("refs.bib"),
)
#show: init-glossary.with(yaml("glossary.yaml"))

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
