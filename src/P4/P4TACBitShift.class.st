Class {
	#name : #P4TACBitShift,
	#superclass : #P4TACInstruction,
	#instVars : [
		'target',
		'bits'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACBitShift >> accept: aVisitor [
	^ aVisitor visitBitShift: self
]

{ #category : #accessing }
P4TACBitShift >> bits [
	^ bits
]

{ #category : #accessing }
P4TACBitShift >> bits: anObject [
	bits := anObject
]

{ #category : #accessing }
P4TACBitShift >> target [
	^ target
]

{ #category : #accessing }
P4TACBitShift >> target: anObject [
	target := anObject
]
