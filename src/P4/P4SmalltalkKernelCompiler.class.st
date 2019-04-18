"
P4SmalltalkKernelCompiler new
processor: P4AbstractX86_64 new;
os: P4Linux new;
compileClasses: { P4Object }
"
Class {
	#name : #P4SmalltalkKernelCompiler,
	#superclass : #P4SmalltalkCompiler,
	#category : #'P4-Compiler'
}

{ #category : #'as yet unclassified' }
P4SmalltalkKernelCompiler >> a2tHelper: methodAST [
	( methodAST hasPragmaNamed: #invoke ) ifTrue: [ ^ P4A2TInvoke new ].
	^ P4A2TKernel new
]

{ #category : #'as yet unclassified' }
P4SmalltalkKernelCompiler >> initialize [ 
	super initialize.
	P4Package loadClasses.
]
