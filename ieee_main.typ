#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/glossy:0.9.0": *

#show: ieee.with(
  title: [A typesetting system to untangle the scientific writing process],
  abstract: [
    The process of scientific writing is often tangled up with the intricacies of typesetting, leading to frustration and wasted time for researchers. In this paper, we introduce Typst, a new typesetting system designed specifically for scientific writing. Typst untangles the typesetting process, allowing researchers to compose papers faster. In a series of experiments we demonstrate that Typst offers several advantages, including faster document creation, simplified syntax, and increased ease-of-use.
  ],
  authors: (
    (
      name: "Frederik Schwarz(00000000)",
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
