=== Technische Ursache/ Ablauf der relevanten Page Faults
Die technische Ursache der Schwachstelle liegt in einer inkorrekten Annahme über den internen Zustand von Speicherseiten während aufeinanderfolgender Page Faults. Konkret wird angenommen, dass sich der Kernel weiterhin in einem gültigen COW-Zustand befindet und daher keine erneute Überprüfung der Schreibberechtigung erforderlich ist. Diese Annahme ist jedoch fehlerhaft, da sich der Zustand der betroffenen Speicherseite zwischen zwei Page Faults ändern kann.

Zwar garantiert der Scheduler die Atomarität eines einzelnen Page Faults für einen spezifischen Speicherbereich, jedoch können zwischen mehreren Page Faults andere Operationen auf denselben virtuellen Speicherbereich verändern, bzw. freigegeben. Genau dieses Zeitfenster wird durch den Exploit ausgenutzt.

Der Angriff basiert auf einer spezifischen Abfolge von Page Faults:
1.	Erster Page Fault
Der Fault wird mit den Flags FOLL_WRITE und FOLL_FORCE ausgelöst. Da weder eine COW-Seite existiert noch Schreibrechte vorliegen, wird eine COW-Seite erzeugt. Der interne Status wird auf read-only gesetzt, was einen weiteren Page Fault auslöst, der versucht, Schreibrechte zu erlangen.
2.	Zweiter Page Fault
Es kommt zu einem weiteren Page Fault, der versucht, Schreibrechte zu erlangen.
3.	Dritter Page Fault
Da die COW-Seite noch nicht vollständig bereitgestellt ist, erfolgt ein erneuter Versuch, diesmal ohne erneute Prüfung der Schreibberechtigung, da davon ausgegangen wird, dass man sich weiterhin in einem gültigen COW-Zustand befindet. In dem aktuellen Page-Fault wurde erkannt, dass eine COW-Page existiert und COW-Pages sind nicht schreibgeschützt.
4.	Letzter Page Fault (Read Fault)
Die zuvor benötigte Schreibberechtigung wurde intern entfernt. Es wird nur überprüft, ob ein read möglich ist und die pagecache page wird zurückgegeben, die nun beschrieben werden kann. Erfolgt nun zwischen diesem und dem vorherigen Fault ein madvise()-Aufruf, wird die page table zurückgesetzt und zeigt nun auf die Shared-Page. Der Kernel behandelt den Zugriff als reinen Lesezugriff und überspringt die Schreibrechteprüfung vollständig.
