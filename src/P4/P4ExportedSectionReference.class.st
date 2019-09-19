Class {
	#name : #P4ExportedSectionReference,
	#superclass : #P4ExportedReference,
	#category : #'P4-Exec'
}

{ #category : #'as yet unclassified' }
P4ExportedSectionReference >> addend [
	^ offset
]

{ #category : #'as yet unclassified' }
P4ExportedSectionReference >> printOn: aStream [
	aStream << 'a section Reference'.
]

{ #category : #'as yet unclassified' }
P4ExportedSectionReference >> relocationTable [
	^ target relocationTable
]

{ #category : #'as yet unclassified' }
P4ExportedSectionReference >> sectionOffset [
	^ offset
]
