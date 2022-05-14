//
//  LinkedList.swift
//  ScreenNavigatorKit 
//
//  Created by Ernest Babayan on 04.05.2022.
//

final class LinkedList<Element> {
    init(head: Element) {
        self.head = Node(head)
        self.tail = self.head
    }

    @dynamicMemberLookup
    final class Node {
        init(_ element: Element, previousNode: Node? = nil) {
            self.element = element
            self.previousNode = previousNode
            previousNode?.nextNode = self
        }

        let element: Element
        fileprivate(set) weak var previousNode: Node?
        fileprivate(set) var nextNode: Node?

        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Element, Value>) -> Value {
            get { element[keyPath: keyPath] }
            set { element[keyPath: keyPath] = newValue }
        }
    }

    let head: Node
    private(set) var tail: Node

    var sequence: AnySequence<Node> {
        head.nextNodesSequence
    }

    @discardableResult
    func append(_ element: Element) -> Node {
        let newNode = Node(element, previousNode: tail)
        tail = newNode

        return newNode
    }

    func remove(_ removedNode: Node) {
        guard let previousNode = removedNode.previousNode else {
            return
        }

        previousNode.nextNode = nil
        tail = previousNode
    }
}

extension LinkedList.Node {
    var nextNodesSequence: AnySequence<LinkedList.Node> {
        AnySequence { [self] () -> AnyIterator in
            var currentNode: LinkedList.Node? = self

            return AnyIterator {
                defer { currentNode = currentNode?.nextNode }
                return currentNode
            }
        }
    }

    var previousNodesSequence: AnySequence<LinkedList.Node> {
        AnySequence { [self] () -> AnyIterator in
            var currentNode: LinkedList.Node? = self

            return AnyIterator {
                defer { currentNode = currentNode?.previousNode }
                return currentNode
            }
        }
    }
}
