Class {
	#name : #P4TACCompare,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #accessing }
P4TACCompare >> accept: aVisitor [
	^ aVisitor visitCompare: self
]

{ #category : #accessing }
P4TACCompare >> op [
	^ #cmp
]
