Class {
	#name : #P4TACMethodObject,
	#superclass : #P4TACValue,
	#category : #'P4-TAC-Values'
}

{ #category : #'instance creation' }
P4TACMethodObject class >> with: aValue [
	^ self new target: aValue  
]

{ #category : #'as yet unclassified' }
P4TACMethodObject >> accept: aVisitor [
	self error: 'can only be accessed'
]

{ #category : #accessing }
P4TACMethodObject >> accessAt: anIndex [
	^ (P4TACMethodObjectAccess new) index: anIndex; method: self
]

{ #category : #testing }
P4TACMethodObject >> isAccess [
	^ true
]
