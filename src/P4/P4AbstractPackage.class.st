Class {
	#name : #P4AbstractPackage,
	#superclass : #P4Object,
	#instVars : [
		'members'
	],
	#category : #'P4-Kernel-Package'
}

{ #category : #'pharo package loading' }
P4AbstractPackage class >> packageOfClass: aClass [
	| path |
	path := '-' split: aClass category.
	path removeFirst.
	path := path collect: #asSymbol.
	^ P4RootPackage ensurePath: path
]

{ #category : #accessing }
P4AbstractPackage >> addClass: aName [
	<preventExport>
	| reference |
	self flag: 'ne'.
	reference := members at: aName ifAbsentPut: [ |class superclass|
		class := P4PharoClass new
					name: aName.
		P4ClassReference new cls: class; package: self ].
	^ reference cls.
]

{ #category : #accessing }
P4AbstractPackage >> at: aName ifAbsent: aBlock [
	^ (members at: aName ifAbsent: [ ^ aBlock value ]) cls
]

{ #category : #iterating }
P4AbstractPackage >> classesDo: action [ 
	members do: [ :member | member classesDo: action ]
]

{ #category : #iterating }
P4AbstractPackage >> dumpGlobalOn: binaryOut [
	^ self dumpOn: binaryOut
]

{ #category : #iterating }
P4AbstractPackage >> dumpLocalOn: binaryOut [
	^ binaryOut postpone: self  
]

{ #category : #'package creation' }
P4AbstractPackage >> ensurePackage: aPackageName [
	<preventExport>
	self flag: 'ne'.
	^ members at: aPackageName ifAbsentPut: [
		P4Package new name: aPackageName; parent: self ]
]

{ #category : #accessing }
P4AbstractPackage >> flush [
	members := nil
]

{ #category : #'initialize-release' }
P4AbstractPackage >> initialize [
	<preventExport>
	self flag: 'ne'.
	members := P4IdentityDictionary new
]

{ #category : #testing }
P4AbstractPackage >> isRootPackage [
	^ false
]

{ #category : #accessing }
P4AbstractPackage >> packageAt: aSymbol [
	^ members at: aSymbol ifAbsent: [ "no such member" self halt ]
]

{ #category : #iterating }
P4AbstractPackage >> packagesDo: action [ 
	action value: self.
	members do: [ :member | member packagesDo: action ]
]

{ #category : #iterating }
P4AbstractPackage >> printOn: aStream [ 
	aStream
]
