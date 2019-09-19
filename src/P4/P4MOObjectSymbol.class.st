Class {
	#name : #P4MOObjectSymbol,
	#superclass : #P4MOSymbol,
	#category : #'P4-Exec-MachO'
}

{ #category : #'as yet unclassified' }
P4MOObjectSymbol >> description [
	"REFERENCE_FLAG_DEFINED (0x2)"
	^ 16r2
]

{ #category : #'as yet unclassified' }
P4MOObjectSymbol >> type [
	"N_SECT (0xe)—The symbol is defined in the section number given in n_sect."
	^ 16rE
]
