== Linux Kernel

Eine wesentliche Rolle spielt hierbei die Implementierung von COW @cow:short @nist_rating.

Im Linux-Kernel besitzt jeder Prozess einen eigenen virtuellen Adressraum. Der physische Speicher wird diesem über Seitentabellen zugeordnet. Gleichzeitig werden die Zugriffsrechte pro Speicherseite festgelegt und durchgesetzt.

Zur effizienten Speichernutzung verwendet der Kernel das Copy-on-Write-Verfahren. Besonders deutlich wird das beim Betrachten der Kernel-Funktion `fork()` @pagetables. In der Praxis wird nach `fork()` meist nur auf einen kleinen Teil des Speichers geschrieben. Daher werden viele Seiten nicht kopiert und bleiben geteilt. So kann Speicher über mehrere Prozesse hinweg wiederverwendet werden, was den RAM-Verbrauch @ram:short reduziert.

Zusammenfassend stellt der Kernel sicher, dass kein Prozess direkt in eine schreibgeschützte Dateiabbildung schreiben kann, sondern nur in seine private Kopie.

Im Folgenden gehe ich auf die Funktionsweise dieses Verfahrens ein.

=== `fork()`
Bei der Systemfunktion `fork()` handelt es sich um ein zentrales Element des Linux-Prozessmodells, das zur Erzeugung eines neuen Prozesses genutzt wird @linux_kernel. Der Aufruf dupliziert den aktuellen Prozess (Elternprozess) und erzeugt einen Kindprozess. Danach setzen beide Prozesse die Ausführung direkt nach dem Funktionsaufruf fort. Unterschieden werden sie über den Rückgabewert: Im Kindprozess liefert `fork()` den Wert 0, im Elternprozess bei Erfolg die PID des Kindprozesses und bei einem Fehler -1.

Der Kernel legt dafür eine neue interne Prozessstruktur an und übernimmt wesentliche Eigenschaften des Elternprozesses, etwa den virtuellen Adressraum und offene Dateideskriptoren @linux_kernel. Für die Speicherverwaltung ist `fork()` besonders relevant, da typischerweise Copy-on-Write genutzt wird, statt sofort physisch zu kopieren @pagetables.

=== Page Faults
In der virtuellen Speicherverwaltung des Linux-Kernels sind Page Faults zentral. Sie entstehen, wenn ein Prozess auf eine virtuelle Adresse zugreift, für die entweder keine gültige Abbildung existiert oder deren Zugriff nicht zu den gesetzten Rechten passt @linux_kernel. Page Faults sind daher weniger „klassische Fehler“ als ein kontrollierter Mechanismus. Sie dienen der bedarfsgerechten Speicherzuweisung und der Durchsetzung von Schutzgrenzen @pagefaults.

Im Folgenden werden insbesondere Read- und Write-Page Faults betrachtet.

==== Read-Page Fault
Ein Read-Page Fault tritt auf, wenn ein Prozess Daten von einer Seite lesen will, die nicht im RAM @ram:short präsent ist oder für die keine gültige Zuordnung besteht. Typisch ist das bei Demand Paging, da Inhalte erst bei Bedarf in den Arbeitsspeicher gemappt werden @pagefaults.

==== Write-Page Fault
Ein Write-Page Fault tritt auf, wenn ein Prozess auf eine Seite schreiben will, die nicht präsent ist oder als schreibgeschützt markiert wurde @pagefaults. Für diese Arbeit ist besonders der Fall „write-on-read-only“ relevant: Der Prozess darf lesen, aber nicht schreiben. Der Kernel nutzt genau diesen Fall, um COW @cow:short umzusetzen.

=== Erläuterung COW
Mehrere Prozesse können sich eine physische Speicherseite teilen, die zunächst schreibgeschützt ist. Versucht ein Prozess, auf diese Seite zu schreiben, löst der Kernel einen Page Fault aus. Im Page-Fault-Handler wird dann eine neue private Seite angelegt. Anschließend kopiert der Kernel den Inhalt der ursprünglichen Seite dorthin und biegt die Seitentabelle des schreibenden Prozesses auf die neue Seite um @pagefaults. Die ursprüngliche Seite bleibt unverändert. Dadurch wird die Isolation zwischen Prozessen gewährleistet @nist_rating.

=== Scheduler und Speicherverwaltung
Der Linux-Kernel koordiniert die CPU-Nutzung über den Scheduler und den Speicherzugriff über die virtuelle Speicherverwaltung @pagetables. Beide Bereiche hängen zusammen: Ein Prozess kann nur effektiv laufen, wenn seine benötigten Speicherseiten verfügbar sind und die Zugriffsrechte passen @scheduler.

==== Scheduler
Der Scheduler teilt die CPU-Zeit @cpu:short zwischen Prozessen auf @scheduler. Prozesse befinden sich typischerweise in den Zuständen runnable (lauffähig, wartet auf CPU), running (läuft) und blocked/sleeping (wartet, z. B. auf I/O oder Speicher).

Befindet sich ein Prozess im Zustand blocked oder sleeping, wählt der Scheduler einen anderen lauffähigen Prozess aus @scheduler. So bleibt das System reaktionsfähig.

#pagebreak()
==== Page Table Entry
Die Speicherverwaltung im Linux-Kernel erfolgt unter anderem über PTE @pte:short. Virtuelle Adressen werden dabei über Seitentabellen auf physische Seiten abgebildet @linux_os. Ein Page-Table Entry ist ein Seitentabelleneintrag, der das Ziel der Abbildung, die Rechte sowie Statusbits (present, accessed, dirty) definiert (siehe @fig:pte-diagramm) @pagetables.

#set figure(supplement: [Abbildung])

#figure(
image("media/PTE.png", width: 100%),
caption: [Übersetzung virtueller Adressen mit Page Table Entry (PTE)],
) [fig:pte-diagramm](fig:pte-diagramm)

=== Linux Permission System
Das Linux-Kontrollsystem basiert auf dem klassischen UNIX-/POSIX-Modell zur Zugriffskontrolle. Es regelt, welche Prozesse auf Dateien und Verzeichnisse zugreifen dürfen @permissions. Grundlage sind Benutzer- und Gruppenidentitäten sowie Rechtebits, die bei Zugriffen geprüft werden.

Der Kernel weist jedem Prozess eine UID (User ID) und eine oder mehrere GIDs (Group IDs) zu. Die Rechte folgen einem Klassensystem: Owner (u), Group (g) und Others (o) @permissions. In jeder Klasse gibt es die Bits read (r), write (w) und execute (x). In Verzeichnissen bedeuten diese Bits search (x), list (r) und change (w).

=== Pagecache Pages
Der Page Cache erhöht die Effizienz, indem er Dateiinhalte im RAM zwischenspeichert. Dadurch werden langsame Zugriffe auf HDD oder SSD reduziert. Eine Pagecache Page ist dabei eine Speicherseite im RAM @ram:short, die einen bestimmten Abschnitt einer Datei repräsentiert.

Beim Lesen prüft der Kernel zunächst den Page Cache. Sind die Daten bereits im RAM @ram:short, handelt es sich um einen Cache Hit und der Zugriff ist schnell. Fehlen sie, liegt ein Cache Miss vor und die Daten müssen vom Datenträger nachgeladen und als neue Pagecache Page abgelegt werden.

Für diese Arbeit ist der Page Cache bei `mmap()` @relevant besonders wichtig, da file-backed Speicherabbildungen typischerweise auf Pagecache Pages verweisen. So können viele Prozesse denselben Datenbereich parallel nutzen.

Beim Schreiben können Änderungen zunächst im Page Cache verbleiben. Die betroffenen Pages werden als dirty markiert und später gesammelt auf den Datenträger zurückgeschrieben. Bei hoher RAM-Auslastung kann der Kernel Pagecache Pages wieder freigeben @relevant.

=== Erläuterung `mmap()`
Die Funktion `mmap()` bindet Dateien oder Speicherbereiche in den virtuellen Adressraum eines Prozesses ein @relevant. Inhalte können dadurch nicht nur über klassische I/O-Operationen, sondern direkt über Speicherzugriffe verarbeitet werden.

Der Kernel unterscheidet grundsätzlich zwischen file-backed und anonymous Speicherabbildungen. Bei file-backed Mappings wird ein definierter Bereich einer Datei eingebunden und typischerweise über den Page Cache bereitgestellt. Bei anonymous Mappings besteht keine direkte Bindung an eine Datei. Die Seiten werden bei Bedarf kernel-seitig bereitgestellt.

Das Zugriffsverhalten wird über Parameter festgelegt, etwa read, write und execute @permissions. Zusätzlich bestimmen die Flags MAP_PRIVATE und MAP_SHARED die Behandlung von Änderungen. Bei MAP_SHARED können Änderungen für andere Prozesse sichtbar sein und in das zugrunde liegende Objekt zurückgeschrieben werden. Bei MAP_PRIVATE bleiben Änderungen prozesslokal, da der Kernel Copy-on-Write nutzt.

Im Rahmen von Copy-on-Write werden file-backed Seiten häufig zunächst schreibgeschützt abgebildet. Will ein Prozess darauf schreiben, löst er einen Write-Page Fault aus. Der Kernel erzeugt dann eine private Kopie der betroffenen Seite für den schreibenden Prozess @relevant. Die ursprüngliche Datei bleibt unverändert, während der Prozess mit einer modifizierbaren Kopie weiterarbeitet.

=== Was ist eine Pseudo-Datei?
Eine Pseudo-Datei ist unter Linux eine Datei, die nicht dauerhaft auf einem Datenträger gespeichert ist, sondern kernel-seitig bereitgestellt wird. Solche Dateien stellen interne Zustände und Systeminformationen in einer Form bereit, die für Benutzerprogramme zugänglich ist @linux_kernel. Sie sind daher keine „echten“ Dateien im klassischen Sinn, sondern eine Schnittstelle zwischen Kernel und User Space.

Pseudo-Dateien finden sich insbesondere in virtuellen Dateisystemen wie `/proc` und `/sys` @relevant. Liest ein Prozess eine solche Datei, liefert der Kernel dynamisch erzeugte Inhalte, z. B. Informationen über Prozesse, Speicherzustände oder Kernel-Parameter. Beim Schreiben auf bestimmte Pseudo-Dateien können umgekehrt Kernel-Funktionen konfiguriert oder gesteuert werden, sofern die Zugriffsrechte dies erlauben.

Für diese Arbeit ist das relevant, da Pseudo-Dateien als Interaktions- oder Angriffspunkt dienen können. Ein typisches Beispiel ist `/proc/self/mem`, das Zugriff auf den eigenen Prozessspeicher ermöglicht und im Kontext kernelnaher Mechanismen besonders wichtig ist @relevant.
