Class {
	#name : #P4TACAnalyzeRemote,
	#superclass : #P4TACPostCompiler,
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4TACAnalyzeRemote >> externalizeVariables [
	| locals remotes |
	remotes := P4TACRemoteArray new.
	locals := callable locals.
	locals do: [ :var | 
		var shouldBeRemote ifTrue: [
			var remote: (remotes add: var).
			var firstAssign isNil ifFalse: [
				remotes assignedAt: var firstAssign.].
			remotes usedAt: var lastUse ]].
	
	callable remoteVariables: remotes.
	
	remotes isEmpty ifFalse: [
		remotes do: [ :remote | locals removeKey: remote name ].
		locals at: remotes name put: remotes. ].
]

{ #category : #'as yet unclassified' }
P4TACAnalyzeRemote >> process: statement [
	statement acceptCaptureClosure: self
]

{ #category : #'as yet unclassified' }
P4TACAnalyzeRemote >> visitCallable: aCallable [
	" first find which variables should be remote "
	super visitCallable: aCallable.
	" then make them remote "
	self externalizeVariables.
    
]

{ #category : #'as yet unclassified' }
P4TACAnalyzeRemote >> visitCaptureClosure: captureClosure [
	(captureClosure closure imports select: 
		[ :variable |	variable shouldBeRemote not ])   
			do: [ :variable |
				(variable lastAssign > captureClosure flowNumber) ifTrue: [
					variable beRemote ]]
]
