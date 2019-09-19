Class {
	#name : #P4TACAdd,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'visitor accepting' }
P4TACAdd >> accept: aVisitor [
	^ aVisitor visitAdd: self
]

{ #category : #accessing }
P4TACAdd >> op [
	^ #add
]
