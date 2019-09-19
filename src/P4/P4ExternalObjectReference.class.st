Class {
	#name : #P4ExternalObjectReference,
	#superclass : #P4ExportedObjectReference,
	#category : #'P4-Exec'
}

{ #category : #'as yet unclassified' }
P4ExternalObjectReference >> printOn: aStream [
	aStream << 'a global Reference'.
]

{ #category : #'as yet unclassified' }
P4ExternalObjectReference >> sectionOffset [ 
	^ 0
]
