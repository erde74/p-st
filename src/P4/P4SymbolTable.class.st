Class {
	#name : #P4SymbolTable,
	#superclass : #P4Set,
	#category : #'P4-Kernel-String'
}

{ #category : #exporting }
P4SymbolTable >> dumpGlobalOn: binaryOut [
	^  self dumpOn: binaryOut  
]

{ #category : #exporting }
P4SymbolTable >> pExportedName [ 
	^ #symboltable
]
