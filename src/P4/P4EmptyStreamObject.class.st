Class {
	#name : #P4EmptyStreamObject,
	#superclass : #P4ObjectStream,
	#classInstVars : [
		'instance'
	],
	#category : #'P4-Stream'
}

{ #category : #'as yet unclassified' }
P4EmptyStreamObject class >> instance [
	^ instance ifNil: [ ^ instance := self new ]
]

{ #category : #'as yet unclassified' }
P4EmptyStreamObject >> do: aBlock [
]

{ #category : #'as yet unclassified' }
P4EmptyStreamObject >> printOn: aStream [
]
