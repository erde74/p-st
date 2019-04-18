Class {
	#name : #P4MOSectionBasedRelocation,
	#superclass : #P4MORelocation,
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOSectionBasedRelocation >> isExternal [ 
	"Indexing into a section"
	^ false
]

{ #category : #'as yet unclassified' }
P4MOSectionBasedRelocation >> section [
	^ symbol
]

{ #category : #'as yet unclassified' }
P4MOSectionBasedRelocation >> section: aSection [
	symbol := aSection
]

{ #category : #'as yet unclassified' }
P4MOSectionBasedRelocation >> sectionOffset: aNumber [
	"this is the offset from the beginning of the section"
	addend := aNumber
]

{ #category : #'as yet unclassified' }
P4MOSectionBasedRelocation >> symbol: aSymbol [
	self shouldNotCall.
]
