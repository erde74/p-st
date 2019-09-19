Class {
	#name : #P4TACReference,
	#superclass : #P4TACValue,
	#instVars : [
		'target'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'instance creation' }
P4TACReference class >> target: aTarget [
	^ self new target: aTarget
]

{ #category : #accessing }
P4TACReference >> accept: visitor [
	^ visitor visitReference: self
]

{ #category : #accessing }
P4TACReference >> printOn: stream [ 
	stream << '&' << target asString .
]

{ #category : #accessing }
P4TACReference >> target [
	^ target
]

{ #category : #accessing }
P4TACReference >> target: anObject [
	target := anObject
]
