Class {
	#name : #P4TACOr,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACOr >> accept: aVisitor [
	^ aVisitor visitOr: self
]

{ #category : #accessing }
P4TACOr >> op [
	^ #or
]
