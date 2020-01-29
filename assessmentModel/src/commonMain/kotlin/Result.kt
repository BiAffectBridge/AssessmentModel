package org.sagebionetworks.assessmentmodel

import kotlinx.serialization.Serializable

/**
 * A [Result] is any data result that should be included with an [Assessment]. The base level interface only has an
 * [identifier] and does not include any other properties. The [identifier] in this case may be either the
 * [ResultMapElement.resultIdentifier] *or* the [ResultMapElement.identifier] if the result identifier is undefined.
 *
 * TODO: syoung 01/10/2020 figure out a clean-ish way to encode the result and include in the base interface. In Swift, the `RSDResult` conforms to the `Encodable` protocol so it can be encoded to a JSON dictionary. Is there a Kotlin equivalent?
 *
 */
interface Result {

    /**
     * The identifier for the result. This identifier maps to the [ResultMapElement.resultIdentifier] for an associated
     * [Assessment] element.
     */
    val identifier: String
}

/**
 * A [CollectionResult] is used to describe the output of a [Section], [Form], [Task], or [Assessment].
 */
interface CollectionResult : Result {

    /**
     * The [pathHistoryResults] includes the history of the [Node] results that were traversed as a part of running an
     * [Assessment]. This will only include a subset that is the path defined at this level of the overall [Assessment]
     * hierarchy.
     */
    var pathHistoryResults: MutableList<Result>

    /**
     * The [asyncActionResults] is a set that contains results that are recorded in parallel to the user-facing node
     * path.
     */
    var asyncActionResults: MutableSet<Result>
}

/**
 * A [TaskResult] is the top-level [Result] for an [Task].
 */
interface TaskResult : CollectionResult {

    /**
     * A unique identifier for this task run. This property is defined as readwrite to allow the controller for the
     * task to set this on the [TaskResult] children included in this task run.
     */
    var taskRunUUIDString: String
}

/**
 * An [AssessmentResult] is the top-level [Result] for an [Assessment].
 */
interface AssessmentResult : TaskResult {

    /**
     * The [versionString] may be a semantic version, timestamp, or sequential revision integer. This should map to the
     * [Assessment.versionString].
     */
    val versionString: String?

    /**
     * The start date timestamp for the result.
     */
    var startDateString: String

    /**
     * The end date timestamp for the result.
     */
    var endDateString: String
}