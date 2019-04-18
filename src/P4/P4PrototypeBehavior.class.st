Class {
	#name : #P4PrototypeBehavior,
	#superclass : #P4Object,
	#instVars : [
		'originalMethods'
	],
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4PrototypeBehavior >> initialize: object [
	originalMethods := object class methodDictionary.
]

{ #category : #'as yet unclassified' }
P4PrototypeBehavior >> lookup: selector for: object [
	| currentObj |
	(originalMethods at: selector) 
		ifNotNil: [ :method | ^ method ].

	currentObj := object.
	[currentObj == nil] whileFalse: [
		(currentObj slot: selector) 
			ifNotNil: [ :method | ^ method ].
		currentObj := currentObj delegate ].

	^ P4DoesNotUnderstand new
]
