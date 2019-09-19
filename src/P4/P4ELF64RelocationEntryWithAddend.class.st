Class {
	#name : #P4ELF64RelocationEntryWithAddend,
	#superclass : #P4ELF64RelocationEntry,
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELF64RelocationEntryWithAddend >> addend [
	type = 16r2 ifTrue: [ ^ -4 ].
	^ 0
]

{ #category : #writing }
P4ELF64RelocationEntryWithAddend >> writeOn: aStream [ 
	super writeOn: aStream.
	aStream pointerPut: self addend
]
