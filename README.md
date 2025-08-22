# Shoe Repair and Cobbler Services Smart Contract System

A comprehensive blockchain-based system for managing shoe repair and cobbler services, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a complete solution for shoe repair businesses to manage appointments, track repair history, coordinate quality guarantees, maintain service catalogs, and educate customers about leather care and maintenance.

## System Architecture

The system consists of five interconnected smart contracts:

1. **Appointment Manager** (`appointment-manager.clar`)
    - Manages repair appointments and scheduling
    - Tracks appointment status and completion
    - Handles customer information and service requests

2. **Service Registry** (`service-registry.clar`)
    - Maintains catalog of available services
    - Manages transparent pricing structure
    - Tracks service categories and completion timelines

3. **Repair History** (`repair-history.clar`)
    - Documents complete repair history for each item
    - Tracks repair quality and customer satisfaction
    - Maintains warranty and guarantee information

4. **Quality Guarantee** (`quality-guarantee.clar`)
    - Manages quality guarantee coordination
    - Tracks guarantee claims and resolutions
    - Handles warranty periods and conditions

5. **Education Hub** (`education-hub.clar`)
    - Provides leather care and maintenance education
    - Manages educational content and resources
    - Tracks customer engagement with educational materials

## Key Features

- **Transparent Pricing**: All service costs are clearly defined and immutable
- **Quality Tracking**: Complete history of repairs and quality metrics
- **Guarantee Management**: Automated warranty tracking and claim processing
- **Educational Resources**: Comprehensive leather care guidance
- **Appointment Scheduling**: Efficient booking and status management
- **Specialty Services**: Support for custom work and specialized repairs

## Data Types

### Core Data Structures

- **Appointment**: Customer info, service type, status, pricing, timeline
- **Service**: Name, category, base price, estimated completion time
- **Repair Record**: Item details, services performed, quality score, warranty
- **Guarantee**: Terms, duration, claim status, resolution details
- **Educational Content**: Topics, difficulty level, engagement metrics

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access attempt
- `ERR-INVALID-INPUT (u101)`: Invalid input parameters
- `ERR-NOT-FOUND (u102)`: Requested item not found
- `ERR-ALREADY-EXISTS (u103)`: Item already exists
- `ERR-INVALID-STATUS (u104)`: Invalid status transition
- `ERR-EXPIRED (u105)`: Item or service has expired

## Usage

### For Cobbler Businesses

1. Register services in the Service Registry
2. Accept and manage appointments
3. Document repair work in Repair History
4. Manage quality guarantees
5. Provide educational content to customers

### For Customers

1. Browse available services and pricing
2. Schedule repair appointments
3. Track repair progress and history
4. Access quality guarantees
5. Learn about leather care and maintenance

## Testing

The system includes comprehensive test coverage using Vitest:

\`\`\`bash
npm test
\`\`\`

## Deployment

Deploy using Clarinet:

\`\`\`bash
clarinet deploy
\`\`\`

## Security Considerations

- All contracts implement proper access controls
- Input validation prevents malicious data entry
- Immutable pricing ensures transparency
- Quality guarantees are cryptographically secured
