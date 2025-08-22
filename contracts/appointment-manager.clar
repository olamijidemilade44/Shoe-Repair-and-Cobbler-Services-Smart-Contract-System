;; Appointment Manager Contract
;; Manages repair appointments and service documentation

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))
(define-constant ERR-INVALID-STATUS (err u104))

;; Data Variables
(define-data-var next-appointment-id uint u1)

;; Data Maps
(define-map appointments
  { appointment-id: uint }
  {
    customer: principal,
    customer-name: (string-ascii 50),
    customer-phone: (string-ascii 20),
    service-type: (string-ascii 30),
    item-description: (string-ascii 100),
    status: (string-ascii 20),
    scheduled-date: uint,
    completion-date: (optional uint),
    estimated-price: uint,
    final-price: (optional uint),
    special-instructions: (string-ascii 200),
    created-at: uint
  }
)

(define-map customer-appointments
  { customer: principal }
  { appointment-ids: (list 50 uint) }
)

;; Read-only functions
(define-read-only (get-appointment (appointment-id uint))
  (map-get? appointments { appointment-id: appointment-id })
)

(define-read-only (get-customer-appointments (customer principal))
  (default-to
    { appointment-ids: (list) }
    (map-get? customer-appointments { customer: customer })
  )
)

(define-read-only (get-next-appointment-id)
  (var-get next-appointment-id)
)

;; Public functions
(define-public (create-appointment
  (customer-name (string-ascii 50))
  (customer-phone (string-ascii 20))
  (service-type (string-ascii 30))
  (item-description (string-ascii 100))
  (scheduled-date uint)
  (estimated-price uint)
  (special-instructions (string-ascii 200))
)
  (let
    (
      (appointment-id (var-get next-appointment-id))
      (customer tx-sender)
    )
    ;; Input validation
    (asserts! (> (len customer-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len service-type) u0) ERR-INVALID-INPUT)
    (asserts! (> scheduled-date block-height) ERR-INVALID-INPUT)
    (asserts! (> estimated-price u0) ERR-INVALID-INPUT)

    ;; Create appointment
    (map-set appointments
      { appointment-id: appointment-id }
      {
        customer: customer,
        customer-name: customer-name,
        customer-phone: customer-phone,
        service-type: service-type,
        item-description: item-description,
        status: "scheduled",
        scheduled-date: scheduled-date,
        completion-date: none,
        estimated-price: estimated-price,
        final-price: none,
        special-instructions: special-instructions,
        created-at: block-height
      }
    )

    ;; Update customer appointments list
    (let
      (
        (current-appointments (get appointment-ids (get-customer-appointments customer)))
        (updated-appointments (unwrap! (as-max-len? (append current-appointments appointment-id) u50) ERR-INVALID-INPUT))
      )
      (map-set customer-appointments
        { customer: customer }
        { appointment-ids: updated-appointments }
      )
    )

    ;; Increment appointment ID
    (var-set next-appointment-id (+ appointment-id u1))

    (ok appointment-id)
  )
)

(define-public (update-appointment-status
  (appointment-id uint)
  (new-status (string-ascii 20))
)
  (let
    (
      (appointment (unwrap! (get-appointment appointment-id) ERR-NOT-FOUND))
    )
    ;; Only contract owner or customer can update
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) (is-eq tx-sender (get customer appointment))) ERR-NOT-AUTHORIZED)

    ;; Validate status
    (asserts! (or
      (is-eq new-status "scheduled")
      (is-eq new-status "in-progress")
      (is-eq new-status "completed")
      (is-eq new-status "cancelled")
    ) ERR-INVALID-INPUT)

    ;; Update appointment
    (map-set appointments
      { appointment-id: appointment-id }
      (merge appointment { status: new-status })
    )

    (ok true)
  )
)

(define-public (complete-appointment
  (appointment-id uint)
  (final-price uint)
)
  (let
    (
      (appointment (unwrap! (get-appointment appointment-id) ERR-NOT-FOUND))
    )
    ;; Only contract owner can complete appointments
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    ;; Validate final price
    (asserts! (> final-price u0) ERR-INVALID-INPUT)

    ;; Update appointment
    (map-set appointments
      { appointment-id: appointment-id }
      (merge appointment {
        status: "completed",
        completion-date: (some block-height),
        final-price: (some final-price)
      })
    )

    (ok true)
  )
)
