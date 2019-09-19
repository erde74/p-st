Class {
	#name : #P4PerformanceTest,
	#superclass : #P4Object,
	#type : #variable,
	#category : #'P4-Test'
}

{ #category : #'as yet unclassified' }
P4PerformanceTest >> dictionary [
	| dict |
	dict := P4Dictionary new.
	1 to: 1000000 do: [ :i |
		dict at: i put: i.
		dict at: i ].
]

{ #category : #'as yet unclassified' }
P4PerformanceTest >> fib: n [
	^ (n<2) ifTrue: [ 1 ] ifFalse: [(self fib: (n-1)) + (self fib: (n-2))]
]

{ #category : #'as yet unclassified' }
P4PerformanceTest >> run [
	self dictionary
]
