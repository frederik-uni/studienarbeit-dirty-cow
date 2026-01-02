=== Ursprung/code Analyse
Die Analyse konzentriert sich primär auf den Call Trace und die logische Abfolge der beteiligten Kernel-Funktionen, da der zugrunde liegende C-Code stark verschachtelt und nur schwer isoliert betrachtbar ist. Detaillierte Codeausschnitte werden lediglich dort herangezogen, wo sie für das Verständnis des Exploits oder der späteren Korrektur unmittelbar relevant sind.

Der Angriff basiert auf einer spezifischen Abfolge von Page Faults:
1.	Erster Page Fault
Der Fault wird mit den Flags FOLL_WRITE und FOLL_FORCE ausgelöst. Da weder eine COW-Seite existiert noch Schreibrechte vorliegen, wird eine COW-Seite erzeugt. Der interne Status wird auf read-only gesetzt, was einen weiteren Page Fault auslöst, der versucht, Schreibrechte zu erlangen.
2.	Zweiter Page Fault
Es kommt zu einem weiteren Page Fault, der versucht, Schreibrechte zu erlangen.
3.	Dritter Page Fault
Da die COW-Seite noch nicht vollständig bereitgestellt ist, erfolgt ein erneuter Versuch, diesmal ohne erneute Prüfung der Schreibberechtigung, da davon ausgegangen wird, dass man sich weiterhin in einem gültigen COW-Zustand befindet. In dem aktuellen Page-Fault wurde erkannt, dass eine COW-Page existiert und COW-Pages sind nicht schreibgeschützt.
4.	Letzter Page Fault (Read Fault)
Die zuvor benötigte Schreibberechtigung wurde intern entfernt. Es wird nur überprüft, ob ein read möglich ist und die pagecache page wird zurückgegeben, die nun beschrieben werden kann. Erfolgt nun zwischen diesem und dem vorherigen Fault ein madvise()-Aufruf, wird die page table zurückgesetzt und zeigt nun auf die Shared-Page. Der Kernel behandelt den Zugriff als reinen Lesezugriff und überspringt die Schreibrechteprüfung vollständig.
