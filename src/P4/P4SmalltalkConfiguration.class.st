Class {
	#name : #P4SmalltalkConfiguration,
	#superclass : #P4Object,
	#classInstVars : [
		'instance'
	],
	#category : #'P4-SystemSpec'
}

{ #category : #'as yet unclassified' }
P4SmalltalkConfiguration class >> doesNotUnderstand: aName [  
	^ self instance perform: aName selector
]

{ #category : #'as yet unclassified' }
P4SmalltalkConfiguration class >> instance [
	^ instance ifNil: [ instance := self new ]
]

{ #category : #'as yet unclassified' }
P4SmalltalkConfiguration >> classIndex [
	^ 0- self objectHeaderSize
]

{ #category : #'as yet unclassified' }
P4SmalltalkConfiguration >> objectHeaderSize [
	^2
]
