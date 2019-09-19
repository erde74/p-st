Class {
	#name : #P4ELFHashTable,
	#superclass : #P4ELFTable,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFHashTable >> type [
	" 5 HASH Symbol hash table (for dynamic linking, single) "
	^ 16r5
]
