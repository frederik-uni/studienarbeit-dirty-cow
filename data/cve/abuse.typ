== Ausnutzen der Schwachstelle
Der Exploit basiert auf dem gleichzeitigen Ausführen zweier Operationen:
1.	Schreibzugriff auf eine gemappte Pseudo-Datei
Hierbei wird eine Datei mittels mmap() in den Speicher gemappt, obwohl sie lediglich über Leserechte verfügt. Die Verwendung einer Pseudo-Datei erlaubt es, bestimmte Sicherheitsprüfungen zu umgehen und gezielt Page Faults auszulösen, welche eine COW-Page erzeugen und beschreiben.
2.	madvise()-Aufruf mit MADV_DONTNEED
Dieser Aufruf signalisiert dem Kernel, dass die aktuell verwendete COW-Seite nicht mehr benötigt wird. In der Folge wird die COW-Seite verworfen, sodass die virtuelle Adresse wieder auf die ursprüngliche, gemeinsam genutzte physische Speicherseite zeigt.

Wird die COW-Seite exakt zwischen dem vorletzten und dem letzten Page Fault entfernt, zeigt die virtuelle Adresse unerwartet auf die Shared Page statt auf die erwartete private Kopie. Da der letzte Page Fault lediglich ein Read-Fault ist, erfolgt keine erneute Überprüfung der Schreibberechtigung. Die Shared Page ist als „dirty“ markiert und wird zurück in die zugrunde liegende Datei geschrieben.
