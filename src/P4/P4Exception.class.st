Class {
	#name : #P4Exception,
	#superclass : #P4Object,
	#instVars : [
		'environment'
	],
	#category : #'P4-Exception'
}

{ #category : #PharoIntegration }
P4Exception >> defaultAction [
	"No one has handled this error, but now give them a chance to decide
	how to debug it. If none handle this either then open debugger (see
	UnhandedError-defaultAction) "
	<preventExport>
	UnhandledError signalForException: self
]

{ #category : #PharoIntegration }
P4Exception >> description [
	<preventExport>
	"Return a textual description of the exception."
	| desc mt |
	desc := self class name asString.
	^ (mt := self messageText) == nil
		ifTrue: [desc]
		ifFalse: [desc , ': ' , mt]
]

{ #category : #PharoIntegration }
P4Exception >> messageText [
	<preventExport>
	| stream |
	stream := WriteStream on: ''.
	self warnOn: stream.
	^ stream contents
]

{ #category : #PharoIntegration }
P4Exception >> pSignal [
	<renameExport: #signal>
	'---> signalled:' print.
	self printObj.
	self pHalt.
	
	
]

{ #category : #PharoIntegration }
P4Exception >> signal [
	"Ask ContextHandlers in the sender chain to handle this signal. The
	default is to execute and return my defaultAction."
	<preventExport>
	environment := thisContext contextTag.
	^ environment nextHandlerContext handleSignal: self
]

{ #category : #PharoIntegration }
P4Exception >> signalerContext [
	<preventExport>
	^ environment
		findContextSuchThat: [:ctxt | (ctxt receiver == self
				or: [ctxt receiver == self class]) not]
]
