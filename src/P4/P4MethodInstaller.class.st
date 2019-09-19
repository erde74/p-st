Class {
	#name : #P4MethodInstaller,
	#superclass : #P4Object,
	#instVars : [
		'compiler'
	],
	#category : #'P4-SystemInstaller'
}

{ #category : #accessing }
P4MethodInstaller >> processor: aProcessor [
	compiler := self newCompiler.
	aProcessor installer: self.
	compiler processor: aProcessor.
]
