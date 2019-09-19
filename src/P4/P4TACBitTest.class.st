Class {
	#name : #P4TACBitTest,
	#superclass : #P4TACInstruction,
	#instVars : [
		'bit',
		'location'
	],
	#category : #'P4-TAC-IR'
}

{ #category : #'initialize-release' }
P4TACBitTest class >> of: num in: var [
	^ self new location: var; bit: num     
]

{ #category : #accessing }
P4TACBitTest >> accept: aVisitor [
	^ aVisitor visitBitTest: self
]

{ #category : #accessing }
P4TACBitTest >> bit [
	^ bit
]

{ #category : #accessing }
P4TACBitTest >> bit: anObject [
	bit := anObject
]

{ #category : #accessing }
P4TACBitTest >> location [
	^ location
]

{ #category : #accessing }
P4TACBitTest >> location: anObject [
	location := anObject
]
