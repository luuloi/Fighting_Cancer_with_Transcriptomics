# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026
## BÀI 05: NỀN TẢNG LẬP TRÌNH R (R PROGRAMMING FUNDAMENTALS) – CÚ PHÁP, KIỂU DỮ LIỆU & LOGIC TÍNH TOÁN

> 🚀 **Notebook tương tác trên Google Colab:** [lecture-05_r_fundamentals_practice.ipynb](./lecture-05_r_fundamentals_practice.ipynb)  
> 💡 **Thiết lập môi trường:** Hướng dẫn cài đặt R cục bộ với Micromamba và VS Code, xem tại [Environment_Setup.md](../Environment_Setup.md).
>
> 🤖 **Cách sử dụng AI trong khóa học này:**  
> Bạn hoàn toàn có thể dùng AI như một gia sư để giải thích những dòng code khó hiểu hoặc làm rõ các thông báo lỗi. Tuy nhiên, xin **không** dùng AI để sao chép đáp án cho các bài tập. Bạn học lập trình bằng cách tự gõ và tự giải quyết vấn đề!

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Ý nghĩa / Định nghĩa |
| :--- | :--- |
| **R** | Ngôn ngữ lập trình thống kê mã nguồn mở, ngôn ngữ tiêu chuẩn cho phân tích dữ liệu sinh học |
| **RStudio** | Môi trường phát triển tích hợp (IDE) bao quanh R, cung cấp Console, Terminal, quản lý tệp và trình soạn thảo |
| **IDE (Integrated Development Environment)** | Môi trường phát triển tích hợp – "cockpit" của lập trình viên |
| **Bioconductor** | Kho lưu trữ hàng nghìn gói phần mềm đã qua bình duyệt, chuyên phục vụ Genomics và Tin sinh học |
| **CRAN** | Comprehensive R Archive Network – kho lưu trữ gói R chính thức |
| **Google Colab** | Nền tảng notebook chạy R trên máy chủ Google, không cần cài đặt |
| **Micromamba** | Trình quản lý môi trường tốc độ cao, tạo môi trường tách biệt qua tệp `environment.yml` |
| **Console / REPL** | Cửa sổ dòng lệnh tương tác của R, nhập lệnh và nhận kết quả ngay lập tức |
| **Working Directory** | Thư mục làm việc hiện tại – nơi R đọc và ghi tệp theo đường dẫn tương đối |
| **Assignment Operator (`<-`)** | Toán tử gán giá trị vào biến; chuẩn của R và Bioconductor |
| **`snake_case`** | Quy ước đặt tên biến: chữ thường nối bằng dấu gạch dưới |
| **Data Type** | Kiểu dữ liệu của một đối tượng trong R: `numeric`, `integer`, `character`, `logical`, `complex` |
| **`typeof()`** | Hàm kiểm tra kiểu dữ liệu thực sự của một đối tượng (ví dụ `numeric` trả về `"double"`) |
| **Missing Value (`NA`)** | Giá trị thiếu – dữ liệu không có hoặc không thu thập được |
| **`NaN` (Not a Number)** | Kết quả toán học không xác định, ví dụ `0 / 0` |
| **`Inf` (Infinity)** | Dương vô cùng (`-Inf` là âm vô cùng), ví dụ `5 / 0` |
| **Type Coercion** | Hiện tượng R tự động chuyển kiểu dữ liệu, thường gây lỗi âm thầm trong tính toán |
| **Escape Character** | Ký tự thoát (dấu gạch chéo `\`) dùng để nhúng ký tự đặc biệt trong chuỗi |
| **Concatenation** | Ghép nối văn bản và giá trị, thực hiện bằng hàm `cat()` |
| **Logical Operator** | Toán tử logic: `&` (AND), `|` (OR), `!` (NOT) |
| **Operator Precedence** | Thứ tự ưu tiên thực thi của các toán tử trong biểu thức |
| **Control Flow** | Cơ chế điều khiển luồng thực thi: phân nhánh điều kiện và vòng lặp |
| **Conditional Branching** | Rẽ nhánh điều kiện `if` / `else if` / `else` |
| **Guard Clause** | Điều kiện lọc ở đầu vòng lặp, dùng `next` để bỏ qua phần tử không hợp lệ |
| **Infinite Loop** | Vòng lặp chạy vô tận – luôn xảy ra khi quên cập nhật biến điều kiện |
| **CPM (Counts Per Million)** | Đơn vị chuẩn hóa số đếm trên 1 triệu read, dùng để so sánh giữa các mẫu khác nhau |

---

### I. TỔNG QUAN BÀI HỌC

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026).
* **Chủ đề:** Module 1 – Buổi 05: Nền tảng lập trình R (Core Syntax, Data Types & Computational Logic).
* **Tiền đề kiến thức:** Đã hoàn thành phần giới thiệu khóa học và phần giới thiệu Linux cơ bản.
* **Mục tiêu cốt lõi:**
  1. Hiểu cú pháp R, viết chú thích (`#`) và quản lý thư mục làm việc (`getwd()`, `setwd()`, `dir()`).
  2. Nắm cách khai báo biến bằng toán tử **`<-`** và quy ước đặt tên `snake_case`.
  3. Phân biệt 5 kiểu dữ liệu cốt lõi: `numeric`, `integer` (`L`), `character`, `logical`, `complex`; và hiểu các giá trị đặc biệt `NA`, `NaN`, `Inf`.
  4. Áp dụng toán tử số học và hàm built-in (`sqrt`, `round`, `log2`) để tính chỉ số chuẩn hóa **CPM**.
  5. Xử lý chuỗi, ký tự thoát, định dạng đầu ra với `cat()`, và nắm quy tắc đường dẫn tệp dùng dấu `/`.
  6. Xây dựng điều kiện lọc phức tạp bằng toán tử so sánh và logic cho kiểm soát chất lượng (QC).
  7. Cài đặt cấu trúc điều khiển: phân nhánh `if/else` và vòng lặp `for`, `while` với guard clause `next`, `break`.

---

### II. TẠI SAO NHÀ SINH HỌC CẦN R? TẠI SAO KHÔNG DÙNG EXCEL?

Hầu hết các nhà nghiên cứu bắt đầu phân tích dữ liệu bằng Microsoft Excel. Nhưng với dữ liệu **spatial** và **single-cell** – nơi hàng chục nghìn gen được đo trên hàng nghìn vùng mô (spot) – Excel thất bại:

#### 1. Excel đóng băng và làm sập (Freezes and Crashes)

* Excel chỉ xử lý được khoảng **1 triệu dòng**.
* Bộ dữ liệu spatial chứa **hàng chục triệu** điểm dữ liệu, vượt xa ngưỡng và làm phần mềm bảng tính sập.

#### 2. Excel âm thầm làm hỏng tên gen (Gene Name Corruption)

Excel tự động chuyển ký hiệu gen thành **ngày tháng**:

| Ký hiệu gen gốc | Bị Excel chuyển thành | Nguyên nhân |
| :--- | :--- | :--- |
| `SEPT2` | `2-Sep` | `SEPT` được hiểu là tháng 9 (September) |
| `MARCH1` | `1-Mar` | `MARCH` được hiểu là tháng 3 (March) |

* Lỗi âm thầm này đã làm **hỏng hàng nghìn bộ dữ liệu gen** trong các bài báo đã công bố.

#### 3. Vấn đề "thao tác bằng chuột" (The "Click" Problem)

* Việc làm sạch dữ liệu thực hiện qua các menu giao diện **không thể kiểm chứng, không thể tái tạo, không thể lặp lại** trên các lô bệnh nhân tiếp theo.

#### Vì sao R lại là "siêu năng lực"?

| Đặc điểm | Chi tiết |
| :--- | :--- |
| 🚀 **Quy mô cao (High-Throughput)** | R xử lý hàng triệu tế bào và số đếm trong vài giây |
| 📦 **Chuyên cho sinh học (Bioconductor)** | Kho mã nguồn mở toàn cầu gồm hàng nghìn gói đã qua bình duyệt, thiết kế riêng cho dữ liệu gen và spatial (`SpatialExperiment`, `Seurat`, `Voyager`) |
| 📜 **Công thức tái lập (Reproducible Recipes)** | Mã nguồn ghi lại từng bước phân tích. Khi có mẫu bệnh nhân mới, toàn bộ pipeline chạy bằng **một lệnh** |

---

### III. CÚ PHÁP, CHÚ THÍCH & IN KẾT QUẢ

Trong R, các câu lệnh thực thi **tuần tự**. Dùng `print()` để hiển thị giá trị hoặc cấu trúc dữ liệu ra console:

```r
print("Welcome to Spatial Transcriptomics!")
# [1] "Welcome to Spatial Transcriptomics!"

total_spots <- 4992
print(total_spots)
# [1] 4992
```

#### 1. Viết chú thích (Comments)

Chú thích bắt đầu bằng dấu `#` và bị R **bỏ qua hoàn toàn**. Dùng để giải thích **tại sao** dòng code đó được viết:

```r
# Calculate total sequenced library depth
depth <- 1500000L # Whole integer read count
```

#### 2. Quản lý thư mục làm việc (Working Directory Management)

Để xác minh tệp được đọc và lưu từ đâu:

| Hàm | Chức năng |
| :--- | :--- |
| `getwd()` | Trả về đường dẫn thư mục làm việc hiện tại |
| `setwd("path/to/folder")` | Thiết lập thư mục làm việc mới |
| `dir()` | Liệt kê các tệp và thư mục trong thư mục làm việc |

```r
getwd() # e.g., "/home/mashxp/Project"
dir()   # Lists directory contents
```

---

### IV. BIẾN & TOÁN TỬ GÁN (`<-`)

Một **biến (variable)** là vùng lưu trữ có tên trong bộ nhớ máy tính. Trong R, phép gán được thực hiện bằng **`<-`**:

```r
gene_name <- "EPCAM"
spot_count <- 150
```

> **Vì sao dùng `<-` thay vì dùng `=`?**  
> Dù `=` hoạt động cho phép gán, nhưng chuẩn R và Bioconductor **khuyến nghị dùng `<-`** cho phép gán biến, và dành riêng dấu `=` cho việc **truyền tham số bên trong hàm** (ví dụ `round(x, digits = 2)`).

#### Quy tắc đặt tên biến

| Ký hiệu | Quy tắc | Ví dụ |
| :---: | :--- | :--- |
| ✅ | Phải bắt đầu bằng một chữ cái | `cell_count` |
| ✅ | Có thể chứa chữ cái, số, dấu gạch dưới `_` và dấu chấm `.` | `gene_1`, `qc.score` |
| 🛑 | Không được bắt đầu bằng chữ số (gây lỗi cú pháp) | `1gene` |
| 🛑 | Không được chứa toán tử toán học | `project-id` được hiểu thành `project - id` |
| 🛑 | **Phân biệt chữ hoa/thường (Case-sensitive)** | `gene_a`, `Gene_A`, `GENE_A` là 3 vùng nhớ khác nhau |
| 💡 | **Chuẩn:** dùng `snake_case` để dễ đọc | `total_spot_count` |

---

### V. KIỂU DỮ LIỆU CỐT LÕI & GIÁ TRỊ

R vận hành trên năm kiểu dữ liệu nguyên tử cơ bản:

| Kiểu dữ liệu | Mô tả | Ví dụ | Hàm kiểm tra |
| :--- | :--- | :--- | :--- |
| **`numeric`** | Số thực (thập phân / double) | `42.5`, `10.0` | `typeof(x)` $\rightarrow$ `"double"` |
| **`integer`** | Số nguyên tường minh (hậu tố `L`) | `4992L`, `150L` | `typeof(x)` $\rightarrow$ `"integer"` |
| **`character`** | Chuỗi văn bản trong dấu nháy | `"EPCAM"`, `"Tumor"` | `typeof(x)` $\rightarrow$ `"character"` |
| **`logical`** | Giá trị logic | `TRUE`, `FALSE` | `typeof(x)` $\rightarrow$ `"logical"` |
| **`complex`** | Số phức có phần ảo | `3 + 2i` | `typeof(x)` $\rightarrow$ `"complex"` |

#### Giá trị đặc biệt trong Tin sinh học

| Ký hiệu | Ý nghĩa | Ví dụ sinh học |
| :--- | :--- | :--- |
| **`NA`** (Not Available) | Dữ liệu thiếu hoặc không thu thập được | Spot giải trình tự thất bại |
| **`NaN`** (Not a Number) | Kết quả toán học không xác định | `0 / 0` |
| **`Inf` / `-Inf`** | Dương hoặc âm vô cùng | `5 / 0` |

```r
typeof(10.5)      # "double"
typeof(150L)      # "integer"
typeof("GAPDH")   # "character"
typeof(TRUE)      # "logical"

is.na(NA)         # TRUE
is.nan(0 / 0)     # TRUE
is.infinite(5/0)  # TRUE
```

---

### VI. HÀM TOÁN HỌC & TOÁN TỬ SỐ HỌC

#### Toán tử số học (Arithmetic Operators)

| Toán tử | Ý nghĩa | Ví dụ | Kết quả |
| :---: | :--- | :--- | :---: |
| `+` | Cộng | `12000 + 3500` | `15500` |
| `-` | Trừ | `4992 - 3820` | `1172` |
| `*` | Nhân | `0.074 * 100` | `7.4` |
| `/` | Chia | `raw_reads / total_reads` | – |
| `^` | Lũy thừa | `2^10` | `1024` |
| `%%` | Phép chia lấy phần dư (Modulo) | `10 %% 3` | `1` |
| `%/%` | Phép chia lấy phần nguyên | `10 %/% 3` | `3` |

#### Hàm toán học built-in thường dùng

| Hàm | Chức năng | Ví dụ | Kết quả |
| :--- | :--- | :--- | :---: |
| `sqrt(x)` | Căn bậc hai | `sqrt(225)` | `15` |
| `round(x, digits)` | Làm tròn theo số chữ số thập phân | `round(12.678, 2)` | `12.68` |
| `floor(x)` | Làm tròn xuống số nguyên gần nhất | `floor(12.8)` | `12` |
| `ceiling(x)` | Làm tròn lên số nguyên gần nhất | `ceiling(12.1)` | `13` |
| `log2(x)` | Logarithm cơ số 2 – chuẩn để tính fold-change | `log2(8)` | `3` |

#### Chuẩn hóa CPM trong Tin sinh học

Khi hai spot có **độ sâu giải trình tự (sequencing depth) khác nhau**, số đếm thô không thể so sánh trực tiếp. Chuẩn hóa **Counts Per Million (CPM)** giải quyết vấn đề này:

```r
# Spot A - độ sâu cao, spot B - độ sâu thấp
counts_a <- 1200
depth_a  <- 15000

counts_b <- 300
depth_b  <- 30000

cpm_a <- counts_a / depth_a * 1e6   # 80000 CPM
cpm_b <- counts_b / depth_b * 1e6   # 10000 CPM
```

> **Bài học rút ra:** Luôn **chuẩn hóa trước khi so sánh** biểu hiện gen giữa các mẫu có độ sâu giải trình tự khác nhau.

---

### VII. CHUỖI & KÝ TỰ THOÁT

Chuỗi (string) là văn bản được bao bọc trong dấu nháy đơn (`'...'`) hoặc nháy kép (`"..."`).

#### 1. Dấu nháy lồng nhau (Quotes Inside Quotes)

Dùng **loại dấu nháy đối diện** để tránh lỗi thoát ký tự:

```r
# An toàn với dấu nháy lồng nhau
note <- 'Pathologist entered: "High EPCAM expression in tumor core"'
```

#### 2. Định dạng đầu ra với `cat()`

Khác với `print()` (hiển thị chuỗi thô kèm dấu nháy), **`cat()`** nối các đoạn văn bản và **diễn giải ký tự thoát**:

| Ký tự thoát | Ý nghĩa |
| :--- | :--- |
| `\n` | Xuống dòng mới (newline) |
| `\t` | Khoảng cách Tab |
| `\"` | Dấu nháy kép đã thoát |

```r
cat("Marker:\t", "CD3D", "\nExpression:\t", 24.5, "\n", sep = "")
```

#### 3. Quy tắc đường dẫn tệp phổ quát (Universal File Path Rule)

**ALWAYS dùng dấu gạch chéo tiền `/` trong đường dẫn tệp R** trên Windows, macOS và Linux.  
Trên Windows, sao chép đường dẫn như `"data\visium\counts.csv"` khiến R **crash** vì `\` là ký tự thoát và `\v` / `\c` là chuỗi thoát không hợp lệ.

```r
# Đường dẫn đúng, dùng được trên mọi nền tảng:
count_file <- "data/visium/counts.csv"
```

---

### VIII. TOÁN TỬ SO SÁNH & TOÁN TỬ LOGIC

#### 1. Toán tử so sánh (luôn trả về `TRUE` hoặc `FALSE`)

| Toán tử | Ý nghĩa | Ví dụ | Kết quả |
| :---: | :--- | :--- | :---: |
| `==` | Bằng đúng | `gene == "EPCAM"` | `TRUE` / `FALSE` |
| `!=` | Không bằng | `spot != "Stroma"` | `TRUE` / `FALSE` |
| `>` | Lớn hơn | `umi > 1000` | `TRUE` / `FALSE` |
| `<` | Nhỏ hơn | `mito < 15.0` | `TRUE` / `FALSE` |
| `>=` | Lớn hơn hoặc bằng | `umi >= 500` | `TRUE` / `FALSE` |
| `<=` | Nhỏ hơn hoặc bằng | `mito <= 20.0` | `TRUE` / `FALSE` |

#### 2. Toán tử logic (Logical Operators)

| Toán tử | Tên gọi | Quy tắc |
| :---: | :--- | :--- |
| **`&`** | AND | Chỉ `TRUE` khi **cả hai** vế đều `TRUE` |
| **`|`** | OR | `TRUE` khi **ít nhất một** vế là `TRUE` |
| **`!`** | NOT | Đảo ngược giá trị logic (`!TRUE` $\rightarrow$ `FALSE`) |

```r
reads <- 1250
mito_pct <- 8.5

# Cổng QC spot (yêu cầu CẢ HAI điều kiện):
pass_qc <- (reads >= 500) & (mito_pct < 15.0) # TRUE & TRUE -> TRUE

# Cờ cảnh báo spot (một trong hai bất thường là đủ):
flag_spot <- (reads < 200) | (mito_pct > 20.0) # FALSE | FALSE -> FALSE

# Đảo ngược cờ:
is_clean <- !flag_spot # TRUE
```

> **Mẹo về thứ tự ưu tiên (Precedence Tip):** Luôn đặt từng biểu thức so sánh trong dấu ngoặc tròn `(...)` để tránh lỗi do thứ tự ưu tiên toán tử.

---

### IX. CẤU TRÚC ĐIỀU KHIỂN (IF...ELSE, VÒNG LẶP)

Cấu trúc điều khiển thực thi động các khối code dựa trên điều kiện.

#### A. Phân nhánh điều kiện (`if...else if...else`)

```r
expression_val <- 450

if (expression_val > 500) {
  cat("Tier: High Expression\n")
} else if (expression_val >= 100) {
  cat("Tier: Medium Expression\n")
} else {
  cat("Tier: Low Expression\n")
}
```

> **Yêu cầu cú pháp R:** `else` và `else if` **luôn phải nằm trên cùng dòng** với dấu ngoặc đóng `}` ngay trước nó: `} else {`.

#### B. Vòng lặp `for`

Duyệt tuần tự qua từng phần tử trong một tập hợp:

```r
marker_genes <- c("EPCAM", "CD3D", "PECAM1")

for (gene in marker_genes) {
  cat("Quantifying marker:", gene, "\n")
}
```

#### C. Điều khiển vòng lặp: `next` và `break`

| Từ khóa | Chức năng |
| :--- | :--- |
| **`next`** | Bỏ qua phần còn lại của lần lặp hiện tại và nhảy thẳng tới phần tử kế tiếp (guard clause) |
| **`break`** | Ngay lập tức hủy và kết thúc **toàn bộ** vòng lặp |

```r
counts <- c(1200, 45, 890, -999, 1400)

for (cnt in counts) {
  # 1. Hủy ngay lập tức khi gặp dữ liệu hỏng
  if (cnt < 0) {
    cat("Corrupted count (", cnt, ")! Aborting loop.\n", sep = "")
    break
  }
  
  # 2. Guard clause: bỏ qua spot chất lượng thấp (< 100)
  if (cnt < 100) {
    next
  }
  
  cat("Valid spot count:", cnt, "\n")
}
```

#### D. Vòng lặp `while`

Lặp lại khối code **chừng nào** điều kiện còn đúng. Luôn tăng biến đếm để tránh **vòng lặp vô tận (infinite loops)**:

```r
resolution <- 0.2
while (resolution <= 0.6) {
  cat("Clustering resolution:", resolution, "\n")
  resolution <- resolution + 0.1
}
```

---

### X. THỰC HÀNH TỔNG HỢP: 3 BÀI TOÁN TIN SINH HỌC

#### 📌 Bài toán 1: Toán học Genomics (Độ phủ giải trình tự)

Một panel gen ung thư mục tiêm phủ `panel_size_bp <- 250000L` base pair. Một lần chạy giải trình tự tạo ra `read_count <- 120000L` read với độ dài trung bình `read_len <- 150L` base pair.

1. Kiểm tra `panel_size_bp` có phải là `integer` không bằng `typeof()`.
2. Tính độ phủ trung bình (fold-coverage):
   $$\text{Coverage} = \frac{\text{read\_count} \times \text{read\_len}}{\text{panel\_size\_bp}}$$
3. Làm tròn kết quả về 1 chữ số thập phân bằng `round()`.

```r
panel_size_bp <- 250000L
read_count    <- 120000L
read_len      <- 150L

# 1. Kiểm tra kiểu dữ liệu
typeof(panel_size_bp)  # "integer"

# 2. Tính độ phủ
coverage <- (read_count * read_len) / panel_size_bp

# 3. Làm tròn 1 chữ số thập phân
round(coverage, digits = 1)  # 72
```

#### 📌 Bài toán 2: Metadata lâm sàng & Định dạng ký tự thoát

Xây dựng tiêu đề báo cáo tự động cho mẫu sinh thiết ung thư không gian:

* Patient ID: `patient_id <- "PT_042"`
* Chẩn đoán bệnh học: The pathologist entered: *Infiltrating "Ductal" Carcinoma*
* Đường dẫn tệp gốc: `data/visium/pt042_matrix.h5`

**Yêu cầu:**
1. Gán văn bản chẩn đoán vào `diagnosis`, **giữ an toàn** dấu nháy kép bên trong quanh `"Ductal"`.
2. Gán đường dẫn tệp vào `counts_path` dùng dấu gạch chéo tiền `/`.
3. Dùng `cat()` để in bản tóm tắt lâm sàng 3 dòng, căn thẳng hàng bằng Tab (`\t`) và xuống dòng (`\n`).

```r
patient_id <- "PT_042"

# 1. Dùng dấu nháy đơn bao quanh dấu nháy kép bên trong:
diagnosis <- 'Infiltrating "Ductal" Carcinoma'

# 2. Đường dẫn dùng dấu gạch chéo tiền:
counts_path <- "data/visium/pt042_matrix.h5"

# 3. In báo cáo 3 dòng có định dạng:
cat("PATIENT:\t", patient_id, "\n",
    "DIAGNOSIS:\t", diagnosis, "\n",
    "FILE PATH:\t", counts_path, "\n", sep = "")
```

**Kết quả mong đợi:**
```
PATIENT:	PT_042
DIAGNOSIS:	Infiltrating "Ductal" Carcinoma
FILE PATH:	data/visium/pt042_matrix.h5
```

#### 📌 Bài toán 3: Kiểm toán chất lượng (Guard Clauses & Phân tầng)

Một lần chạy giải trình tự không gian tạo ra vector số đo nhiễm độc tế bào (theo phần trăm) trên 6 spot mô:
`mito_readings <- c(4.8, 12.3, 85.0, -1.0, 18.5, 9.2)`

Viết vòng lặp `for` duyệt qua `mito_readings`:
1. **Kiểm tra lỗi cảm biến:** Nếu số đo âm (`< 0`), in `"Sensor Error ([reading]%)! Aborting audit."` và **thoát vòng lặp ngay** bằng `break`.
2. **Lọc spot chết:** Nếu số đo lớn hơn `20.0%` (tế bào vỡ/chết), bỏ qua bằng `next`.
3. **Phân tầng spot đạt yêu cầu:**
   * Nếu `< 10.0%`, in `"Spot [reading]% mito: Pristine"`
   * Nếu `>= 10.0%`, in `"Spot [reading]% mito: Acceptable"`

```r
mito_readings <- c(4.8, 12.3, 85.0, -1.0, 18.5, 9.2)

for (mito in mito_readings) {
  # 1. Break khi lỗi cảm biến (< 0)
  if (mito < 0) {
    cat("Sensor Error (", mito, "%)! Aborting audit.\n", sep = "")
    break
  }
  
  # 2. Guard clause: bỏ qua spot chết (> 20%)
  if (mito > 20.0) {
    next
  }
  
  # 3. Phân tầng
  if (mito < 10.0) {
    cat("Spot ", mito, "% mito: Pristine\n", sep = "")
  } else {
    cat("Spot ", mito, "% mito: Acceptable\n", sep = "")
  }
}
```

**Kết quả mong đợi:**
```
Spot 4.8% mito: Pristine
Spot 12.3% mito: Acceptable
Sensor Error (-1%)! Aborting audit.
```

> **Phân tích điểm dừng (Điểm mấu chốt của bài toán):** Giá trị `85.0` bị bỏ qua bằng `next`, nhưng ngay sau đó giá trị `-1.0` gặp điều kiện lỗi cảm biến nên kích hoạt `break` – vòng lặp **dừng hoàn toàn**, các giá trị `18.5` và `9.2` phía sau **không bao giờ được xử lý**. Đây chính là sự khác biệt cốt lõi giữa `next` và `break`.

---

### XI. TỔNG HỢP CÂU HỎI & TRẢ LỜI TRONG LỚP (Q&A SESSION)

#### Câu hỏi 1: Tại sao Excel lại hỏng tên gen `SEPT2` và `MARCH1`?
* **Trả lời:** Excel tự động nhận diện chuỗi ký hiệu gen theo logic **ngày tháng** và chuyển đổi chúng:
  * `SEPT2` $\rightarrow$ `2-Sep` (Excel hiểu `SEPT` là tháng 9 – September)
  * `MARCH1` $\rightarrow$ `1-Mar` (Excel hiểu `MARCH` là tháng 3 – March)
* **Mức độ nghiêm trọng:** Lỗi này đã âm thầm làm hỏng hàng nghìn bộ dữ liệu gen trong các bài báo đã công bố, và **không thể hoàn tác** (không reverse được).

#### Câu hỏi 2: Tại sao phải dùng toán tử `<-` thay vì `=`?
* **Trả lời:** Dù `=` hoạt động cho phép gán, chuẩn **R và Bioconductor nghiêm ngặt khuyến nghị `<-`** cho phép gán biến. Dấu `=` được dành riêng cho việc **truyền tham số bên trong hàm**, ví dụ `round(x, digits = 2)`. Việc tuân thủ quy ước này giúp mã nguồn dễ đọc và nhất quán khi cộng tác.

#### Câu hỏi 3: Biến R có phân biệt chữ hoa và chữ thường không?
* **Trả lời:** **Có, R phân biệt chữ hoa/thường (case-sensitive).** `gene_a`, `Gene_A` và `GENE_A` trỏ tới **ba vùng nhớ hoàn toàn khác nhau**. Nếu bạn định nghĩa `target_gene` rồi gọi `Target_gene`, R sẽ báo lỗi "object not found".

#### Câu hỏi 4: Tại sao không dùng dấu gạch ngang `-` trong tên biến?
* **Trả lời:** Vì dấu `-` là **toán tử trừ**. Khi viết `project-id`, R hiểu đó là phép tính `project - id` chứ không phải một tên biến. Hãy dùng dấu gạch dưới `_` thay thế: `project_id`.

#### Câu hỏi 5: Vì sao phải luôn dùng dấu `/` trong đường dẫn tệp R?
* **Trả lời:** Vì dấu `\` là **ký tự thoát (escape character)** trong R. Trên Windows, đường dẫn như `"data\visium\counts.csv"` sẽ khiến R cố đọc `\v` và `\c` là các chuỗi thoát không hợp lệ và **crash**. Dấu gạch chéo tiền `/` hoạt động ổn định trên cả Windows, macOS và Linux.

#### Câu hỏi 6: Khác biệt giữa `next` và `break` trong vòng lặp?
* **Trả lời:**
  * **`next`** – bỏ qua phần còn lại của **lần lặp hiện tại** và nhảy tới phần tử kế tiếp. Thường dùng làm **guard clause** để lọc dữ liệu không hợp lệ.
  * **`break`** – hủy và kết thúc **toàn bộ vòng lặp** ngay lập tức. Dùng khi phát hiện lỗi nghiêm trọng không thể tiếp tục.
  * **Minh họa từ Bài toán 3:** `85.0` bị bỏ qua bằng `next`, nhưng `-1.0` kích hoạt `break`, khiến `18.5` và `9.2` không bao giờ được xử lý.

#### Câu hỏi 7: Làm thế nào tránh vòng lặp `while` chạy vô tận?
* **Trả lời:** Luôn **cập nhật biến điều kiện** trong thân vòng lặp để nó tiến về phía làm điều kiện trở thành `FALSE`. Nếu quên bước này, điều kiện luôn đúng và chương trình bị treo vô hạn.

---

### XII. TỔNG KẾT CỐT LÕI (KEY TAKEAWAYS)

1. **Excel không phải công cụ cho dữ liệu sinh học:** Nó âm thầm hỏng tên gen thành ngày tháng (`SEPT2` → `2-Sep`), giới hạn ~1 triệu dòng, và không tạo ra tính tái lập.
2. **R là ngôn ngữ, RStudio là công cụ:** Nhớ rõ sự khác biệt giữa ngôn ngữ lập trình (engine) và môi trường phát triển tích hợp (cockpit).
3. **Tuân thủ chuẩn mực của ngôn ngữ:** Dùng **`<-`** để gán biến và **`snake_case`** để đặt tên. Không dùng `-` trong tên biến vì đó là toán tử trừ.
4. **Hiểu rõ các giá trị đặc biệt:** `NA` (thiếu dữ liệu), `NaN` (không xác định), `Inf` (vô cùng). Biết kiểm tra bằng `is.na()`, `is.nan()`, `is.infinite()`.
5. **Luôn dùng dấu `/` cho đường dẫn:** Dấu `\` là ký tự thoát và sẽ gây crash trên Windows.
6. **Dùng `cat()` để định dạng đầu ra:** Nó nối văn bản và diễn giải ký tự thoát (`\n`, `\t`), không giống `print()` vốn hiển thị chuỗi thô kèm dấu nháy.
7. **`next` bỏ qua lần lặp, `break` kết thúc vòng lặp:** Nắm rõ sự khác biệt này để viết guard clause và cơ chế dừng an toàn.
8. **Chuẩn hóa trước khi so sánh:** Dùng **CPM** để so sánh biểu hiện gen giữa các mẫu có độ sâu giải trình tự khác nhau.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo. 
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.