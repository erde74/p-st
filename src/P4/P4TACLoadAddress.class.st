Class {
	#name : #P4TACLoadAddress,
	#superclass : #P4TACAssigning,
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACLoadAddress class >> load: aValue in: aTarget [
	^ self new left: aValue; right: aTarget
]

{ #category : #accessing }
P4TACLoadAddress >> accept: aVisitor [
	^ aVisitor visitLoadAddress: self
]

{ #category : #accessing }
P4TACLoadAddress >> op [
	^ #lea
]
