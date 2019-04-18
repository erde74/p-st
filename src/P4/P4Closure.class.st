Class {
	#name : #P4Closure,
	#superclass : #P4Callable,
	#type : #variable,
	#instVars : [
		'outerScope'
	],
	#category : #'P4-Kernel-Callable'
}

{ #category : #'as yet unclassified' }
P4Closure class >> pNew: size [
	<globalName:#closureNew>
	<preventExport>
	"not really a primitive since the receiver is not passed, only the untagged size..."
]

{ #category : #'as yet unclassified' }
P4Closure >> return [
	<globalName: #closureReturn>
	<preventExport>
]
