Class {
	#name : #P4TACPostCompiler,
	#superclass : #P4Object,
	#instVars : [
		'toReplace',
		'callable',
		'basicBlock'
	],
	#category : #'P4-TAC'
}

{ #category : #accessing }
P4TACPostCompiler >> basicBlock [
	^ basicBlock
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> callable [ 
	^ callable 
]

{ #category : #accessing }
P4TACPostCompiler >> helper: aHelper [
	helper := aHelper
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> process: statement [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> runOn: aTACNode [
	aTACNode accept: self
	
	
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> visitBasicBlock: aBasicBlock [
	basicBlock := aBasicBlock.
	basicBlock do: [ :i | self process: i.	].
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> visitCallable: aCallable [
	callable := aCallable.
	callable basicBlocksDo: [ :b | b accept: self ]  
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> visitClosure: aClosure [
	self visitCallable: aClosure     

]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> visitEndBlock: aBasicBlock [
	
]

{ #category : #'as yet unclassified' }
P4TACPostCompiler >> visitMethod: aMethod [
	self visitCallable: aMethod.  
	aMethod closures do: [ :closure |
		self visitClosure: closure  ]
]
