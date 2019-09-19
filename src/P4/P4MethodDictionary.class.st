Class {
	#name : #P4MethodDictionary,
	#superclass : #P4IdentityDictionary,
	#category : #'P4-Kernel-Behavior'
}

{ #category : #statictyping }
P4MethodDictionary class >> pExportedName [ 
	^ self == P4MethodDictionary
		ifTrue: [ #MethodDictionary ]
		ifFalse: [ super pExportedName ]
]

{ #category : #statictyping }
P4MethodDictionary class >> typeHints [ 
	<preventExport>
	^ super typeHints addAll:
	{
		#self-> #'Kernel.Behavior.MethodDictionary'
	} asDictionary
]

{ #category : #'as yet unclassified' }
P4MethodDictionary >> at: key [
	<groundTypes>
	^ self at: key ifAbsent: nil
]
