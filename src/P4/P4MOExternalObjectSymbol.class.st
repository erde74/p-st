Class {
	#name : #P4MOExternalObjectSymbol,
	#superclass : #P4MOSymbol,
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOExternalObjectSymbol >> description [
	"REFERENCE_FLAG_UNDEFINED_NON_LAZY (0x0)—This symbol is a reference to an external non-lazy (data) symbol."
	^ 16r0
]

{ #category : #'as yet unclassified' }
P4MOExternalObjectSymbol >> type [
	"N_UNDF (0x0)—The symbol is undefined. Undefined symbols are symbols referenced in this module but defined in a different module. Set the n_sect field to NO_SECT."
	^ 16r0
]
