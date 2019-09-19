Class {
	#name : #P4TACAssigning,
	#superclass : #P4TACOperation,
	#category : #'P4-TAC-IR'
}

{ #category : #'instance creation' }
P4TACAssigning class >> assign: value to: target [
	self halt.
	^ self new origin: value; target: target
]

{ #category : #'instance creation' }
P4TACAssigning class >> move: value to: target [
	^ self new origin: value; target: target
]

{ #category : #visiting }
P4TACAssigning >> asValue [ 
	self flag: 'Not sure if this is correct'.
	^ left
]

{ #category : #testing }
P4TACAssigning >> isAssignment [ 
	^true
]

{ #category : #accessing }
P4TACAssigning >> left [
	^ left
]

{ #category : #accessing }
P4TACAssigning >> origin [
	^ left
]

{ #category : #accessing }
P4TACAssigning >> origin: anOrigin [
	self haltIf: anOrigin isNil.
	left := anOrigin 
]

{ #category : #accessing }
P4TACAssigning >> right [
	^ right
]

{ #category : #accessing }
P4TACAssigning >> target [
	^ right
]

{ #category : #accessing }
P4TACAssigning >> target: aTarget [
	self haltIf: aTarget isNil.
	right := aTarget 
]
