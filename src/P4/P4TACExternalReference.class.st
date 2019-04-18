Class {
	#name : #P4TACExternalReference,
	#superclass : #P4TACReference,
	#category : #'P4-TAC-Values'
}

{ #category : #'visitor accepting' }
P4TACExternalReference >> accept: visitor [
	^ visitor visitConstantReference: self
]

{ #category : #testing }
P4TACExternalReference >> isConstant [
	^ true
]

{ #category : #testing }
P4TACExternalReference >> wrapTypeGuard: types andCondition: condition around: aBlock fallback: anOtherBlock with: helper [
	(types anySatisfy: [ :type | target pclass == type ])
		ifTrue: [ 
			aBlock value.
			^ condition ifNotEmpty: [ helper insertCondition: condition fallback: anOtherBlock ]].
	anOtherBlock value.
]
