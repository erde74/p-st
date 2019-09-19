Class {
	#name : #P4Package,
	#superclass : #P4AbstractPackage,
	#instVars : [
		'parent',
		'name'
	],
	#category : #'P4-Kernel-Package'
}

{ #category : #'instance creation' }
P4Package class >> byPathName: aName [
	| segments |
	segments := ('.' split: aName) collect: #asSymbol.
	^ P4RootPackage resolve: segments
	
]

{ #category : #'pharo package loading' }
P4Package class >> loadClass: aClass [
	| package |
	aClass ifNil: [ ^ nil ].
	package := self packageOfClass: aClass.
	^ package at: aClass pname ifAbsent: [
		(package addClass: aClass pname)   
			superclass: (P4Package loadClass: aClass p4super);
			inPharo: aClass;
			metaclass: aClass p4class]
]

{ #category : #'pharo package loading' }
P4Package class >> loadClasses [
	P4RootPackage flushPackages.
]

{ #category : #'pharo package loading' }
P4Package class >> packageOfClass: aClass [
	| path |
	path := '-' split: aClass instanceSide category.
	path removeFirst.
	path := path collect: #asSymbol.
	^ P4RootPackage ensurePath: path
]

{ #category : #filesystem }
P4Package >> ensureDirectory [
	<preventExport>
	| parentDir |
	parentDir := parent ensureDirectory.
"	(parentDir directoryExists: name) ifFalse: [ parentDir createDirectory: name ]."
	(parentDir / name) ensureCreateDirectory.
	^ parentDir / name.
	
]

{ #category : #accessing }
P4Package >> name [
	^ name

]

{ #category : #accessing }
P4Package >> name: anObject [
	name := anObject
]

{ #category : #exporting }
P4Package >> pExportedName [
	^ (parent relativeNameFor: self name) asSymbol
]

{ #category : #accessing }
P4Package >> parent [
	^ parent
]

{ #category : #accessing }
P4Package >> parent: anObject [
	parent := anObject
]

{ #category : #iterating }
P4Package >> printOn: aStream [ 
	self printOn: aStream separatedBy: '.'  
]

{ #category : #filesystem }
P4Package >> printOn: aStream separatedBy: separator [
	parent isRootPackage ifFalse: [
		parent printOn: aStream separatedBy: separator.
		aStream << separator ].
	aStream << name
]

{ #category : #filesystem }
P4Package >> relativeNameFor: aName [
	^ self relativeNameFor: aName separatedBy: '_'
]

{ #category : #filesystem }
P4Package >> relativeNameFor: aName separatedBy: separator [
	<preventExport>
	| aStream |
	aStream := WriteStream on: (String new: 32).
	self printOn: aStream separatedBy: separator.
	aStream << separator << aName.
	^ aStream contents
]

{ #category : #filesystem }
P4Package >> relativePathNameFor: aName [
	^ self relativeNameFor: aName separatedBy: '/'
]
