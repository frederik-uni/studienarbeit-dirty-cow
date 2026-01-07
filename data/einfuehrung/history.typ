#import "@preview/wrap-it:0.1.1"
== Relevanz der Schwachstelle

#let w = 2.2in
#set figure(supplement: [Abbildung])

Entgegen vielen üblichen Schwachstellen liegt diese auf Kernel-Ebene und betrifft damit das gesamte System statt nur eine einzelne Anwendung. Die Auswirkungen sind als sehr hoch einzustufen, da ein potenzieller Angreifer im Rahmen einer lokalen Privilegieneskalation die Kontrolle über Daten und Prozesse des Systems erlangen kann @relevant.

Besonders gravierend ist die hohe Verbreitung von Linux in Serverinfrastrukturen. Dadurch kann sich das Schadenspotenzial von einem einzelnen System auf ein gesamtes Netzwerk ausweiten @linux_os.

Hinsichtlich des Angriffswegs ist dieser als praxisnah zu bewerten: Bereits ein bestehender @ssh:short -Zugang (siehe @fig:ssh-logo) kann ausreichen, um den Exploit auf dem Zielsystem auszuführen und eine Übernahme mit erweiterten Rechten zu ermöglichen.

#let ssh_fig = block(width: w)[
  #figure(
    image("media/SSH_Logo.svg", width: w),
    caption: [SSH-Logo],
  ) <fig:ssh-logo>
]

#wrap-it.wrap-content(
  box(ssh_fig, inset: 0.25em),
  [
    Die Schwere der Schwachstelle wird zudem durch die drei IT-Sicherheitsziele untermauert:
    Vertraulichkeit ist durch den möglichen Zugriff auf sensible Daten gefährdet, Integrität
    durch potenzielle Manipulationen an Systemdateien und Verfügbarkeit durch die Möglichkeit,
    den legitimen Zugriff auf das System zu beeinträchtigen oder zu verhindern.

    Zusammenfassend stellt diese Schwachstelle einen bedeutsamen Fall in der IT-Sicherheitsgeschichte
    dar @nist_rating und hat zur erhöhten Sensibilisierung für Risiken im Kernel-Bereich beigetragen.
  ],
  align: top + right,
  column-gutter: 1em,
)
