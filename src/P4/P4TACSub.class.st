Class {
	#name : #P4TACSub,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACSub >> accept: aVisitor [
	^ aVisitor visitSub: self
]

{ #category : #accessing }
P4TACSub >> op [
	^ #sub
]
