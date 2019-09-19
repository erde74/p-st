Class {
	#name : #P4TACEndBlock,
	#superclass : #P4TACCodeBlock,
	#category : #'P4-TAC-IR'
}

{ #category : #testing }
P4TACEndBlock >> accept: aVisitor [
	^ aVisitor visitEndBlock: self
]

{ #category : #testing }
P4TACEndBlock >> atEnd [
	^ true
]

{ #category : #accessing }
P4TACEndBlock >> number: aValue [
	"ignore"
]

{ #category : #testing }
P4TACEndBlock >> printOn: stream [
	stream << '---'
]
