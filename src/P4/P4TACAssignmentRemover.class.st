Class {
	#name : #P4TACAssignmentRemover,
	#superclass : #P4TACPostCompiler,
	#category : #'P4-TAC'
}

{ #category : #visiting }
P4TACAssignmentRemover >> visitBasicBlock: aBasicBlock [
	aBasicBlock isEmpty ifTrue: [ ^ self ].
	
	aBasicBlock do: [ :instr |
		( instr isAssignment and: [ instr origin asAsm == instr target asAsm ] ) 
			ifTrue: [ aBasicBlock remove: instr ]].
]
