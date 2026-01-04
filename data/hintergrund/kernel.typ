*2.2 Linux Kernel*

Im Zusammenhang mit Dirty COW (CVE-2016-5195) besonders relevant ist die Funktionsweise der Speicherverwaltung des Linux-Kernels. Eine wesentliche Rolle hierbei spielt die Implementierung von Copy-on-Write (COW) und die interne Kernel-Funktion #text(font: "Fira Code")[get\_user\_pages()] [vgl. 1].

Unter dem Linux-Kernel wird für jeden Prozess ein eigener virtueller Adressraum verwaltet. Physischer Speicher wird über Seitentabellen abgebildet und gleichzeitig mit den jeweiligen Zugriffsrechten versehen.

Zur effizienten Speichernutzung, verwendet der Kernel das Copy-on-Write-Verfahren. Deutlich wird dies, wenn wir die grundlegende Kernel-Funktion #text(font: "Fira Code")[fork()] betrachten [vgl. 4]. Dabei kommt es in der Praxis nur selten zu einem grossteiligem Schreiben auf den dafür vorgesehenen Speicherplatz. Daraufhin werden die meisten Seiten nicht kopiert und bleiben in einem geteiltem Zustand, was wiederum zu einer Reduzierung des RAM-Verbrauchs führt.

Nachfolgend möchte ich auf die Funktionsweise dieses Verfahrens eingehen.

Mehrere Prozesse können sich unter dem Kernel eine physische Speicherseite teilen, welche zunächst schreibgeschützt markiert ist. Sobald ein Prozess versucht auf eine solche Seite zu schreiben wird vom Kernel ein Page Fault ausgelöst. Daraufhin wird im Page-Fault-Handler eine neue private Seite angelegt und der Inhalt der ursprünglichen Seite dorthin kopiert und die Seitentabelle des schreibenden Prozesses auf diese neue Seite umgelenkt. Dabei bleibt die ursprüngliche Seite unverändert, was wiederum eine Isolation zwischen Prozessen gewährleistet [vgl. 3]. 

Zusammenfassend stellt der Kernel somit sicher, dass kein Prozess direkt in eine schreibgeschützte Dateiabbildung schreiben kann, sondern nur in seine private Kopie.

Das eben beschriebene Szenario stellt einen typischen User-Mode-Speicherzugriff dar, allerdings erfolgen solche Zugriffe auch oft vom Kernel selbst. Typische Szenarien eines Kernel-Zugriffs sind I/O-Operationen, sowie Debugging-Schnittstellen und Pseudo-Dateien.
Für einen derartigen Zugriff benutzt der Kernel die Funktion #text(font: "Fira Code")[get\_user\_pages()]. Diese Funktion folgt einer virtuellen Adresse im Adressraum des Prozesses und sorgt über den Page-Fault-Handler dafür, dass die entsprechende Seite im Speicher vorhanden ist. Außerdem pinnt sie die Seite, sodass sie während der Operation nicht ausgetauscht oder freigegeben werden kann. Die Funktion erhält dazu #text(font: "Fira Code")[gup\_flags]. Ein derartiges Flag ist #text(font: "Fira Code")[FOLL\_WRITE] und signalisiert, dass diese Seite schreibbar verwendet werden soll [vgl. 3]. Die Kernel-Logik muss in diesem Fall sicherstellen, dass der Aufrufer nur dann eine schreibbare Referenz erhält, wenn bereits eine korrekte COW-Trennung erfolgt ist.

[3] National Institute of Standards and Technology (NIST): #strong[CVE-2016-5195 Detail – Dirty COW.] In: #emph[National Vulnerability Database (NVD)];, 2016. Online verfügbar unter: #link("https://nvd.nist.gov/vuln/detail/CVE-2016-5195")

[4] McCracken D. Sharing page tables in the Linux kernel. In: Proceedings of the Linux Symposium; 2003; Ottawa, Ontario, Canada. p. 315-320. Available from: https://kernel.org/doc/ols/2003/ols2003-pages-315-320.pdf
. Accessed January 3, 2026
