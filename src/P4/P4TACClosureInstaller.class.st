Class {
	#name : #P4TACClosureInstaller,
	#superclass : #P4TACPostCompiler,
	#instVars : [
		'helper',
		'importedRemotes'
	],
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> fix: imports [
	imports reverseDo: [ :aVariable |
		aVariable shouldBeRemote
			ifTrue: [
				imports remove: aVariable.
				importedRemotes add: aVariable remoteVariable ]].
	importedRemotes do: [ :aRemote | imports add: aRemote ].
	importedRemotes removeAll.
]

{ #category : #accessing }
P4TACClosureInstaller >> helper: aHelper [
	helper := aHelper
]

{ #category : #'initialize-release' }
P4TACClosureInstaller >> initialize [
	importedRemotes := P4IdentitySet new.
]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> installRemotes: method [
	(method entry positionAtBeginning) 
		<< ((P4TACConstant with: method remoteVariables size asTaggedInteger ) moveTo: ( helper arg: 1 of: 1 ));
		<< (P4TACCall to: (P4RemoteArray earlyClassSelectorAddress: #pNew:));
		<< (helper resultVariable moveTo: method remoteVariables).

]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> loadClosureVariable: closure [
	| closureObj i unwind |
	closureObj := helper intermediateLValue.
	closure entry positionAtBeginning.
	closure entry << ((helper arg: 1 of: closure) moveTo: closureObj).  
	i := 1.
	closure imports do: [ :var |
		closure entry << ((closureObj accessAt: i) moveTo: (closure locals at: var name)).
		i := i + 1 ].
]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> process: statement [
	statement acceptCaptureClosure: self
]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> unroll: captureClosure [
	| closure imports copyImports i closureVariable |
	closure := captureClosure closure.
	imports := closure imports.
	self fix: imports.
	closureVariable := captureClosure resultVariable.
	closureVariable assignedAt: captureClosure flowNumber.  

	basicBlock overridePosition: captureClosure.
	basicBlock 
		<< ((P4TACConstant with: (imports size + 1) asTaggedInteger) moveTo: (helper arg: 1 of: 1));
		<< (P4TACCall to: (P4Closure earlyClassSelectorAddress: #pNew:));
		<< (helper resultVariable moveTo: closureVariable );
		
		<< ((P4TACReference new target: closure) loadAddressIn: helper intermediateLValue );
		<< (helper intermediateLValue moveTo: (closureVariable accessAt: 0 )).
			
	i := 1.
	imports do: [ :aVariable |
		basicBlock << (aVariable moveTo: (closureVariable accessAt: i)).
		i := i + 1]

]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> visitCaptureClosure: captureClosure [
	self unroll: captureClosure.
	self loadClosureVariable: captureClosure closure.
]

{ #category : #'as yet unclassified' }
P4TACClosureInstaller >> visitMethod: method [
	super visitMethod: method.
	method remoteVariables isEmpty ifFalse: [
		self installRemotes: method  ].
	method expungeUnusedLocals. 
]
