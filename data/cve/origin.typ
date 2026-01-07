=== Ursprung/code Analyse
Die Analyse konzentriert sich primär auf eine annotierte Ablaufbeschreibung eines Seitenfehlers(Pagefaults) und die logische Abfolge der beteiligten Kernel-Funktionen, da der zugrunde liegende C-Code stark verschachtelt und nur schwer isoliert betrachtbar ist. Detaillierte Codeausschnitte werden lediglich dort herangezogen, wo sie für das Verständnis des Exploits oder der späteren Korrektur unmittelbar relevant sind.

Der Angriff basiert auf einer spezifischen Abfolge von Page Faults:
1.	Erster Page Fault
#block(inset: (left: 2em))[
  Der Fault wird mit den Flags FOLL_WRITE und FOLL_FORCE ausgelöst, durch einen Schreibversuch. Da weder eine COW-Seite existiert noch Schreibrechte vorliegen, wird eine eine private anonyme Kopie der Page vorbereitet. Der interne Status wird auf read-only gesetzt, was einen weiteren Page Fault auslöst, der versucht, Schreibrechte zu erlangen @analysis.
  #figure([
```
faultin_page
  handle_mm_fault
    __handle_mm_fault
      handle_pte_fault
        do_fault <- pte is not present
 do_cow_fault <- FAULT_FLAG_WRITE
   alloc_set_pte
     maybe_mkwrite(pte_mkdirty(entry), vma) <- mark the page dirty but keep it RO
```
  ],  caption: [Page Fault 1 @analysis])
]
2.	Zweiter Page Fault
#block(inset: (left: 2em))[
  Da der letzte Page Fault nicht erfolgreich war kommt zu einem weiteren Page Fault, der versucht, Schreibrechte zu erlangen @analysis.
  #figure([
```
follow_page_mask
  follow_page_pte
    (flags & FOLL_WRITE) && !pte_write(pte) <- retry fault
```
  ], caption: [Page Fault 2 @analysis])
]
3.	Dritter Page Fault
#block(inset: (left: 2em))[
  Da die COW-Seite noch nicht vollständig bereitgestellt ist, erfolgt ein erneuter Versuch, diesmal ohne erneute Prüfung der Schreibberechtigung, da davon ausgegangen wird, dass man sich weiterhin in einem gültigen COW-Zustand befindet. In dem aktuellen Page-Fault wurde erkannt, dass eine COW-Page existiert und COW-Pages sind nicht schreibgeschützt @analysis.
  #figure([
```
faultin_page
  handle_mm_fault
    __handle_mm_fault
      handle_pte_fault
        FAULT_FLAG_WRITE && !pte_write
	  do_wp_page
	    PageAnon() <- this is CoWed page already
	    reuse_swap_page <- page is exclusively ours
	    wp_page_reuse
	      maybe_mkwrite <- dirty but RO again
	      ret = VM_FAULT_WRITE
((ret & VM_FAULT_WRITE) && !(vma->vm_flags & VM_WRITE)) <- we drop FOLL_WRITE
```
  ], caption: [Page Fault 2 @analysis])
]

4.	Letzter Page Fault (Read Fault)
#block(inset: (left: 2em))[
  Die zuvor benötigte Schreibberechtigung wurde intern entfernt. Es wird nur überprüft, ob ein read möglich ist und die Page-Cache-Seite wird zurückgegeben, die nun beschrieben werden kann. Erfolgt nun zwischen diesem und dem vorherigen Fault ein madvise()-Aufruf, wird die page table zurückgesetzt und zeigt nun auf die Shared-Page. Der Kernel behandelt den Zugriff als reinen Lesezugriff und überspringt die Schreibrechteprüfung vollständig @analysis.
  #figure([
```
follow_page_mask
  !pte_present && pte_none
faultin_page
  handle_mm_fault
    __handle_mm_fault
      handle_pte_fault
        do_fault <- pte is not present
	  do_read_fault <- this is a read fault and we will get pagecache page!
```
], caption: [Page Fault 4(READ) @analysis])
]
