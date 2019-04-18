Class {
	#name : #P4ASMObjectAccess,
	#superclass : #P4ASMReference,
	#instVars : [
		'offset'
	],
	#category : #'P4-ASM-Values'
}

{ #category : #accessing }
P4ASMObjectAccess >> offset [
	^ offset ifNil: [ 0 ]
]

{ #category : #accessing }
P4ASMObjectAccess >> offset: anObject [
	offset := anObject
]
