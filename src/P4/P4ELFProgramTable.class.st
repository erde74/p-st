Class {
	#name : #P4ELFProgramTable,
	#superclass : #P4Object,
	#instVars : [
		'segments'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'as yet unclassified' }
P4ELFProgramTable class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4ELF' size + 1 to: self name size) asSymbol ]
]

{ #category : #header }
P4ELFProgramTable >> entryCount [
	^ 0
]

{ #category : #header }
P4ELFProgramTable >> entrySize: aStream [
	^ 0
]

{ #category : #header }
P4ELFProgramTable >> header: aSegment [
]

{ #category : #printing }
P4ELFProgramTable >> writeHeaderOn: aStream [
	
]
