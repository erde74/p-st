Class {
	#name : #P4A2TMethod,
	#superclass : #P4AST2TAC,
	#instVars : [
		'closureCompiler',
		'host'
	],
	#category : #'P4-TAC'
}

{ #category : #compiling }
P4A2TMethod >> compile: anAst [
	self reset.
	^ self visit: anAst 
]

{ #category : #visitor }
P4A2TMethod >> compileClosureCapture: closureCapture [
	closureCompiler compile: closureCapture closure.
]

{ #category : #accessing }
P4A2TMethod >> compileInvokeBlock [ 
	helper invokeBlockFor: callable  
]

{ #category : #visitor }
P4A2TMethod >> createNonLocalReturnToken [
	callable entry positionAtBeginning.
	callable entry     
		<< (P4TACCall to: #newClosureReturnToken);
		<< (helper resultVariable moveTo:  (callable returnToken));
		<< (callable returnToken moveTo:  (callable basePointer accessAt: 0));
		<< ((callable basePointer) moveTo: (callable returnToken accessAt: 0))


]

{ #category : #accessing }
P4A2TMethod >> declareInstVars [
	builder declareSelf: #self.
	builder declareInstVars: currentInstVars.
	callable locals at: P4TACBasePointerName instance put: (P4TACConstantLocal named: P4TACBasePointerName instance).
	callable locals at: P4TACReturnTokenName instance put: (P4TACConstantLocal named: P4TACReturnTokenName instance)..
	helper currentHost: host.
]

{ #category : #compiling }
P4A2TMethod >> emptyBody [
	builder return: builder self  
]

{ #category : #accessing }
P4A2TMethod >> helper: aHelper [
	helper := aHelper.
	closureCompiler helper: aHelper.
	aHelper
		builder: builder;
		methodCompiler: self.
]

{ #category : #accessing }
P4A2TMethod >> host: aClass [
	host := aClass.

]

{ #category : #'initialize-release' }
P4A2TMethod >> initialize [
	builder := P4TACBuilder new.
	closureCaptures := OrderedCollection new.
	closureCompiler := P4A2TClosure new
							builder: builder;
							closures: closureCaptures;
							methodCompiler: self.
]

{ #category : #visitor }
P4A2TMethod >> insertPopArguments [
	helper insertPopArguments
]

{ #category : #visitor }
P4A2TMethod >> insertPreamble [
	helper insertMethodPreamble: callable

]

{ #category : #compiling }
P4A2TMethod >> insertReturn: lastResult [
	builder return: builder self
]

{ #category : #visitor }
P4A2TMethod >> loadIncomingArguments: parameters [
	^ helper loadMethodArguments: parameters
]

{ #category : #accessing }
P4A2TMethod >> method [
	^ callable
]

{ #category : #accessing }
P4A2TMethod >> methodSuper [
	^ callable host superclass
]

{ #category : #accessing }
P4A2TMethod >> numArgs [
	^ callable message numArgs + 1
]

{ #category : #accessing }
P4A2TMethod >> readAnnotations: aCallable [  
	aCallable pragmas do: [ :a | a acceptVisitor: self ].
]

{ #category : #'initialize-release' }
P4A2TMethod >> reset [
	builder reset.
	callable := P4TACMethod new.
	closureCaptures removeAll.
]

{ #category : #convenience }
P4A2TMethod >> storeBasePointer [
	builder move: helper stackPointer to: callable basePointer
]

{ #category : #compiling }
P4A2TMethod >> unrollPrimitive [
	helper unrollPrimitiveFor: callable
]

{ #category : #visitor }
P4A2TMethod >> visitMethodNode: aMethod [
	| entry currentCapture |
	callable host: host.
	callable message: aMethod selector.
	
	self compileCallable: aMethod.
	
	[ closureCaptures isEmpty ] whileFalse: [
		currentCapture := closureCaptures removeFirst.
		self compileClosureCapture: currentCapture.
		callable addClosure: currentCapture closure. ].

	callable hasNonLocalReturn ifTrue: [ self createNonLocalReturnToken ].
				
	callable literals: builder literals.
	
	^ callable
]

{ #category : #visitor }
P4A2TMethod >> visitPragmaNode: anASTKeywordAnnotation [
	^ helper annotation: anASTKeywordAnnotation

]

{ #category : #visitor }
P4A2TMethod >> visitReturnNode: aReturnNode [
	^ helper methodReturn: aReturnNode
]
