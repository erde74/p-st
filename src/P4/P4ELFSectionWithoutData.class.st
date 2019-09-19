Class {
	#name : #P4ELFSectionWithoutData,
	#superclass : #P4ELFSection,
	#instVars : [
		'size',
		'siblingSection'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'instance creation' }
P4ELFSectionWithoutData class >> newFor: aSection [
	^ self new
		siblingSection: aSection
]

{ #category : #header }
P4ELFSectionWithoutData >> addrAlign [
	^ 4
]

{ #category : #accessing }
P4ELFSectionWithoutData >> allocate: amount [ 
	| result |
	result := size.
	size := size + amount.
	^ result
]

{ #category : #header }
P4ELFSectionWithoutData >> entrySize: pointerSize [
	^ pointerSize
]

{ #category : #'initialize-release' }
P4ELFSectionWithoutData >> initialize [
	super initialize.
	size := 0.
]

{ #category : #header }
P4ELFSectionWithoutData >> link [
	^ siblingSection headerIndex
]

{ #category : #accessing }
P4ELFSectionWithoutData >> siblingSection [
	^ siblingSection
]

{ #category : #accessing }
P4ELFSectionWithoutData >> siblingSection: anObject [
	siblingSection := anObject
]

{ #category : #header }
P4ELFSectionWithoutData >> size: pointerSize [
	^ size * pointerSize
]

{ #category : #header }
P4ELFSectionWithoutData >> type [
	" 8 NOBITS Occupies no space in the file, otherwise similar to PROGBITS "
	^ 16r8
]
