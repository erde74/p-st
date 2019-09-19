Class {
	#name : #P4A2TClosure,
	#superclass : #P4AST2TAC,
	#instVars : [
		'methodCompiler'
	],
	#category : #'P4-TAC'
}

{ #category : #accessing }
P4A2TClosure >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
P4A2TClosure >> closures: anObject [
	closureCaptures := anObject
]

{ #category : #compiling }
P4A2TClosure >> compile: aClosure [
	callable := aClosure.
	self compileCallable: aClosure code
]

{ #category : #compiling }
P4A2TClosure >> declareInstVars [ 
	builder loadSelf: #self from: [callable import: #self].
	builder clearInstVars.
]

{ #category : #compiling }
P4A2TClosure >> emptyBody [
	builder return: (builder global: #nil)
]

{ #category : #compiling }
P4A2TClosure >> insertReturn: lastResult [
	builder return: lastResult.
]

{ #category : #visitor }
P4A2TClosure >> loadIncomingArguments: parameters [ 
	| numOfArgs aLocal i |

	"arg 1 is the closure"
	numOfArgs := parameters size + 1.
	i := 0.
	parameters do: [ :arg |
		aLocal := builder declare: arg name.
		i := i + 1.
		builder move: ( helper arg: i + 1 of: numOfArgs ) to: aLocal ]. 
	
	builder volatileFence 
]

{ #category : #visitor }
P4A2TClosure >> lookupLValue: anASTVariable [
	^ builder local: anASTVariable name ifAbsent: [
		(callable import: anASTVariable name) ifNil: [
			builder instVar: anASTVariable name ]]
]

{ #category : #accessing }
P4A2TClosure >> methodCompiler: aMethodCompiler [
	methodCompiler := aMethodCompiler
]

{ #category : #accessing }
P4A2TClosure >> methodSuper [
	^ methodCompiler methodSuper
]

{ #category : #visitor }
P4A2TClosure >> storeBasePointer [ 
]

{ #category : #'as yet unclassified' }
P4A2TClosure >> visitReturnNode: aReturnNode [
	| ret |
	ret := aReturnNode value acceptVisitor: self.
	builder move: (callable returnTokenFor: self) to: (helper arg: 1 of: 1).
	builder move: ret to: helper resultVariable. 
	builder directCall: (P4Closure earlySelectorAddress: #return).
	^ ret
]

{ #category : #visitor }
P4A2TClosure >> visitSelfNode: aSelf [
	^ builder local: #self ifAbsent: [ callable import: #self ]
]

{ #category : #visitor }
P4A2TClosure >> visitVariableNode: anASTVariable [
	^ builder local: anASTVariable name ifAbsent: [
		(callable import: anASTVariable name) ifNil: [
			builder instVarOrGlobal: anASTVariable name ]]
]
