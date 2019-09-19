Class {
	#name : #P4TACClosureTemp,
	#superclass : #P4TACTemp,
	#category : #'P4-TAC-Values'
}

{ #category : #'as yet unclassified' }
P4TACClosureTemp >> wrapTypeGuard: types andCondition: condition around: aBlock fallback: anOtherBlock with: helper [
	(types anySatisfy: [ :type | P4Closure asPClass == type ])
		ifTrue: [ ^ aBlock value.].
	anOtherBlock value.
]
