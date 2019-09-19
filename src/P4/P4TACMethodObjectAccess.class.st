Class {
	#name : #P4TACMethodObjectAccess,
	#superclass : #P4TACValue,
	#instVars : [
		'methodObject',
		'index'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'as yet unclassified' }
P4TACMethodObjectAccess >> accept: aVisitor [
	^ aVisitor visitMethodObjectAccess: self
]

{ #category : #accessing }
P4TACMethodObjectAccess >> index [
	^ index
]

{ #category : #accessing }
P4TACMethodObjectAccess >> index: anObject [
	index := anObject
]

{ #category : #accessing }
P4TACMethodObjectAccess >> method: aMethodObject [
	methodObject := aMethodObject
]

{ #category : #'as yet unclassified' }
P4TACMethodObjectAccess >> printOn: stream [
	methodObject printOn: stream.
	stream << '[' << index << ']'
]

{ #category : #accessing }
P4TACMethodObjectAccess >> target [
	^ methodObject    
]
