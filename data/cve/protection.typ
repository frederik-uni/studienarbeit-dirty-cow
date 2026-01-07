== Verteidigung
Zur Behebung der Schwachstelle wurde die zugrunde liegende Logik im Kernel angepasst. Anstatt die Schreibanforderung temporär zu entfernen, wird nun explizit ein zusätzliches Flag eingeführt, das kennzeichnet, dass sich der aktuelle Zugriff innerhalb eines COW-Kontextes befindet.

Im Write Fault wird geprüft ob:
- ob ein COW-Zustand aktiv ist,
- ob der zugehörige Page Table Entry (PTE) als „dirty“ markiert ist.

Basierend auf diesen Prüfungen wird entschieden, ob der Speicherbereich invalidiert werden muss. In diesem Fall wird ein erneuter Page Fault ausgelöst (Retry), wodurch eine erneute und korrekte Überprüfung der Zugriffsrechte sichergestellt wird. Dadurch wird verhindert, dass Schreiboperationen auf Shared Pages ohne explizite Schreibberechtigung durchgeführt werden können.

Die Logik für die Überprüfung des ob Schreibberechtigungen existieren oder ob eine COW-Page aktiv ist wurde in eine separate Funktion ausgelagert, um den Code besser lesbar und wartbar zu gestalten wie in @figure1 dargestellt. @linux_mm_remove_gup_flags_2016

#figure([
```c
/*
 * FOLL_FORCE can write to even unwritable pte's, but only
 * after we've gone through a COW cycle and they are dirty.
 */
static inline bool can_follow_write_pte(pte_t pte, unsigned int flags) {
	return pte_write(pte) ||
		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
}
```
], caption: [mm/gup.c @linux_mm_remove_gup_flags_2016]) <figure1>

Statt nur write Permissions zu überprüfen wird write oder FOLL_COW + pte_dirty überprüft. Wie in @figure2 und @figure1 zu erkennen.

#figure([
```diff
if ((flags & FOLL_NUMA) && pte_protnone(pte)) goto no_page;
-  if ((flags & FOLL_WRITE) && !pte_write(pte)) {
+  if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
        pte_unmap_unlock(ptep, ptl);
        return NULL;
    }
```
], caption: [mm/gup.c updated retry @linux_mm_remove_gup_flags_2016]) <figure2>

@figure3 ist der Ursprung des Bugs. Hier wurde ursprünglich FOLL_WRITE entfernt. Statt FOLL_WRITE zu entfernen würd überprüft ob eine COW-Page existiert und es wird eine neue Flag engeführt die in den eben erklärten Funktionen verwendet wird.
#figure([
```diff
if ((ret & VM_FAULT_WRITE) && !(vma->vm_flags & VM_WRITE))
-  *flags &= ~FOLL_WRITE;
+  *flags |= FOLL_COW;
```
], caption: [mm/gup.c updated flags linux_mm_remove_gup_flags_2016]) <figure3>
