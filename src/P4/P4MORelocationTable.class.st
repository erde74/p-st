Class {
	#name : #P4MORelocationTable,
	#superclass : #P4Object,
	#instVars : [
		'entries',
		'fileOffset'
	],
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MORelocationTable >> absoluteRelocate: aSymbol at: position [
	(aSymbol isKindOf: P4ExportedSectionReference)
		ifTrue: [
			^ self add: (P4MOSectionBasedRelocation new
				absolute;
				section: aSymbol target;
				address: position) ]
		ifFalse: [ 
			^ self add: (P4MORelocation new
				absolute;
				symbol: aSymbol target;
				address: position) ]
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> add: aRelocation [
	^ entries add: aRelocation
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> fileOffset [
	^ fileOffset
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> fileOffset: offset [
	"just align it on 16bytes, we're lazy..."
	fileOffset := (offset / 16) ceiling * 16.
	^ fileOffset + self fileSize
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> fileSize [
	^ entries inject: 0 into: [ :sum :relocationEntry| sum + relocationEntry fileSize]
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> initialize [
	entries := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> relocate: aSymbol at: position [
	^ self add: (P4MORelocation new
			symbol: aSymbol target;
			address: position)
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> size [
	^ entries size
]

{ #category : #'as yet unclassified' }
P4MORelocationTable >> writeOn: aStream [
	aStream fillTo: fileOffset with: 16r00.
	entries do: [ :relocationEntry| relocationEntry writeOn: aStream].
]
