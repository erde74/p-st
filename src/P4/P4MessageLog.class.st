Class {
	#name : #P4MessageLog,
	#superclass : #P4SmalltalkBehavior,
	#instVars : [
		'log',
		'tally'
	],
	#category : #'P4-Examples'
}

{ #category : #'as yet unclassified' }
P4MessageLog >> incTally [
	tally := tally + 1.
	(tally == self size)
		ifTrue: [ tally := 1 ] 
]

{ #category : #'as yet unclassified' }
P4MessageLog >> initialize [ 
	log := P4Array new: self size.
	tally := 0.
]

{ #category : #'as yet unclassified' }
P4MessageLog >> log [
	^ log
]

{ #category : #'as yet unclassified' }
P4MessageLog >> log: aMessage [
	self incTally.
	log at: tally put: aMessage.

]

{ #category : #'as yet unclassified' }
P4MessageLog >> printMessage: m [
	'------> sent:' print.
	(m at:3) print.
	(m at:2) print.
	(m at:4) do: [ :a | a print]
]

{ #category : #'as yet unclassified' }
P4MessageLog >> replay [ 
	| m |
	1 to: tally do: [ :i |
		m := log at: i.
		self printMessage: m].
]

{ #category : #'as yet unclassified' }
P4MessageLog >> size [
	^ 100
]
