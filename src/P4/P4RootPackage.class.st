Class {
	#name : #P4RootPackage,
	#superclass : #P4AbstractPackage,
	#classInstVars : [
		'instance'
	],
	#category : #'P4-Kernel-Package'
}

{ #category : #'instance creation' }
P4RootPackage class >> ensurePath: aPath [
	| current |
	current := self instance.
	[ aPath isEmpty ] whileFalse: [ 
		current := current ensurePackage: aPath removeFirst ].
	^ current 
]

{ #category : #'pharo class loading' }
P4RootPackage class >> flushPackages [
	instance ifNotNil: [ instance classesDo: #flush ].
	instance := nil
]

{ #category : #'instance creation' }
P4RootPackage class >> instance [
	^ instance ifNil: [ instance := self new ]
]

{ #category : #'instance creation' }
P4RootPackage class >> resolve: aPath [
	| current |
	current := self instance.
	[ aPath isEmpty ] whileFalse: [ 
		current := current packageAt: aPath removeFirst ].
	^ current cls
]

{ #category : #filesystem }
P4RootPackage >> ensureDirectory [
	<preventExport>
	^ FileSystem disk workingDirectory

]

{ #category : #testing }
P4RootPackage >> isRootPackage [
	^ true
]

{ #category : #filesystem }
P4RootPackage >> printOn: aStream separatedBy: separator [
]

{ #category : #filesystem }
P4RootPackage >> relativeNameFor: aName [
	^ aName  
]
