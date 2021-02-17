!classDefinition: #BillingSystemTest category: 'Ejercicio-Mercap-v2'!
TestCase subclass: #BillingSystemTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!BillingSystemTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 17:21:37'!
test01_BillingSystemWithNoCallsHandsBillOnlyWithBasePayement
	| testBillingSystem basePayement testBill |
	basePayement := 10.
	testBillingSystem := BillingSystem withBaseOf: basePayement.
	testBill := testBillingSystem billFor: #January.
	self assert: ((testBill at: #BasePayement) = 10).
	self assert: ((testBill at: #LocalCalls) = 0).
	self assert: ((testBill at: #OtherCalls) = 0).! !

!BillingSystemTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 17:29:35'!
test02_BillingJanuaryWithOneJanuaryCall
	| testBillingSystem basePayement testBill end start testCall |
	basePayement := 10.
	testBillingSystem := BillingSystem withBaseOf: basePayement.
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	testBillingSystem registerCall: testCall.
	testBill := testBillingSystem billFor: #January.
	
	self assert: ((testBill at: #BasePayement) = 10).
	self assert: ((testBill at: #LocalCalls) = testCall cost).
	self assert: ((testBill at: #OtherCalls) = 0).! !

!BillingSystemTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 17:40:23'!
test03_BillingJanuaryWithOneFebruaryCall
	| testBillingSystem basePayement testBill end start testCall |
	basePayement := 10.
	testBillingSystem := BillingSystem withBaseOf: basePayement.
	start := DateAndTime year: 2020 day: 40 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	testBillingSystem registerCall: testCall.
	testBill := testBillingSystem billFor: #January.
	
	self assert: ((testBill at: #BasePayement) = 10).
	self assert: ((testBill at: #LocalCalls) = 0).
	self assert: ((testBill at: #OtherCalls) = 0).! !


!classDefinition: #CallTest category: 'Ejercicio-Mercap-v2'!
TestCase subclass: #CallTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 12:18:27'!
test01_10MinuteCallLasts10Minutes
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall lastsMinutes: 10).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 12:30:17'!
test02_CanNotCreateCallThatStartsAfterItEnds
	| end start |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	self 
		should: [Call from: end to: start.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | self assert: anError messageText = Call invalidDateAndTimeErrorMessage.]! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 12:33:10'!
test03_10MinuteCallBetween8And20OnBusinessDayCosts2
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 12 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 2).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 12:38:10'!
test04_10MinuteCallBetween20And8OnBusinessDayCosts1
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 1).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 13:58:35'!
test05_10MinuteCallAcrossMidnightOnBusinessDaysCosts1
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 23 minute: 55 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 1).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 16:05:42'!
test06_10MinuteCallBetween8And20OnNonBusinessDaysCosts1
	| end start testCall |
	start := DateAndTime year: 2020 day: 4 hour: 12 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 1).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 16:43:41'!
test07_CallBetween19SaturdayAnd1SundayDaysCosts36
	| end start testCall |
	start := DateAndTime year: 2020 day: 4 hour: 19 minute: 0 second: 0.
	end := start + (Duration hours: 6).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 36).! !


!classDefinition: #BillingSystem category: 'Ejercicio-Mercap-v2'!
Object subclass: #BillingSystem
	instanceVariableNames: 'calls basePayement eight twenty midnight eightToTwentyCost costList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:52:47'!
billFor: monthName
	| bill |
	bill := Dictionary new.
	bill add: #BasePayement-> basePayement.
	bill add: #LocalCalls-> 0.
	bill add: #OtherCalls-> 0.
	(calls select: [:call | call belongsTo: monthName]) do: [ :call | 
		(call isKindOf: LocalCall) ifTrue: [bill at: #LocalCalls put: ((bill at: #LocalCalls) + call costFor: self)].
		(call isKindOf: NotLocalCall ) ifTrue: [bill at: #OtherCalls put: ((bill at: #OtherCalls) + call costFor: self)]
		 ].
	bill add: #Total-> ((bill at: #LocalCalls) + (bill at: #OtherCalls)).
	^bill! !

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:41:04'!
costAsNotLocalCall: aCall withDestination: aDestination
		
	^aCall totalMinutes * (costList at: aDestination).! !

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:57:06'!
costAsNotThroughMidnightCall: aCall
		
	(aCall startsOnWeekend) ifTrue: [ ^aCall totalMinutes * 0.1 ].
		
	(aCall startsBefore: eight) ifTrue: [
		(aCall endsBefore: eight) ifTrue: [ 	^aCall totalMinutes * 0.1 ].
		(aCall endsBefore: twenty) ifTrue: [ ^((aCall minutesBefore: eight) * 0.1) + ((aCall minutesAfter: eight) * 0.2) ].
		^((aCall minutesBefore: eight) * 0.1) + eightToTwentyCost + ((aCall minutesAfter: twenty) * 0.1).
		].
	(aCall startsBefore: twenty) ifTrue: [
		(aCall endsBefore: eight) ifTrue: [ 	^aCall totalMinutes * 0.2 ].
		^((aCall minutesBefore: twenty) * 0.2) + ((aCall minutesAfter: twenty) * 0.1).
		].
	^aCall totalMinutes * 0.1! !

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:59:12'!
costAsThroughMidnightCall: aCall
	| midnightToEightCost eightToMidnightCost midnightToTwentyCost firstDayCost lastDayCost twentyToMidnightCost |
	twentyToMidnightCost := 4 * 60 * 0.1.
	midnightToEightCost := twentyToMidnightCost.
	eightToMidnightCost := eightToTwentyCost + twentyToMidnightCost.
	midnightToTwentyCost := midnightToEightCost + eightToTwentyCost.
	firstDayCost := 0.
	lastDayCost := 0.
	
	aCall startsOnWeekend 
		ifTrue: [ firstDayCost := (aCall minutesBefore: midnight) * 0.1 ]
		ifFalse: [
			(aCall startsBefore: eight)
			ifTrue: [ firstDayCost := (aCall minutesBefore: eight * 0.1) + eightToMidnightCost ]
			ifFalse: [
				(aCall startsBefore: twenty)
				ifTrue: [ firstDayCost := ((aCall minutesBefore: twenty) * 0.2) + twentyToMidnightCost ]
				ifFalse: [ firstDayCost := aCall minutesBefore: midnight * 0.1 ].
				].
			].
	
	(aCall endsOnWeekend or: [ (aCall endsBefore: eight) ])
		ifTrue: [ lastDayCost := (aCall minutesAfter: midnight) * 0.1 ]
		ifFalse: [
			(aCall endsBefore: twenty)
			ifTrue: [ lastDayCost := midnightToEightCost + ((aCall minutesAfter: eight) * 0.2) ]
			ifFalse: [ lastDayCost := midnightToTwentyCost + ((aCall minutesAfter: twenty) * 0.1) ].
			].
	
	^firstDayCost + lastDayCost! !

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 21:06:43'!
registerCall: aCall
	(aCall destinationIsIn: costList keys) ifFalse: [ self error: self class callDestinationNotInCostListErrorMessage ].
	calls addLast: aCall.! !

!BillingSystem methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:41:46'!
withBaseOf: base andListing: costsList
	costList := costsList.
	basePayement := base.
	calls := OrderedCollection new.
	eight := Time afterMidnight: (Duration hours: 8).
	twenty := Time afterMidnight: (Duration hours: 20).
	midnight := Time midnight.
	eightToTwentyCost := 12 * 60 * 0.2.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BillingSystem class' category: 'Ejercicio-Mercap-v2'!
BillingSystem class
	instanceVariableNames: ''!

!BillingSystem class methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 21:07:54'!
callDestinationNotInCostListErrorMessage
	^'Call destination is not in the system costs list!!'! !

!BillingSystem class methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:42:17'!
withBaseOf: base andListing: costsList
	^BillingSystem new withBaseOf: base andListing: costsList.! !


!classDefinition: #Call category: 'Ejercicio-Mercap-v2'!
Object subclass: #Call
	instanceVariableNames: 'startingDate startingTime endingDate endingTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 17:43:01'!
belongsTo: monthName
	^endingDate monthName = monthName .! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 17:49:22'!
costFor: aBillingSystem
	self subclassResponsibility ! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:12:31'!
endsBefore: aTime
	^endingTime < aTime! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:52:02'!
endsOnWeekend
	^(#(#Saturday #Sunday)) includes: endingDate dayOfWeekName! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:53:05'!
from: startingDateTime to: endingDateTime
	startingDate := startingDateTime date.
	startingTime := startingDateTime time.
	endingDate := endingDateTime date.
	endingTime := endingDateTime time.! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 18:03:55'!
lastsMinutes: anAmountOfMinutes
	^ anAmountOfMinutes = self totalMinutes! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:14:01'!
minutesAfter: aTime
	^(endingTime - aTime) totalMinutes! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:52:56'!
minutesBefore: aTime
	aTime = Time midnight ifTrue: [ ^((Duration hours: 24) + (aTime - startingTime)) totalMinutes ].
	^(aTime - startingTime) totalMinutes! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:18:22'!
startsBefore: aTime
	^startingTime < aTime! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 19:52:11'!
startsOnWeekend
	^(#(#Saturday #Sunday)) includes: startingDate dayOfWeekName! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 18:03:42'!
totalMinutes
	| endingDateTime startingDateTime |
	startingDateTime := DateAndTime date: startingDate time: startingTime.
	endingDateTime := DateAndTime date: endingDate time: endingTime.
	^(endingDateTime - startingDateTime) totalMinutes! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: 'Ejercicio-Mercap-v2'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:56:13'!
from: start to: end
	self validateDateTime: start with: end.
	start date < end date ifTrue: [ ^ThroughMidnightCall new from: start to: end ].
	^NotThroughMidnightCall new from: start to: end.! !

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:56:09'!
from: start to: end withDestination: aDestination
	self validateDateTime: start with: end.
	^NotLocalCall new from: start to: end withDestination: aDestination.! !

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/12/2021 12:30:35'!
invalidDateAndTimeErrorMessage
	^'Starting and/or ending date and times are invalid'! !

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:55:54'!
validateDateTime: start with: end
	start > end ifTrue: [self error: self invalidDateAndTimeErrorMessage].! !


!classDefinition: #LocalCall category: 'Ejercicio-Mercap-v2'!
Call subclass: #LocalCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!LocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 17:49:31'!
costFor: aBillingSystem
	self subclassResponsibility ! !


!classDefinition: #NotThroughMidnightCall category: 'Ejercicio-Mercap-v2'!
LocalCall subclass: #NotThroughMidnightCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!NotThroughMidnightCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 18:35:08'!
costFor: aBillingSystem
	^aBillingSystem costAsNotThroughMidnightCall: self! !


!classDefinition: #ThroughMidnightCall category: 'Ejercicio-Mercap-v2'!
LocalCall subclass: #ThroughMidnightCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!ThroughMidnightCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 18:35:27'!
costFor: aBillingSystem
	^aBillingSystem costAsThroughMidnightCall: self! !


!classDefinition: #NotLocalCall category: 'Ejercicio-Mercap-v2'!
Call subclass: #NotLocalCall
	instanceVariableNames: 'destination'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap-v2'!

!NotLocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:34:20'!
costFor: aBillingSystem
	^aBillingSystem costAsNotLocalCall: self withDestination: destination.! !

!NotLocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 21:09:13'!
destinationIsIn: aDestinationsSet
	^aDestinationsSet includes: destination.! !

!NotLocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/16/2021 20:32:07'!
from: startingDateTime to: endingDateTime withDestination: aDestination
	startingDate := startingDateTime date.
	startingTime := startingDateTime time.
	endingDate := endingDateTime date.
	endingTime := endingDateTime time.
	destination := aDestination.! !
