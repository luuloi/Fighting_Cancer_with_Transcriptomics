# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026

## BÀI 06: QUẢN LÝ & BIẾN ĐỔI DỮ LIỆU TRONG R (R DATA MANIPULATION & MANAGEMENT) – PHẦN 1 & 2

### CẤU TRÚC DỮ LIỆU, ĐỌC/GHI TỆP, XÂY DỰNG METADATA, VECTORIZATION & CUSTOM FUNCTIONS

> 🚀 **Notebook tương tác trên Google Colab:** [Colab Notebook](https://colab.research.google.com/drive/1piKzsYlBzeE_aCngwLGN7eK7ujV9vg6K?usp=sharing) | Bản địa phương: [`lecture-06_r_data_manipulation_management.ipynb`](./lecture-06_r_data_manipulation_management.ipynb)

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Thuật ngữ tiếng Việt / Ý nghĩa kỹ thuật | Định nghĩa chi tiết & Ngữ cảnh áp dụng |
| :--- | :--- | :--- |
| **Data Structure** | Cấu trúc dữ liệu | Cách thức tổ chức, quản lý và lưu trữ dữ liệu trong bộ nhớ máy tính để thao tác hiệu quả (Vector, Matrix, List, Data Frame). |
| **Data Type** | Kiểu dữ liệu | Bản chất của từng giá trị đơn lẻ lưu trữ bên trong biến (`numeric`, `integer`, `character`, `logical`). |
| **Atomic Vector** | Vector nguyên tử | Cấu trúc dữ liệu 1 chiều (1D) cơ bản nhất của R; toàn bộ phần tử bắt buộc phải có cùng một kiểu dữ liệu duy nhất. |
| **Matrix** | Ma trận 2 chiều | Cấu trúc dữ liệu 2 chiều (hàng x cột) mang dữ liệu thuần nhất (homogeneous). Chuẩn định dạng của Count Matrix. |
| **Array** | Mảng đa chiều | Cấu trúc dữ liệu thuần nhất từ 3 chiều trở lên (hàng x cột x lớp/slice); ứng dụng lưu trữ ảnh mô học (H&E RGB). |
| **List** | Danh sách (Hộp chứa đa kiểu) | Cấu trúc dữ liệu 1 chiều không đồng nhất (heterogeneous); mỗi phần tử có thể chứa bất kỳ kiểu dữ liệu và độ dài nào. |
| **Data Frame** | Khung dữ liệu 2 chiều | Cấu trúc bảng 2 chiều dị thể; mỗi cột là một vector có tên cùng độ dài, các cột có thể mang kiểu dữ liệu khác nhau. |
| **Factor** | Biến phân loại / Yếu tố | Cấu trúc lưu trữ dữ liệu danh mục (categorical) kèm theo danh sách các mức độ (`levels`) có thứ tự xác định trước. |
| **Tibble (`tbl_df`)** | Khung dữ liệu hiện đại | Cấu trúc bảng mở rộng từ hệ sinh thái *tidyverse*; in ấn gọn gàng, kiểm tra kiểu dữ liệu nghiêm ngặt, không ép kiểu ngầm. |
| **Coercion** | Ép kiểu dữ liệu | Cơ chế R tự động chuyển đổi các phần tử trong vector về kiểu dữ liệu có bậc ưu tiên cao nhất (`character` > `numeric` > `logical`). |
| **Column-major Order** | Điền theo thứ tự cột | Quy tắc mặc định của R khi khởi tạo Ma trận: điền dữ liệu dọc từ trên xuống dưới cột 1, rồi mới chuyển sang cột tiếp theo. |
| **GSE129221** | Mã định danh bộ dữ liệu GEO | Bộ dữ liệu RNA-seq nghiên cứu cơ chế thuốc Apatinib ức chế tế bào ung thư phổi PC9 kháng Gefitinib. |
| **Count Matrix** | Ma trận đếm biểu hiện gen | Bảng số liệu biểu hiện gen thô: hàng là các gen (Entrez ID), cột là các mẫu sinh học (GSM accession), ô là số read giải trình tự. |
| **Entrez Gene ID** | Định danh gen NCBI | Mã số nguyên duy nhất do NCBI cấp cho từng gen (ví dụ: `100287102`, `653635`); ổn định nhưng khó đọc trực tiếp. |
| **GEO Accession (`GSM...`)** | Mã truy cập mẫu GEO | Định danh kỹ thuật của từng mẫu nạp lên Gene Expression Omnibus; không mang ngữ nghĩa sinh học trực tiếp. |
| **Metadata / Sample Info** | Dữ liệu mô tả mẫu | Bảng chú giải đặc tính sinh học của các mẫu (dòng tế bào, nhóm can thiệp thuốc, số lần lặp kỹ thuật/sinh học). |
| **Relative Path** | Đường dẫn tương đối | Đường dẫn tính từ vị trí thư mục làm việc hiện tại (`getwd()`); giúp mã nguồn linh hoạt khi chia sẻ. |
| **Absolute Path** | Đường dẫn tuyệt đối | Đường dẫn cố định bắt đầu từ gốc ổ đĩa (ví dụ `/home/user/...`); gây lỗi crash nghiêm trọng khi chia sẻ mã nguồn. |
| **`here` Package** | Gói neo vị trí dự án | Thư viện R giúp tự động nhận diện thư mục gốc của dự án (`.git`) và tạo đường dẫn độc lập với vị trí chạy script. |
| **`read.delim()`** | Hàm đọc tệp phân tách tab | Hàm cơ sở của R chuyên dùng để nạp tệp TSV (Tab-Separated Values) vào bộ nhớ dưới dạng Data Frame. |
| **`data.table::fread()`** | Trình đọc bảng siêu tốc | Hàm đọc tệp tối ưu bộ nhớ bằng C, nhanh gấp 10–100 lần Base R; bắt buộc dùng cho các tệp ma trận > 100 MB. |
| **`rep()`** | Hàm lặp lại vector | Hàm nhân bản vector với 2 đối số cốt lõi: `times` (lặp cả khối) và `each` (lặp từng phần tử liên tiếp). |
| **`paste()`** | Hàm nối chuỗi ký tự | Hàm ghép nối các chuỗi hoặc vector chuỗi; phân tách nhau bằng đối số `sep` (mặc định là khoảng trắng `" "`). |
| **Shebang (`#!/usr/bin/env bash`)** | Dòng khai báo trình thông dịch | Dòng đầu tiên của Bash script chỉ định môi trường thực thi chuẩn xác trên các hệ điều hành Unix/Linux. |
| **`set -euo pipefail`** | Cờ an toàn nghiêm ngặt Bash | Cấu hình bắt buộc cho script tự động hóa: dừng script ngay khi có lệnh lỗi, biến chưa khai báo hoặc lỗi pipeline. |
| **Vectorization** | Vector hóa | Kỹ thuật thực thi phép toán đồng thời trên toàn bộ mảng dữ liệu mà không cần viết vòng lặp `for` tường minh. |
| **`apply()` Family** | Họ hàm áp dụng chức năng | Tập hợp các hàm xử lý dữ liệu hàng loạt hiệu năng cao trong R (`apply`, `lapply`, `sapply`, `tapply`). |
| **`MARGIN`** | Chiều thao tác hàm apply | Tham số xác định phương hướng tính toán: `MARGIN = 1` (theo từng hàng) và `MARGIN = 2` (theo từng cột). |
| **`rowMeans()` / `colMeans()`** | Hàm trung bình hàng / cột tối ưu | Các hàm nội tại viết bằng ngôn ngữ C của R, tính trung bình theo hàng hoặc cột với tốc độ vượt trội `apply()`. |
| **`grep()` / `grepl()`** | Tìm kiếm mẫu chuỗi (Regex) | Hàm tìm vị trí chỉ mục (`grep`) hoặc vector boolean TRUE/FALSE (`grepl`) của chuỗi ký tự khớp với biểu thức chính quy. |
| **`sub()` / `gsub()`** | Thay thế chuỗi (Substitution) | `sub` thay thế ký tự khớp mẫu đầu tiên; `gsub` thay thế toàn bộ ký tự khớp mẫu trên toàn bộ chuỗi văn bản. |
| **`trimws()`** | Cắt khoảng trắng đầu cuối | Hàm loại bỏ khoảng trắng dư thừa ở đầu và cuối chuỗi, khắc phục lỗi không khớp định danh ID trong database. |
| **`complete.cases()`** | Kiểm tra dòng dữ liệu đầy đủ | Trả về vector logic TRUE cho các dòng dữ liệu không chứa bất kỳ giá trị khuyết thiếu (`NA`) nào. |
| **`na.omit()`** | Loại bỏ dòng chứa NA | Lọc và xóa bỏ toàn bộ các hàng chứa ít nhất một giá trị `NA` khỏi Data Frame. |
| **CPM (Counts Per Million)** | Số đọc chuẩn hóa trên mỗi triệu read | Chỉ số chuẩn hóa biểu hiện gen theo chiều sâu giải trình tự: $\text{CPM} = \frac{\text{Counts}}{\text{Library Size}} \times 10^6$. |
| **% Mitochondrial Reads** | Tỷ lệ đọc gen ty thể | Chỉ số kiểm soát chất lượng (QC): tỷ lệ read ty thể cao cảnh báo màng tế bào vỡ hoặc tế bào chết trong scRNA-seq/Spatial. |
| **`stop()`** | Cắt ngang & Báo lỗi nghiêm trọng | Hàm dừng thực thi script và xuất thông báo lỗi ngay khi các điều kiện kiểm tra (Input Validation) bị vi phạm. |

---

### I. TỔNG QUAN BÀI HỌC (OVERVIEW & OBJECTIVES)

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026).
* **Bài giảng:** Buổi 06 (Phần 1 & 2): R Data Manipulation & Management (Quản lý & Thao tác dữ liệu trong R).
* **Bộ dữ liệu thực hành (Case Study):** [NCBI GEO GSE129221](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE129221) (Nghiên cứu cơ chế phân tử của thuốc Apatinib trên ung thư phổi không tế bào nhỏ kháng thuốc Gefitinib).

```
                     THIẾT KẾ THÍ NGHIỆM GSE129221 (12 MẪU)
  ┌─────────────────────────────────┴─────────────────────────────────┐
  │                                                                   │
  ▼                                                                   ▼
Dòng nhạy cảm (PC9)                                   Dòng kháng Gefitinib (PC9-GR)
  ├─ Control (Đối chứng): 3 mẫu (Rep 1, 2, 3)           ├─ Control (Đối chứng): 3 mẫu (Rep 1, 2, 3)
  └─ Apatinib (Can thiệp): 3 mẫu (Rep 1, 2, 3)          └─ Apatinib (Can thiệp): 3 mẫu (Rep 1, 2, 3)
  
  ==> Ma trận đếm biểu hiện (Count Matrix): 39.376 hàng (Gen) × 12 cột (Mẫu giải trình tự)
```

#### Mục tiêu học tập cốt lõi (Learning Objectives)

1. **Kiểm tra & Củng cố kiến thức nền tảng (Lecture 5 Review):** Nắm vững cú pháp, biến, kiểu dữ liệu, toán tử số học (`%%`, `%/%`), xử lý chuỗi đường dẫn và luồng điều khiển (`if`/`else if`, `for`, `next`, `break`).
2. **Kỹ nghệ đường ống tải dữ liệu (Bash Data Plumbing):** Tự động hóa quá trình thu thập tệp đếm biểu hiện từ máy chủ NCBI GEO bằng script Bash chuẩn mực (`download.sh`) với cờ an toàn `set -euo pipefail`.
3. **Làm chủ 5 Cấu trúc dữ liệu trong R:** Định nghĩa, phân biệt và ứng dụng chính xác Vector, Matrix, Array, List, Data Frame cùng hai cấu trúc mở rộng là Factor và Tibble.
4. **Quy tắc trích xuất & Lọc dữ liệu (Subsetting & Filtering):** Sử dụng thành thạo chỉ mục số nguyên (bắt đầu từ 1), chỉ mục âm (loại trừ), chỉ mục logic và toán tử `$` / `[[ ]]` / `[ ]`.
5. **Chuẩn hóa quản lý tệp & Thư mục làm việc:** Xóa bỏ hoàn toàn thói quen nguy hiểm "hard-code" đường dẫn tuyệt đối; làm chủ kỹ thuật neo dự án với gói `here`.
6. **Xây dựng Bảng Metadata mẫu từ số không:** Ứng dụng kỹ thuật lặp vector nâng cao (`rep()` với `times` và `each`) để kiến tạo bảng `sample_info` 12 mẫu hoàn chỉnh.
7. **Biến đổi chuỗi & Chuẩn hóa nhãn mẫu:** Dùng `paste()` để tạo nhãn sinh học có nghĩa và gán trực tiếp vào `colnames()` của ma trận đếm.
8. **Giải pháp hoàn chỉnh bài tập ánh xạ chú giải gen:** Nắm phương pháp tiếp cận tệp chú giải hệ gen người (`Human.GRCh38.p13.annot.tsv`) và ghép nối chính xác với `match()`.
9. **Làm chủ nguyên lý Vectorization & Họ hàm `apply`:** Thay thế triệt để vòng lặp `for` chậm chạp bằng `apply()`, `lapply()`, `sapply()`, `tapply()`, `rowMeans()`, `colMeans()`.
10. **Xử lý chuỗi nâng cao & Biểu thức chính quy (Regex):** Lọc tách nhãn gen và mẫu sinh học bằng `grep()`, `sub()`, `gsub()`, `toupper()`, `tolower()`, `trimws()`.
11. **Quản lý dữ liệu khuyết thiếu (`NA`) & Quy trình QC không gian:** Phân biệt ý nghĩa sinh học giữa `0` và `NA`, ứng dụng `complete.cases()`, `is.na()`, và lọc kiểm soát chất lượng (Spatial QC).
12. **Xây dựng hàm tự tạo (Custom Functions) chuyên nghiệp:** Thiết kế hàm tính toán CPM và % gen ty thể có kiểm soát lỗi đầu vào chặt chẽ bằng `stop()`.re 5 Review):** Nắm vững cú pháp, biến, kiểu dữ liệu, toán tử số học (`%%`, `%/%`), xử lý chuỗi đường dẫn và luồng điều khiển (`if`/`else if`, `for`, `next`, `break`).
2. **Kỹ nghệ đường ống tải dữ liệu (Bash Data Plumbing):** Tự động hóa quá trình thu thập tệp đếm biểu hiện từ máy chủ NCBI GEO bằng script Bash chuẩn mực (`download.sh`) với cờ an toàn `set -euo pipefail`.
3. **Làm chủ 5 Cấu trúc dữ liệu trong R:** Định nghĩa, phân biệt và ứng dụng chính xác Vector, Matrix, Array, List, Data Frame cùng hai cấu trúc mở rộng là Factor và Tibble.
4. **Quy tắc trích xuất & Lọc dữ liệu (Subsetting & Filtering):** Sử dụng thành thạo chỉ mục số nguyên (bắt đầu từ 1), chỉ mục âm (loại trừ), chỉ mục logic và toán tử `$` / `[[ ]]` / `[ ]`.
5. **Chuẩn hóa quản lý tệp & Thư mục làm việc:** Xóa bỏ hoàn toàn thói quen nguy hiểm "hard-code" đường dẫn tuyệt đối; làm chủ kỹ thuật neo dự án với gói `here`.
6. **Xây dựng Bảng Metadata mẫu từ số không:** Ứng dụng kỹ thuật lặp vector nâng cao (`rep()` với `times` và `each`) để kiến tạo bảng `sample_info` 12 mẫu hoàn chỉnh.
7. **Biến đổi chuỗi & Chuẩn hóa nhãn mẫu:** Dùng `paste()` để tạo nhãn sinh học có nghĩa và gán trực tiếp vào `colnames()` của ma trận đếm.
8. **Định hướng bài tập ánh xạ chú giải gen:** Nắm phương pháp tiếp cận tệp chú giải hệ gen người (`Human.GRCh38.p13.annot.tsv`) để chuyển đổi Entrez Gene ID sang Gene Symbol.

---

### II. ÔN TẬP BÀI CŨ (REVIEW: LECTURE 5)

Trước khi tiếp cận các cấu trúc dữ liệu mới, buổi học dành 20 phút đầu tiên thực hiện 3 vòng kiểm tra phản xạ nhanh (Rapid Fire) không mở tài liệu.

```
       VÒNG 1: Cú pháp & Biến       ──►       VÒNG 2: Kiểu dữ liệu & Toán       ──►       VÒNG 3: Logic & Luồng
   (Dấu ngoặc, gán biến, đặt tên)             (typeof, integer, %%, escape)               (else if, &, next/break)
```

#### Vòng 1: Cú pháp & Biến số (Syntax & Variables)

* **Câu hỏi 1:** Khi nhập lệnh `print("hello)` vào R Console và bấm `Enter`, điều gì sẽ xảy ra?
  * **Hiện tượng:** R **không báo lỗi (crash)** và **cũng không thực thi**. Console xuất hiện dấu nhắc lệnh `+`.
  * **Bản chất:** R phát hiện chuỗi ký tự chưa được đóng dấu ngoặc kép hợp lệ. Trình thông dịch chuyển sang trạng thái chờ nhận thêm ký tự cho đến khi đóng đủ ngoặc.
  * **Cách xử lý:** Nhập bổ sung dấu `")` hoặc bấm `Ctrl + C` để hủy lệnh treo.
* **Câu hỏi 2:** Cú pháp gán giá trị `150` vào biến `x` chuẩn mực trong R?
  * **Cú pháp:** `x <- 150` (sử dụng toán tử gán mũi tên `<-`, tuân thủ R Style Guide).
* **Câu hỏi 3:** Phân loại 4 tên biến sau: `1gene`, `cell count`, `gene_A`, `Gene_A`?
  * `1gene` & `cell count`: **Lỗi cú pháp (Syntax Error) lập tức**. Tên biến không được bắt đầu bằng chữ số và không được chứa khoảng trắng.
  * `Gene_A`: **Hợp lệ nhưng nguy hiểm (Dangerous)**. Ngôn ngữ R phân biệt hoa/thường (*case-sensitive*), dễ gây nhầm lẫn biến trong quá trình phân tích dài.
  * `gene_A`: **An toàn tuyệt đối (Safe)**, tuân thủ chuẩn `snake_case`.

#### Vòng 2: Kiểu dữ liệu, Toán học & Chuỗi (Types, Math & Strings)

* **Câu hỏi 1:** Kiểu dữ liệu của `150` và `"EGFR"` là gì?
  * `150` có kiểu **`numeric`** (cụ thể là lưu dưới dạng số thực `double` 64-bit). Muốn R hiểu là số nguyên thuần túy (`integer`), phải ghi tường minh: `150L`.
  * `"EGFR"` có kiểu **`character`** (chuỗi văn bản); có dấu ngoặc kép bao quanh, không thể tham gia phép tính cộng trừ nhân chia trực tiếp.
  * *Hàm kiểm tra:* `typeof(150)` $\rightarrow$ `"double"`; `typeof(150L)` $\rightarrow$ `"integer"`; `typeof("EGFR")` $\rightarrow$ `"character"`.
* **Câu hỏi 2:** Phân biệt phép toán `10 %% 3` và `10 %/% 3`?
  * `%%` là toán tử **chia lấy phần dư (Modulo)**: `10 %% 3` trả về `1`.
  * `%/%` là toán tử **chia lấy phần nguyên (Integer Division)**: `10 %/% 3` trả về `3`.
* **Câu hỏi 3:** Vì sao lệnh `read.csv("data\visium\counts.csv")` bị lỗi nghiêm trọng?
  * Dấu gạch chéo ngược `\` là **ký tự thoát (Escape Character)** trong R. Trình thông dịch sẽ cố gắng phân tích cú pháp `\v` và `\c`, vốn không tồn tại trong bảng mã thoát chuẩn $\rightarrow$ phát sinh lỗi: `Error: '\v' is an unrecognized escape in character string`.
  * **Quy tắc bất biến:** Luôn sử dụng dấu gạch chéo xuôi `/` cho mọi đường dẫn tệp trong R trên cả Linux, macOS và Windows:

    ```r
    read.csv("data/visium/counts.csv") # Cú pháp an toàn chuẩn mực
    ```

#### Vòng 3: Toán tử Logic & Cấu trúc điều khiển (Operators & Control Flow)

* **Câu hỏi 1:** Khi kiểm tra lệnh `if (condition)` trả về `FALSE`, muốn kiểm tra thêm một điều kiện thứ hai thì dùng cú pháp nào?
  * Sử dụng **`else if (condition_2)`**. Lưu ý: R không có từ khóa `elif` (như Python) hay `elseif`.
* **Câu hỏi 2:** Viết cú pháp kiểm tra điều kiện $500 \le x \le 2500$ trong R?
  * Cú pháp chuẩn: `(x >= 500) & (x <= 2500)`.
  * **Lưu ý:** R tuyệt đối không hỗ trợ nối chuỗi so sánh trực tiếp kiểu toán học `500 <= x <= 2500`. Bắt buộc phải tách thành hai biểu thức logic riêng biệt và nối bằng toán tử logic `&`.
* **Câu hỏi 3:** Sự khác biệt giữa từ khóa `next` và `break` trong vòng lặp `for`?
  * `next`: **Bỏ qua phần còn lại** của bước lặp hiện tại và lập tức chuyển sang bước lặp kế tiếp (*skip iteration*).
  * `break`: **Dừng và thoát ngay lập tức** ra khỏi toàn bộ cấu trúc vòng lặp (*abort loop*).

---

### III. CASE STUDY GSE129221 & CHUẨN BỊ DỮ LIỆU QUA BASH

#### 1. Bối cảnh Sinh học & Câu hỏi Nghiên cứu

* Thuốc đích thế hệ 1 **Gefitinib** rất hiệu quả trên bệnh nhân ung thư phổi có đột biến thụ thể EGFR. Tuy nhiên, tế bào ung thư nhanh chóng phát triển đột biến kháng thuốc.
* Thuốc ức chế VEGFR thế hệ mới **Apatinib** có khả năng đảo ngược tình trạng kháng thuốc bằng cách kích hoạt chu trình bắt giữ tế bào ở pha G1 (Cell Cycle Arrest) thay vì chỉ gây độc tế bào đơn thuần.
* Thí nghiệm giải trình tự RNA (RNA-seq) trên 2 dòng tế bào: **PC9** (nhạy cảm) và **PC9-GR** (kháng Gefitinib) với 2 điều kiện: **Control** (đối chứng) và **Apatinib** (xử lý thuốc), mỗi điều kiện thực hiện 3 lần lặp (Replicates).
* Tổng số mẫu: $2 \times 2 \times 3 = 12$ mẫu sinh học. Ma trận đếm gồm **39.376 gen**.

#### 2. Thao tác dòng lệnh Bash thu thập dữ liệu thô

Nhằm đảm bảo tính tái lập (Reproducibility), toàn bộ quy trình thu thập và giải nén dữ liệu từ máy chủ NCBI được thực hiện qua dòng lệnh Bash:

```bash
# Tạo thư mục làm việc chuyên dụng cho dữ liệu đếm
mkdir -p counts
cd counts

# Tải ma trận đếm đã chuẩn hóa từ máy chủ NCBI GEO
# LƯU Ý: Luôn dùng cờ -o để đặt tên tệp tường minh (tránh lỗi Header của GEO làm hỏng tên khi dùng -O)
curl -o counts.tsv.gz \
  "https://www.ncbi.nlm.nih.gov/geo/download/?type=rnaseq_counts&acc=GSE129221&format=file&file=GSE129221_raw_counts_GRCh38.p13_NCBI.tsv.gz"

# Giải nén tệp tsv.gz thành tệp tsv thuần túy
gunzip counts.tsv.gz
```

#### 3. Tự động hóa thành Bash Script chuyên nghiệp (`download.sh`)

Thay vì gõ thủ công từng câu lệnh dễ nhầm lẫn, toàn bộ quy trình được đóng gói vào một tệp kịch bản tự động hóa đạt chuẩn bài báo quốc tế:

```bash
#!/usr/bin/env bash
# ==============================================================================
# Pipeline: Thu thập & Kiểm tra Dữ liệu GSE129221
# Script: counts/download.sh
# ==============================================================================

# Kích hoạt chế độ kiểm soát lỗi nghiêm ngặt:
# -e: Thoát ngay khi một lệnh trả về mã lỗi khác 0
# -u: Báo lỗi nếu sử dụng biến chưa được gán giá trị
# -o pipefail: Pipeline thất bại nếu bất kỳ lệnh thành phần nào bị lỗi
set -euo pipefail

# Khởi tạo tham số cấu hình
TARGET_DIR="counts"
FILE_URL="https://www.ncbi.nlm.nih.gov/geo/download/?type=rnaseq_counts&acc=GSE129221&format=file&file=GSE129221_raw_counts_GRCh38.p13_NCBI.tsv.gz"
COMPRESSED_FILE="${TARGET_DIR}/counts.tsv.gz"
OUTPUT_TSV="${TARGET_DIR}/counts.tsv"

echo "[INFO] Khởi tạo thư mục ${TARGET_DIR}..."
mkdir -p "${TARGET_DIR}"

echo "[INFO] Đang tải ma trận đếm từ NCBI GEO..."
curl -s -o "${COMPRESSED_FILE}" "${FILE_URL}"

echo "[INFO] Đang giải nén dữ liệu..."
gunzip -f "${COMPRESSED_FILE}"

echo "[INFO] Dữ liệu đã sẵn sàng: ${OUTPUT_TSV}"
echo "[INFO] Xem trước 5 dòng đầu tiên của ma trận đếm:"
head -n 5 "${OUTPUT_TSV}"
```

Cấp quyền thực thi và vận hành script:

```bash
chmod +x counts/download.sh
./counts/download.sh
```

#### 4. Vấn đề cốt lõi phát hiện khi kiểm tra dữ liệu thô (`head -n 5 counts.tsv`)

Khi quan sát 5 dòng đầu tiên của tệp `counts.tsv`, hai trở ngại kỹ thuật lớn xuất hiện:

1. **Mã hàng (Row IDs):** Là các số nguyên **Entrez Gene ID** (`100287102`, `653635`, `102466751`). Nhà sinh học không thể nhận biết đây là gen sinh ung hay gen ức chế khối u nếu không ánh xạ sang Gene Symbol.
2. **Mã cột (Column Headers):** Là các mã truy cập kỹ thuật vô nghĩa **GSM Accession** (`GSM3702795` $\rightarrow$ `GSM3702806`). Không có thông tin mẫu nào là PC9, mẫu nào là PC9-GR, mẫu nào có xử lý thuốc Apatinib.
3. **Mục tiêu của R:** Sử dụng hệ thống cấu trúc dữ liệu của R để nạp, giải mã và gắn nhãn sinh học có nghĩa cho ma trận đếm này.

---

### IV. HỆ THỐNG CẤU TRÚC DỮ LIỆU TRONG R (R DATA STRUCTURES)

R cung cấp 5 cấu trúc dữ liệu chính yếu được phân loại dựa trên **Số chiều (Dimensions)** và **Tính đồng nhất của dữ liệu (Homogeneity)**:

| Cấu trúc dữ liệu | Số chiều (Dimensions) | Kiểu dữ liệu chứa bên trong | Ứng dụng thực tế trong Tin sinh học |
| :--- | :--- | :--- | :--- |
| **Vector** | 1 Chiều (1D) | Thuần nhất (Homogeneous) | Danh sách tên mẫu, nồng độ biểu hiện 1 gen, vector logic QC |
| **Matrix** | 2 Chiều (2D) | Thuần nhất (Homogeneous) | Count Matrix (ma trận đếm read), ma trận khoảng cách PCA |
| **Array** | Đa chiều ($N \ge 3$) | Thuần nhất (Homogeneous) | Dữ liệu ảnh mô bệnh học đa kênh (H&E RGB: $H \times W \times 3$) |
| **List** | 1 Chiều (1D) | Dị thể (Heterogeneous) | Kết quả mô hình hồi quy, đối tượng DESeq2/Seurat, tham số hàm |
| **Data Frame** | 2 Chiều (2D) | Dị thể theo cột (Heterogeneous) | Bảng chú giải mẫu (Metadata), bảng kết quả sai khác biểu hiện (DEG) |
| *Factor* | 1 Chiều (1D) | Số nguyên ánh xạ nhãn mức (*Levels*) | Phân nhóm can thiệp (Control/Treatment), dòng tế bào |
| *Tibble* | 2 Chiều (2D) | Dị thể hiện đại (*Tidyverse*) | Bảng dữ liệu định dạng đẹp, không tự ý biến đổi kiểu |

```
                       CÂY PHÂN CẤP CẤU TRÚC DỮ LIỆU R
                                      │
            ┌─────────────────────────┴─────────────────────────┐
            ▼                                                   ▼
     Dữ liệu Thuần nhất                                  Dữ liệu Dị thể
   (Cùng 1 kiểu dữ liệu)                             (Đa dạng kiểu dữ liệu)
    ├── 1D: Atomic Vector                             ├── 1D: List
    ├── 2D: Matrix                                    └── 2D: Data Frame
    └── 3D+: Array                                         └── Mở rộng: Tibble
    └── Mở rộng: Factor
```

---

#### 1. Atomic Vector — Nền tảng 1 Chiều

* **Khái niệm:** Dãy giá trị 1 chiều có cùng kiểu dữ liệu. Mọi hàm trong R đều được thiết kế để xử lý vector (*Vectorized*).
* **Khởi tạo cơ bản:**

  ```r
  # Dùng hàm combine c()
  vals <- c(10, 20, 30)

  # Dãy số nguyên liên tiếp bằng toán tử dấu hai chấm :
  1:5                   # Kết quả: 1 2 3 4 5

  # Dãy số cách đều tùy biến với seq()
  seq(2, 10, by = 2)    # Kết quả: 2 4 6 8 10

  # Lặp lại phần tử với rep()
  rep(1, times = 5)     # Kết quả: 1 1 1 1 1
  ```

* **Cơ chế Ép kiểu ngầm định (Implicit Coercion):**
  Nếu trộn lẫn các kiểu dữ liệu vào cùng một vector, R sẽ tự động ép tất cả phần tử về kiểu dữ liệu có độ linh hoạt cao nhất theo thứ tự:
  $$\text{logical} \longrightarrow \text{integer} \longrightarrow \text{double (numeric)} \longrightarrow \text{character}$$

  ```r
  mixed <- c(10, 20, "hello")
  typeof(mixed)         # Trả về "character" -> Các số 10, 20 bị ép thành chuỗi "10", "20"
  ```

* **Các hàm tóm tắt thống kê trên Vector:**

  ```r
  x <- c(1, 2, 3, 4, 5)
  length(x)  # Độ dài vector: 5
  sum(x)     # Tổng các giá trị: 15
  mean(x)    # Trung bình cộng: 3
  ```

* **Kỹ thuật trích xuất phần tử (Subsetting Vector) — Đánh số từ 1:**

  ```r
  gene_reads <- c(1200, 450, 0, 89, 3300)

  # Trích xuất 1 phần tử đơn lẻ
  gene_reads[2]         # Trả về 450 (R đánh chỉ mục từ 1, KHÔNG bắt đầu từ 0)

  # Trích xuất một khoảng phần tử liên tiếp
  gene_reads[2:4]       # Trả về: 450 0 89

  # Dùng chỉ mục âm để LOẠI TRỪ phần tử
  gene_reads[-2]        # Trả về: 1200 0 89 3300 (loại bỏ phần tử thứ 2)

  # Lọc theo điều kiện logic (Conditional Filtering)
  gene_reads[gene_reads > 500] # Trả về: 1200 3300
  ```

---

#### 2. Matrix — Ma trận 2 Chiều thuần nhất

* **Khái niệm:** Bảng lưới 2 chiều (hàng và cột) trong đó mọi ô bắt buộc phải có cùng kiểu dữ liệu (thường là `numeric` hoặc `integer`).
* **Khởi tạo và Thứ tự điền (Column-major vs Row-major):**
  * Theo mặc định, R điền số vào ma trận theo **thứ tự cột (Column-major)**: điền hết cột 1 rồi sang cột 2.
  * Nếu muốn điền theo hàng, đặt thêm tham số `byrow = TRUE`.

  ```r
  # Tạo ma trận 3 hàng, 2 cột (mặc định điền theo cột)
  count_mat <- matrix(c(120, 45, 0, 310, 85, 12), nrow = 3, ncol = 2)
  #      [,1] [,2]
  # [1,]  120  310
  # [2,]   45   85
  # [3,]    0   12

  # Kiểm tra kích thước chiều: [hàng, cột]
  dim(count_mat)        # Trả về vector c(3, 2)
  ```

* **Gán nhãn hàng và cột (`rownames`, `colnames`):**

  ```r
  rownames(count_mat) <- c("EPCAM", "CD3D", "PECAM1")
  colnames(count_mat) <- c("Tumor", "Normal")

  #       Tumor Normal
  # EPCAM   120    310
  # CD3D     45     85
  # PECAM1    0     12
  ```

* **Trích xuất trên Ma trận `[hàng, cột]`:**

  ```r
  count_mat[1, 2]            # Hàng 1, Cột 2 -> Trả về 310
  count_mat[, "Tumor"]       # Lấy toàn bộ cột 'Tumor' của tất cả các gen -> Vector: 120 45 0
  count_mat["EPCAM", ]       # Lấy toàn bộ hàng gen 'EPCAM' qua tất cả các nhóm -> Vector: 120 310
  ```

---

#### 3. Array — Mảng Đa chiều ($N \ge 3$)

* **Khái niệm:** Cấu trúc dữ liệu đa chiều thuần nhất, có thể hình dung như việc xếp chồng nhiều ma trận 2 chiều lên nhau theo các lớp (slices/layers).
* **Ứng dụng:** Lưu trữ dữ liệu hình thái học không gian (Spatial Transcriptomics Histology H&E images), trong đó chiều 1 là chiều cao (Height), chiều 2 là chiều rộng (Width), chiều 3 là các kênh màu (Red, Green, Blue).

  ```r
  # Mảng 2 hàng x 3 cột x 2 lớp
  layers <- array(c(255, 128, 45, 0, 89, 210, 180, 95, 15, 0, 72, 190), 
                  dim = c(2, 3, 2))
  dim(layers)           # Trả về: 2 3 2

  # Trích xuất: [hàng, cột, lớp]
  layers[1, 2, 1]       # Lấy phần tử hàng 1, cột 2, lớp 1 -> 89
  layers[1, 2, 2]       # Lấy phần tử hàng 1, cột 2, lớp 2 -> 95
  ```

---

#### 4. List — Hộp chứa Đa kiểu Dữ liệu

* **Khái niệm:** Danh sách 1 chiều mà mỗi ngăn chứa có thể lưu một đối tượng có kích thước và kiểu dữ liệu hoàn toàn khác nhau (chứa được cả số, chuỗi, vector, ma trận, data frame hay một list con khác).
* **Quy tắc phân biệt toán tử trích xuất cốt tử:**
  * `[ ]` (Ngoặc vuông đơn): Trích xuất một **danh sách con (sublist)**. Kết quả vẫn là một `list`.
  * `[[ ]]` (Ngoặc vuông đôi): Mở hộp và trích xuất **giá trị dữ liệu thô thực sự** nằm bên trong.
  * `$` (Toán tử Dollar): Trích xuất giá trị thực tế theo tên phần tử (tương đương `[[ "tên" ]]`).

  ```r
  spot <- list(
    name    = "Visium_S1",
    counts  = c(120, 45, 0),
    qc_pass = TRUE
  )

  spot["qc_pass"]       # Trả về một List 1 phần tử ($qc_pass: TRUE)
  spot[["qc_pass"]]     # Trả về giá trị logic thuần túy: TRUE
  spot$qc_pass          # Trả về giá trị logic thuần túy: TRUE (cú pháp ngắn gọn khuyên dùng)
  ```

---

#### 5. Data Frame — "Ngựa thồ" của Phân tích Sinh học

* **Khái niệm:** Cấu trúc bảng 2 chiều chữ nhật trong đó các cột là những vector có cùng độ dài nhưng có thể mang kiểu dữ liệu khác nhau. Đây là định dạng lưu trữ tiêu chuẩn cho bảng Metadata mẫu.
* **Khởi tạo và Điều hướng kiểm tra:**

  ```r
  spots <- data.frame(
    spot_id   = c("S1", "S2", "S3"),
    umi_count = c(12, 45, 0),
    in_tissue = c(TRUE, TRUE, FALSE)
  )

  # "Tour 3 lệnh 90 giây" bắt buộc chạy khi gặp dataset mới:
  head(spots, n = 2)    # Xem trước các dòng đầu tiên
  dim(spots)            # Xem kích thước [số dòng, số cột] -> 3 3
  str(spots)            # Xem chi tiết cấu trúc, kiểu dữ liệu từng cột
  ```

* **Trích xuất và Lọc trên Data Frame:**
  * Quy tắc dấu phẩy: `df[hàng muốn lấy , cột muốn lấy]`. Để trống bên nào nghĩa là lấy toàn bộ bên đó.

  ```r
  # 1. Trích xuất 1 cột thành vector thuần túy
  spots$umi_count                                     # Trả về vector: 12 45 0

  # 2. Lọc các hàng thỏa điều kiện logic
  spots[spots$umi_count > 10, ]                      # Giữ lại các hàng có umi_count > 10

  # 3. Lọc hàng kết hợp chọn lọc cột cụ thể
  spots[spots$in_tissue, c("spot_id", "umi_count")]  # Chỉ lấy hàng trong mô và 2 cột chỉ định
  ```

---

#### 6. Mở rộng: Factor & Tibble

* **Factor (Biến định tính / Phân loại):**
  Lưu trữ nhãn danh mục kèm theo danh sách các mức độ (`levels`) được định nghĩa trước. Thứ tự mặc định là bảng chữ cái (*alphabetical*). Trong phân tích sai khác biểu hiện (DESeq2/EdgeR), việc thiết lập đúng level đối chứng (ví dụ `levels = c("Control", "Treated")`) quyết định chiều dương/âm của Log2 Fold Change.

  ```r
  cell_types <- factor(c("T-cell", "B-cell", "T-cell", "T-cell"))
  levels(cell_types)    # Trả về: "B-cell" "T-cell"
  table(cell_types)     # Đếm tần suất: B-cell: 1, T-cell: 3
  ```

* **Tibble (`tbl_df`):**
  Bảng dữ liệu cải tiến từ gói `tibble` (*tidyverse*). Ưu điểm vượt trội: xem trước đẹp mắt (chỉ hiện 10 dòng đầu và cột vừa màn hình), không bao giờ tự ý chuyển cột chuỗi thành factor, và không tự động ép kiểu thành vector khi trích xuất một cột đơn lẻ qua `df[, 1]`.

---

#### 7. Tổng kết Bài tập Trắc nghiệm tại lớp (Exercises 6.1 – 6.3)

##### Bài tập 6.1: Chọn cấu trúc dữ liệu phù hợp

Cho bảng dữ liệu gồm 4 gen và 3 mẫu: cột `gene_id` chứa chuỗi văn bản (`"gene_A"`, ...), 3 cột mẫu `S1`, `S2`, `S3` chứa số đếm nguyên. Cấu trúc dữ liệu nào phù hợp nhất?

* **Đáp án:** **e) Data frame**.
* **Giải thích chuyên sâu:** Bảng chứa đồng thời 2 kiểu dữ liệu: văn bản (tên gen) và số nguyên (số count). Vector, Matrix và Array bắt buộc thuần nhất 1 kiểu dữ liệu nên nếu dùng sẽ bị ép toàn bộ số thành văn bản. List không có cấu trúc tọa độ hàng/cột 2 chiều chữ nhật.

##### Bài tập 6.2: Xác định chiều của ma trận/bảng

Cho lệnh tạo bảng:

```r
counts <- data.frame(
  gene_id = c("gene_A", "gene_B", "gene_C", "gene_D"),
  S1 = c(2, 0, 310, 89),
  S2 = c(3, 45, 85, 12),
  S3 = c(1, 12, 0, 640),
  row.names = 1
)
```

Hàm `dim(counts)` trả về kết quả gì?

* **Đáp án:** **b) `4 3`** (4 hàng, 3 cột).
* **Giải thích chuyên sâu:** `dim()` luôn trả về thứ tự `[hàng, cột]`. Tham số `row.names = 1` đã chuyển cột đầu tiên (`gene_id`) thành nhãn tên hàng (*row labels*), do đó số cột dữ liệu chỉ còn lại 3 cột mẫu (`S1`, `S2`, `S3`). Nếu không có `row.names = 1`, kết quả sẽ là `4 4`.

##### Bài tập 6.3: Trích xuất một mẫu dưới dạng Vector

Muốn lấy toàn bộ giá trị số đếm của mẫu `S1` ra dưới dạng một vector thuần túy, câu lệnh nào đúng?

* **Đáp án:** **b) `counts$S1`** (hoặc `counts[["S1"]]`).
* **Giải thích chuyên sâu:** Toán tử `$` hoặc `[[ ]]` bóc tách trực tiếp vector cột ra khỏi bảng. Câu lệnh `counts["S1"]` hoặc `counts[, "S1", drop = FALSE]` sẽ trả về một Data Frame con kích thước $4 \times 1$ chứ không phải vector. Lệnh `counts[1, ]` lấy nhầm thông tin của hàng 1 (gen A trên tất cả các mẫu).

---

### V. QUẢN LÝ THƯ MỤC & ĐỌC/GHI TỆP DỮ LIỆU

#### 1. Cạm bẫy "Mã cứng" đường dẫn tuyệt đối (Hard-coded Absolute Paths)

* Lệnh cơ sở: `getwd()` (lấy thư mục hiện tại), `setwd()` (đặt thư mục làm việc).
* **Cạm bẫy:** Viết đường dẫn tuyệt đối dạng `setwd("/Users/phongdinh/Documents/Project...")` chỉ chạy được duy nhất trên máy tính cá nhân của tác giả. Khi đưa mã nguồn cho đồng nghiệp, người phản biện (*reviewer*) hoặc chạy trên máy chủ đám mây, script lập tức sụp đổ.
* **Đường dẫn tương đối thay đổi theo vị trí đứng:** Nếu chạy script từ thư mục gốc, `file.exists("counts/counts.tsv")` trả về `TRUE`. Nếu di chuyển vào thư mục con, câu lệnh y hệt sẽ trả về `FALSE`.

#### 2. Giải pháp độc lập nền tảng: Gói `here`

Thư viện `here` giải quyết triệt để bài toán đường dẫn bằng cách tự động tìm kiếm tệp neo `.git` hoặc tệp dự án RStudio để xác định thư mục gốc của kho lưu trữ, sau đó xây dựng đường dẫn an toàn:

```r
library(here)

# here tự động ghép nối các phần tử thành đường dẫn chuẩn tắc theo hệ điều hành
f <- here("FCWT_2026", "lecture-06", "counts", "counts.tsv")

# Dù getwd() đang đứng ở bất kỳ thư mục con nào, đường dẫn vẫn luôn chính xác
file.exists(f) # Luôn trả về TRUE
```

#### 3. So sánh các hàm đọc bảng trong R

| Hàm đọc bảng | Ký tự phân cách (`sep`) | Tiêu đề cột (`header`) | Dấu thập phân (`dec`) | Trường hợp sử dụng tối ưu |
| :--- | :---: | :---: | :---: | :--- |
| **`read.delim()`** | `\t` (Tab) | `TRUE` | `.` | **Chuẩn cho ma trận đếm TSV & chú giải gen** |
| **`read.csv()`** | `,` (Phẩy) | `TRUE` | `.` | Tệp bảng tính CSV tiêu chuẩn (quốc tế) |
| **`read.table()`** | `" "` (Khoảng trắng) | `FALSE` | `.` | Bảng định dạng tự do phân cách bằng dấu cách |
| **`read.csv2()`** | `;` (Chấm phẩy) | `TRUE` | `,` | Định dạng số kiểu châu Âu (dấu phẩy thập phân) |
| **`data.table::fread()`** | Tự động nhận diện | `TRUE` | `.` | **Bắt buộc cho tệp lớn (>100 MB), nhanh gấp 100 lần** |

```r
# Nạp ma trận đếm GSE129221 chuẩn mực:
counts <- read.delim(f, row.names = 1)

dim(counts)  # 39376 hàng (gen) x 12 cột (mẫu)
head(counts) # Xem 6 gen đầu tiên
```

> **Điểm mấu chốt:** Luôn khai báo `row.names = 1` khi đọc tệp count matrix. Nếu quên tham số này, cột Entrez Gene ID sẽ bị coi là một cột dữ liệu, làm tăng kích thước thành 13 cột và gây nguy cơ ép kiểu toàn bộ ma trận số thành ký tự.

---

### VI. THỰC HÀNH: XÂY DỰNG BẢNG METADATA & CHUẨN HÓA MẪU

#### 1. Đặt bài toán Metadata

Cột của ma trận đếm hiện tại mang tên truy cập GEO: `GSM3702795` $\dots$ `GSM3702806`. Ta cần xây dựng một bảng `sample_info` hoàn chỉnh gồm 12 hàng tương ứng với thiết kế thí nghiệm:

| sample_id | cell_line | treatment | replicate |
| :--- | :--- | :--- | :---: |
| GSM3702795 | PC9 | Control | 1 |
| GSM3702796 | PC9 | Control | 2 |
| GSM3702797 | PC9 | Control | 3 |
| GSM3702798 | PC9 | Apatinib | 1 |
| GSM3702799 | PC9 | Apatinib | 2 |
| GSM3702800 | PC9 | Apatinib | 3 |
| GSM3702801 | PC9GR | Control | 1 |
| GSM3702802 | PC9GR | Control | 2 |
| GSM3702803 | PC9GR | Control | 3 |
| GSM3702804 | PC9GR | Apatinib | 1 |
| GSM3702805 | PC9GR | Apatinib | 2 |
| GSM3702806 | PC9GR | Apatinib | 3 |

#### 2. Kỹ thuật tạo Vector bằng hàm `rep()`: Phân biệt `times` vs `each`

Hàm `rep(x, times, each)` có hai đối số then chốt không thể thay thế lẫn nhau:

* `times`: Nhân bản **toàn bộ khối vector** $n$ lần liên tiếp.
* `each`: Lặp lại **từng phần tử đơn lẻ** $n$ lần liên tiếp trước khi sang phần tử tiếp theo.

```r
rep(c("A", "B"), times = 3) # Kết quả: "A" "B" "A" "B" "A" "B"
rep(c("A", "B"), each = 3)  # Kết quả: "A" "A" "A" "B" "B" "B"
```

#### 3. Quy trình kiến tạo 4 Vector thành phần

```r
# Cột 1: Lấy danh sách ID mẫu trực tiếp từ tên cột của ma trận đếm
sample_id <- colnames(counts)

# Cột 2: Dòng tế bào - 6 mẫu PC9 liên tiếp, theo sau bởi 6 mẫu PC9GR
cell_line <- rep(c("PC9", "PC9GR"), each = 6)

# Cột 3: Xử lý thuốc - Cụm (3 Control, 3 Apatinib) lặp lại 2 lần (cho 2 dòng tế bào)
treatment <- rep(c("Control", "Apatinib"), times = 2, each = 3)

# Cột 4: Lần lặp sinh học - Dãy 1, 2, 3 lặp lại 4 lần cho 4 nhóm thí nghiệm
replicate <- rep(1:3, times = 4)
```

#### 4. Đóng gói Data Frame & Xuất tệp Metadata

```r
# Ghép 4 vector có cùng độ dài 12 thành một Data Frame hoàn chỉnh
sample_info <- data.frame(
  sample_id = sample_id,
  cell_line = cell_line,
  treatment = treatment,
  replicate = replicate
)

# Xuất bảng metadata ra tệp CSV:
# BẮT BUỘC đặt row.names = FALSE vì các chỉ số 1..12 tự động không mang ý nghĩa sinh học
write.csv(sample_info, "sample_metadata.csv", row.names = FALSE)
```

#### 5. Chuẩn hóa tên cột Ma trận đếm bằng `paste()`

Để ma trận đếm hiển thị trực quan thay cho các mã GSM khô khan, ta ghép nối thông tin sinh học thành nhãn mới:

```r
# Hàm paste() ghép các vector theo từng vị trí tương ứng
# Luôn đặt sep = "_" tường minh để tránh khoảng trắng mặc định
new_sample_names <- paste(sample_info$cell_line,
                          sample_info$treatment,
                          sample_info$replicate,
                          sep = "_")

# Kết quả:
# "PC9_Control_1"    "PC9_Control_2"    "PC9_Control_3" 
# "PC9_Apatinib_1"   "PC9_Apatinib_2"   "PC9_Apatinib_3"
# "PC9GR_Control_1"  "PC9GR_Control_2"  "PC9GR_Control_3"
# "PC9GR_Apatinib_1" "PC9GR_Apatinib_2" "PC9GR_Apatinib_3"

# Gán trực tiếp nhãn mới vào colnames của counts
colnames(counts) <- new_sample_names

# Lưu ma trận đếm đã chuẩn hóa tên cột ra đĩa
# LƯU Ý: Ở đây row.names = TRUE để giữ lại danh sách Entrez Gene ID
write.table(counts, "counts_sample_name_merge.tsv", sep = "\t", row.names = TRUE)
```

---

### VII. BÀI TẬP VỀ NHÀ & LỜI GIẢI: ÁNH XẠ CHÚ GIẢI GEN (`annotate_gene.R`)

#### 1. Đặt bài toán
Sau khi chuẩn hóa tên cột mẫu, ma trận `counts_sample_name_merge.tsv` vẫn mang chỉ số hàng là các mã số **Entrez Gene ID** khó tra cứu. Nhiệm vụ của học viên là viết một R script độc lập mang tên `annotate_gene.R` để chuyển đổi ma trận sang định dạng có kèm mã gen chuẩn quốc tế (**Gene Symbol**).

#### 2. Dữ liệu đầu vào
1. `counts_sample_name_merge.tsv`: Ma trận đếm đã đổi tên cột.
2. `Human.GRCh38.p13.annot.tsv`: Tệp chú giải hệ gen người từ NCBI, gồm các cột: `GeneID`, `Symbol`, `Description`.

#### 3. Kết quả kỳ vọng (`counts_annotated.tsv`)
```
GeneID       Symbol        PC9_Control_1   PC9_Control_2   PC9_Apatinib_1  ...
100287102    DDX11L1       2               3               2               ...
653635       WASH7P        531             485             433             ...
102466751    MIR6859-1     14              13              14              ...
107985730    MIR1302-2HG   1               1               0               ...
```

#### 4. Lời giải hoàn chỉnh (`annotate_gene.R`)
```r
#!/usr/bin/env Rscript
# ==============================================================================
# Script: annotate_gene.R
# Mục tiêu: Ánh xạ Entrez Gene ID sang Gene Symbol cho ma trận đếm GSE129221
# ==============================================================================

library(here)

# 1. Định vị đường dẫn tệp độc lập nền tảng
counts_file <- here("data", "counts_sample_name_merge.tsv")
annot_file  <- here("annotation", "Human.GRCh38.p13.annot.tsv")

# 2. Đọc dữ liệu vào R
# counts: Đọc row.names = 1 để lấy Entrez Gene ID làm nhãn dòng
counts <- read.delim(counts_file, row.names = 1, check.names = FALSE)
annot  <- read.delim(annot_file, stringsAsFactors = FALSE)

# 3. Kiểm tra tính toàn vẹn của bảng chú giải
cat(sprintf("Tổng số gen trong counts: %d dòng\n", nrow(counts)))
cat(sprintf("Tổng số bản ghi trong annotation: %d dòng\n", nrow(annot)))
cat(sprintf("Cột GeneID trong annotation có trùng lặp không? %s\n", 
            ifelse(any(duplicated(annot$GeneID)), "CÓ (Cần lọc)", "KHÔNG (Duy nhất)")))

# 4. Tìm kiếm chỉ mục ánh xạ bằng hàm match()
# match(x, table): Tìm vị trí xuất hiện đầu tiên của từng phần tử trong rownames(counts) tại annot$GeneID
match_idx <- match(rownames(counts), annot$GeneID)

# 5. Kiểm tra chất lượng ánh xạ
unmatched_genes <- sum(is.na(match_idx))
if (unmatched_genes == 0) {
  cat("Ánh xạ thành công 100%! Không có gen nào bị khuyết thiếu (unmatched).\n")
} else {
  cat(sprintf("Cảnh báo: Có %d gen không tìm thấy trong tệp chú giải.\n", unmatched_genes))
}

# 6. Đóng gói kết quả thành Data Frame có Symbol ở cột thứ hai
counts_annotated <- data.frame(
  GeneID = rownames(counts),
  Symbol = annot$Symbol[match_idx],
  counts,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# 7. Xuất ma trận đếm đã chú giải ra tệp TSV
output_file <- here("data", "counts_annotated.tsv")
write.table(counts_annotated, file = output_file, sep = "\t", row.names = FALSE, quote = FALSE)
cat(sprintf("Đã lưu kết quả thành công tại: %s\n", output_file))
```

---

### VIII. NGUYÊN LÝ VECTORIZATION & GIA ĐÌNH HÀM APPLY (THE APPLY FAMILY)

#### 1. Đặt vấn đề: Tại sao vòng lặp `for` thất bại trước dữ liệu Big Data?
Trong tin sinh học, ma trận đếm RNA-seq thường có quy mô rất lớn ($39.376$ gen $\times$ hàng chục mẫu trong bulk RNA-seq, hoặc hàng nghìn tế bào/spot trong scRNA-seq và Spatial Transcriptomics). 

Nếu dùng vòng lặp `for` để tính trung bình hoặc độ lệch chuẩn của từng gen:
```r
# CÁCH TIẾP CẬN NGUY HIỂM & CHẬM CHẠP
gene_means <- numeric(nrow(counts))
for (i in 1:nrow(counts)) {
  gene_means[i] <- mean(as.numeric(counts[i, ]))
}
```
* **Nhược điểm nghiêm trọng:** R là ngôn ngữ thông dịch (interpreted language). Vòng lặp `for` buộc R phải cấp phát lại bộ nhớ, kiểm tra kiểu dữ liệu và gọi hàm `mean()` hàng chục nghìn lần, dẫn đến thời gian thực thi kéo dài và tràn bộ nhớ RAM.
* **Giải pháp chuẩn mực:** Áp dụng **Vectorization** và gia đình hàm **`apply`**, cho phép đẩy toàn bộ vòng lặp xuống tầng biên dịch C/Fortran của R với tốc độ xử lý nhanh hơn từ 10 đến 100 lần.

```
       VÒNG LẶP FOR TRUYỀN THỐNG                   GIA ĐÌNH HÀM APPLY (VECTORIZED)
  ┌─────────────────────────────────┐           ┌─────────────────────────────────┐
  │ Lặp từng gen i = 1, 2, ..., N   │           │ Đẩy toàn bộ ma trận/khối dữ liệu│
  │ Kiểm tra kiểu dữ liệu R mỗi lần │           │ xuống tầng mã nguồn C/Fortran   │
  │ Cấp phát lại bộ nhớ liên tục    │           │ Tính toán song song trên vector │
  │ => Chậm chạp, dễ tràn RAM      │           │ => Tốc độ tức thì, tối ưu RAM   │
  └─────────────────────────────────┘           └─────────────────────────────────┘
```

#### 2. Hàm `apply()` trên Ma trận 2D
Cú pháp cơ sở: `apply(X, MARGIN, FUN, ...)`
* `X`: Ma trận hoặc Data Frame số thực.
* `MARGIN`: Chiều không gian áp dụng phép toán:
  * `MARGIN = 1`: Áp dụng theo từng **Hàng** (Row) — thường dùng để tính toán theo từng gen.
  * `MARGIN = 2`: Áp dụng theo từng **Cột** (Column) — thường dùng để tính toán theo từng mẫu giải trình tự.
* `FUN`: Tên hàm muốn áp dụng (`mean`, `sd`, `median`, `sum`, ...).

```r
# Loại bỏ 2 cột định danh (GeneID và Symbol) để lấy ma trận số thuần túy
counts_matrix <- as.matrix(counts_annotated[, -(1:2)])

# MARGIN = 1: Tính trung bình biểu hiện của từng gen qua 12 mẫu
gene_means <- apply(counts_matrix, MARGIN = 1, FUN = mean)

# MARGIN = 2: Tính tổng số đọc giải trình tự (Library Size) của từng mẫu
library_sizes <- apply(counts_matrix, MARGIN = 2, FUN = sum)
```

#### 3. Bộ đôi hàm nguyên thủy siêu tốc: `rowMeans()` & `colMeans()`
Đối với các phép toán cơ bản như tính tổng (`sum`) hoặc trung bình (`mean`), Base R cung cấp các hàm nội tại viết bằng C thuần túy:
* `rowMeans(X)` / `colMeans(X)`: Nhanh hơn `apply(X, 1, mean)` gấp nhiều lần.
* `rowSums(X)` / `colSums(X)`: Nhanh hơn `apply(X, 2, sum)` gấp nhiều lần.

```r
# Tính trung bình biểu hiện của từng gen siêu tốc
fast_gene_means <- rowMeans(counts_matrix)

# Tính tổng số đọc của từng mẫu siêu tốc
fast_sample_totals <- colSums(counts_matrix)
```

#### 4. Hàm `lapply()`: Duyệt qua List và luôn trả về List
`lapply(X, FUN, ...)` nhận đầu vào là một List hoặc Vector, áp dụng hàm `FUN` lên từng phần tử và **luôn luôn trả về kết quả dưới dạng List**.

```r
# Danh sách chứa số đọc của 4 mẫu
sample_reads <- list(
  S1 = c(2, 4, 6),
  S2 = c(10, 20, 30),
  S3 = c(100, 200, 300)
)

# Áp dụng căn bậc hai lên từng vector trong list
sqrt_reads <- lapply(sample_reads, sqrt)
# Kết quả trả về là một List gồm 3 phần tử
```

#### 5. Hàm `sapply()`: Tự động đơn giản hóa (Simplify)
`sapply()` hoạt động tương tự `lapply()`, nhưng tự động đơn giản hóa cấu trúc dữ liệu đầu ra:
* Nếu mỗi phần tử trả về một giá trị vô hướng $\rightarrow$ Gom thành một **Atomic Vector**.
* Nếu mỗi phần tử trả về một vector cùng độ dài $\rightarrow$ Gom thành một **Matrix**.
* Nếu các phần tử có kích thước khác nhau $\rightarrow$ Giữ nguyên dưới dạng **List**.

```r
# Tính trung bình số đọc của từng mẫu
sample_means_vec <- sapply(sample_reads, mean)
# Kết quả: Vector c(S1 = 4, S2 = 20, S3 = 200)
```

#### 6. Hàm `tapply()`: Phân nhóm thống kê sinh học (Grouping Factor)
`tapply(X, INDEX, FUN)` nhận vào một vector dữ liệu `X`, một vector phân loại `INDEX` (Factor), và áp dụng hàm `FUN` lên từng nhóm dữ liệu riêng biệt.

```r
# Ví dụ: Tính trung bình số đọc theo nhóm can thiệp (Control vs Apatinib)
sample_means <- colMeans(counts_matrix) # Vector 12 giá trị trung bình của 12 mẫu
treatment_group <- sample_info$treatment # Factor: 6 Control, 6 Apatinib

# Gom nhóm tính trung bình theo treatment
treatment_avg <- tapply(sample_means, treatment_group, mean)
# Kết quả:
#  Apatinib   Control 
#  1245.30    1890.50
```

#### 7. Bảng tổng hợp so sánh gia đình hàm `apply`

| Tên hàm | Cấu trúc đầu vào (`X`) | Chiều thao tác (`MARGIN`) | Định dạng đầu ra | Tình huống sử dụng thực tế trong Transcriptomics |
| :--- | :--- | :--- | :--- | :--- |
| **`apply()`** | Matrix / 2D Data Frame | `1` (Hàng), `2` (Cột) | Vector / Matrix / List | Tính mean/sd của gen trên hàng, tính library size trên cột. |
| **`lapply()`** | List / Vector | Không có | **Luôn luôn là List** | Duyệt qua danh sách nhiều file đếm hoặc danh sách gene set. |
| **`sapply()`** | List / Vector | Không có | Vector / Matrix (nếu được) | Trích xuất nhanh thông số tóm tắt từ danh sách mô hình hồi quy. |
| **`tapply()`** | Vector 1 chiều | Factor nhóm (`INDEX`) | Vector / Array | Tính giá trị trung bình theo nhóm đối chứng, bệnh lý, cell type. |
| **`rowMeans()`** | Matrix thuần số | Cố định Hàng | Vector 1 chiều | Tính nhanh biểu hiện cơ bản của gen (Tối ưu C, cực nhanh). |
| **`colSums()`** | Matrix thuần số | Cố định Cột | Vector 1 chiều | Tính Library Size hoặc Sequencing Depth của từng mẫu. |

#### 8. Tổng kết bài tập trắc nghiệm tại lớp (Exercises 6.4 – 6.6)
* **Bài tập 6.4 (MARGIN trong apply):** Muốn tính trung bình của từng mẫu giải trình tự (nằm ở các cột), ta chọn tham số nào?
  * *Đáp án đúng:* `apply(counts, MARGIN = 2, mean)`. Vì `MARGIN = 2` tương ứng với chiều cột.
* **Bài tập 6.5 (Định dạng trả về của `lapply`):** Hàm `lapply()` luôn trả về cấu trúc dữ liệu nào?
  * *Đáp án đúng:* Luôn luôn là **List**, đảm bảo độ tin cậy tuyệt đối về kiểu dữ liệu khi làm việc với các phần tử có chiều dài không đều nhau.
* **Bài tập 6.6 (Gom nhóm tapply):** Muốn gom 12 mẫu thành 2 nhóm `Control` và `Apatinib` để so sánh mức biểu hiện trung bình của thuốc, dùng hàm nào?
  * *Đáp án đúng:* `tapply(sample_means, treatment, mean)`.

---

### IX. XỬ LÝ CHUỖI KÝ TỰ & BIỂU THỨC CHÍNH QUY (STRINGS & REGEX)

Trong tin sinh học, việc làm sạch nhãn mẫu (sample label), tiền tố gen chuột/người (`hsa-`, `mmu-`), và các ký tự phân tách là nhiệm vụ thường nhật.

#### 1. Tìm kiếm chuỗi với `grep()`
* `grep(pattern, x, value = FALSE, invert = FALSE)`:
  * `value = FALSE` (mặc định): Trả về vector các **vị trí chỉ mục** (index).
  * `value = TRUE`: Trả về trực tiếp các **chuỗi ký tự** khớp mẫu.
  * `invert = TRUE`: Đảo ngược điều kiện, lấy các phần tử **không** khớp mẫu.

```r
genes <- c("ACTB_human", "Actb_mouse", "Cd8a_mouse", "GAPDH_human", "IL6_human")

# Tìm các gen có chứa chuỗi "mouse"
grep("mouse", genes)               # Trả về: c(2, 3)
grep("mouse", genes, value = TRUE) # Trả về: c("Actb_mouse", "Cd8a_mouse")

# Lọc chỉ lấy các gen của người (loại trừ mouse)
human_genes <- grep("mouse", genes, value = TRUE, invert = TRUE)
# Trả về: c("ACTB_human", "GAPDH_human", "IL6_human")
```

#### 2. Thay thế chuỗi: Phân biệt `sub()` vs `gsub()`
* `sub(pattern, replacement, x)`: Chỉ thay thế **lần xuất hiện đầu tiên** của mẫu trong mỗi chuỗi.
* `gsub(pattern, replacement, x)`: Thay thế **toàn bộ tất cả các lần xuất hiện** của mẫu trong chuỗi (*Global Substitution*).

```r
raw_labels <- c("sample-01-control", "sample-02-treated", "sample-03-control")

# Dùng sub: Chỉ bỏ dấu gạch ngang đầu tiên
sub("-", "_", raw_labels)
# Kết quả: "sample_01-control"  "sample_02-treated"  "sample_03-control"

# Dùng gsub: Thay toàn bộ dấu gạch ngang thành gạch dưới
gsub("-", "_", raw_labels)
# Kết quả: "sample_01_control"  "sample_02_treated"  "sample_03_control"
```

#### 3. Các hàm chuẩn hóa chuỗi ký tự thiết yếu
* `toupper(x)` / `tolower(x)`: Chuyển toàn bộ chuỗi sang chữ IN HOA hoặc in thường. Rất quan trọng khi đối chiếu Gene Symbol giữa người (IN HOA: `TP53`, `EGFR`) và chuột (Viết hoa chữ đầu: `Trp53`, `Egfr`).
* `nchar(x)`: Đếm số lượng ký tự trong chuỗi.
* `trimws(x)`: Cắt bỏ khoảng trắng dư thừa ở đầu và cuối chuỗi (*whitespace*). Khoảng trắng ẩn là nguyên nhân hàng đầu khiến hàm `match()` hoặc `merge()` thất bại thầm lặng.

```r
# Cắt bỏ khoảng trắng ẩn nguy hiểm
gene_with_space <- " EGFR "
clean_gene <- trimws(gene_with_space) # "EGFR"
```

#### 4. Biểu thức chính quy (Regex) & Quy tắc thoát ký tự `\\.`
Trong Regex, ký tự dấu chấm `.` mang ý nghĩa là **ký tự đại diện cho bất kỳ ký tự nào** (*wildcard*).

* Nếu muốn tìm kiếm chính xác dấu chấm văn bản (ví dụ tìm phiên bản isoform `HLA-A.1`), ta bắt buộc phải sử dụng **`\\.`** để thoát nghĩa (*escape*).
* **Lý do có 2 dấu gạch chéo ngược:**
  1. Dấu `\` thứ nhất là ký tự thoát của chuỗi ký tự R (*R string escape*).
  2. Dấu `\` thứ hai là ký tự thoát của bộ máy Regex (*Regex engine escape*).

```r
transcripts <- c("HLA-A.1", "HLA-A1", "HLA-B.1", "HLA-B2")

# SAI: Dấu chấm bắt cả chữ "1" và bất kỳ ký tự nào
grep("HLA-A.1", transcripts, value = TRUE) # Bắt cả HLA-A.1 và HLA-A1

# ĐÚNG: Thoát nghĩa chính xác dấu chấm thực tế
grep("HLA-A\\.1", transcripts, value = TRUE) # Chỉ bắt duy nhất "HLA-A.1"
```

---

### X. QUẢN LÝ DỮ LIỆU KHUYẾT THIẾU (MISSING DATA & SPATIAL QC)

#### 1. Nhận diện và kiểm kê giá trị `NA`
Trong R, giá trị khuyết thiếu được biểu diễn bằng hằng số logic đặc biệt `NA` (*Not Available*). Mọi phép toán số học thực hiện trực tiếp trên `NA` đều trả về `NA` (*NA propagation*).

```r
exp_values <- c(10, 25, NA, 40, NA, 55)

# Kiểm tra từng phần tử
is.na(exp_values) # FALSE FALSE  TRUE FALSE  TRUE FALSE

# Đếm tổng số giá trị NA
sum(is.na(exp_values)) # 2

# Lập bảng phân bố tần số
table(is.na(exp_values))
# FALSE  TRUE 
#     4     2 
```

#### 2. Các chiến lược xử lý dữ liệu khuyết thiếu

```r
# Chiến lược 1: Bỏ qua NA trong các hàm thống kê bằng na.rm = TRUE
mean_val <- mean(exp_values, na.rm = TRUE) # 32.5

# Chiến lược 2: Lọc các dòng hoàn chỉnh bằng complete.cases()
clean_values <- exp_values[complete.cases(exp_values)]

# Chiến lược 3: Loại bỏ NA trên bảng dữ liệu bằng na.omit()
df <- data.frame(Gene = c("A", "B", "C"), Count = c(10, NA, 30))
clean_df <- na.omit(df)
```

#### 3. Bản chất sinh học sống còn: Phân biệt `NA` và `0`
Người làm phân tích tin sinh học bắt buộc phải phân biệt rõ ràng hai khái niệm này:
* **Giá trị `0` (Zero Expression):** Gen thực sự không phiên mã trong tế bào hoặc số lượng phiên mã quá thấp nằm dưới ngưỡng nhạy của máy giải trình tự (*technical dropout*). Giá trị 0 mang đầy đủ ý nghĩa sinh học hợp lệ.
* **Giá trị `NA` (Missing / Undetected):** Lỗi đọc kỹ thuật, mẫu bị hỏng, hoặc trong **Spatial Transcriptomics**, spot đo lường nằm hoàn toàn ngoài phạm vi của lát cắt mô sinh học (*out-of-tissue spot*).

> [!CAUTION]
> **Tuyệt đối không tự ý thay thế `NA` bằng `0`!**
> Việc ép toàn bộ `NA` về `0` sẽ làm tăng mẫu số giả tạo khi tính trung bình thư viện, kéo tụt mức biểu hiện biểu kiến của các gen khác và làm sai lệch hoàn toàn mô hình phân tích sai khác biểu hiện (DEG).

#### 4. Thực hành Pipeline kiểm định chất lượng không gian (Spatial QC Filtering)
Trong dữ liệu Spatial Transcriptomics, mỗi spot cần thỏa mãn 2 điều kiện QC:
1. Tổng số phân tử UMI đọc được phải lớn hơn ngưỡng tối thiểu (`UMI > 500`).
2. Tỷ lệ gen ty thể phải thấp hơn ngưỡng tế bào chết (`% Mito < 10%`).

```r
# Tạo bảng mô phỏng dữ liệu QC không gian
spatial_qc <- data.frame(
  Spot = paste0("Spot_", 1:5),
  UMI_count = c(650, 420, 1200, 310, 890),
  pct_mito  = c(2.5, 12.0, 4.1, 15.5, 3.8)
)

# Thiết lập cờ đánh giá Pass/Fail
spatial_qc$QC_pass <- spatial_qc$UMI_count >= 500 & spatial_qc$pct_mito < 10

# Lọc chỉ giữ lại các spot đạt chuẩn
filtered_spots <- spatial_qc[spatial_qc$QC_pass == TRUE, ]
cat(sprintf("Số spot vượt qua QC: %d / %d (%.1f%%)\n",
            nrow(filtered_spots), nrow(spatial_qc), 
            (nrow(filtered_spots)/nrow(spatial_qc))*100))
```

---

### XI. THIẾT KẾ HÀM TỰ TẠO CHUYÊN NGHIỆP (CUSTOM FUNCTIONS & INPUT VALIDATION)

Khi một chuỗi xử lý tính toán sinh học được lặp lại từ 3 lần trở lên, thực hành tốt nhất là đóng gói chuỗi lệnh đó thành một hàm (*Custom Function*).

#### 1. Cú pháp cơ bản và Đối số mặc định
```r
# Cú pháp tổng quát:
ten_ham <- function(doi_so_1, doi_so_2 = gia_tri_mac_dinh) {
  # Khối lệnh tính toán
  return(ket_qua)
}
```

#### 2. Cơ chế trả về: `return()` tường minh vs Biểu thức cuối cùng
* R mặc định tự động trả về giá trị của biểu thức cuối cùng được tính toán trong hàm.
* Tuy nhiên, theo quy chuẩn **R Style Guide**, luôn khuyến nghị sử dụng lệnh `return()` tường minh để người đọc dễ dàng xác định điểm xuất dữ liệu và tránh lỗi khi gán biến trung gian ở dòng cuối.
* Khi muốn trả về **nhiều giá trị khác nhau** (ví dụ vừa trả về ma trận kết quả, vừa trả về thông số thống kê), bắt buộc phải đóng gói các giá trị đó vào một **Named List**.

```r
# Hàm trả về nhiều giá trị thông qua named list
calc_summary <- function(vec) {
  res_mean <- mean(vec, na.rm = TRUE)
  res_sd   <- sd(vec, na.rm = TRUE)
  
  return(list(
    mean = res_mean,
    sd   = res_sd,
    n    = length(vec)
  ))
}
```

#### 3. Kiểm định an toàn dữ liệu đầu vào (Input Validation) bằng `stop()`
Một hàm tin sinh học chuẩn mực phải chủ động ngăn chặn các dữ liệu rác trước khi đưa vào mô hình tính toán bằng hàm `stop()`.

```r
# Hàm tính CPM có kiểm tra an toàn dữ liệu
calculate_cpm <- function(counts, lib_size = NULL) {
  # 1. Kiểm tra định dạng dữ liệu
  if (!is.numeric(counts)) {
    stop("Lỗi nghiêm trọng: Đầu vào 'counts' bắt buộc phải là kiểu số (numeric)!")
  }
  
  # 2. Tự động tính library size nếu không cung cấp
  if (is.null(lib_size)) {
    lib_size <- sum(counts)
  }
  
  # 3. Kiểm tra kích thước thư viện hợp lệ
  if (lib_size <= 0) {
    stop("Lỗi: Tổng kích thước thư viện (library size) phải là số dương lớn hơn 0!")
  }
  
  # 4. Tính toán CPM
  cpm_values <- (counts / lib_size) * 1e6
  return(cpm_values)
}
```

#### 4. Ứng dụng thực tế: Hàm tính tỷ lệ đọc gen ty thể (% Mitochondrial Reads)
```r
calculate_pct_mito <- function(counts_mat, gene_names) {
  # Tìm các gen ty thể (bắt đầu bằng MT- hoặc mt-)
  mito_idx <- grep("^(MT-|mt-)", gene_names)
  
  if (length(mito_idx) == 0) {
    warning("Không tìm thấy gen ty thể nào khớp với mẫu '^(MT-|mt-)'!")
    return(rep(0, ncol(counts_mat)))
  }
  
  mito_counts  <- colSums(counts_mat[mito_idx, , drop = FALSE])
  total_counts <- colSums(counts_mat)
  
  pct_mito <- (mito_counts / total_counts) * 100
  return(pct_mito)
}
```

---

### XII. TỔNG HỢP HỎI - ĐÁP TRONG LỚP (Q&A SESSION)

* **Hỏi:** *Trong tệp chú giải gen `Human.GRCh38.p13.annot.tsv`, nếu cột `GeneID` là duy nhất (`unique`) thì ta nên dùng `merge()` hay `match()` để ghép vào ma trận đếm?*
  * **Đáp:** Cả hai cách đều khả thi. Tuy nhiên, trong xử lý ma trận đếm sinh học quy mô lớn (hàng chục nghìn gen), phương pháp dùng `match()` kết hợp chỉ mục vector thường được ưu tiên hơn vì:
    1. Giữ nguyên vẹn 100% trật tự sắp xếp dòng vốn có của ma trận đếm ban đầu.
    2. Tốc độ thực thi trên bộ nhớ RAM nhanh hơn so với thuật toán ghép nối bảng tổng quát của `merge()`.
* **Hỏi:** *Tại sao khi tạo ma trận bằng `matrix()`, R lại tự động điền giá trị theo cột (`byrow = FALSE`) thay vì điền theo hàng như người dùng thường hình dung?*
  * **Đáp:** Đây là đặc trưng thiết kế kế thừa từ ngôn ngữ Fortran của R. Trong bộ nhớ máy tính, ma trận R thực chất chỉ là một atomic vector 1 chiều dài được gắn thêm thuộc tính kích thước (`dim`). Cách lưu trữ theo thứ tự cột (*Column-major*) giúp việc trích xuất và tính toán thống kê trên từng cột mẫu diễn ra với hiệu năng phần cứng tối ưu nhất.
* **Hỏi:** *Tại sao khi lưu bảng metadata ta lại bắt buộc phải đặt `row.names = FALSE`, trong khi lưu ma trận đếm lại phải đặt `row.names = TRUE`?*
  * **Đáp:**
    * Với bảng metadata (`sample_info`), nhãn hàng mặc định của R chỉ là các số đếm thứ tự tự động `1, 2, ..., 12`. Nếu lưu `row.names = TRUE`, tệp CSV sẽ bị dư thừa một cột số đầu tiên không có tiêu đề, gây lệch cột khi nạp vào các phần mềm khác.
    * Ngược lại, với ma trận đếm (`counts`), nhãn hàng chính là **Entrez Gene ID** mang thông tin nhận diện gen cốt tử. Nếu đặt `row.names = FALSE`, toàn bộ định danh gen sẽ bị xóa sạch khỏi tệp và ma trận mất hoàn toàn giá trị khoa học.
* **Hỏi:** *Một custom function trong R có thể trả về (`return`) nhiều giá trị cùng lúc như Python tuple được không?*
  * **Đáp:** Trong R, hàm chỉ có thể trả về một đối tượng đơn lẻ duy nhất tại lệnh `return()`. Tuy nhiên, để trả về nhiều giá trị khác nhau (ví dụ: vừa trả về tổng, vừa trả về tích, hoặc trả về ma trận kèm vector thống kê), giải pháp chuẩn mực là đóng gói toàn bộ các đối tượng đó vào một **Named List** (ví dụ: `return(list(sum = a + b, prod = a * b))`). Phía người gọi hàm có thể dễ dàng trích xuất từng thành phần qua toán tử `$`.
* **Hỏi:** *Khi phân tích biểu hiện gen sai khác (DEG), tại sao lại tính `rowMeans` mà không phải `colMeans`?*
  * **Đáp:** Mỗi hàng đại diện cho một gen, và mỗi cột đại diện cho một mẫu giải trình tự. Để biết mức độ hoạt động trung bình của một gen qua các điều kiện thí nghiệm, ta phải tính trung bình dọc theo hàng ngang của gen đó qua các cột mẫu (`rowMeans`). Ngược lại, `colMeans` tính trung bình số đọc của toàn bộ các gen trong một mẫu, dùng để đánh giá chất lượng thư viện của mẫu đó.
* **Hỏi:** *Tại sao trong biểu thức chính quy (Regex) của R, khi muốn tìm dấu chấm `.` lại phải viết hai dấu gạch chéo ngược `\\.` thay vì một?*
  * **Đáp:** Trong R, dấu gạch chéo `\` là ký tự thoát (*escape*) của kiểu chuỗi văn bản. Nếu viết `\.`, R sẽ báo lỗi cú pháp vì `\.` không phải là ký tự thoát hợp lệ của R (như `\n` hay `\t`). Do đó, dấu `\` thứ nhất dùng để bảo toàn dấu `\` thứ hai khi biên dịch chuỗi, giúp bộ máy Regex nhận được chính xác ký tự `\.` để thoát nghĩa ký tự wildcard của dấu chấm.
* **Hỏi:** *Tại sao giảng viên khuyến cáo không nên chạy dữ liệu RNA-seq thực tế quy mô lớn trên Google Colab miễn phí mà nên cài đặt R trực tiếp trên máy trạm cá nhân?*
  * **Đáp:** Phiên làm việc (runtime) của Google Colab miễn phí bị giới hạn thời gian (timeout ngắt kết nối tự động), bộ nhớ RAM thấp (~12 GB), và toàn bộ tệp tạm trên ổ đĩa ảo sẽ bị xóa sạch ngay khi phiên bị ngắt. Các tệp ma trận đếm sinh học, tệp FASTQ và phân tích giải trình tự không gian đòi hỏi hàng chục GB RAM và chạy hàng giờ liên tục. Việc chạy trên môi trường Linux/Ubuntu cá nhân giúp chủ động 100% tài nguyên phần cứng và lưu trữ bền vững.

---

### XIII. TỔNG KẾT CỐT LÕI & QUY TẮC THỰC HÀNH (KEY TAKEAWAYS)

1. **Quy tắc 1-based Indexing:** Ngôn ngữ R đánh chỉ số bắt đầu từ số 1. Chỉ số `0` không tồn tại; chỉ số âm `[-i]` dùng để loại bỏ phần tử thứ $i$.
2. **Quy tắc Dấu phẩy trong Subsetting:** Cú pháp trích xuất 2 chiều luôn tuân thủ nguyên tắc `[hàng muốn lấy , cột muốn lấy]`. Để trống bên nào là lấy trọn vẹn toàn bộ bên đó.
3. **Quy tắc Lặp Vector `rep()`:** Phân biệt rõ `each` (giữ các giá trị giống nhau nằm liền kề nhau) và `times` (lặp lại nguyên chu kỳ của toàn bộ khối vector).
4. **Quy tắc Đường dẫn & Tính tái lập:** Tuyệt đối không hard-code đường dẫn tuyệt đối. Luôn sử dụng dấu gạch chéo xuôi `/` và neo vị trí tệp bằng thư viện `here`.
5. **Quy tắc Kiểm tra Dữ liệu 90 giây:** Luôn thực thi bộ ba lệnh `head()`, `dim()`, `str()` ngay sau khi nạp bất kỳ tệp dữ liệu nào vào phiên làm việc.
6. **Quy tắc An toàn Dòng lệnh Bash:** Khi viết script tự động hóa thu thập dữ liệu sinh học, luôn đặt cờ an toàn `set -euo pipefail` ngay đầu tệp để kiểm soát lỗi tức thì.
7. **Quy tắc Vectorization thay thế For-loop:** Tuyệt đối không dùng vòng lặp `for` để tính toán trên từng gen trong ma trận lớn. Luôn ưu tiên bộ đôi siêu tốc `rowMeans()` / `colMeans()` hoặc gia đình hàm `apply()`.
8. **Quy tắc Chiều Thao Tác MARGIN:** Khi sử dụng `apply()`, luôn khắc ghi `MARGIN = 1` là thao tác theo từng **Hàng** (gen) và `MARGIN = 2` là thao tác theo từng **Cột** (mẫu).
9. **Quy tắc Thay thế Chuỗi `sub` vs `gsub`:** Dùng `sub()` khi chỉ cần xóa tiền tố đầu tiên; dùng `gsub()` khi cần làm sạch triệt để mọi ký tự đặc biệt trên toàn bộ chuỗi.
10. **Quy tắc Bản chất Sinh học của Missing Data:** Không bao giờ tự tiện gán `NA = 0`. Phải phân biệt rõ `0` (gen không biểu hiện hoặc dropout) với `NA` (lỗi kỹ thuật hoặc spot ngoài mô).
11. **Quy tắc Kiểm định Đầu vào Hàm (Input Validation):** Mọi custom function sinh học đều phải bắt đầu bằng các khối kiểm tra logic và ngắt lỗi bằng `stop()` để ngăn ngừa lỗi tính toán ngầm định.
12. **Quy tắc Đóng gói Nhiều Giá trị Trả về:** Khi một hàm cần xuất nhiều kết quả phân tích, luôn đóng gói vào một **Named List** để mã nguồn rõ ràng, an toàn và dễ tái sử dụng.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.

