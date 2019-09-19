Class {
	#name : #P4TACBitShiftRight,
	#superclass : #P4TACInstruction,
	#instVars : [
		'target',
		'bits'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACBitShiftRight >> accept: aVisitor [
	^ aVisitor visitBitShiftRight: self
]

{ #category : #accessing }
P4TACBitShiftRight >> bits [
	^ bits
]

{ #category : #accessing }
P4TACBitShiftRight >> bits: anObject [
	bits := anObject
]

{ #category : #accessing }
P4TACBitShiftRight >> target [
	^ target
]

{ #category : #accessing }
P4TACBitShiftRight >> target: anObject [
	target := anObject
]
