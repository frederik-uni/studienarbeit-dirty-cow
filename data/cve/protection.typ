== Verteidigung
Zur Behebung der Schwachstelle wurde die zugrunde liegende Logik im Kernel angepasst. Anstatt die Schreibanforderung temporär zu entfernen, wird nun explizit ein zusätzliches Flag eingeführt, das kennzeichnet, dass sich der aktuelle Zugriff innerhalb eines COW-Kontextes befindet.

Im Write Fault wird nun überprüft:
- ob ein COW-Zustand aktiv ist,
- ob der zugehörige Page Table Entry (PTE) als „dirty“ markiert ist.

Basierend auf diesen Prüfungen wird entschieden, ob der Speicherbereich invalidiert werden muss. In diesem Fall wird ein erneuter Page Fault ausgelöst (Retry), wodurch eine erneute und korrekte Überprüfung der Zugriffsrechte sichergestellt wird. Dadurch wird verhindert, dass Schreiboperationen auf Shared Pages ohne explizite Schreibberechtigung durchgeführt werden können.
