== Race-Condition
Eine Race Condition tritt auf, wenn mehrere Threads oder Prozesse gleichzeitig auf dieselbe Ressource zugreifen und dieser Zugriff nicht hinreichend synchronisiert wird. Dies kann zu nichtdeterministischen Ergebnissen, fehlerhaften Systemzuständen oder sogar zu Datenkorruption führen. Eine notwendige Bedingung für das Auftreten einer Race Condition ist, dass mindestens ein beteiligter Zugriff schreibend erfolgt und gleichzeitig ein weiterer Zugriff(sei er lesend oder schreibend) stattfindet. Unter diesen Voraussetzungen können sich die einzelnen Operationen überlappen und unbeabsichtigte Wechselwirkungen hervorrufen.

Ursächlich für solche Probleme ist meist die fehlende Atomarität der ausgeführten Operationen.

#figure(
  image("../../Race-Increment.png", width: 30%),
  caption: [Race Condition: Increment],
) <race>

Wie in @race dargestellt, werden zwei Threads gestartet, die eine gemeinsame Variable modifizieren. Die Operation increment ist nicht atomar. Sie besteht vielmehr aus einer Sequenz von read, increment und write. Erfolgt das read des zweiten Threads, bevor der erste Thread den neuen Wert nach Abschluss seiner Operation zurückschreiben kann, lesen beide Threads denselben Anfangswert und berechnen dieselbe Aktualisierung. Dadurch wird die Variable zwar zweimal verändert, jedoch auf denselben Endwert gesetzt. Dies ist ein klassischer Fall einer verlorenen Aktualisierung (lost update).

Neben verlorenen Updates existieren weitere Kategorien von Race Conditions. Ein häufiges Szenario ist das Time-of-Check to Time-of-Use-Problem (TOCTOU), bei dem sich ein Systemzustand zwischen einer Überprüfung und einer anschließenden Verwendung unbemerkt ändert. Ebenfalls verbreitet, insbesondere in Sprachen ohne automatische Speicherverwaltung (wie C/C++) können Use-After-Free-Races auftreten. Hierbei wird bereits freigegebener Speicher weiterverwendet, während das Programm fälschlicherweise davon ausgeht, dass dieser Speicherbereich weiterhin gültig sei. Dies ermöglicht es anderen Prozessen oder Threads, denselben Speicher zwischenzeitlich neu zu belegen, was zu gravierenden Fehlfunktionen oder Sicherheitslücken führen kann.@whatracecondition

Dies sind einige Beispiele für Race-Conditions um das Prinzip dieser zu verdeutlichen.
