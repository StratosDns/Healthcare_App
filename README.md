# askisi1 by Efstratios Demertzoglou | TH20580



## Detailed Component Descriptions

### 1. Models (`/models`)
Represents the data structures for different medical records:
- User information
- Demographics
- Allergies
- Immunizations
- Medications
- Problem List
- Medical Procedures

**Key Responsibilities:**
- Define data structure for each medical record type
- Provide methods for data parsing
- Encapsulate data-related logic

### 2. Providers (`/providers`)
Manages the state of the application using the Provider package:
- Fetch data from services
- Manage loading and error states
- Notify widgets about data changes
- Provide data to widgets

### 3. Services (`/services`)
Responsible for data retrieval and API interactions:
- Communicate with backend or mock data sources
- Handle network requests
- Transform raw data into model objects

### 4. Screens (`/screens`)
Represent individual pages or views in the application:
- Define page layout
- Fetch and display data
- Handle user interactions
- Manage screen-specific UI logic

### 5. Widgets (`/widgets`)
Reusable UI components:
- Base screen template
- User information card
- Dashboard item tiles

### 6. Utils (`/utils`)
Utility files with constants and enums:
- App-wide constants
- Menu item definitions

## Technical Details

### State Management
- Uses Provider for state management
- Follows unidirectional data flow
- Separates concerns between UI, data management, and data sources

### Design Patterns
- Model-View-ViewModel (MVVM) inspired architecture
- Dependency injection through providers
- Separation of concerns

## Color Scheme
- Primary Color: #10c9b7 (Teal)
- Accent colors used for various UI elements

## Getting Started



### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/health-dashboard.git