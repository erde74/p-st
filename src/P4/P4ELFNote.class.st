Class {
	#name : #P4ELFNote,
	#superclass : #P4ELFSectionWithData,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFNote >> type [
	" 7 NOTE File marking "
	^ 16r7
]
