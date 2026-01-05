*2.2 Linux Kernel*

Im Zusammenhang mit Dirty COW (CVE-2016-5195) besonders relevant ist die Funktionsweise der Speicherverwaltung des Linux-Kernels. Eine wesentliche Rolle hierbei spielt die Implementierung von Copy-on-Write (COW) @nist_rating.

Unter dem Linux-Kernel wird für jeden Prozess ein eigener virtueller Adressraum verwaltet. Physischer Speicher wird über Seitentabellen abgebildet und gleichzeitig mit den jeweiligen Zugriffsrechten versehen.

Zur effizienten Speichernutzung, verwendet der Kernel das Copy-on-Write-Verfahren. Deutlich wird dies, wenn wir die grundlegende Kernel-Funktion ``fork() betrachten @pagetables. Dabei kommt es in der Praxis nur selten zu einem grossteiligem Schreiben auf den dafür vorgesehenen Speicherplatz. Daraufhin werden die meisten Seiten nicht kopiert und bleiben in einem geteiltem Zustand, was wiederum zu einer Reduzierung des RAM-Verbrauchs führt.

Nachfolgend möchte ich auf die Funktionsweise dieses Verfahrens eingehen.

Mehrere Prozesse können sich unter dem Kernel eine physische Speicherseite teilen, welche zunächst schreibgeschützt markiert ist. Sobald ein Prozess versucht auf eine solche Seite zu schreiben wird vom Kernel ein Page Fault ausgelöst. Daraufhin wird im Page-Fault-Handler eine neue private Seite angelegt und der Inhalt der ursprünglichen Seite dorthin kopiert und die Seitentabelle des schreibenden Prozesses auf diese neue Seite umgelenkt. Dabei bleibt die ursprüngliche Seite unverändert, was wiederum eine Isolation zwischen Prozessen gewährleistet @nist_rating. 

Zusammenfassend stellt der Kernel somit sicher, dass kein Prozess direkt in eine schreibgeschützte Dateiabbildung schreiben kann, sondern nur in seine private Kopie.
