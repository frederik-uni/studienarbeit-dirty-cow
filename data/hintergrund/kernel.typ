Im Zusammenhang mit Dirty COW (CVE-2016-5195) besonders relevant ist die Funktionsweise der Speicherverwaltung des Linux-Kernels. Eine wesentliche Rolle hierbei spielt die Implementierung von Copy-on-Write (COW) @nist_rating.

Im Linux-Kernel besitzt jeder Prozess einen eigenen virtuellen Adressraum. Der physische Speicher wird diesem über Seitentabellen zugeordnet, wobei zeitgleich die jeweiligen Zugriffsrechte für jede Speicherseite festgelegt und durchgesetzt werden.

Zur effizienten Speichernutzung verwendet der Kernel das Copy-on-Write-Verfahren. Deutlich wird dies, wenn wir die grundlegende Kernel-Funktion ``fork()`` betrachten @pagetables. Dabei kommt es in der Praxis nur selten zu einem großteiligen Schreiben auf den dafür vorgesehenen Speicherplatz. Daraufhin werden die meisten Seiten nicht kopiert und bleiben in einem geteilten Zustand, was wiederum zu einer Wiederverwendung des Speichers über mehrere Prozesse und somit zu einer Reduzierung des RAM-Verbrauchs führt.

Zusammenfassend stellt der Kernel somit sicher, dass kein Prozess direkt in eine schreibgeschützte Dateiabbildung schreiben kann, sondern nur in seine private Kopie.

Nachfolgend möchte ich auf die Funktionsweise dieses Verfahrens eingehen.

== Die Funktion ``fork()``
Bei der Systemfunktion ``fork()`` handelt es sich um ein zentrales Element des Linux-Prozessmodells und wird zur Erzeugung eines neuen Prozesses verwendet @linux_kernel. Der Funktionsaufruf bewirkt eine Duplikation des aktuellen Prozesses (Elternprozess) zu einer Kopie (Kindprozess). Anschließend führen Eltern- und Kindprozess die Ausführung an der Stelle nach dem Aufruf der Funktion fort; dabei werden die beiden Prozesse anhand ihres Rückgabewertes unterschieden. Im Kindprozess gibt ``fork()`` 0 aus, im Elternprozess bei erfolgreicher Ausführung die PID (Prozess-ID) des Kindprozesses und bei einem Fehler -1.

Der Kernel legt anschließend eine neue interne Prozessstruktur für das Kind an und übernimmt dabei wesentliche Eigenschaften wie den virtuellen Adressraum und offene Dateideskriptoren des Elternprozesses @linux_kernel. Insbesondere ist diese Funktion entscheidend für die Speicherverwaltung, aufgrund der üblichen Verwendung von Copy-on-Write statt einer sofortigen physischen Kopie @pagetables.

== Page Faults
In der virtuellen Speicherverwaltung des Linux-Kernels sind Page Faults ein zentrales Element. Sie entstehen durch einen Zugriffsversuch eines Prozesses auf eine virtuelle Speicheradresse, wobei entweder keine gültige Abbildung existiert oder der Zugriff nicht den Zugriffsrechten entspricht @linux_kernel. Resultierend lässt sich anmerken, dass Page Faults weniger als klassische Fehler zu betrachten sind, sondern mehr als kontrollierter Mechanismus zur bedarfsgerechten Speicherzuweisung und zur Durchsetzung von Schutzgrenzen des Systems @pagefaults.

Nachfolgend wird insbesondere auf die zwei Arten Read- und Write-Page Faults eingegangen.

===  Read-Page Fault
Sobald ein Prozess Daten von einer Seite lesen will, welche noch nicht in den RAM geladen wurde und somit nicht präsent ist oder für welche keine gültige Zuordnung besteht, entsteht ein derartiger Page Fault. Typischerweise tritt dieses Szenario bei Demand Paging auf, da bei diesem Verfahren Inhalte erst bei Bedarf in den Arbeitsspeicher gemappt werden @pagefaults.

=== Write-Page Fault
Sobald ein Prozess auf eine Seite schreiben will, welche entweder nicht präsent ist oder vorab als schreibgeschützt markiert wurde, entsteht ein derartiger Page Fault @pagefaults. Besonders relevant für diese Arbeit ist der Fall write-on-read-only, da der Prozess hierbei nur auf die Seite zugreifen, aber nicht schreiben kann. Der Kernel nutzt diese Situation aktiv, um das COW-Verfahren umzusetzen.

== Erläuterung zu COW
Mehrere Prozesse können sich unter dem Kernel eine physische Speicherseite teilen, welche zunächst schreibgeschützt markiert ist. Sobald ein Prozess versucht, auf eine solche Seite zu schreiben, wird vom Kernel ein Page Fault ausgelöst. Daraufhin wird im Page-Fault-Handler eine neue private Seite angelegt und der Inhalt der ursprünglichen Seite dorthin kopiert und die Seitentabelle des schreibenden Prozesses auf diese neue Seite umgelenkt @pagefaults. Dabei bleibt die ursprüngliche Seite unverändert, was eine Isolation zwischen Prozessen gewährleistet @nist_rating.

== Scheduler und Speicherverwaltung
Der Linux-Kernel koordiniert einerseits die CPU-Nutzung durch den Scheduler und andererseits den Speicherzugriff mit Hilfe der virtuellen Speicherverwaltung @pagetables. Diese beiden Bereiche partizipieren voneinander, da ein Prozess nur effektiv laufen kann, wenn die benötigten Speicherseiten verfügbar sind und die Zugriffsrechte übereinstimmen @scheduler.

=== Scheduler
Die Rolle des Schedulers im Linux-Kernel ist die Aufteilung der CPU-Zeit auf Prozesse @scheduler. Derartige Prozesse befinden sich üblicherweise in den Zuständen runnable (lauffähig/wartend auf CPU), running (laufend) und blocked/sleeping (wartend auf Speicherereignisse).

Insofern sich ein Prozess in den Zuständen blocked oder sleeping befindet, wählt der Scheduler einen lauffähigen Prozess aus @scheduler. Somit wird ein möglichst latenzfreies Arbeiten des Systems garantiert.

#pagebreak()

=== Page Table Entry
Die Speicherverwaltung unter dem Linux-Kernel erfolgt unter anderem über PTE, wobei virtuelle Adressen über Seitentabellen auf physische Seiten abgebildet werden @linux_os. Unter einem Page-Table Entry versteht man einen Seitentabelleneintrag, welcher wiederum das Ziel der Abbildung, die Rechte und die Statusbits (present, accessed, dirty) festlegt; siehe @fig:pte-diagramm @pagetables.

#set figure(supplement: [Abbildung])

#figure(
  image("media/PTE.png", width: 100%),
  caption: [#align(center)[Übersetzung virtueller Adressen mit Page Table Entry (PTE) [2]]],
) <fig:pte-diagramm>

== Linux Permission System
Das unter Linux verwendete Kontrollsystem basiert auf dem klassischen UNIX-/POSIX-Modell zur Zugriffskontrolle und reguliert, welche Prozesse auf Dateien und Verzeichnisse zugreifen dürfen @permissions. Der Kern des Systems sind hierbei Benutzer- und Gruppenidentitäten, sowie auch Rechtebits, welche bei relevanten Zugriffen überprüft werden.

Der Kernel vergibt an jeden Prozess eine UID (User ID) und eine oder mehrere GIDs (Group IDs). Diese genannten Rechte folgen einem Klassensystem, in dem sie unter Owner (u), Group (g) und Others (o) unterteilt werden @permissions. Folglich existieren in jeder Klasse die Bits read (r), write (w), execute (x). Im Gegensatz dazu haben diese Bits in Verzeichnissen die Bedeutung search (x), list (r) und change (w).

== Pagecache Pages
Die Funktion des Page Cache im Kernel ist eine Steigerung der Effizienz, indem er Dateiinhalte im RAM zwischenspeichert und somit ineffiziente Zugriffe auf Hard Disk Drive (HDD) oder Solid State Drive (SSD) minimiert. In Bezug darauf stellt eine Pagecache Page eine Speicherseite im RAM dar, die einen speziellen Abschnitt einer Datei repräsentiert.

Während des Lesevorgangs findet eine Kernel-seitige Prüfung des Page Caches statt. Insofern die Dateidaten bereits im RAM gespeichert sind, wird von einem Cache Hit gesprochen und der Zugriff erfolgt sehr schnell; falls diese fehlen, wird von einem Cache Miss gesprochen und ein Nachladen der Daten vom Datenträger ist erforderlich, um sie als neue Pagecache Page abzulegen.
Im Folgenden ist der Page Cache bei der Funktion ``mmap()`` besonders relevant @relevant, da file-backed Speicherabbildungen üblicherweise auf Pagecache Pages verweisen und somit eine Vielzahl an Prozessen denselben Datenbereich parallel nutzen können.

Beim Schreibvorgang besteht die Möglichkeit eines Verweilens der Änderungen im Page Cache, wobei die betroffenen Pages als dirty markiert und später gebündelt auf den Datenträger zurückgeschrieben werden. Sobald eine hohe Speicherauslastung des RAMs gegeben ist, kann der Kernel Pagecache Pages wieder freigeben @relevant.

== Erläuterung zu mmap
Die Funktion ``mmap()`` unter Linux dient der Einbindung von Dateien oder Speicherbereichen in den virtuellen Adressraum eines Prozesses @relevant. Dadurch können Inhalte nicht ausschließlich über klassische Ein- und Ausgabeoperationen, sondern direkt über Speicherzugriffe verarbeitet werden.

In Bezug darauf unterscheidet der Kernel grundsätzlich zwischen file-backed und anonymous Speicherabbildungen. Bei file-backed Mappings wird ein definierter Bereich einer Datei in den Adressraum eingebunden und typischerweise über den Page Cache bereitgestellt. Bei anonymous Mappings hingegen besteht keine direkte Bindung an eine Datei, sodass die benötigten Speicherseiten bei Zugriff kernel-seitig bereitgestellt werden.
Für das Zugriffsverhalten legt ``mmap()`` über Parameter die Rechte fest, unter anderem read, write und execute @permissions. Zusätzlich bestimmen die Flags MAP_PRIVATE und MAP_SHARED, wie Änderungen behandelt werden. Insofern MAP_SHARED verwendet wird, können Veränderungen für andere Prozesse sichtbar sein und in das zugrunde liegende Objekt zurückgeschrieben werden. Bei MAP_PRIVATE verbleiben Änderungen prozesslokal, da der Kernel das Copy-on-Write-Verfahren nutzt.

Im Rahmen von Copy-on-Write werden file-backed Seiten zunächst häufig schreibgeschützt abgebildet. Sobald ein Prozess auf eine solche Seite schreiben möchte, wird ein Write Page Fault ausgelöst und der Kernel erzeugt eine private Kopie der betroffenen Seite für den schreibenden Prozess @relevant. Somit bleibt die ursprüngliche Datei unverändert, während der Prozess weiterhin mit einer modifizierbaren Kopie arbeiten kann.

== Was ist eine Pseudo Datei
Unter einer Pseudo-Datei versteht man unter Linux eine Datei, die nicht als dauerhaft gespeicherter Inhalt auf einem Datenträger vorliegt, sondern kernel-seitig zur Verfügung gestellt wird. Derartige Dateien dienen vor allem dazu, interne Zustände und Informationen des Systems in einer für Benutzerprogramme zugänglichen Form darzustellen @linux_kernel. Somit handelt es sich nicht um „echte“ Dateien im klassischen Sinn, sondern um eine Schnittstelle zwischen Kernel und User Space.

Pseudo-Dateien treten insbesondere in virtuellen Dateisystemen wie ``/proc`` und ``/sys`` auf @relevant. Insofern ein Prozess eine solche Datei liest, liefert der Kernel dynamisch erzeugte Inhalte, beispielsweise Informationen über Prozesse, Speicherzustände oder Kernel-Parameter. Beim Schreiben auf bestimmte Pseudo-Dateien kann umgekehrt eine Konfiguration oder Steuerung von Kernel-Funktionen erfolgen, sofern dies durch die jeweiligen Zugriffsrechte erlaubt ist.

Für die weitere Arbeit ist dieses Konzept relevant, da Pseudo-Dateien häufig als Angriffs- oder Interaktionspunkt genutzt werden können. Ein typisches Beispiel ist ``/proc/self/mem``, welches den Zugriff auf den eigenen Prozessspeicher ermöglicht und damit im Kontext kernelnaher Mechanismen eine besondere Bedeutung besitzt @relevant.
