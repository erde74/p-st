Class {
	#name : #P4TACTest,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACTest >> accept: aVisitor [
	^ aVisitor visitTest: self
]

{ #category : #accessing }
P4TACTest >> op [
	^ #test
]
