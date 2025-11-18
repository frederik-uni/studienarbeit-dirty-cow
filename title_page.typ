#let title = "Studienarbeit über die Schwachstelle"
#let subtitle = "CVE-"
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
  *#subtitle*

  #v(0.75cm)

  #set text(size: 12pt)

  #table(
    stroke: none,
    columns: (auto, auto),
    inset: 12pt,
    align: horizon,
    table.header(
      [Frederik Schwarz(000000)], [Lars- Johan Schrenk(0000000)],
    )
  )


  #v(0.75cm)

  #date.display("[day] [month repr:short] [year]")

  #v(2cm)

  #text(size: 12pt, weight: "bold")[Zusammenfassung]


  #v(0.3cm)

  #block(width: 12cm)[
    #par(justify: true)[
      #text(weight: "regular", size: 11pt)[
        #lorem(70)
      ]
    ]
  ]
  ])
