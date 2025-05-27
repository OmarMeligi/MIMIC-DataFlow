# Age Average MapReduce Job

## Overview
This MapReduce job calculates the average age of patients from a CSV dataset using Hadoop's distributed computing framework.

## Architecture Diagram

```
┌─────────────────┐    ┌──────────────────┐    ┌───────────────────┐    ┌─────────────────┐
│   PATIENTS.csv  │───▶│   AgeMapper      │───▶│ Shuffle & Sort    │───▶│ AverageAge      │
│                 │    │                  │    │                   │    │ Reducer         │
│ John,25,Male    │    │ Extracts age     │    │ Groups by key     │    │                 │
│ Jane,30,Female  │    │ from each record │    │                   │    │ Calculates      │
│ Bob,35,Male     │    │                  │    │ age → [25,30,35]  │    │ average age     │
│ ...             │    │ Emits: (age,1)   │    │                   │    │                 │
└─────────────────┘    └──────────────────┘    └───────────────────┘    └─────────────────┘
                                │                        │                        │
                                ▼                        ▼                        ▼
                       ┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
                       │ (25, 1)         │    │ Key: "age"       │    │ Final Output:   │
                       │ (30, 1)         │    │ Values: [1,1,1,  │    │ Average Age:    │
                       │ (35, 1)         │    │         1,1,1,   │    │ 30.5 years      │
                       │ ...             │    │         ...]     │    │                 │
                       └─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Component Details

### 1. **PATIENTS.csv** (Input Data)
- **Format**: CSV file containing patient records
- **Sample Structure**:
  ```
  Name,Age,Gender
  John,25,Male
  Jane,30,Female
  Bob,35,Male
  Alice,28,Female
  ```

### 2. **AgeMapper**
- **Purpose**: Extracts age information from each patient record
- **Input**: Text lines from PATIENTS.csv
- **Processing**:
  - Parses CSV format
  - Extracts age field (column 2)
  - Validates age data
- **Output**: Key-value pairs `(key, age_value)`
  ```
  ("age", 25)
  ("age", 30)
  ("age", 35)
  ("age", 28)
  ```

### 3. **Shuffle & Sort Phase** (Hadoop Framework)
- **Purpose**: Groups all mapped values by key
- **Process**: 
  - Collects all age values with the same key
  - Sorts and organizes data for reducer
- **Result**: `("age", [25, 30, 35, 28, ...])`

### 4. **AverageAgeReducer**
- **Purpose**: Calculates the average age from all collected age values
- **Input**: Key with list of age values
- **Processing**:
  ```
  sum = 25 + 30 + 35 + 28 + ...
  count = number of patients
  average = sum / count
  ```
- **Output**: Final average age result

### 5. **AgeAverageDriver**
- **Purpose**: Orchestrates the entire MapReduce job
- **Responsibilities**:
  - Configures job parameters
  - Sets input/output paths
  - Specifies mapper and reducer classes
  - Defines input/output formats
  - Submits job to Hadoop cluster

## Data Flow Example

```
Input CSV:
┌─────────────────────────────┐
│ Name,Age,Gender             │
│ John,25,Male                │
│ Jane,30,Female              │
│ Bob,35,Male                 │
│ Alice,28,Female             │
│ Charlie,32,Male             │
└─────────────────────────────┘
              │
              ▼
Mapper Output:
┌─────────────────────────────┐
│ ("age", 25)                 │
│ ("age", 30)                 │
│ ("age", 35)                 │
│ ("age", 28)                 │
│ ("age", 32)                 │
└─────────────────────────────┘
              │
              ▼
Reducer Input:
┌─────────────────────────────┐
│ Key: "age"                  │
│ Values: [25, 30, 35, 28, 32]│
└─────────────────────────────┘
              │
              ▼
Final Output:
┌─────────────────────────────┐
│ Average Age: 30.0 years     │
└─────────────────────────────┘
```

## Key Features

- **Scalability**: Processes large patient datasets across multiple nodes
- **Fault Tolerance**: Hadoop framework handles node failures automatically  
- **Efficiency**: Parallel processing reduces computation time
- **Flexibility**: Easy to modify for other statistical calculations

## Usage

```bash
# Compile and package the job
javac -classpath $(hadoop classpath) *.java
jar cf age-average.jar *.class

# Run the MapReduce job
hadoop jar age-average.jar AgeAverageDriver input/PATIENTS.csv output/
```

## Output Format
The job produces a text file containing:
```
Average Age: [calculated_average]
```

---

*This MapReduce job demonstrates distributed processing of healthcare data for statistical analysis.*