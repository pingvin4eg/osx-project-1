//
//  Cell+mutator.m
//  DNA project
//
//  Created by Sergey Starukhin on 02.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Cell+mutator.h"
#import "NSSet+Randomizer.h"

@interface Cell ()

@property (nonatomic, strong) NSMutableArray *dna;

+ (NSSet *)possibleElements;

+ (NSArray *)shuffledArray;

@end

@implementation Cell (mutator)

+ (NSArray *)shuffledArray {
    static NSMutableArray *indexes;
    if (!indexes) {
        indexes = [NSMutableArray arrayWithCapacity:kLengthOfDNA];
	for (int i = 0; i < kLengthOfDNA; i++) [indexes addObject:[NSNumber numberWithInt:i]];
    }
    // shuffle
    for (int i = kLengthOfDNA; i; i--) {
        int j = rand() % i;
	id tmp = [indexes objectAtIndex:i];
	[indexes replaceObjectAtIndex:i withObject:[indexes objectAtIndex:j]];
	[indexes replaceObjectAtIndex:j withObject:tmp];
    }
    return indexes;
}

- (void)mutate:(int)percent {
    if (percent >= 0 && percent <= 100) {
        //NSNumber *randomNumber;
        //NSMutableSet *alreadyMutatedElements = [[NSMutableSet alloc] init];  // множество для хранения индексов мутированных элементов (чтобы не повторяться)
	NSRange elementsForMutation;
	elementsForMutation.location = 0;
        elementsForMutation.length = percent * kLengthOfDNA / 100; // вычисляем количество элементов для мутации
	NSArray *indexesForMutation = [[Cell shuffledArray] subarrayWithRange:elementsForMutation];
	for (NSNumber *index in indexesForMutation) {
        //while (alreadyMutatedElements.count < numberOfElementsForMutation) {
            // генерация случайного числа с проверкой на уникальность
            //do {
                //randomNumber = [NSNumber numberWithInt:(rand() % kLengthOfDNA)];
            //} while ([alreadyMutatedElements containsObject:randomNumber]);
            NSMutableSet *dnaComponents = [[Cell possibleElements] mutableCopy]; // локальная изменяемая копия множества элементов ДНК
            [dnaComponents removeObject:[self.dna objectAtIndex:index.intValue]]; //удаляем текущий элемент из локального множества
            [self.dna replaceObjectAtIndex:index.intValue withObject:[dnaComponents randomObject]]; // заменяем текущий элемент ДНК случайным элементом локального множества
            //[alreadyMutatedElements addObject:randomNumber];
        }
    } else {
        NSLog(@"Alarm! Mutation of DNA 146%%");
    }
}

@end
