Class {
	#name : #P4TACAnd,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACAnd >> accept: aVisitor [
	^ aVisitor visitAnd: self
]

{ #category : #accessing }
P4TACAnd >> op [
	^ #and
]
