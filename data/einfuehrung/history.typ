= Warum ist das relevant ?

#let w = 2.2in
#set figure(supplement: [Abbildung])

Entgegen anderen üblichen Schwachstellen befindet sich diese auf Kernel-Ebene und betrifft damit das gesamte System anstelle einer einzelnen Anwendung. Der Grad der Auswirkung ist als sehr hoch einzustufen, da ein potenzieller Angreifer im Rahmen einer lokalen Privilegieneskalation die Kontrolle über Daten und Prozesse des Systems erlangen kann @relevant.

Besonders gravierend ist hierbei die hohe Verbreitung von Linux im Bereich Serverinfrastrukturen, wodurch sich das Schadenspotenzial von einem einzelnen System auf ein gesamtes Netzwerk ausweiten kann @linux_os. 

Hinsichtlich des Angriffswegs ist dieser als praxisnah zu bewerten, da bereits ein bestehender SSH-Zugang @ssh:short siehe @fig:ssh-logo ausreicht, um den Exploit auf dem Zielsystem auszuführen und so eine Übernahme mit erweiterten Rechten zu ermöglichen.

#let ssh_fig = block(width: w)[
  #figure(
    image("media/SSH_Logo.svg", width: w),
    caption: [SSH-Logo [@fig:ssh-logo]],
  ) <fig:ssh-logo>
]

#wrap-content(
  box(ssh_fig, inset: 0.25em),
  [
    Die Schwere der Schwachstelle wird zudem durch die drei IT-Sicherheitsziele untermauert.
    Vertraulichkeit ist durch den möglichen Zugriff auf sensible Daten gefährdet, Integrität
    durch potenzielle Manipulationen an Systemdateien, und Verfügbarkeit durch die Möglichkeit,
    den legitimen Zugriff auf das System zu beeinträchtigen oder zu verhindern.

    Zusammenfassend stellt diese Schwachstelle einen bedeutsamen Fall in der IT-Sicherheitsgeschichte
    dar @nist_rating und hat zur erhöhten Sensibilisierung für Sicherheitsrisiken im Kernel-Bereich beigetragen.
  ],
  align: top + right,
  column-gutter: 1em,
)
