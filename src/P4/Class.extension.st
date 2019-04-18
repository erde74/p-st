Extension { #name : #Class }

{ #category : #'*P4' }
Class >> asPClass [
	^ P4Package loadClass: self mapToPclass		
		
		
  
]

{ #category : #'*P4' }
Class >> dumpGlobalOn: binaryOut [
	^ self dumpOn: binaryOut
]

{ #category : #'*P4' }
Class >> dumpLocalOn: binaryOut [
	^ binaryOut postpone: self  
]
