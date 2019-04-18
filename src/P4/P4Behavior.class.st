Class {
	#name : #P4Behavior,
	#superclass : #P4Object,
	#instVars : [
		'instanceHeader',
		'behavior',
		'layout'
	],
	#category : #'P4-Kernel-Behavior'
}

{ #category : #accessing }
P4Behavior >> basicNew [
	<pprimitive: #basicNew>
	self pHalt.
]

{ #category : #accessing }
P4Behavior >> basicNew: n [
	<pprimitive: #'basicNew_'>
	self pHalt.
]

{ #category : #accessing }
P4Behavior >> initialize [ 
	<preventExport>
	behavior := P4SmalltalkBehavior for: self
]

{ #category : #accessing }
P4Behavior >> installMethod: aMethod [  
	behavior installMethod: aMethod  
]

{ #category : #accessing }
P4Behavior >> instanceHeader [
	^ instanceHeader
]

{ #category : #accessing }
P4Behavior >> instanceHeader: anObject [
	instanceHeader := anObject
]

{ #category : #accessing }
P4Behavior >> layout [
	^ layout
]

{ #category : #accessing }
P4Behavior >> methodDictionary [
	^ behavior methodDictionary
]

{ #category : #accessing }
P4Behavior >> methodDictionary: aMethodDictionary [
	behavior methodDictionary: aMethodDictionary
]

{ #category : #accessing }
P4Behavior >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
P4Behavior >> new: n [
	^ (self basicNew: n) initialize
]

{ #category : #accessing }
P4Behavior >> setBehavior: anObject [
	behavior := anObject
]

{ #category : #accessing }
P4Behavior >> superclass [
	^ behavior superclass
]

{ #category : #accessing }
P4Behavior >> superclass: aSuperclass [ 
	behavior superclass: aSuperclass 
]

{ #category : #accessing }
P4Behavior >> theBehavior [
	^ behavior
]

{ #category : #accessing }
P4Behavior >> theClass [
	^ self
]
