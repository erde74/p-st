Class {
	#name : #P4TACMessage,
	#superclass : #P4Object,
	#instVars : [
		'selector',
		'numOfArguments'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #accessing }
P4TACMessage >> numOfArguments [
	^ numOfArguments
]

{ #category : #accessing }
P4TACMessage >> numOfArguments: anObject [
	numOfArguments := anObject
]

{ #category : #accessing }
P4TACMessage >> selector [
	^ selector
]

{ #category : #accessing }
P4TACMessage >> selector: anObject [
	selector := anObject
]
