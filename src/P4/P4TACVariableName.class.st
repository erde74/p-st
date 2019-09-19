Class {
	#name : #P4TACVariableName,
	#superclass : #P4Object,
	#classInstVars : [
		'inst'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'as yet unclassified' }
P4TACVariableName class >> instance [
	^ inst ifNil: [ ^ inst := self new]
]

{ #category : #'as yet unclassified' }
P4TACVariableName >> name [
	^ self
]
