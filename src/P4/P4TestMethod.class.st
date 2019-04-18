Class {
	#name : #P4TestMethod,
	#superclass : #P4Object,
	#category : #'P4-Test'
}

{ #category : #'as yet unclassified' }
P4TestMethod >> numArgs [ 
	^0
]

{ #category : #'as yet unclassified' }
P4TestMethod >> perform: selector on: receiver with: args [   
	| all |
	all := Array new: (args size +1).
	1 to: args size do: [ :i |
		all at: i put: (args at: i) ].
	all at: (args size +1) put: receiver.
	^ all
]
