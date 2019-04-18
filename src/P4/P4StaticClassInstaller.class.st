Class {
	#name : #P4StaticClassInstaller,
	#superclass : #P4ClassInstaller,
	#instVars : [
		'dumper'
	],
	#category : #'P4-SystemInstaller'
}

{ #category : #accessing }
P4StaticClassInstaller >> compileClass: compiledClass [
	self flag: 'clean up pathOfClass stuff'.
	
	compiledClass inPharo methodDictionary do: [ :aMethod | 
		methodInstaller installMethod: aMethod on: compiledClass ].
	compiledClass pclass inPharo methodDictionary do: [ :aMethod | 
		methodInstaller installMethod: aMethod on: compiledClass pclass ].
	
	dumper 
		dump: compiledClass; 
		dump: compiledClass theBehavior;
		dump: compiledClass pclass; 
		dump: compiledClass pclass theBehavior;
		into: (self pathOfClass: compiledClass inPharo).
]

{ #category : #accessing }
P4StaticClassInstaller >> compileClasses: classes [
	|toDump|
	P4RootPackage flushPackages.
	dumper dumpCoreObjects.

	dumper addPharoClasses: classes.
	dumper addPharoClasses:
	{
		P4SymbolTable.
		P4Symbol.
		P4RootPackage.
		P4Package.
		P4ClassReference.
		P4MethodDictionary.
		P4Method.
		P4Metaclass.
		P4True.
		P4False.
		P4UndefinedObject.
		P4SmallInteger.
		P4Closure.
		P4SetBucket.
		P4SmalltalkBehavior.
		P4String.
		P4Array.
		P4RemoteArray.
		P4DoesNotUnderstand.
		P4Object.
	}.

	[ dumper todo isEmpty ] whileFalse: [
		toDump := dumper todo removeFirst.
		self compileClass: toDump ].
	
	dumper dumpPackages.
	dumper dumpSymbolTable.
]

{ #category : #accessing }
P4StaticClassInstaller >> initialize [ 
	super initialize.
	methodInstaller := P4StaticMethodInstaller new.
]

{ #category : #accessing }
P4StaticClassInstaller >> loadClass: aClass [
	<preventExport>
	^ P4Package loadClass: aClass
]

{ #category : #accessing }
P4StaticClassInstaller >> pathOfClass: aClass [
	<preventExport>
	| package |
	package := P4Package packageOfClass: aClass.
	package ensureDirectory.
	^ package relativePathNameFor: aClass pname
]

{ #category : #accessing }
P4StaticClassInstaller >> processor: aProcessor os: anOs [
	dumper := P4BinaryOut new processor: aProcessor os: anOs.
	methodInstaller processor: aProcessor.
]
