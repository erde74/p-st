Class {
	#name : #P4StaticMethodInstaller,
	#superclass : #P4MethodInstaller,
	#instVars : [
		'globals',
		'references'
	],
	#category : #'P4-SystemInstaller'
}

{ #category : #'as yet unclassified' }
P4StaticMethodInstaller >> flush [
	globals := P4IdentityDictionary new.
	references := P4IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
P4StaticMethodInstaller >> global: aGlobal at: position [
	globals at: position put: aGlobal
]

{ #category : #'as yet unclassified' }
P4StaticMethodInstaller >> installFunction: functionName at: position [
	functionName isSymbol ifFalse: [ self error: 'not a function call' ].
	references at: position put: functionName
]

{ #category : #'as yet unclassified' }
P4StaticMethodInstaller >> installMethod: aCompiledMethod on: aClass [
	self flush.
	compiler host: aClass.
	(compiler compileMethod: aCompiledMethod ) ifNotNil: [ :method |
		method usedGlobals: globals.
		method usedReferences: references.
		aClass installMethod: method.]
]

{ #category : #'as yet unclassified' }
P4StaticMethodInstaller >> newCompiler [
	^ P4SmalltalkKernelCompiler new
]
