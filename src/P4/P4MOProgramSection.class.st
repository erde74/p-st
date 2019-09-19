Class {
	#name : #P4MOProgramSection,
	#superclass : #P4MOSectionWithData,
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOProgramSection >> attributes [
	"S_ATTR_PURE_INSTRUCTIONS   0x80000000	/* section contains only true machine instructions */
	 S_ATTR_SOME_INSTRUCTIONS 0x00000400	/* section contains some machine instructions */"
	^ 16r80000000 bitOr: 16r00000400
]

{ #category : #'as yet unclassified' }
P4MOProgramSection >> reserved1 [
	^ 0
]

{ #category : #'as yet unclassified' }
P4MOProgramSection >> reserved2 [
	^ 0
]

{ #category : #'as yet unclassified' }
P4MOProgramSection >> reserved3 [
	^ 0
]

{ #category : #'as yet unclassified' }
P4MOProgramSection >> type [
	"S_REGULAR"
	^ 16r00
]

{ #category : #'as yet unclassified' }
P4MOProgramSection >> virtualMemorySize [
	^ data size
]
