Class {
	#name : #P4A2TInvoke,
	#superclass : #P4A2TKernel,
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4A2TInvoke >> insertMethodPreamble: method [
	method invokeBlock: builder nextBasicBlock.
	processor callRegisters reverseDo: [ :r | builder push: r ]
]

{ #category : #'as yet unclassified' }
P4A2TInvoke >> insertPopArguments [
	processor callRegisters do: [ :r | builder pop: r ]
]

{ #category : #'as yet unclassified' }
P4A2TInvoke >> loadMethodArguments: parameters [
	| theSelf paramName |
	"invoke gets the only 1 arg (the selector) "
	
	theSelf := builder self.
	builder move: ( self arg: 1 of: 1 ) to: theSelf.
	
	paramName := parameters first name.
	builder declare: paramName.
	builder move: self selectorVariable to: (builder local: paramName).
	
	builder volatileFence
]
