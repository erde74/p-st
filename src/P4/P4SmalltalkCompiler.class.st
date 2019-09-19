Class {
	#name : #P4SmalltalkCompiler,
	#superclass : #P4Object,
	#instVars : [
		'parser',
		'ast2tac',
		'tac2asm',
		'registerAllocator',
		'registerSwapper',
		'assignmentRemover',
		'host',
		'livenessAnalyzer',
		'analyzeRemote',
		'closureInstaller',
		'classInstaller',
		'processor'
	],
	#category : #'P4-Compiler'
}

{ #category : #compiling }
P4SmalltalkCompiler >> a2tHelper: aMethodAST [
	^ P4A2THelper new
	
	

]

{ #category : #compiling }
P4SmalltalkCompiler >> compileMethod: aCompiledMethod [
	| methodAST methodTAC |
	
	methodAST := aCompiledMethod ast.
	
	(self shouldBeExported: methodAST) 
		ifFalse: [ ^ nil ].
	
	self haltIf: (self hasHalt: methodAST).
	self helper: (self a2tHelper: methodAST).
	
	methodTAC := ast2tac compile: methodAST.
	
	livenessAnalyzer runOn: methodTAC.
	analyzeRemote runOn: methodTAC.
	closureInstaller runOn: methodTAC.
	registerAllocator runOn: methodTAC.
	registerSwapper runOn: methodTAC.
	assignmentRemover runOn: methodTAC.
	^ tac2asm compile: methodTAC
	
	"self halt."

]

{ #category : #accessing }
P4SmalltalkCompiler >> currentClass: aClass [
	ast2tac currentClass: aClass    
]

{ #category : #compiling }
P4SmalltalkCompiler >> hasHalt: methodAST [
	^ (methodAST hasPragmaNamed: #halt)
]

{ #category : #compiling }
P4SmalltalkCompiler >> helper: anA2THelper [
	anA2THelper processor: processor.
	ast2tac helper: anA2THelper.
	registerSwapper helper: anA2THelper.
	closureInstaller helper: anA2THelper.

]

{ #category : #accessing }
P4SmalltalkCompiler >> host: anObject [
	ast2tac host: anObject .
	ast2tac currentInstVars: anObject inPharo allInstVarNames.

]

{ #category : #'initialize-release' }
P4SmalltalkCompiler >> initialize [
	livenessAnalyzer := P4TACLivenessAnalysis new.
	registerAllocator := P4TACLinearScanRegisterAllocator new.
	registerSwapper := P4TACRegisterSwapper new.
	assignmentRemover := P4TACAssignmentRemover new.
	analyzeRemote := P4TACAnalyzeRemote new.
	closureInstaller := P4TACClosureInstaller new.
	tac2asm := P4TAC2ASM new.
	ast2tac := P4A2TMethod new.
	

]

{ #category : #accessing }
P4SmalltalkCompiler >> processor: aProcessor [
	processor := aProcessor.
	registerAllocator processor: aProcessor.
	tac2asm processor: aProcessor.
]

{ #category : #compiling }
P4SmalltalkCompiler >> shouldBeExported: methodAST [
	^ (methodAST hasPragmaNamed: #preventExport) not
]
