# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026

## BÀI 07: XỬ LÝ TỆP FASTQ, ĐÁNH GIÁ CHẤT LƯỢNG (QC) & CẮT LỌC TRÌNH TỰ (READ TRIMMING)

### CẤU TRÚC FASTQ, PHRED SCORE, FASTQC, MULTIQC, FASTP, TRIMMOMATIC & CUTADAPT

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Thuật ngữ tiếng Việt / Ý nghĩa kỹ thuật | Định nghĩa chi tiết & Ngữ cảnh áp dụng |
| :--- | :--- | :--- |
| **FASTQ Format** | Định dạng tệp FASTQ | Chuẩn tệp văn bản lưu trữ trình tự nucleotide thô kèm theo điểm số chất lượng tương ứng của từng base (gồm 4 dòng cho mỗi read). |
| **Read (Đoạn đọc)** | Trình tự đoạn đọc | Chuỗi nucleotide ngắn được đọc trực tiếp từ máy giải trình tự (sequencer), thường có độ dài từ 50 bp – 300 bp (đối với Short-read Illumina). |
| **Flowcell** | Bản mạch dòng quang học | Bản vi lưu thủy tinh chứa hàng triệu cluster DNA được cố định để máy Illumina chụp ảnh huỳnh quang trong từng chu kỳ giải trình tự. |
| **Tile** | Ô quang học trên Flowcell | Đơn vị bề mặt nhỏ hình chữ nhật trên mỗi lane của flowcell; nơi máy quét quang học chụp lại tín hiệu huỳnh quang của các cụm cluster. |
| **Cluster** | Cụm nhân bản DNA | Tập hợp hàng nghìn bản sao giống hệt nhau của cùng một đoạn phân tử DNA ban đầu, được khuếch đại cầu (bridge amplification) trên flowcell. |
| **Single-End (SE)** | Giải trình tự một đầu | Phương pháp giải trình tự chỉ đọc từ một chiều duy nhất (5' $\rightarrow$ 3') của đoạn DNA chèn (insert); tiết kiệm chi phí nhưng thiếu thông tin không gian. |
| **Paired-End (PE)** | Giải trình tự hai đầu | Phương pháp giải trình tự đọc từ cả 2 đầu của cùng một đoạn phân tử DNA (Read 1 từ đầu 5' và Read 2 từ đầu đối diện); mang thông tin khoảng cách vật lý. |
| **Fragment Size** | Chiều dài phân tử gốc | Tổng độ dài của đoạn DNA ban đầu sau khi phân cắt và chọn kích thước (size selection), ví dụ khoảng 200 – 500 bp. |
| **Insert Size** | Kích thước đoạn chèn | Đoạn trình tự mục tiêu nằm giữa 2 adapter trong cấu trúc thư viện giải trình tự; cần phân biệt với chiều dài thực đọc của read. |
| **Size Selection** | Chọn lọc kích thước đoạn | Bước điện di hoặc tinh sạch bằng hạt từ trong Wet Lab nhằm giữ lại các phân tử DNA có khoảng chiều dài phân bố hẹp mong muốn trước khi nạp máy. |
| **Phred Quality Score ($Q$)** | Điểm số chất lượng Phred | Chỉ số logarit biểu thị xác suất máy giải trình tự gọi sai base ($P_{error}$); tính theo công thức $Q = -10 \log_{10}(P_{error})$. |
| **Base Quality (Q-score)** | Chất lượng gọi base | Thang điểm độ tin cậy của từng nucleotide trên read do phần mềm phân tích ảnh của máy giải trình tự tính toán. |
| **Mapping Quality (MAPQ)** | Điểm chất lượng ánh xạ | Thang điểm đánh giá độ tin cậy của thuật toán căn dòng khi đặt một read vào một vị trí cụ thể trên bộ gen tham chiếu ($MAPQ = -10 \log_{10}(P_{wrong\_map})$). |
| **Variant / SNP Quality** | Điểm chất lượng biến thể | Điểm xác suất tin cậy của việc phát hiện đột biến điểm (SNP) hoặc chèn/mất đoạn (Indel) không phải do lỗi giải trình tự ngẫu nhiên. |
| **ASCII-33 Encoding** | Bảng mã ký tự ASCII bù 33 | Quy ước biểu diễn điểm Phred bằng một ký tự đơn bằng cách cộng giá trị điểm $Q$ với 33 để tránh các ký tự điều khiển không in được (Sanger / Illumina 1.8+). |
| **FastQC** | Trình kiểm định chất lượng tệp FASTQ | Công cụ tiêu chuẩn công nghiệp chạy bằng Java, sinh báo cáo đánh giá 10 khía cạnh chất lượng độc lập của tệp FASTQ. |
| **MultiQC** | Trình tổng hợp báo cáo đa mẫu | Công cụ Python tổng hợp kết quả phân tích từ hàng trăm tệp log của nhiều công cụ (FastQC, Star, fastp...) thành một giao diện HTML duy nhất. |
| **Adapter (Trình tự tiếp hợp)** | Đoạn tiếp hợp nhân tạo | Đoạn oligonucleotide nhân tạo gắn vào hai đầu phân tử DNA để cố định lên flowcell và làm mồi cho quá trình giải trình tự. |
| **Read Trimming** | Cắt lọc trình tự | Quá trình loại bỏ các trình tự adapter dư thừa, base chất lượng thấp hoặc cắt bớt hai đầu read trước khi căn dòng (alignment). |
| **fastp** | Trình xử lý tệp FASTQ đa năng siêu tốc | Công cụ viết bằng C++, tích hợp kiểm định chất lượng, tự động phát hiện adapter, lọc base kém và xuất báo cáo HTML/JSON cùng lúc. |
| **Trimmomatic** | Trình cắt tỉa linh hoạt chuẩn Illumina | Công cụ viết bằng Java, hỗ trợ xử lý Paired-End bảo toàn cặp (tạo ra tệp Paired và Unpaired), áp dụng thuật toán cửa sổ trượt (Sliding Window). |
| **Cutadapt** | Trình cắt tỉa trình tự đặc hiệu | Công cụ Python chuyên sâu cho phép tìm và loại bỏ chính xác các trình tự adapter tùy biến hoặc các đoạn nucleotide nhân tạo cụ thể. |
| **Sliding Window** | Thuật toán cửa sổ trượt | Kỹ thuật quét dọc theo read theo một khung kích thước cố định (ví dụ 4 bp); nếu điểm chất lượng trung bình trong khung tụt dưới ngưỡng, toàn bộ phần sau bị cắt bỏ. |
| **Split Read** | Read tách đôi | Trình tự của một read bị ngắt quãng, trong đó nửa đầu căn dòng vào một locus gen và nửa sau căn dòng vào locus gen khác; dấu hiệu của biến dị cấu trúc (SV). |
| **Structural Variation (SV)** | Biến dị cấu trúc bộ gen | Các biến đổi lớn trên NST bao gồm đảo đoạn (inversion), chuyển đoạn (translocation), lặp đoạn (duplication) hoặc dung hợp gen (gene fusion). |
| **Bioconda** | Kênh phân phối phần mềm tin sinh học | Kênh chuyên biệt của hệ thống Conda chứa hàng nghìn gói phần mềm mã nguồn mở cho sinh học tính toán và phân tích NGS. |
| **Miniforge** | Trình quản lý môi trường Conda tối giản | Bản phân phối Conda gọn nhẹ, mặc định ưu tiên sử dụng kênh `conda-forge`, không bị ràng buộc bản quyền thương mại như Anaconda. |

---

### I. TỔNG QUAN BÀI HỌC (OVERVIEW & OBJECTIVES)

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026).
* **Bài giảng:** Buổi 07: FASTQ Processing, Quality Control & Read Trimming.
* **Trợ giảng:** Quỳnh (Điều phối & Thực hành Pipeline).
* **Tài liệu bài giảng (Slides):** [PDF](https://drive.google.com/file/d/1K9mqp88CKxoVtDRH4s-8u6MUl2az8_93/view?usp=drive_link) | [PPTX](https://docs.google.com/presentation/d/1x98viSsJbdZombaAmilje-4t4txagyYM/edit?usp=drive_link&ouid=103569893297275501178&rtpof=true&sd=true)
* **Video bài giảng:** [YouTube Recording](https://www.youtube.com/live/qyiUTJYK36M?si=5GbGov-qexkxsSNg)
* **Môi trường thực hành:** Miniforge / Conda Linux (WSL2 / Google Colab / Linux Native).

```
               QUY TRÌNH TIỀN XỬ LÝ DỮ LIỆU RNA-SEQ (PRE-PROCESSING PIPELINE)
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │                                                                                 │
  ▼                                                                                 ▼
DỮ LIỆU THÔ (RAW FASTQ)                                            KIỂM TRA CHẤT LƯỢNG ĐẦU VÀO
(Mẫu giải trình tự SE/PE) ───► [FastQC] ───► [MultiQC] ───► Đạt tiêu chuẩn?
                                                                 │              ▲
                                                                 │ (Không đạt)  │ (Đạt chuẩn)
                                                                 ▼              │
                                                        [CẮT TỈA (READ TRIMMING)]
                                                        * fastp (Khuyến nghị)
                                                        * Trimmomatic (Sliding Window)
                                                        * Cutadapt (Specific Primers)
                                                                 │
                                                                 ▼
                                                        [FASTQ SẠCH (CLEAN)]
                                                                 │
                                                                 ▼
                                                        [CĂN DÒNG (ALIGNMENT)]
                                                        * STAR / HISAT2 (Genome)
                                                        * Salmon / Kallisto (Pseudo)
                                                                 │
                                                                 ▼
                                                        [TÍNH ĐIỂM BIỂU HIỆN (COUNTING)]
                                                        * featureCounts / HTSeq
                                                        * Phân tích DEG (DESeq2)
```

#### Mục tiêu học tập cốt lõi (Learning Objectives)

1. **Hiểu rõ cấu trúc tệp FASTQ:** Nắm vững cấu tạo 4 dòng chuẩn mực của mỗi read và phân tích chi tiết thông tin phần cứng của máy giải trình tự trong dòng định danh (Illumina Header Identifier).
2. **Làm chủ thang điểm Phred Quality Score ($Q$):** Hiểu rõ mối liên hệ toán học giữa $Q$-score và xác suất sai số $P_{error}$; giải mã thành thạo quy tắc ánh xạ ASCII-33 sang điểm chất lượng số nguyên.
3. **Phân biệt sâu sắc Single-End (SE) và Paired-End (PE):** Giải thích được vì sao dù phần giữa của phân tử DNA không được đọc (unsequenced gap), dữ liệu Paired-End vẫn vượt trội hoàn toàn trong việc nâng cao độ đặc hiệu ánh xạ (Unique Mapping), ước tính kích thước đoạn chèn (Fragment Size) và phát hiện biến dị cấu trúc (Fusion Genes / Splicing).
4. **Nắm vững 3 thang điểm chất lượng trong NGS:** Phân biệt rạch ròi Base Quality Score, Mapping Quality Score (MAPQ) và Variant/SNP Quality Score.
5. **Kiểm tra chất lượng toàn diện với FastQC & MultiQC:** Đọc hiểu và phân tích được toàn bộ 10 mô-đun kết quả của FastQC; nhận diện các bất thường về adapter, dao động GC, suy giảm chất lượng base ở đầu 3' và tổng hợp báo cáo đa mẫu bằng MultiQC.
6. **Làm chủ các công cụ cắt tỉa (fastp, Trimmomatic, Cutadapt):** So sánh ưu - nhược điểm và ngữ cảnh áp dụng thực tế của từng công cụ theo triết lý "Canva vs Photoshop"; cấu hình thành thạo các tham số cắt tỉa.
7. **Thiết lập môi trường làm việc chuẩn mực:** Cài đặt Miniforge, cấu hình kênh Bioconda/Conda-forge và viết script Bash tự động hóa pipeline kiểm tra chất lượng và cắt tỉa read có tính tái lập cao (`set -euo pipefail`).

---

### II. NỘI DUNG LÝ THUYẾT & KỸ THUẬT CHI TIẾT

```
  ┌───────────────────────┬───────────────────────┬───────────────────────┐
  │ 1. CẤU TRÚC FASTQ     │ 2. SE vs PE           │ 3. PHRED QUALITY      │
  │ 4 dòng quy chuẩn      │ Cơ chế neo 2 đầu      │ Q = -10 log10(P)      │
  │ Giải mã Header        │ Khắc phục lỗi Gap     │ Bảng mã ASCII-33      │
  ├───────────────────────┼───────────────────────┼───────────────────────┤
  │ 4. FASTQC & MULTIQC   │ 5. BẢN CHẤT ADAPTER   │ 6. BỘ 3 TRIMMING      │
  │ 10 mô-đun phân tích   │ Cấu trúc thư viện     │ fastp, Trimmomatic    │
  │ Tổng hợp đa mẫu       │ Hiện tượng Read-through│ & Cutadapt so sánh   │
  └───────────────────────┴───────────────────────┴───────────────────────┘
```

#### 1. Cấu trúc tệp FASTQ & Giải mã Illumina Read Identifier

Tệp FASTQ là chuẩn định dạng văn bản gốc lưu trữ toàn bộ dữ liệu giải trình tự thô sau khi chuyển đổi từ tín hiệu ảnh quang học. Mỗi read luôn được cấu tạo bởi chính xác **4 dòng liên tiếp**:

```
@A00355:101:HLPDDDSXX:1:1101:1398:1031 1:N:0:ATCACG    <── Dòng 1: Định danh read (Read Identifier)
NCAGCTCGTACCATGAGCGATCGATCGATCGATCGATCGATCGATCGA     <── Dòng 2: Trình tự nucleotide thô (Base Sequence)
+                                                    <── Dòng 3: Dấu ngăn cách (Separator, tùy chọn lặp lại ID)
#FFFFFJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ     <── Dòng 4: Chuỗi điểm chất lượng Phred (Quality String)
```

##### Chi tiết 4 dòng quy chuẩn

1. **Dòng 1 (Header / Identifier):** Bắt đầu bằng ký tự `@`, theo sau là chuỗi định danh phần cứng duy nhất của máy giải trình tự, tọa độ quang học của cụm cluster và thông tin read (Read 1 hay Read 2).
2. **Dòng 2 (Sequence):** Chuỗi ký tự nucleotide thực tế gồm các ký tự `A`, `T`, `C`, `G`. Nếu máy giải trình tự không thể phân biệt được tín hiệu huỳnh quang của 4 base tại một chu kỳ nhất định, ký tự `N` (Unknown/Ambiguous Base) sẽ được điền vào.
3. **Dòng 3 (Separator):** Bắt đầu bằng ký tự `+`. Dòng này dùng để ngăn cách dòng trình tự và dòng chất lượng. Trong các phiên bản cũ, toàn bộ chuỗi ID ở Dòng 1 có thể được lặp lại tại đây; tuy nhiên ở chuẩn hiện đại (nhằm tiết kiệm dung lượng lưu trữ), dòng này chỉ chứa duy nhất dấu `+`.
4. **Dòng 4 (Quality Scores):** Chuỗi các ký tự ASCII có độ dài **bắt buộc phải bằng chính xác** số lượng nucleotide ở Dòng 2. Mỗi ký tự tại vị trí $i$ đại diện cho điểm chất lượng Phred của nucleotide tại vị trí $i$ ở Dòng 2.

##### Giải mã cấu trúc định danh Illumina Header

Chuỗi định danh ở Dòng 1 tuân theo quy ước cấu trúc nghiêm ngặt của Illumina, phân tách nhau bởi dấu hai chấm `:`:

```
@A00355 : 101 : HLPDDDSXX : 1 : 1101 : 1398 : 1031   1 : N : 0 : ATCACG
 ──┬───   ─┬─   ────┬────   ┬   ──┬─   ──┬─   ──┬─   ┬   ┬   ┬   ───┬──
   │       │        │       │     │      │      │    │   │   │      └─ Index / Barcode (Mã mẫu)
   │       │        │       │     │      │      │    │   │   └─ Control bits (0 nếu không phải control)
   │       │        │       │     │      │      │    │   └─ Filter flag (Y = Lọc bỏ, N = Vượt qua QC máy)
   │       │        │       │     │      │      │    └─ Read number (1 = Forward / Read 1, 2 = Reverse / Read 2)
   │       │        │       │     │      │      └─ Tọa độ Y của cluster trên tile
   │       │        │       │     │      └─ Tọa độ X của cluster trên tile
   │       │        │       │     └─ Số hiệu Tile (Ô quang học trên lane)
   │       │        │       └─ Số thứ tự Lane trên Flowcell (Lane 1 đến 8)
   │       │        └─ Mã định danh Flowcell (Flowcell ID)
   │       └─ Số hiệu mẻ chạy của thiết bị (Run ID)
   └─ Tên thiết bị giải trình tự duy nhất (Instrument ID / Sequencer ID)
```

* **Tiền tố tên máy (`Instrument ID`):**
  * `A`... : Dòng máy NovaSeq 6000.
  * `M`... : Dòng máy MiSeq.
  * `NB`... : Dòng máy NextSeq 500/550.
  * `HI`... : Dòng máy HiSeq 2500/4000.
* **Tọa độ quang học (`Tile:X:Y`):** Mỗi Flowcell được chia thành các Lane, mỗi Lane gồm hàng trăm ô vuông (Tile, thường chia 2 hàng, mỗi hàng 50 tile). Tọa độ X và Y biểu thị vị trí vật lý chính xác của cụm vi nhân bản (cluster) trên bề mặt kính, giúp xác định các lỗi quang học cục bộ (bọt khí, vết trầy).

---

#### 2. Phân biệt chuyên sâu: Single-End (SE) vs Paired-End (PE)

```
                       CƠ CHẾ GIẢI TRÌNH TỰ SINGLE-END VS PAIRED-END

1. SINGLE-END SEQUENCING (SE):
   5' ───────────────────────────► 3'
   [ Read 1 (ví dụ 150 bp) ] ─── [ Phần còn lại không đọc được ] ────────────── 3'

2. PAIRED-END SEQUENCING (PE):
   ◄──────────────────────── Tổng chiều dài đoạn phân tử (Fragment: ví dụ 500 bp) ────────────────────────►
   5' ────────────────►                                                                ◄──────────────── 5'
   [ Read 1 (150 bp)  ] ─── [ Khoảng giữa không giải trình tự (Unsequenced Gap: 200 bp) ] ─── [ Read 2 (150 bp) ]
   (Forward strand)                                                                    (Reverse strand)
```

##### Bảng so sánh toàn diện Single-End và Paired-End

| Đặc điểm / Tiêu chí | Single-End Sequencing (SE) | Paired-End Sequencing (PE) |
| :--- | :--- | :--- |
| **Số lượng tệp đầu ra** | 1 tệp FASTQ duy nhất cho mỗi mẫu (`sample.fastq.gz`). | 2 tệp FASTQ tương ứng cho mỗi mẫu (`sample_R1.fastq.gz` và `sample_R2.fastq.gz`). |
| **Chiều đọc của máy** | Chỉ đọc 1 chiều từ đầu 5' của chuỗi DNA. | Đọc 2 chiều ngược nhau từ 2 đầu mút của cùng một phân tử DNA. |
| **Chi phí & Dung lượng** | Chi phí giải trình tự thấp, dung lượng ổ đĩa tốn ít hơn 50%. | Chi phí cao hơn, dung lượng lưu trữ tăng gấp đôi. |
| **Độ chính xác căn dòng** | Dễ bị căn dòng sai vị trí (Multi-mapping) ở các vùng lặp lại. | Căn dòng đơn nhất (Unique Mapping) cực cao nhờ cơ chế neo 2 đầu (*Pair-anchoring*). |
| **Ước tính Fragment Size** | Hoàn toàn không thể tính toán được độ dài phân tử gốc. | Tính toán chính xác phân bố độ dài phân tử (Insert Size Distribution). |
| **Phát hiện biến dị cấu trúc** | Rất hạn chế, gần như không thể nhận diện chuyển đoạn lớn. | Nhận diện xuất sắc chuyển đoạn (Translocation), đảo đoạn và Gen dung hợp (Fusion Genes). |
| **Biến thể ghép nối (Splicing)** | Kém hiệu quả trong việc phát hiện các Exon bị bỏ qua cách xa. | Định vị chính xác các điểm nối Exon-Exon ở khoảng cách xa qua hiện tượng rẽ nhánh read. |
| **Ứng dụng tối ưu** | Đếm biểu hiện gen đơn giản (Gene-level RNA-seq cơ bản), ChIP-seq, Small RNA-seq. | Lắp ráp bộ gen mới (*De novo assembly*), Isoform-level RNA-seq, Whole Genome Sequencing (WGS), Cancer Transcriptomics. |

##### Tại sao khoảng giữa không đọc (Unsequenced Gap) nhưng Paired-End vẫn vượt trội?

> [!NOTE]
> **Giải thích bản chất từ TS. Lưu Lợi:**
> Nhiều người thường thắc mắc: *"Nếu chọn đoạn phân tử DNA 500 bp, giải đầu R1 được 150 bp, đầu R2 được 150 bp, thì 200 bp ở chính giữa hoàn toàn không có dữ liệu. Vậy tại sao không giải Single-End 300 bp liên tục mà lại giải Paired-End?"*
> 
> Bản chất nằm ở **3 giá trị sinh học và kỹ thuật vô giá** của liên kết cặp:
> 
> 1. **Cơ chế thả neo tăng tính đơn nhất (Unique Pair-Anchoring):**
>    Trong bộ gen người, các đoạn trình tự lặp lại (transposons, lặp tandem) chiếm hơn 50%. Nếu Read 1 rơi vào một vùng lặp lại có mặt ở 10 vị trí khác nhau trên hệ gen, thuật toán sẽ không thể biết nó thuộc về nhiễm sắc thể nào (gây điểm Mapping Quality thấp). Tuy nhiên, vì Read 2 cùng thuộc phân tử đó và cách Read 1 một khoảng $\sim 500$ bp, Read 2 có khả năng rất cao rơi vào vùng trình tự độc nhất (unique sequence). Khi Read 2 đã được "thả neo" cố định vào một tọa độ, Read 1 **bắt buộc phải nằm ở phía bên trái** và cách Read 2 trong phạm vi $\sim 500$ bp. Toàn bộ 9 vị trí mơ hồ khác lập tức bị loại trừ!
> 
> 2. **Ước lượng kích thước đoạn chèn (Fragment Size Estimation):**
>    Khi căn dòng R1 và R2 lên hệ gen tham chiếu, ta có tọa độ đầu của R1 và tọa độ cuối của R2. Khoảng cách giữa chúng chính là kích thước của phân tử DNA thực tế. Nếu khoảng cách tính toán này sai lệch nghiêm trọng so với phân bố chọn lọc kích thước ban đầu (ví dụ tính ra 50.000 bp thay vì 500 bp), đó là bằng chứng thép chỉ ra các hiện tượng sinh học bệnh lý: **mất đoạn lớn (Large Deletion)** hoặc **chèn đoạn lớn (Large Insertion)**.
> 
> 3. **Phát hiện gen dung hợp (Fusion Genes) và biến dị cấu trúc (Split Reads):**
>    Trong tế bào ung thư, hiện tượng chuyển đoạn NST (Translocation) diễn ra rất phổ biến (ví dụ gen *BCR-ABL1*). Khi Read 1 căn dòng vào NST số 9 nhưng Read 2 của cùng phân tử đó lại căn dòng vào NST số 22, ta lập tức phát hiện ra biến dị chuyển đoạn tạo gen dung hợp ung thư — điều mà dữ liệu Single-End hoàn toàn bất lực.

---

#### 3. Phred Quality Score ($Q$-Score) & Mã hóa ký tự ASCII-33

##### Định nghĩa toán học của Phred Score

Phred Quality Score ($Q$) là một thang đo logarit biểu diễn xác suất một nucleotide bị máy giải trình tự nhận diện sai ($P_{error}$):

$$Q = -10 \log_{10}(P_{error})$$

Biến đổi ngược lại để tìm xác suất sai số từ điểm $Q$:

$$P_{error} = 10^{-\frac{Q}{10}}$$

Độ chính xác trong việc gọi base (Base Call Accuracy) được xác định bởi:

$$\text{Accuracy (\%)} = (1 - P_{error}) \times 100\%$$

##### Bảng quy đổi chuẩn xác suất sai số Phred

| Điểm Phred ($Q$) | Xác suất nhận diện sai ($P_{error}$) | Tỷ lệ lỗi | Độ chính xác gọi Base (Accuracy) | Đánh giá chất lượng thực tế |
| :---: | :---: | :---: | :---: | :--- |
| **$Q10$** | $10^{-1} = 0.1$ | $1$ trong $10$ base | **$90.0\%$** | Rất kém (Unacceptable / Junk data) |
| **$Q20$** | $10^{-2} = 0.01$ | $1$ trong $100$ base | **$99.0\%$** | Chấp nhận được (Ngưỡng tối thiểu chuẩn cũ) |
| **$Q30$** | $10^{-3} = 0.001$ | $1$ trong $1.000$ base | **$99.9\%$** | Xuất sắc (Chuẩn vàng hiện đại của NGS) |
| **$Q40$** | $10^{-4} = 0.0001$ | $1$ trong $10.000$ base | **$99.99\%$** | Gần như hoàn hảo |

##### Nguyên lý mã hóa ASCII-33 (Phred+33)

Trong tệp FASTQ, mỗi read chứa hàng trăm base. Nếu ghi điểm chất lượng dưới dạng số thập phân (ví dụ `36 36 20 40`), các con số sẽ chiếm nhiều ký tự và phải dùng dấu cách, làm phình to kích thước tệp và khó phân tách. Các nhà khoa học đã giải quyết bằng cách **ánh xạ mỗi con số thành đúng 1 ký tự ASCII duy nhất**.

* Bảng mã ASCII tiêu chuẩn có các ký tự từ 0 đến 31 là các **ký tự điều khiển không in được** (ví dụ: chuông báo, xuống dòng, tab). Ký tự 32 là dấu cách (khoảng trắng).
* Do đó, hệ quy ước **Phred+33 (Sanger / Illumina 1.8+)** lấy điểm chất lượng $Q$ cộng thêm $33$ để bắt đầu từ ký tự in được đầu tiên là dấu chấm than `!` (mã 33):

$$\text{ASCII Code} = Q + 33$$

$$\text{Ký tự hiển thị} = \text{chr}(Q + 33)$$

```
     THANG ĐO ÁNH XẠ ĐIỂM CHẤT LƯỢNG SANG KÝ TỰ BẢNG MÃ PHRED+33
  Điểm Q:     0    1    ...    10   ...    20   ...    30   ...    40
              │    │           │           │           │           │
  + 33:      33   34           43          53          63          73
              │    │           │           │           │           │
  Ký tự:      !    "           +           5           ?           I
```

##### Bài tập thực hành chuyển đổi (Lớp học FCWT 2026)

* **Bài toán 1:** Một base có ký tự chất lượng là số `5`. Điểm $Q$ và xác suất sai số là bao nhiêu?
  * Ký tự `5` có mã thập phân ASCII là $53$.
  * Điểm $Q = 53 - 33 = 20$.
  * Xác suất sai số: $P = 10^{-20/10} = 0.01$ ($1\%$). Độ chính xác: $99\%$.
* **Bài toán 2:** Base có điểm $Q = 35$, ký tự đại diện là gì?
  * Mã ASCII $= 35 + 33 = 68$.
  * Tra bảng ASCII, ký tự có mã $68$ là chữ cái **`D`**.
* **Bài toán 3:** Một đoạn sequence có 5 base `ACGTA` với chuỗi chất lượng tương ứng là `5?I+D`. Giải mã toàn bộ điểm $Q$?
  * `5` $\rightarrow 53 - 33 = \mathbf{Q20}$ (Base `A`)
  * `?` $\rightarrow 63 - 33 = \mathbf{Q30}$ (Base `C`)
  * `I` $\rightarrow 73 - 33 = \mathbf{Q40}$ (Base `G`)
  * `+` $\rightarrow 43 - 33 = \mathbf{Q10}$ (Base `T`)
  * `D` $\rightarrow 68 - 33 = \mathbf{Q35}$ (Base `A`)

##### Ba thang điểm chất lượng cốt lõi trong Tin sinh học NGS

Trong suốt quy trình phân tích dữ liệu giải trình tự thế hệ mới, có **3 thang điểm chất lượng** độc lập nhưng liên kết chặt chẽ với nhau:

1. **Base Quality Score ($Q$-score):** Được ghi trong tệp FASTQ. Đánh giá độ tin cậy quang học của từng nucleotide.
2. **Mapping Quality Score (MAPQ):** Được ghi trong cột thứ 5 của tệp SAM/BAM sau khi căn dòng bằng STAR/BWA. Đánh giá độ tin cậy rằng read này thực sự thuộc về vị trí gen được căn dòng ($MAPQ = -10 \log_{10} P_{wrong\_alignment}$). Nếu read căn dòng vào 5 vị trí giống nhau, $MAPQ = 0$.
3. **Variant / SNP Quality Score (QUAL):** Được ghi trong cột thứ 6 của tệp VCF sau khi gọi biến dị (Variant Calling bằng GATK/FreeBayes). Đánh giá xác suất một biến dị di truyền là có thật chứ không phải do sai số giải trình tự hay lỗi căn dòng.

---

#### 4. Đánh giá chất lượng với FastQC & Báo cáo đa mẫu MultiQC

FastQC là công cụ tiêu chuẩn hàng đầu để kiểm tra chất lượng dữ liệu thô. Sau khi chạy, công cụ xuất ra một tệp báo cáo dạng HTML kèm thư mục chứa hình ảnh chi tiết.

##### Phân tích chi tiết 10 mô-đun kiểm định của FastQC

```
   Per Base Quality              Per Tile Quality             Per Sequence Quality
  ┌─────────────────┐           ┌─────────────────┐          ┌─────────────────┐
  │  Vùng xanh: Q30 │           │  Xanh: Đồng đều │          │  Đỉnh duy nhất: │
  │  Vùng vàng: Q20 │           │  Đỏ: Bọt khí,   │          │  Q > 30 là đạt  │
  │  Vùng đỏ: < Q20 │           │  trầy xước kính │          │  Hai đỉnh: Lỗi  │
  └─────────────────┘           └─────────────────┘          └─────────────────┘
           │                             │                            │
           ▼                             ▼                            ▼
  Per Base Content              Per Sequence GC              Adapter Content
  ┌─────────────────┐           ┌─────────────────┐          ┌─────────────────┐
  │  Đầu 5' dao động│           │  Phân bố chuẩn  │          │  Đường dốc lên: │
  │  do Random Prim │           │  Đa đỉnh: Nhiễm │          │  Chưa cắt sạch  │
  │  Thân: Tách biệt│           │  khuẩn, rRNA    │          │  cần Trim ngay  │
  └─────────────────┘           └─────────────────┘          └─────────────────┘
```

1. **Basic Statistics (Thống kê cơ bản):**
   * Cung cấp thông tin tổng quan: Tên tệp, phiên bản mã hóa (ví dụ: Sanger / Illumina 1.9), tổng số lượng read, số lượng read được lọc bởi máy, độ dài read (ví dụ: 150 bp) và tỷ lệ phần trăm $\%GC$ trung bình.
2. **Per Base Sequence Quality (Chất lượng từng chu kỳ đọc):**
   * **Cấu trúc biểu đồ:** Trục hoành là vị trí các base từ 1 đến 150 bp. Trục tung là điểm Phred từ 0 đến 40.
   * **Phân vùng chất lượng:**
     * *Vùng màu xanh lá ($Q \ge 28$):* Chất lượng rất tốt.
     * *Vùng màu cam ($20 \le Q < 28$):* Chất lượng trung bình.
     * *Vùng màu đỏ ($Q < 20$):* Chất lượng kém, tỷ lệ lỗi cao.
   * **Quy luật vật lý của máy:** Đoạn cuối 3' thường có điểm chất lượng suy giảm dần do sự suy thoái enzym polymerase và hiện tượng mất đồng pha (*dephasing*) của tín hiệu huỳnh quang sau nhiều chu kỳ giải trình tự.
   * **Biểu đồ hộp (Boxplot):** Đường màu đỏ là trung vị (Median), đường màu xanh lam là giá trị trung bình (Mean), hộp màu vàng biểu thị khoảng tứ phân vị (25% – 75%), râu kéo dài từ 10% đến 90%.
3. **Per Tile Sequence Quality (Chất lượng theo từng ô quang học):**
   * Biểu thị sai lệch chất lượng của từng Tile trên Flowcell so với mức trung bình của toàn mẻ chạy.
   * Màu xanh lam là bình thường. Các vệt màu đỏ cảnh báo các vùng vật lý bị bọt khí, vết trầy xước trên bề mặt vi lưu hoặc tắc nghẽn dòng chất lỏng. Nếu vệt đỏ chỉ xuất hiện ở vài tile cá biệt, có thể chấp nhận; nếu đỏ diện rộng, cần loại bỏ lane đó.
4. **Per Sequence Quality Scores (Phân bố điểm chất lượng toàn read):**
   * Đồ thị biểu thị số lượng read ứng với mỗi mức điểm chất lượng trung bình.
   * Dữ liệu chuẩn phải có một đỉnh duy nhất lệch hẳn về bên phải ($Q \ge 34$). Nếu xuất hiện đỉnh phụ thứ hai ở vùng $Q < 20$, chứng tỏ có một nhóm read bị suy thoái tín hiệu nghiêm trọng.
5. **Per Base Sequence Content (Thành phần base theo từng chu kỳ):**
   * Biểu thị tỷ lệ $\%A$, $\%T$, $\%C$, $\%G$ tại từng vị trí nucleotide.
   * Trong hệ gen ngẫu nhiên, các đường phải song song và ổn định. Tuy nhiên, ở dữ liệu RNA-seq, tại 10 – 12 base đầu tiên ở đầu 5', 4 đường này **luôn dao động mạnh và cắt chéo nhau**.
   * *Nguyên nhân sinh học:* Quá trình tổng hợp cDNA sử dụng các mồi ngẫu nhiên lục phân tử (Random Hexamers). Các mồi này có hiện tượng thiên vị liên kết (Binding Bias), không hoàn toàn ngẫu nhiên. Đây là đặc tính kỹ thuật bình thường của RNA-seq, không phải lỗi mẫu.
6. **Per Sequence GC Content (Phân bố tỷ lệ $\%GC$):**
   * So sánh phân bố $\%GC$ thực tế với đường phân bố chuẩn lý thuyết (Gaussian curve).
   * Nếu đồ thị thực tế xuất hiện nhiều đỉnh nhô cao bất thường (đa đỉnh), đây là chỉ dấu rõ ràng của việc **nhiễm DNA ngoại lai** (ví dụ: nhiễm khuẩn Mycoplasma trong nuôi cấy tế bào) hoặc do còn sót lượng lớn RNA ribosome (rRNA) chưa được loại bỏ sạch.
7. **Per Base N Content (Tỷ lệ base không xác định):**
   * Đồ thị tỷ lệ base `N`. Ở dữ liệu tốt, đường này luôn bám sát trục số $0$. Nếu có vị trí vọt lên cao, chứng tỏ máy giải trình tự bị mất nét quang học tại chu kỳ đó.
8. **Sequence Length Distribution (Phân bố độ dài read):**
   * Trước khi cắt tỉa, toàn bộ read phải có độ dài đồng nhất (ví dụ: 100% read đều dài chính xác 150 bp). Đồ thị là một thanh dọc duy nhất.
9. **Sequence Duplication Levels (Mức độ nhân bản trình tự):**
   * Đánh giá tỷ lệ các read có trình tự giống hệt nhau lặp lại nhiều lần.
   * Đối với DNA-seq (WGS), tỷ lệ trùng lặp cao là lỗi khuếch đại PCR quá mức (PCR Duplicates).
   * Đối với RNA-seq, các gen biểu hiện siêu mạnh (như Actin, GAPDH) tự nhiên sẽ sinh ra hàng triệu bản sao transcript giống hệt nhau. Do đó, FastQC thường báo cảnh báo vàng hoặc đỏ ở mô-đun này đối với RNA-seq, điều này là **hoàn toàn bình thường**.
10. **Adapter Content (Tỷ lệ nhiễm trình tự Adapter):**
    * Phát hiện tỷ lệ phần trăm các read chứa các đoạn adapter thương mại (Illumina Universal, Nextera...).
    * Nếu đường adapter dốc đứng lên ở đầu 3', chứng tỏ đoạn DNA chèn quá ngắn và máy đã đọc xuyên qua adapter. Dữ liệu bắt buộc phải được cắt lọc (Trimming) trước khi đưa vào bước căn dòng.

##### Vai trò của MultiQC

Khi làm việc với các dự án thực tế gồm hàng chục đến hàng trăm mẫu, việc mở từng tệp `fastqc_report.html` thủ công là bất khả thi. **MultiQC** ra đời để quét toàn bộ thư mục chứa các tệp kết quả của FastQC và tự động tổng hợp tất cả vào **một trang HTML tương tác duy nhất**:
* So sánh trực quan chất lượng của 50 mẫu trên cùng một đồ thị.
* Phát hiện nhanh mẫu bất thường (Outliers).
* Hỗ trợ xuất dữ liệu dạng bảng biểu để đưa vào báo cáo khoa học.

---

#### 5. Bản chất Adapter & Kỹ thuật cắt tỉa trình tự (Read Trimming)

##### Hiện tượng đọc xuyên Adapter (Adapter Read-through)

Trong quá trình chuẩn bị thư viện giải trình tự (Library Preparation), các adapter nhân tạo (chứa primer binding site, sample index/barcode và flowcell attachment oligo) được gắn vào hai đầu của đoạn DNA mục tiêu:

```
                  CẤU TRÚC PHÂN TỬ THƯ VIỆN GIẢI TRÌNH TỰ ILLUMINA
  5' [P5 Flowcell]─[i5 Index]─[Read 1 Primer]─[INSERT (ĐOẠN GEN MỤC TIÊU)]─[Read 2 Primer]─[i7 Index]─[P7 Flowcell] 3'
```

* **Trường hợp phân tử dài (Normal Fragment $\ge 150$ bp):** Máy giải trình tự đọc 150 chu kỳ, chỉ đọc toàn bộ trình tự của đoạn INSERT mục tiêu.
* **Trường hợp phân tử ngắn (Short Fragment $< 150$ bp):** Nếu đoạn INSERT chỉ dài 100 bp, sau khi đọc hết 100 bp mục tiêu, máy giải trình tự tiếp tục chạy thêm 50 chu kỳ nữa. Khi đó, máy sẽ **đọc xuyên vào đoạn Adapter nhân tạo ở đầu 3'**.

> [!WARNING]
> **Hậu quả nếu không cắt tỉa Adapter:**
> Các đoạn adapter là chuỗi nhân tạo, hoàn toàn không tồn tại trên hệ gen tham chiếu (Reference Genome). Nếu giữ nguyên tệp FASTQ thô, thuật toán căn dòng (STAR, HISAT2) sẽ không thể tìm thấy vị trí khớp cho các read này, dẫn đến tỷ lệ căn dòng thành công (Uniquely Mapped Reads %) bị tụt dốc thảm hại, làm sai lệch toàn bộ kết quả phân tích biểu hiện gen về sau!

---

#### 6. So sánh bộ ba công cụ Trimming: fastp, Trimmomatic & Cutadapt

```
                               SO SÁNH BỘ BA CÔNG CỤ TRIMMING
  ┌─────────────────────────────────┬─────────────────────────────────┬─────────────────────────────────┐
  │ fastp                           │ Trimmomatic                     │ Cutadapt                        │
  │ • Ngôn ngữ: C++                 │ • Ngôn ngữ: Java                │ • Ngôn ngữ: Python              │
  │ • Triết lý: "Canva" (All-in-one)│ • Triết lý: "Photoshop"         │ • Triết lý: Dao mổ tinh vi      │
  │ • Tự động nhận diện Adapter     │ • Cần tệp Adapter FASTA ngoài   │ • Cắt các chuỗi primer tùy biến │
  │ • Xuất HTML/JSON báo cáo tự động│ • Kiểm soát chặt Sliding Window │ • Tốc độ trung bình             │
  │ • Tốc độ siêu tốc (Multi-thread)│ • Tách tệp Paired/Unpaired      │ • Tối ưu cho Small RNA / Amplicon│
  └─────────────────────────────────┴─────────────────────────────────┘
```

##### Ẩn dụ sinh động trong lớp học: "Canva vs Photoshop"

Trong buổi thảo luận Q&A, trợ giảng đã giải thích sự khác biệt giữa các công cụ cắt tỉa qua hình ảnh so sánh:
* **`fastp` giống như "Canva":** Rất hiện đại, thông minh và tiện lợi tối đa. Chỉ cần đưa ảnh vào, phần mềm tự động xóa phông, tự động chỉnh sáng. `fastp` tự động dò tìm adapter của các dòng máy phổ biến (Illumina) mà không bắt người dùng phải cung cấp tệp adapter. Nó tích hợp sẵn QC trước và sau khi cắt, đồng thời sinh báo cáo HTML trực quan. Đây là lựa chọn số một cho hầu hết các pipeline tiêu chuẩn hiện đại.
* **`Trimmomatic` giống như "Photoshop":** Đòi hỏi người dùng phải hiểu sâu từng thông số kỹ thuật và can thiệp thủ công chi tiết. Bạn phải tự tải và chỉ định tệp adapter tương ứng của mẻ chạy, cấu hình từng bước lọc với thuật toán cửa sổ trượt. Khi dữ liệu có những bất thường sâu mà các công cụ tự động bó tay, `Trimmomatic` mang lại khả năng kiểm soát tuyệt đối.
* **`Cutadapt` giống như "Công cụ cắt cúp chuyên dụng":** Chuyên dùng để cắt chính xác từng đoạn sequence đặc hiệu, các đoạn mồi PCR (Primers) hoặc các adapter phi tiêu chuẩn không có trong cơ sở dữ liệu chung.

##### Bảng so sánh kỹ thuật chi tiết

| Tham số / Tiêu chí | `fastp` | `Trimmomatic` | `Cutadapt` |
| :--- | :--- | :--- | :--- |
| **Ngôn ngữ phát triển** | C++ (Tối ưu hóa đa luồng siêu tốc) | Java (Chạy trên JVM) | Python (Hỗ trợ Cython) |
| **Nhận diện Adapter** | **Tự động 100%** (cho cả SE và PE bằng cách căn chỉnh overlap giữa R1 và R2). | **Bắt buộc thủ công** (phải nạp tệp FASTA chứa danh sách adapter). | **Thủ công** (phải khai báo chuỗi adapter cụ thể qua cờ lệnh `-a`, `-g`). |
| **Cơ chế lọc Paired-End** | Tự động đồng bộ; loại bỏ read hỏng và giữ lại cặp hoàn chỉnh. | Tách rõ ràng thành 4 tệp: R1-paired, R1-unpaired, R2-paired, R2-unpaired. | Cắt lọc song song với cờ `-A` cho R2; có thể cần lọc thêm read rác. |
| **Kiểm định chất lượng tích hợp** | Tích hợp sẵn QC trước và sau cắt; xuất báo cáo HTML và JSON. | Không có (bắt buộc phải chạy FastQC độc lập trước và sau). | Không có (chỉ in log tóm tắt ở terminal). |
| **Lọc PolyA / PolyG** | Tự động phát hiện và cắt đuôi PolyG (lỗi quang học phổ biến trên máy 2-color như NextSeq/NovaSeq). | Phải cấu hình thủ công qua các tham số cắt crop. | Cắt được nếu cấu hình chuỗi lặp. |
| **Ngữ cảnh khuyên dùng** | **Lựa chọn mặc định số 1** cho RNA-seq và WGS/WES hiện đại. | Dữ liệu cũ, thư viện tùy biến sâu, hoặc pipeline yêu cầu quản lý unpaired reads. | Small RNA-seq, dữ liệu amplicon giải trình tự mồi tùy chỉnh. |

---

### III. THỰC HÀNH & WORKFLOW MẪU (HANDS-ON PIPELINE)

```
                 KIẾN TRÚC MÔI TRƯỜNG & DỮ LIỆU THỰC HÀNH BUỔI 07
  Thư mục dự án: /home/mashxp/App/phowhisper
  ├── envs/
  │   └── environment.yml                 <── Môi trường Conda 'rnaseq_qc'
  ├── scripts/
  │   └── run_qc_and_trimming.sh          <── Script tự động hóa pipeline
  └── data/
      ├── raw_fastq/                      <── Dữ liệu 4 cặp mẫu Breast Cancer thô
      │   ├── Sample_A_R1.fastq.gz
      │   └── Sample_A_R2.fastq.gz
      ├── qc_raw/                         <── Kết quả FastQC & MultiQC dữ liệu thô
      ├── clean_fastq/                    <── Dữ liệu sau khi cắt tỉa bằng fastp
      └── qc_clean/                       <── Kết quả kiểm tra chất lượng sau cắt tỉa
```

#### 1. Thiết lập môi trường Conda với Miniforge & Kênh Bioconda

##### Tại sao chọn Miniforge thay vì Anaconda?

* **Miniforge** hoàn toàn miễn phí, mã nguồn mở, không bị giới hạn bởi các điều khoản bản quyền thương mại (Commercial License) của Anaconda.
* Mặc định sử dụng kênh `conda-forge` hiện đại và tương thích hoàn hảo với kênh `bioconda`.

##### Cấu hình thứ tự ưu tiên kênh (Channel Priority)

Trong tin sinh học, thứ tự ưu tiên của các kênh Conda là **yếu tố sống còn** để tránh xung đột thư viện C/C++:

```bash
# Thêm các kênh cần thiết
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Thiết lập mức ưu tiên nghiêm ngặt
conda config --set channel_priority strict
```

##### Tệp cấu hình môi trường chuẩn: `environment.yml`

```yaml
name: rnaseq_qc
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - python=3.10
  - fastqc>=0.12.1
  - multiqc>=1.21
  - fastp>=0.23.4
  - trimmomatic>=0.39
  - cutadapt>=4.7
```

Khởi tạo và kích hoạt môi trường:

```bash
# Tạo môi trường từ tệp cấu hình
conda env create -f environment.yml

# Kích hoạt môi trường làm việc
conda activate rnaseq_qc

# Kiểm tra danh sách công cụ đã cài đặt
conda list
```

---

#### 2. Cú pháp thực thi cốt lõi của các công cụ Trimming

##### Thực thi với `fastp` (Khuyến nghị chuẩn)

```bash
fastp \
  -i raw_fastq/Sample_A_R1.fastq.gz \
  -I raw_fastq/Sample_A_R2.fastq.gz \
  -o clean_fastq/Sample_A_R1.clean.fastq.gz \
  -O clean_fastq/Sample_A_R2.clean.fastq.gz \
  --detect_adapter_for_pe \
  --cut_front \
  --cut_tail \
  --cut_window_size 4 \
  --cut_mean_quality 20 \
  --qualified_quality_phred 20 \
  --unqualified_percent_limit 40 \
  --n_base_limit 5 \
  --length_required 36 \
  --html qc_clean/Sample_A_fastp.html \
  --json qc_clean/Sample_A_fastp.json \
  --thread 4
```

* `--detect_adapter_for_pe`: Tự động căn chỉnh overlap giữa Read 1 và Read 2 để dò tìm và loại bỏ adapter cực kỳ chính xác mà không cần biết trước chuỗi adapter.
* `--cut_front` / `--cut_tail`: Thuật toán cửa sổ trượt tương tự Trimmomatic cắt bỏ base xấu ở đầu 5' và đuôi 3'.
* `--qualified_quality_phred 20`: Ngưỡng điểm $Q$ đạt chuẩn ($Q \ge 20$).
* `--length_required 36`: Loại bỏ toàn bộ các read sau cắt tỉa có chiều dài ngắn hơn 36 bp.

##### Thực thi với `Trimmomatic` (Tham khảo cơ chế)

```bash
trimmomatic PE -threads 4 -phred33 \
  raw_fastq/Sample_A_R1.fastq.gz raw_fastq/Sample_A_R2.fastq.gz \
  clean_fastq/Sample_A_R1.paired.fq.gz clean_fastq/Sample_A_R1.unpaired.fq.gz \
  clean_fastq/Sample_A_R2.paired.fq.gz clean_fastq/Sample_A_R2.unpaired.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  LEADING:3 \
  TRAILING:3 \
  SLIDINGWINDOW:4:20 \
  MINLEN:36
```

* `ILLUMINACLIP:TruSeq3-PE.fa:2:30:10`: Cắt adapter dựa trên tệp FASTA đối chiếu (cho phép sai lệch tối đa 2 mismatch).
* `LEADING:3` / `TRAILING:3`: Cắt bỏ các base ở đầu và đuôi read nếu điểm $Q < 3$.
* `SLIDINGWINDOW:4:20`: Quét cửa sổ 4 base liên tiếp, nếu chất lượng trung bình $< 20$, cắt bỏ phần còn lại của read.
* `MINLEN:36`: Bỏ các read có độ dài $< 36$ bp.

---

#### 3. Kịch bản Bash Pipeline tự động hóa hoàn chỉnh: `run_qc_and_trimming.sh`

Script Bash dưới đây tuân thủ các quy chuẩn kỹ thuật nghiêm ngặt (`set -euo pipefail`), tự động xử lý hàng loạt mẫu, kiểm tra chất lượng trước và sau khi cắt tỉa:

```bash
#!/usr/bin/env bash
# ==============================================================================
# Pipeline: QC Thô, Cắt tỉa (fastp) và Báo cáo Đa mẫu (MultiQC)
# Khóa học: Fighting Cancer with Transcriptomics 2026 (FCWT 2026) - Buổi 07
# Tác giả: Antigravity & FCWT Team
# ==============================================================================

set -euo pipefail

# Khai báo các thư mục làm việc
RAW_DIR="data/raw_fastq"
QC_RAW_DIR="results/01_qc_raw"
CLEAN_DIR="data/clean_fastq"
QC_CLEAN_DIR="results/02_qc_clean"
LOG_DIR="results/logs"
THREADS=4

# Tạo thư mục nếu chưa tồn tại
mkdir -p "${QC_RAW_DIR}" "${CLEAN_DIR}" "${QC_CLEAN_DIR}" "${LOG_DIR}"

echo "=========================================================="
echo "BƯỚC 1: KIỂM ĐỊNH CHẤT LƯỢNG DỮ LIỆU THÔ BẰNG FASTQC"
echo "=========================================================="

fastqc -t "${THREADS}" -o "${QC_RAW_DIR}" "${RAW_DIR}"/*.fastq.gz

echo ">>> Tổng hợp báo cáo dữ liệu thô bằng MultiQC..."
multiqc "${QC_RAW_DIR}" -o "${QC_RAW_DIR}/multiqc_report" --interactive

echo "=========================================================="
echo "BƯỚC 2: CẮT TỈA ADAPTER VÀ LỌC BASE KÉM BẰNG FASTP"
echo "=========================================================="

# Quét qua tất cả các cặp mẫu Read 1
for R1 in "${RAW_DIR}"/*_R1.fastq.gz; do
    # Tự động suy ra tên tệp Read 2 tương ứng
    R2="${R1/_R1.fastq.gz/_R2.fastq.gz}"
    
    # Lấy tên mẫu (Sample ID)
    SAMPLE_NAME=$(basename "${R1}" _R1.fastq.gz)
    
    echo "Đang xử lý mẫu: ${SAMPLE_NAME}..."
    
    fastp \
        -i "${R1}" \
        -I "${R2}" \
        -o "${CLEAN_DIR}/${SAMPLE_NAME}_R1.clean.fastq.gz" \
        -O "${CLEAN_DIR}/${SAMPLE_NAME}_R2.clean.fastq.gz" \
        --detect_adapter_for_pe \
        --cut_front \
        --cut_tail \
        --cut_window_size 4 \
        --cut_mean_quality 20 \
        --qualified_quality_phred 20 \
        --unqualified_percent_limit 40 \
        --n_base_limit 5 \
        --length_required 36 \
        --html "${QC_CLEAN_DIR}/${SAMPLE_NAME}_fastp.html" \
        --json "${QC_CLEAN_DIR}/${SAMPLE_NAME}_fastp.json" \
        --thread "${THREADS}" \
        2> "${LOG_DIR}/${SAMPLE_NAME}_fastp.log"
done

echo "=========================================================="
echo "BƯỚC 3: KIỂM ĐỊNH LẠI CHẤT LƯỢNG SAU CẮT TỈA (POST-TRIM QC)"
echo "=========================================================="

fastqc -t "${THREADS}" -o "${QC_CLEAN_DIR}" "${CLEAN_DIR}"/*.clean.fastq.gz

echo ">>> Tổng hợp báo cáo dữ liệu sạch bằng MultiQC..."
multiqc "${QC_CLEAN_DIR}" -o "${QC_CLEAN_DIR}/multiqc_report" --interactive

echo "=========================================================="
echo "HOÀN TẤT PIPELINE TIỀN XỬ LÝ DỮ LIỆU! SẴN SÀNG CĂN DÒNG STAR."
echo "=========================================================="
```

---

### IV. TỔNG HỢP HỎI - ĐÁP TRONG LỚP (Q&A SESSION)

#### Câu hỏi 1: Tại sao khoảng giữa của Paired-End không được giải trình tự nhưng vẫn có giá trị vượt trội so với Single-End?

* **Học viên đặt vấn đề:** Giả sử ta có đoạn DNA 500 bp, máy chỉ đọc 150 bp ở mỗi đầu, còn 200 bp ở giữa bị bỏ trống. Tại sao không đọc một mạch Single-End dài hơn mà lại phải đọc ngắt quãng hai đầu như vậy?
* **Giải đáp chi tiết từ TS. Lưu Lợi:**
  * Thứ nhất, công nghệ giải trình tự ngắn của Illumina bị giới hạn vật lý về độ dài đọc do hiện tượng suy giảm hóa học tích lũy qua từng chu kỳ; việc đọc một lèo 500 bp sẽ làm chất lượng đoạn đuôi tụt thảm hại.
  * Thứ hai, việc chia thành 2 đầu đọc mang lại **thông tin không gian và khoảng cách vật lý**. Khi Read 1 bám vào một vị trí, Read 2 bắt buộc phải bám vào vị trí đối diện cách đó $\sim 500$ bp. Điều này giải quyết triệt để vấn đề căn dòng nhầm lẫn tại các vùng gen lặp lại (transposon, tandem repeats).
  * Thứ ba, phân bố khoảng cách giữa 2 đầu đọc cho phép tính toán kích thước phân tử thực tế (*Fragment Size Distribution*), từ đó phát hiện các đột biến cấu trúc quy mô lớn (Structural Variations) như mất đoạn, lặp đoạn và chuyển đoạn hình thành gen dung hợp trong ung thư (*Fusion Genes*).

#### Câu hỏi 2: Ba loại thang điểm chất lượng (Quality Score) trong phân tích NGS có mối liên hệ như thế nào?

* **Giải đáp tổng hợp:**
  * **Base Quality Score ($Q$-score):** Được sinh ra ở bước giải trình tự thô (trong tệp FASTQ). Đo lường xác suất máy gọi đúng nucleotide dựa trên cường độ tín hiệu huỳnh quang quang học.
  * **Mapping Quality Score (MAPQ):** Được tính toán ở bước căn dòng (trong tệp SAM/BAM). Đánh giá độ tin cậy rằng toàn bộ read đó thực sự nằm ở vị trí tọa độ gen đó trên nhiễm sắc thể chứ không phải ở một nơi khác. Một read có base quality rất cao vẫn có thể có $MAPQ = 0$ nếu trình tự của nó trùng khớp hoàn toàn với 100 vị trí khác nhau trên hệ gen.
  * **Variant Quality Score (QUAL):** Được tính toán ở bước gọi biến dị di truyền (trong tệp VCF). Đánh giá mức độ tin cậy rằng một nucleotide đột biến là một biến dị sinh học thực sự chứ không phải do sai số ngẫu nhiên của enzym PCR hay máy giải trình tự.

#### Câu hỏi 3: Tiêu chí lựa chọn giữa fastp, Trimmomatic và Cutadapt là gì? Khi nào nên dùng công cụ nào?

* **Học viên thắc mắc:** Sự khác biệt thực tế giữa 3 công cụ cắt tỉa là gì và trong trường hợp nào ta nên chọn công cụ nào?
* **Giải đáp từ Trợ giảng & Lớp học:**
  * Sử dụng ẩn dụ **"Canva vs Photoshop"**:
    * **`fastp`:** Lựa chọn ưu tiên hàng đầu cho hầu hết các phân tích RNA-seq và DNA-seq hiện đại. Tự động nhận diện adapter, tốc độ thực thi C++ cực nhanh, tích hợp sẵn báo cáo QC trước/sau cắt tỉa. Phù hợp cho 90% các nhu cầu chuẩn.
    * **`Trimmomatic`:** Sử dụng khi cần kiểm soát thủ công tuyệt đối các bước cắt tỉa, hoặc khi pipeline hạ nguồn yêu cầu tách riêng rẽ các read mất cặp (*unpaired reads*) để tận dụng triệt để dữ liệu. Yêu cầu người dùng phải tự cung cấp tệp adapter FASTA phù hợp.
    * **`Cutadapt`:** Sử dụng trong các bài toán đặc thù yêu cầu cắt bỏ các trình tự mồi nhân tạo (PCR Primers) tùy biến, giải trình tự Small RNA / microRNA hoặc xử lý các cấu trúc thư viện phi chuẩn mà thuật toán tự động của fastp không nhận diện được.

#### Câu hỏi 4: Làm thế nào để tìm được tệp Adapter phù hợp cho mẫu giải trình tự nếu sử dụng Trimmomatic?

* **Học viên thắc mắc:** Trong lệnh của Trimmomatic cần nạp tệp adapter, làm sao để biết mẫu của mình dùng adapter nào?
* **Giải đáp:**
  * Nguồn chính thống nhất là **liên hệ trực tiếp đơn vị dịch vụ giải trình tự (Core Facility / Sequencing Provider)** hoặc xem trong tài liệu kỹ thuật của bộ kit chuẩn bị thư viện (ví dụ: Illumina TruSeq Stranded mRNA Kit, Nextera DNA Flex...).
  * Trimmomatic khi cài đặt qua Bioconda đã tích hợp sẵn một thư mục chứa các tệp adapter phổ biến (`TruSeq2-PE.fa`, `TruSeq3-PE.fa`, `NexteraPE-PE.fa`).
  * Nếu không chắc chắn về loại adapter được sử dụng, giải pháp an toàn và chính xác nhất là chuyển sang sử dụng **`fastp`** với cờ `--detect_adapter_for_pe` để công cụ tự động phát hiện adapter từ chính dữ liệu chồng lấn của mẫu.

#### Câu hỏi 5: Có nên chạy phân tích RNA-seq trên Google Colab không? Và nếu đã có Anaconda trên Windows thì có cần cài thêm Miniforge không?

* **Học viên đặt câu hỏi:** Google Colab có đủ tài nguyên để thực hành toàn bộ khóa học không? Đã cài Anaconda trên Windows kèm WSL2 thì có cần cài Miniforge không?
* **Giải đáp kỹ thuật:**
  * **Google Colab:** Miễn phí và tiện lợi cho việc làm quen ban đầu, nhưng bị giới hạn nghiêm ngặt về dung lượng RAM (thường chỉ 12 GB) và ổ đĩa tạm. Dữ liệu FASTQ của RNA-seq rất nặng (mỗi mẫu từ 2 – 5 GB nén); các bước căn dòng tiếp theo bằng phần mềm STAR đòi hỏi tối thiểu **32 GB RAM** để nạp chỉ mục hệ gen người. Do đó, Google Colab sẽ bị sập (Out of Memory) ở các bước sau. Học viên bắt buộc phải làm quen và vận hành trên môi trường dòng lệnh Linux thực thụ (Terminal Linux / WSL2).
  * **Anaconda vs Miniforge:** Nếu đã cài sẵn Anaconda trên WSL2, bạn vẫn có thể sử dụng bình thường. Tuy nhiên, khuyến khích tạo môi trường mới và cấu hình thứ tự ưu tiên kênh nghiêm ngặt (`strict channel priority`) với kênh `conda-forge` và `bioconda` để tránh xung đột gói thư viện.

---

### V. TỔNG KẾT CỐT LÕI & QUY TẮC THỰC HÀNH (KEY TAKEAWAYS)

```
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                   5 NGUYÊN TẮC VÀNG TRONG TIỀN XỬ LÝ FASTQ                  │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │ 1. Luôn kiểm tra chất lượng (FastQC) TRƯỚC và SAU khi cắt tỉa (Trimming).   │
  │ 2. Hiểu bản chất $Q$-score: $Q30$ là chuẩn mực vàng hiện đại (sai số 0.1%). │
  │ 3. Không hoảng loạn khi thấy dao động base đầu 5' trong RNA-seq (Bias mồi). │
  │ 4. Ưu tiên sử dụng fastp cho pipeline chuẩn nhờ tính tự động hóa và tốc độ. │
  │ 5. Thực hiện phân tích trên môi trường Linux/WSL2; kiểm soát RAM chặt chẽ.  │
  └─────────────────────────────────────────────────────────────────────────────┘
```

1. **Nguyên tắc "Đầu vào sạch, đầu ra chuẩn" (Garbage In, Garbage Out):** Chất lượng của các bước phân tích sinh học chuyên sâu (căn dòng, xác định biểu hiện gen vi sai, phân tích biến dị) phụ thuộc hoàn toàn vào độ sạch của dữ liệu đầu vào. Bỏ qua bước kiểm định chất lượng là nguyên nhân hàng đầu dẫn đến các kết luận sinh học sai lệch.
2. **Quy tắc đọc hiểu báo cáo FastQC trong RNA-seq:** Không phải mọi cảnh báo màu đỏ của FastQC đều là lỗi! Hiện tượng dao động tỷ lệ nucleotide ở 10 – 12 bp đầu tiên (Per Base Content) và mức độ nhân bản trình tự cao (Duplication Levels) là đặc tính sinh học và kỹ thuật tự nhiên của RNA-seq. Ngược lại, cảnh báo đỏ ở phần $\%GC$ (nhiều đỉnh) hoặc Adapter Content dốc đứng là các vấn đề nghiêm trọng bắt buộc phải xử lý.
3. **Sức mạnh của Paired-End:** Dù có khoảng cách không giải trình tự ở giữa, liên kết cặp của Paired-End mang lại thông tin cấu trúc vật lý vô giá giúp loại bỏ căn dòng mơ hồ, tính toán kích thước phân tử và phát hiện các đột biến ung thư phức tạp.
4. **Tối ưu hóa công cụ:** Tận dụng `fastp` để tinh gọn đường ống phân tích từ 3 bước riêng lẻ (FastQC thô $\rightarrow$ Trimming $\rightarrow$ FastQC sạch) vào một quy trình tự động duy nhất, giúp tiết kiệm đáng kể thời gian và tài nguyên tính toán.
5. **Chuẩn bị cho bài học tiếp theo:** Dữ liệu FASTQ sạch sau khi được cắt tỉa và kiểm định đạt chuẩn ở Bài 07 sẽ là đầu vào trực tiếp cho Bài 08: Căn dòng lên hệ gen tham chiếu người (Genome Alignment với STAR) và đếm số lượng đọc (Read Summarization với featureCounts).

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
