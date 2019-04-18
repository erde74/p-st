Class {
	#name : #P4TACXOr,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'as yet unclassified' }
P4TACXOr >> accept: aVisitor [
	^ aVisitor visitXor: self
]

{ #category : #'as yet unclassified' }
P4TACXOr >> op [
	^ #xor
]
