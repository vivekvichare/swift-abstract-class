//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import AbstractClassValidatorFramework

class AbstractClassDefinitionsAggregatorTests: BaseFrameworkTests {

    func test_aggregate_withAncestors_verifyAggregatedResults() {
        let grandParentVars = [AbstractVarDefinition(name: "gV", returnType: "GV")]
        let grandParentMethods = [AbstractMethodDefinition(name: "gM1", returnType: "GM1", parameterTypes: []), AbstractMethodDefinition(name: "gM2", returnType: "GM2", parameterTypes: ["GMP1", "GMP2"])]

        let parentVars = [AbstractVarDefinition(name: "pV1", returnType: "PV1"), AbstractVarDefinition(name: "pV2", returnType: "PV2")]
        let parentMethods = [AbstractMethodDefinition(name: "gM", returnType: "GM", parameterTypes: [])]

        let childVars = [AbstractVarDefinition(name: "cV", returnType: "CV")]
        let childMethods = [AbstractMethodDefinition(name: "cM", returnType: "CM", parameterTypes: ["CMP"])]

        let definitions = [
            AbstractClassDefinition(name: "GrandParent", abstractVars: grandParentVars, abstractMethods: grandParentMethods, inheritedTypes: []),
            AbstractClassDefinition(name: "Parent", abstractVars: parentVars, abstractMethods: parentMethods, inheritedTypes: ["GrandParent"]),
            AbstractClassDefinition(name: "Child", abstractVars: childVars, abstractMethods: childMethods, inheritedTypes: ["Parent"]),
        ]

        let aggregator = AbstractClassDefinitionsAggregator()

        let results = aggregator.aggregate(abstractClassDefinitions: definitions)

        for definition in results {
            switch definition.name {
            case "Child":
                let allVars = grandParentVars + parentVars + childVars
                for v in allVars {
                    XCTAssertTrue(definition.abstractVars.contains(v))
                }
                let allMethods = grandParentMethods + parentMethods + childMethods
                for m in allMethods {
                    XCTAssertTrue(definition.abstractMethods.contains(m))
                }
            case "Parent":
                let allVars = grandParentVars + parentVars
                for v in allVars {
                    XCTAssertTrue(definition.abstractVars.contains(v))
                }
                let allMethods = grandParentMethods + parentMethods
                for m in allMethods {
                    XCTAssertTrue(definition.abstractMethods.contains(m))
                }
            case "GrandParent":
                for v in grandParentVars {
                    XCTAssertTrue(definition.abstractVars.contains(v))
                }
                for m in grandParentMethods {
                    XCTAssertTrue(definition.abstractMethods.contains(m))
                }
            default:
                XCTFail()
            }
        }
    }
}