Class {
	#name : #P4TACConstantLocal,
	#superclass : #P4TACVariable,
	#instVars : [
		'remote'
	],
	#category : #'P4-TAC-Values'
}

{ #category : #'as yet unclassified' }
P4TACConstantLocal >> beRemote [ 

]

{ #category : #'as yet unclassified' }
P4TACConstantLocal >> name: aName [
	name := aName
]

{ #category : #'as yet unclassified' }
P4TACConstantLocal >> shouldBeRemote [ 
	^ false
]
