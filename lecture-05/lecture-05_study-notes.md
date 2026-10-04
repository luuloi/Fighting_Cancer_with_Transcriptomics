# Lecture 5: R Programming Fundamentals

### Core Syntax, Data Types & Computational Logic

> 🚀 **Interactive Google Colab Notebook:** [lecture-05_r_fundamentals_practice.ipynb](./lecture-05_r_fundamentals_practice.ipynb)  
> 💡 **Environment Setup:** For instructions on configuring R locally with Micromamba and VS Code, see [Environment_Setup.md](../Environment_Setup.md).
>
> 🤖 **How to Use AI in This Course:**  
> You are welcome to use AI as a tutor to explain confusing lines of code or clarify error messages. Please do **not** use AI to copy-paste answers to exercises. You learn to code by typing and solving problems yourself!

---

### 🎯 What You Will Learn Today

1. **Syntax & Output**: Run code, write comments (`#`), and manage working directories.
2. **Variables & `<-`**: Store values in memory using standard R naming conventions (`snake_case`).
3. **Core Data Types**: Distinguish `numeric`, `integer` (`L`), `character`, `logical`, and missing values (`NA`, `NaN`, `Inf`).
4. **Biological Math**: Apply arithmetic operators and built-in functions (`sqrt`, `round`, `log2`) to compute sequencing metrics (CPM).
5. **Strings & Escape Characters**: Handle quote nesting, format clean output with `cat()`, and master the Windows file path rule.
6. **Relational & Logical Operators**: Construct compound boolean filters (`&`, `|`, `!`) for quality control.
7. **Control Flow**: Implement decision branching (`if`, `else if`, `else`) and automated loops (`for`, `while`) with guard clauses (`next`, `break`).
8. **Hands-on Capstone**: Solve 3 real-world bioinformatics practice problems.

---

## 🧬 0. Why Do Biologists Need R?

### Why Not Just Use Microsoft Excel?

Most researchers begin analyzing data in Microsoft Excel. In spatial and single-cell transcriptomics—where tens of thousands of genes are measured across thousands of tissue spots—Excel fails:

1. **Excel Freezes and Crashes**: Excel is limited to ~1 million rows. Spatial datasets contain tens of millions of data points that crash spreadsheet software.
2. **Excel Permanently Corrupts Gene Names**: Excel automatically converts gene symbols into calendar dates (e.g., `SEPT2` becomes `2-Sep`, `MARCH1` becomes `1-Mar`). This silent error has corrupted thousands of published genomic datasets.
3. **The "Click" Problem**: Data cleaning performed via GUI menus cannot be audited, reproduced, or repeated on subsequent patient batches.

### Why R is Our Superpower

* 🚀 **High-Throughput Scale**: R processes millions of cells and transcript counts in seconds.
* 📦 **Built for Biology (Bioconductor)**: A global open-source repository of thousands of peer-reviewed packages specifically designed for genomic and spatial data (e.g., `SpatialExperiment`, `Seurat`, `Voyager`).
* 📜 **Reproducible Recipes**: Code documents every analytical step. When new patient samples arrive, the entire pipeline executes with one command.

---

## 1. Syntax, Comments & Output

### Running Code & Printing

In R, commands execute sequentially. Use `print()` to display raw values or data structures to the console:

```R
print("Welcome to Spatial Transcriptomics!")
# [1] "Welcome to Spatial Transcriptomics!"

total_spots <- 4992
print(total_spots)
# [1] 4992
```

### Writing Comments

Comments start with `#` and are ignored by R. Use them to explain *why* code was written:

```R
# Calculate total sequenced library depth
depth <- 1500000L # Whole integer read count
```

### Working Directory Management

To verify where files are read from and saved to:

* `getwd()`: Returns current working directory path.
* `setwd("path/to/folder")`: Sets a new working directory.
* `dir()`: Lists files and folders in the current working directory.

```R
getwd() # e.g., "/home/mashxp/Project"
dir()   # Lists directory contents
```

---

## 2. Variables & The Assignment Operator (`<-`)

A **variable** is a named storage container in your computer's memory. In R, assignment is performed with **`<-`**:

```R
gene_name <- "EPCAM"
spot_count <- 150
```

> **Why `<-` instead of `=`?**  
> While `=` works for assignment, R and Bioconductor standards strictly recommend **`<-`** for variable assignment, reserving `=` for passing arguments inside functions (e.g., `round(x, digits = 2)`).

### Variable Naming Rules

* ✅ **Must start with a letter** (e.g., `cell_count`).
* ✅ **Can contain** letters, numbers, underscores `_`, and dots `.`.
* 🛑 **Cannot start with a digit** (`1gene` triggers a syntax error).
* 🛑 **Cannot contain mathematical operators** (`project-id` is interpreted as `project - id`).
* 🛑 **Case-sensitive**: `gene_a`, `Gene_A`, and `GENE_A` refer to three completely different memory locations.
* 💡 **Standard**: Use **`snake_case`** (lowercase words joined by underscores) for readability.

---

## 3. Core Data Types & Values

R operates on five fundamental atomic types:

| Data Type | Description | Example | Check Function |
| :--- | :--- | :--- | :--- |
| **`numeric`** | Real numbers (decimals/doubles) | `42.5`, `10.0` | `typeof(x)` $\rightarrow$ `"double"` |
| **`integer`** | Explicit whole numbers (suffix with `L`) | `4992L`, `150L` | `typeof(x)` $\rightarrow$ `"integer"` |
| **`character`** | Text strings in quotes | `"EPCAM"`, `"Tumor"` | `typeof(x)` $\rightarrow$ `"character"` |
| **`logical`** | Boolean truth values | `TRUE`, `FALSE` | `typeof(x)` $\rightarrow$ `"logical"` |
| **`complex`** | Complex numbers with imaginary part | `3 + 2i` | `typeof(x)` $\rightarrow$ `"complex"` |

### Special Values in Bioinformatics

* **`NA` (Not Available)**: Missing or uncollected data (e.g., failed sequencing spot).
* **`NaN` (Not a Number)**: Mathematically undefined results (e.g., `0 / 0`).
* **`Inf` / `-Inf`**: Positive or negative infinity (e.g., `5 / 0`).

```R
typeof(10.5)      # "double"
typeof(150L)      # "integer"
typeof("GAPDH")   # "character"
typeof(TRUE)      # "logical"

is.na(NA)         # TRUE
is.nan(0 / 0)     # TRUE
is.infinite(5/0)  # TRUE
```

---

## 4. R Math Functions & Arithmetic Operators

### Arithmetic Operators

* `+` (Addition): `12000 + 3500`
* `-` (Subtraction): `4992 - 3820`
* `*` (Multiplication): `0.074 * 100`
* `/` (Division): `raw_reads / total_reads`
* `^` (Exponentiation): `2^10`
* `%%` (Modulo / Remainder): `10 %% 3` $\rightarrow$ `1`
* `%/%` (Integer Division): `10 %/% 3` $\rightarrow$ `3`

### Common Built-in Math Functions

* `sqrt(x)`: Square root (`sqrt(225)` $\rightarrow$ `15`).
* `round(x, digits)`: Round to specified decimal places (`round(12.678, 2)` $\rightarrow$ `12.68`).
* `floor(x)`: Round down to nearest whole integer (`floor(12.8)` $\rightarrow$ `12`).
* `ceiling(x)`: Round up to nearest whole integer (`ceiling(12.1)` $\rightarrow$ `13`).
* `log2(x)`: Log base 2, standard for fold-change calculation (`log2(8)` $\rightarrow$ `3`).

---

## 5. Strings & Escape Characters

Strings are text enclosed in single (`'...'`) or double (`"..."`) quotes.

### Quotes Inside Quotes

Enclose the string with the opposite quote type to avoid escaping errors:

```R
# Safe quote nesting
note <- 'Pathologist entered: "High EPCAM expression in tumor core"'
```

### Formatted Output with `cat()`

While `print()` displays raw strings with quotes, **`cat()`** concatenates text and interprets escape sequences:

* `\n`: Newline
* `\t`: Tab space
* `\"`: Escaped double quote

```R
cat("Marker:\t", "CD3D", "\nExpression:\t", 24.5, "\n", sep = "")
```

### 🌐 The Universal File Path Rule

**ALWAYS use forward slashes `/` in R file paths across Windows, macOS, and Linux.**  
On Windows, copying paths like `"data\visium\counts.csv"` causes R to crash because `\` is the escape character and `\v` / `\c` are invalid escape sequences.

```R
# Correct cross-platform path:
count_file <- "data/visium/counts.csv"
```

---

## 6. R Operators

### Comparison Operators (Result is always `TRUE` or `FALSE`)

| Operator | Meaning | Example | Result |
| :---: | :--- | :--- | :---: |
| `==` | Exactly equal to | `gene == "EPCAM"` | `TRUE` / `FALSE` |
| `!=` | Not equal to | `spot != "Stroma"` | `TRUE` / `FALSE` |
| `>` | Greater than | `umi > 1000` | `TRUE` / `FALSE` |
| `<` | Less than | `mito < 15.0` | `TRUE` / `FALSE` |
| `>=` | Greater than or equal to | `umi >= 500` | `TRUE` / `FALSE` |
| `<=` | Less than or equal to | `mito <= 20.0` | `TRUE` / `FALSE` |

### Logical Operators

* **`&` (AND)**: `TRUE` only if **both** sides are `TRUE`.
* **`|` (OR)**: `TRUE` if **at least one** side is `TRUE`.
* **`!` (NOT)**: Inverts truth value (`!TRUE` $\rightarrow$ `FALSE`).

```R
reads <- 1250
mito_pct <- 8.5

# Spot QC gate (both conditions required):
pass_qc <- (reads >= 500) & (mito_pct < 15.0) # TRUE & TRUE -> TRUE

# Spot flag (either anomaly triggers flag):
flag_spot <- (reads < 200) | (mito_pct > 20.0) # FALSE | FALSE -> FALSE

# Invert flag:
is_clean <- !flag_spot # TRUE
```

> **Precedence Tip:** Always enclose individual comparison expressions in parentheses `(...)` to prevent operator precedence bugs.

---

## 7. Control Flow (If...Else, Loops)

Control structures dynamically execute code blocks based on conditions.

### A. Conditional Branching (`if...else if...else`)

```R
expression_val <- 450

if (expression_val > 500) {
  cat("Tier: High Expression\n")
} else if (expression_val >= 100) {
  cat("Tier: Medium Expression\n")
} else {
  cat("Tier: Low Expression\n")
}
```

> **R Syntax Requirement:** `else` and `else if` must always be placed on the **same line** as the preceding closing brace: `} else {`.

### B. `for` Loops

Iterate sequentially through each element in a collection:

```R
marker_genes <- c("EPCAM", "CD3D", "PECAM1")

for (gene in marker_genes) {
  cat("Quantifying marker:", gene, "\n")
}
```

### C. Loop Control: `next` and `break`

* **`next`**: Skips the remainder of the current iteration and jumps directly to the next element (guard clause).
* **`break`**: Immediately aborts and terminates the entire loop.

```R
counts <- c(1200, 45, 890, -999, 1400)

for (cnt in counts) {
  # 1. Abort immediately on corrupted data
  if (cnt < 0) {
    cat("Corrupted count (", cnt, ")! Aborting loop.\n", sep = "")
    break
  }
  
  # 2. Guard clause: skip low-quality spots (< 100)
  if (cnt < 100) {
    next
  }
  
  cat("Valid spot count:", cnt, "\n")
}
```

### D. `while` Loops

Repeats a code block as long as the condition remains `TRUE`. Always increment the counter to avoid infinite loops:

```R
resolution <- 0.2
while (resolution <= 0.6) {
  cat("Clustering resolution:", resolution, "\n")
  resolution <- resolution + 0.1
}
```
