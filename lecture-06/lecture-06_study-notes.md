# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026

## BÀI 06: QUẢN LÝ & BIẾN ĐỔI DỮ LIỆU TRONG R (R DATA MANIPULATION & MANAGEMENT) – PHẦN 1

### CẤU TRÚC DỮ LIỆU, ĐỌC/GHI TỆP, XÂY DỰNG METADATA & BASH PIPELINE

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

---

### I. TỔNG QUAN BÀI HỌC (OVERVIEW & OBJECTIVES)

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026).
* **Bài giảng:** Buổi 06 (Phần 1): R Data Manipulation & Management (Quản lý & Thao tác dữ liệu trong R).
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

### VII. BÀI TẬP VỀ NHÀ: ÁNH XẠ CHÚ GIẢI GEN (`annotate_gene.R`)

#### Đặt bài toán

Sau khi chuẩn hóa tên cột mẫu, ma trận `counts_sample_name_merge.tsv` vẫn mang chỉ số hàng là các mã số **Entrez Gene ID** khó tra cứu. Nhiệm vụ của học viên là viết một R script độc lập mang tên `annotate_gene.R` để chuyển đổi ma trận sang định dạng có kèm mã gen chuẩn quốc tế (**Gene Symbol**).

#### Dữ liệu đầu vào

1. `counts_sample_name_merge.tsv`: Ma trận đếm đã đổi tên cột.
2. `Human.GRCh38.p13.annot.tsv`: Tệp chú giải hệ gen người từ NCBI, gồm các cột: `GeneID`, `Symbol`, `Description`.

#### Kết quả kỳ vọng (`counts_annotated.tsv`)

```
GeneID       Symbol        PC9_Control_1   PC9_Control_2   PC9_Apatinib_1  ...
100287102    DDX11L1       2               3               2               ...
653635       WASH7P        531             485             433             ...
102466751    MIR6859-1     14              13              14              ...
107985730    MIR1302-2HG   1               1               0               ...
```

#### Hướng dẫn thuật toán gợi ý

1. Đọc tệp chú giải bằng `read.delim("Human.GRCh38.p13.annot.tsv")`.
2. Kiểm tra tính duy nhất của cột `GeneID` trong bảng chú giải bằng `any(duplicated(annot$GeneID))`.
3. Ánh xạ dòng gen dựa trên hàm tìm kiếm chỉ mục `match(rownames(counts), annot$GeneID)` hoặc dùng hàm kết hợp bảng `merge()`.
4. Ghép cột `Symbol` vào vị trí cột thứ hai của ma trận và xuất kết quả bằng `write.table(..., sep = "\t", row.names = FALSE)`.

---

### VIII. TỔNG HỢP HỎI - ĐÁP TRONG LỚP (Q&A SESSION)

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

---

### IX. TỔNG KẾT CỐT LÕI & QUY TẮC THỰC HÀNH (KEY TAKEAWAYS)

1. **Quy tắc 1-based Indexing:** Ngôn ngữ R đánh chỉ số bắt đầu từ số 1. Chỉ số `0` không tồn tại; chỉ số âm `[-i]` dùng để loại bỏ phần tử thứ $i$.
2. **Quy tắc Dấu phẩy trong Subsetting:** Cú pháp trích xuất 2 chiều luôn tuân thủ nguyên tắc `[hàng muốn lấy , cột muốn lấy]`. Để trống bên nào là lấy trọn vẹn toàn bộ bên đó.
3. **Quy tắc Lặp Vector `rep()`:** Phân biệt rõ `each` (giữ các giá trị giống nhau nằm liền kề nhau) và `times` (lặp lại nguyên chu kỳ của toàn bộ khối vector).
4. **Quy tắc Đường dẫn & Tính tái lập:** Tuyệt đối không hard-code đường dẫn tuyệt đối. Luôn sử dụng dấu gạch chéo xuôi `/` và neo vị trí tệp bằng thư viện `here`.
5. **Quy tắc Kiểm tra Dữ liệu 90 giây:** Luôn thực thi bộ ba lệnh `head()`, `dim()`, `str()` ngay sau khi nạp bất kỳ tệp dữ liệu nào vào phiên làm việc.
6. **Quy tắc An toàn Dòng lệnh Bash:** Khi viết script tự động hóa thu thập dữ liệu sinh học, luôn đặt cờ an toàn `set -euo pipefail` ngay đầu tệp để kiểm soát lỗi tức thì.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
