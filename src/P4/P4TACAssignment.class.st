Class {
	#name : #P4TACAssignment,
	#superclass : #P4TACAssigning,
	#category : #'P4-TAC-IR'
}

{ #category : #visiting }
P4TACAssignment >> accept: aVisitor [
	^ aVisitor visitAssignment: self
]

{ #category : #accessing }
P4TACAssignment >> op [
	^ #mov
]
