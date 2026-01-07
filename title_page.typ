#let cve = "CVE-2016-5195"
#let title = "Studienarbeit über die Schwachstelle"
#let course = "IT-Sicherheit"
#let university = "Hochschule Hof"
#let date= datetime.today()
#let semester = "Wintersemester 2025/2026"

#set page(numbering: none)

#place(
 top + right,
   [
     #image("logo.svg", format: "svg", width: 4cm)
   ]
)

#align(center, [
  #v(5cm)

  #university \
  #course \
  #semester \

  #v(0.75cm)

  #set text(size: 20pt)
  *#title*

  #set text(size: 24pt)
  *#cve*

  #v(0.75cm)

  #set text(size: 12pt)

  #table(
    stroke: none,
    columns: (auto, auto),
    inset: 12pt,
    align: horizon,
    table.header(
      [Frederik Schwarz(00514322)], [Lars- Johan Schrenk(0000000)],
    )
  )


  #v(0.75cm)

  #date.display("[day] [month repr:short] [year]")

  #v(2cm)

  #text(size: 12pt, weight: "bold")[Abstract]


  #v(0.3cm)

  #block(width: 12cm)[
    #par(justify: true)[
      #text(weight: "regular", size: 11pt)[
        Diese Studienarbeit analysiert die Linux-Kernel-Schwachstelle CVE-2016-5195 oder auch bekannt als Dirty COW, eine Race Condition im Copy-on-Write-Mechanismus, die lokale Privilegieneskalation ermöglicht. Nach einer Einführung in relevante Kernelmechanismen wie Page Faults, mmap() und Copy-on-Write wird der fehlerhafte Ablauf der Speicherverwaltung detailliert nachvollzogen. Anschließend wird gezeigt, wie die Schwachstelle praktisch ausgenutzt werden kann und welche Änderungen im Kernel zur Behebung vorgenommen wurden. Ziel ist es, die Ursachen der Schwachstelle nachvollziehbar darzustellen und daraus allgemeine Erkenntnisse für sichere Kernelarchitektur abzuleiten.
      ]
    ]
  ]
  ])
