# TÀI LIỆU HỌC TẬP: KHÓA HỌC FIGHTING CANCER WITH TRANSCRIPTOMICS 2026

## BÀI 08: INDEX HỆ GEN, ALIGNMENT VỚI STAR, QC SAU ALIGNMENT & COUNTING VỚI featureCounts

*(Reference Genome Indexing, STAR Alignment, Post-Alignment QC & featureCounts — Phần 1 & Phần 2)*

- **Link bài giảng (YouTube):** 
  - [Part 1](https://youtu.be/YpvOTaNcEzw?si=XvKusKP2Kxlg9avW) 
  - [Part 2 — Live](https://www.youtube.com/live/oVkNUDqU1PU?si=8GL1u71SpoPKqebn)
- **Link slide:** [lecture-08_slides](https://mashxp.github.io/Spatial_Transcriptomics_Course/FCWT_2026/lecture-08/lecture-08_slides.html)
- **Link notebook thực hành (Colab):** [lecture-08_star_alignment.ipynb](https://colab.research.google.com/drive/1jnt1hra6XeeAz3QdFKONT9C9a3iXw7V1?usp=sharing) ([local](./lecture-08_star_alignment.ipynb))
- **Link dataset thực hành (GEO/SRA):** [GSE129221](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE129221) — mẫu `GSM3702795` / `SRR8836894`
- **Giảng viên:** Đinh Chấn Phong — 25/10/2026

> [!TIP]
> **Phạm vi bài này:** Bài 07 đưa ra **dữ liệu sạch** (FASTQ đã cắt tỉa). Bài 08 trả lời ba câu hỏi của căn dòng: **read này khớp ở đâu (`POS`), khớp tốt tới mức nào (`CIGAR`), và ta tin chắc tới mức nào (`MAPQ`)**, rồi biến kết quả căn dòng thành **counts** cho phân tích differential expression ở Bài 09.

---

### I. TỪ VỰNG & THUẬT NGUYÊN (GLOSSARY)

| Thuật ngữ (Term) |Ý nghĩa (Definition) |
| :--- | :--- |
| **Alignment (Căn dòng)** | Quá trình xác định vị trí gốc (*origin*) trên hệ gen tham chiếu (*reference*) mà một read nhiều khả năng xuất phát nhất. |
| **Reference Genome (Hệ gen tham chiếu)** | Bộ trình tự "chuẩn" của một loài (ở đây là GRCh38 của người), dùng làm nền để mapping các read. |
| **Suffix Array (Mảng hậu tố)** | Cấu trúc dữ liệu của STAR: mỗi dòng là một vị trí trong hệ gen, được sắp xếp theo thứ tự từ điển (*lexicographic*) của chuỗi hậu tố bắt đầu từ vị trí đó. Cho phép tra cứu nhanh bằng lookup thay vì quét tuần tự. |
| **Seed (Seed length / MMP)** | Đoạn chuỗi ngắn nhất STAR dùng làm "mồi" để tìm điểm bám đầu tiên vào hệ gen bằng suffix array. |
| **Anchored Seed (Seed bám)** | Seed đã được xác nhận là neo vào hệ gen; cụm (*cluster*) các seed bám trên cùng một read là ứng viên vị trí căn dòng. |
| **Splice Junction (Điểm nối splice)** | Boundary giữa hai exon, nơi read bị "cắt" (`N` trong CIGAR). Gồm acceptor (đầu 5', motif `AG`) và donor (đầu 3', motif `GT`). |
| **Intron** | Đoạn trình tự nằm giữa hai exon **không có trong read** → được ghi nhận bằng `N` trong CIGAR, không phải bằng `D` (deletion). |
| **Split / Spliced Alignment** | Căn dòng cho phép một read "nhảy" qua intron, tạo ra các khối match (`M`) bị ngăn cách bởi `N`. |
| **Soft-clip (Cờ `S`)** | Phần đầu/cuối read bị **cắt bỏ** trong CIGAR (thường là adapter, mồi, hoặc read dài hơn khối bám), read vẫn được giữ nguyên trong record. |
| **Splice Junction Database (`--sjdbGTFfile`)** | Danh sách junctions lấy từ GTF, giúp STAR **chính xác và nhanh hơn** (không cần thử mọi tổ hợp). |
| **`--sjdbOverhang`** | Độ dài phần read bắc qua junction; bắt buộc = **read length − 1** (150 bp → 149). |
| **SAM (Sequence Alignment Map)** | Định dạng văn bản dạng bảng, tab-separated, mô tả kết quả căn dòng. |
| **BAM (Binary Alignment Map)** | Bản nén nhị phân của SAM, định dạng chuẩn trong pipeline NGS. |
| **CRAM** | Bản lossy, tham chiếu nền; tiết kiệm nhất, cần reference khi giải nén. |
| **`.bai` (BAM index)** | Index sidecar tạo bằng `samtools index`, bắt buộc cho truy vấn theo tọa độ (`samtools view FILE contig:start-end`), truy vấn tên read (`-r REGEX`) và IGV. |
| **QNAME (Column 1)** | Tên read (`read1`/`read2`), **phải đồng nhất** giữa hai đầu đọc của cùng một fragment. |
| **FLAG (Column 2)** | Số nguyên bit-mask mô tả trạng thái read: paired, mate mapped, reverse strand, strand của mate... |
| **CIGAR (Column 6)** | Chuỗi mô tả read khớp vào reference theo từng khối (`M`, `I`, `D`, `N`, `S`, `H`, `P`, `=`). |
| **MAPQ (Mapping Quality, Column 5)** | Độ tin cậy read thuộc **đúng một** locus. Thang STAR: `255` (nhất quán cao), `1`, `3`, `0` (nhiều locus). |
| **Multi-mapping (Đa căn dòng)** | Hiện tượng một read khớp hoàn hảo ở **nhiều vị trí** trên hệ gen; STAR giữ một record primary, các bản còn lại là **secondary**. |
| **Secondary Alignment** | Bản căn dòng phụ, được đánh bit `0x100`; dùng để **kế thừa** số lượng locus, không được dùng để đếm. |
| **Supplementary Alignment** | Bản căn dòng bổ sung (bit `0x800`) cho read bị xé thành nhiều phần (fusion, read xuyên junction dài). |
| **Unmapped / `*`** | Read không map vào contig nào; cột contig, POS, MAPQ, CIGAR = `*`. |
| **TLEN (Template Length, Column 9)** | Độ dài fragment **suy ra từ vị trí căn dòng**, không phải độ dài đo thật của fragment. |
| **Properly Paired (bit `0x02`)** | Cặp read được gắn kết đúng quy ước thư viện (đúng hướng, khoảng cách phù hợp). |
| **Primary record** | Record chính thức của một read; số primary + secondary = tổng record. |
| **Fragment (Bản phiên)** | Đơn vị đếm của featureCounts: một **molecule** cDNA gồm 2 read, không phải 2 read rời rạc. |
| **Mapping Rate** | Tỷ lệ read/fragment map vào reference; con số **phải gắn với denominator** của nó. |
| **Insert Size** | Độ dài suy ra của fragment từ cặp read properly paired (`samtools stats`). |
| **featureCounts** | Công cụ (thuộc gói Subread/SubreadTools) đếm fragment overlap với feature (`exon`) và gộp theo `gene_id`. |
| **Strandedness (`-s 0/1/2`)** | Hướng thư viện: `0` unstranded, `1` forward, `2` reverse. Sai giá trị → **mất một nửa counts**. |
| **Contamination (Nhiễm bẩn)** | Reads đến từ sinh vật/loài không có trong reference → dồn vào một contig nhỏ, mapping rate thấp. |
| **rRNA Read** | Read thuộc ribosomal RNA; xuất hiện trong thư viện khi depletion không sạch. |
| **`Log.final.out` / `Log.out` / `Log.progress.out`** | Nhóm log kỹ thuật STAR: tổng kết cuối, log dựng index, tiến độ theo chunk. |
| **`--outSAMtype BAM SortedByCoordinate`** | Kiểu xuất BAM đã sắp xếp theo tọa độ; bắt buộc cho featureCounts, samtools region query, IGV. |
| **Pseudo-aligner** | Công cụ đếm trực tiếp vào transcriptome, **không sinh BAM** (salmon, kallisto, alevin). |

---

### II. NỘI DUNG LÝ THUYẾT & KỸ THUẬT CHI TIẾT

#### 1. Ôn tập & kiểm tra 15 phút: đặt nền từ FASTQ tới Alignment

Trước khi vào căn dòng, lớp ôn lại ba trụ cột của Bài 07 và chốt lại bằng 3 câu hỏi kiểm tra.

##### 1.1. Kiểm tra 15 phút — 3 tình huống kinh điển

**Câu 1 — Interpretation của dòng 4 trong FASTQ (đổi thang điểm Phred).**

Một file FASTQ có cấu trúc 4 dòng:

```text
@SRR8836894.1 1/1              ← 1. Tên read
GTCGGAGCACATCTTGCTGGCCCAGGTGTTCAGCAAGATGGAGCAGGTGTCTGGCGTG  ← 2. Sequence (60 bp)
+                              ← 3. Dấu cộng
AFAI<FFF77<AF-AAF7FAAJJJ7JFAJ-FFF-FF--7---F<<F<AJJFFAFJJAJ-  ← 4. Quality string
```

Ký tự **`I`** ở dòng chất lượng (ASCII 73) → $Q = 73 - 33 = 40$.

| ASCII | 70 | 71 | 72 | **73** | 74 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Char | `F` | `G` | `H` | **`I`** | `J` |
| Phred+33 | 37 | 38 | 39 | **40** | 41 |

- **Câu hỏi lớp đặt ra:** "`I` là trình tự sai, không căn dòng được?" → **sai**; `I` là **ký tự chất lượng cao**, không phải ký tự lỗi.
- **Kết luận đúng:** Chất lượng `Q40` nghĩa là **xác suất gọi sai base là $10^{-4}$** (0.01%), và $P_{\text{correct}} = 1 - 10^{-4} = 0.9999$ (99.99%). Đây là **chất lượng cao**, không phải lỗi.

**Bài học cốt lõi:** Đổi qua lại giữa **thang Phred (log₁₀)** và **xác suất lỗi** là kỹ năng "đi theo" các dòng log, các bảng QC, các hàm R ở bài sau.

**Câu 2 — Cắt tỉa gì, khi nào cắt, cắt ra sao (đọc FastQC trước, cắt sau).**

Tình huống đưa ra một FastQC plot có:

- Adapter content dốc cao, xuất hiện ở các vị trí cuối read.
- Ramp chất lượng tăng ở vài base đầu (`per-base sequence quality` ramp), sau đó giảm ở **20–25 base cuối**.
- Length plot cho thấy phần lớn read trong khoảng 36–150 bp.

Chiến lược đúng:

1. **Chạy FastQC TRƯỚC** khi cắt tỉa.
2. **Cắt adapter** (`--adapter_sequence` / `--detect_adapter_for_pe`).
3. **Cắt chất lượng thấp ở đuôi 3'** (`--quality_avg 20`).
4. **Bỏ read quá ngắn** (`--minimum_length 36`).

Phương án được đưa trong lớp: **cut adapter + `--quality_avg 20 --minimum_length 36`** — **đúng**.

> [!WARNING]
> **Cắt tỉa không phải "nghi thức" bắt buộc!**
> - FastQC plot cho thấy 90% read **đã đạt chuẩn**, chỉ phần đuôi bị suy giảm → cắt **phần suy giảm**, không cắt toàn bộ.
> - Nếu dữ liệu **đã sạch** → **không cắt tỉa**, vì cắt sẽ làm **mất dữ liệu** (mất base, mất read, giảm số lượng read).
> - **Quy trình chuẩn:** FastQC trước $\rightarrow$ `fastp` $\rightarrow$ FastQC sau $\rightarrow$ MultiQC. **Phải chứng minh** được chất lượng read **được cải thiện** sau khi cắt.

**Câu 3 — Bắt buộc số read Read 1 và Read 2 phải bằng nhau.**

Tình huống: `R1_1.fastq.gz` có **4,998,000** records, `R2_1.fastq.gz` có **5,000,000** records.

**Không thể align được**, vì:

1. **Cấu trúc 4 dòng:** Số dòng file FASTQ phải **chia hết cho 4** (`wc -l` → chia cho 4 là số nguyên).
2. **STAR đọc cặp theo mate:** STAR đọc **1 read R1 + 1 read R2** liên tiếp, **ghép thành 1 fragment**.
3. **Lệch số lượng → lệch khung cặp:** read thứ 4,998,001 của R1 sẽ bị ghép với **read thứ 5,000,001** của R2, dẫn đến **sai cặp toàn bộ phần đọc**.
4. **Hậu quả nghiêm trọng:** sai **kích thước fragment** → sai suy luận vị trí gen → **sai kết quả phân tích biểu hiện gen** ở bài sau.

> [!IMPORTANT]
> **Kiểm tra số records trước khi align** = **thói quen vàng**. Lỗi này **cực khó phát hiện** khi chỉ nhìn kết quả.

**Công thức kiểm tra nhanh:**

```bash
# Mỗi file FASTQ: số dòng chia hết cho 4
zcat R1_1.fastq.gz | wc -l   # chia cho 4 → integer (số record)
# STAR: số read R1 == số read R2 → số dòng R1 == số dòng R2
```

##### 1.2. Bài toán căn dòng ("Where / How well / How sure")

Với một **read 150 bp** và **hệ gen người 3 Gb** ($3\times 10^9$ bp), ta không thể "đọc từng vị trí".

Ba câu hỏi kỹ thuật (chính là 3 cột trong SAM/BAM):

1. **Where** — read **đến từ vị trí nào** trên hệ gen? $\rightarrow$ **Column 4 (`POS`)**.
2. **How well** — read khớp **tốt tới đâu**, có gap, indel, spliced junction không? $\rightarrow$ **Column 6 (`CIGAR`)**.
3. **How sure** — ta **tin** read đó nằm ở đây **mạnh tới đâu**? $\rightarrow$ **Column 5 (`MAPQ`)**.

##### 1.3. Bốn lý do "matching thô" thất bại

1. **Sequencing errors & variants** — read có **base mismatch** (lỗi máy, SNP, mutation) → cần **alignment có mismatch**, không phải **exact matching**.
2. **Poly-A & repetitive elements** — một read toàn poly-A, hoặc read thuộc Alu/LINE/repeat, **map vào hàng trăm vị trí** → ta không biết **đọc đến từ locus nào** → sinh ra **multi-mapping**, giảm **MAPQ**.
3. **Strandedness — read đến từ cả hai sợi** — read có thể xuất phát từ **strand forward** lẫn **strand reverse** $\rightarrow$ công cụ **phải xử lý cả hai chiều** (STAR, HISAT2 đều vậy), còn `grep`/`egrep` hay **regex chỉ quét một chiều**.
4. **Splicing — RNA-seq bỏ intron** — pre-mRNA chứa intron, mature mRNA chỉ còn exon. Một read **150 bp** bắc qua junction exon 1 → intron → exon 2 sẽ có **100 bp ở exon 1, 50 bp ở exon 2**, **6500 bp ở giữa không có trong read**. $\rightarrow$ **không thể dùng một block match liên tục.**

> **Bài toán tổ hợp:** read 150 bp, có 100/50 bp split, và **hàng chục intron** (hàng trăm kb) trên hệ gen, tổng số cách tổ hợp **vượt khả năng tính toán brute force** $\rightarrow$ **bắt buộc cần index** (suffix array).


#### 2. Hai trường phái công cụ alignment trong RNA-seq

| Nhóm công cụ | Đại diện | Đầu ra | Điểm mạnh | Hạn chế |
| :--- | :--- | :--- | :--- | :--- |
| **Genome aligner** (căn dòng lên hệ gen) | **STAR**, **HISAT2** | **BAM** | chính xác, **thấu cảm** (minh bạch từng read), **xem được trong IGV**, dùng được cho **splicing, fusion, SNP, QC** | nặng tài nguyên (RAM, CPU), cần index hệ gen |
| **Transcriptome / Pseudo-aligner** (căn dòng vào transcript) | **salmon**, **kallisto**, **alevin** | **counts trực tiếp** (không có BAM) | **rất nhanh**, tiết kiệm RAM, tối cho **gene-level expression** | **không có BAM** → không IGV, không splicing/fusion analysis, không QC tọa độ |

> [!NOTE]
> **Space Ranger** (10x Genomics) là công cụ xử lý không gian (**spatial transcriptomics**, nền tảng **Visium**); **bên trong nó chạy STAR** cho bước căn dòng. Không xếp Space Ranger vào pseudo-aligner.

> [!IMPORTANT]
> **Lựa chọn của lớp là STAR** vì lớp **cần BAM**: để xem trong IGV, để đếm bằng featureCounts, để phân tích splicing. Pseudo-aligner tối ưu cho gene-level counts, nhưng không trả lời được câu hỏi cấu trúc.

#### 3. Giải thuật STAR 101 — "Spliced Transcripts Alignment to a Reference"

STAR (Dobin et al., *Bioinformatics* 2013) gồm **4 bước**: **1 Index · 2 Seed · 3 Extend · 4 Stitch**.

```
      READ 150 bp (R1 + R2)
      ┌────────────────────────────────────────────────────────────┐
      │  S1  S2  S3  S4  S5  ...  Sn        ← seed length (MMP)    │
      └────────────────────────────────────────────────────────────┘
                          │
                          ▼   lookup trong SUFFIX ARRAY
      REFERENCE (contig 17, 21, 22 — hậu tố đã sắp xếp theo từ điển)
      ┌────────────────────────────────────────────────────────────┐
      │ 1. SEED    tìm nơi đầu tiên bám vào reference              │
      │ 2. SEED    tìm seed tiếp theo ở phần read chưa khớp        │
      │ 3. EXTEND  mở rộng 2 phía, chấp nhận mismatch              │
      │ 4. STITCH  cụm hóa seed → ghép alignment → phát hiện intron│
      └────────────────────────────────────────────────────────────┘
```

##### 3.1. Bước 1 — Index: Suffix Array (mảng hậu tố)

* **Cấu trúc:** index **mỗi vị trí** trong hệ gen — mỗi dòng = một vị trí, sắp xếp **theo thứ tự từ điển** của hậu tố bắt đầu tại vị trí đó.
* **Cốt lõi:** STAR **lookup** (tra cứu nhị phân), **không scan** (quét từng vị trí) như `grep`/`egrep`/regex.
* **Hệ quả khi lookup:** với read 150 bp, STAR tìm tập hợp **tất cả** các vị trí có seed xuất hiện, rồi chọn seed **nhiều khả năng nhất** (thường seed **dài nhất, rare nhất**).

> **Ví dụ minh họa trong lớp:** hệ gen mẫu gồm các chuỗi `ACACGG`, `CAGT`, `CTTG`, `GCTA`, `TGAA`, `TTGG`. Suffix array cho `ACACGG` (và toàn bộ reference) sẽ sắp xếp hậu tố theo thứ tự từ điển: `ACACGG` → `CACGG` → `ACGG` → `CGG` → `GG` → `G`, kèm vị trí gốc `0, 1, 2, 3, 4, 5` tương ứng.

* **Chi phí tài nguyên của index:**

| Reference | Index build | Index on disk | Peak RAM |
| :--- | :--- | :--- | :--- |
| **3 NST** (chr17, chr21, chr22 — 180.8 Mb) | **77 s** (16 threads) | **1.7 GB** | **4.1 GB** |
| **Whole genome** | **hàng giờ** | **~28 GB** | **~28 GB** |

Trong Colab (2 vCPU, 12 GB RAM): index 3 NST tốn **~25 phút**, index whole-genome **không chạy được** vì RAM.

* **Giảm RAM:** `--genomeSAsparseD` = **thinning** suffix array; kích thước = $(1 + 8/sparseD) \times$ genomeLength.
  * `sparseD 1` → **~1.6 GB** (dense, nhanh), `sparseD 2` → **~0.9 GB**, `sparseD 0` → **4.1 GB** (số của slide).
  * Colab của lớp: RAM không khan hiếm → **chọn `sparseD 1` để lấy tốc độ**. **Memory-for-speed dial.**

##### 3.2. Bước 2 & 3 — Seed, Extend, và splice site

* **Seed 1** (`MMP` — Minimum Match Portion): read được cắt thành các seed bằng `seedLength`. Seed đầu tiên được lookup trong suffix array; nếu seed map vào **nhiều locus** → seed bị coi là **quá phổ biến**, chuyển sang seed kế tiếp.
* **Seed 2:** tìm trong **phần read chưa khớp**. Nếu seed thứ hai **không map về phía trước seed 1** mà map ở **vị trí xa hơn** → đó chính là **spliced alignment**, và STAR kiểm tra motif splice site:
  * **donor (`GT`)** nằm ở **đầu 5′ của intron** (tiếp giáp cuối exon của seed 1),
  * **acceptor (`AG`)** nằm ở **cuối 3′ của intron** (tiếp giáp đầu exon của seed 2).
  $\rightarrow$ read có **110 bp bám exon 1**, **40 bp bám exon 2**, khoảng trống **7,018 bp** ở giữa khớp motif **`GT…AG`** → CIGAR **`110M7018N40M`**.
* **Extend:** STAR mở rộng seed **2 phía**, **chấp nhận mismatch** (do lỗi giải trình tự/SNP). Seed ngắn + nhiều mismatch → **loại**; seed dài, bám tốt → **giữ**.
* **Soft clip (`S`)**: phần đầu/cuối read **bị cắt** trong CIGAR (thường là **adapter** còn sót, mồi, phần read bám kém). STAR giữ nguyên read, chỉ **khai báo phần không khớp** trong CIGAR.

##### 3.3. Bước 4 — Stitch (Clustering, Anchor Seeds, Intron)

* **Cluster** các seed bám trên cùng read (anchor seeds, min spacing = `seedMinSpace`).
* **Nối** các cluster → nếu hai anchor cách nhau **một khoảng trống lớn** và biên khớp motif `GT…AG` → **đó là intron**, ghi thành `N` trong CIGAR.
* **Splice junction** của read **so với GTF** (`--sjdbGTFfile`):
  * **annotated junction** (có trong GTF) → chính xác, nhanh.
  * **novel junction** (không có trong GTF, chỉ motif) → `--alignSJoverhangMin` cho phép khám phá.

> [!NOTE]
> **STAR cần biết cả hai strand.** Sợi reverse được căn dòng (bit `0x10` của FLAG), STAR **đảo ngược read + complement** khi báo cáo; ta không phải xử lý thủ công.

#### 4. Lựa chọn cờ STAR trong lớp và ánh xạ tới giải thuật

Cờ STAR **quy định** chính 4 bước trên:

```bash
STAR \
  --runThreadN 16 \
  --genomeDir  data/STAR/index \
  --readFilesIn R1_1.fastq.gz R2_1.fastq.gz \
  --readFilesCommand zcat \
  --sjdbGTFfile data/gtf/Homo_sapiens.GRCh38.sub.gtf \
  --sjdbOverhang 149 \
  --outSAMtype BAM SortedByCoordinate \
  --outFileNamePrefix sample.
```

| Cờ STAR | Ánh xạ vào giải thuật | Ghi chú thực hành |
| :--- | :--- | :--- |
| `--genomeSAindexNbases` | kích thước prefix index — **bước 1** | **14** cho whole genome, **12** cho reference nhỏ. **Sai → segfault!** |
| `--genomeSAsparseD` | **thinning** suffix array | $(1+8/sparseD)\times$genomeLength: `1`→~1.6 GB, `2`→~0.9 GB, `0`→4.1 GB |
| `--seedLength` / `--seedMultimapNmax` / `--seedPerReadNmax` / `--seedPerWindowNmax` | **bước 2 — seed** | số seed mỗi read, số locus tối đa cho một seed |
| `--seedAttractor` | giới hạn seed ở vùng lặp lại cao (`1000`, `300`, `200`, `100`, `50`) | giảm seed trong repeat-rich zone |
| `--seedPerMinFactor` | **soft-clipping** — **bước 3** | seed quá ngắn so với read → clip |
| `--alignIntronMax` / `--alignMatsGapMax` | **khoảng trống stitch** — **bước 4** | max intron / max mismatch gap |
| `--alignSJoverhangMin` | **novel junction** | số base bắt buộc bám 2 phía junction **không có trong GTF** |
| `--alignSJDBoverhangMin` | **annotated junction** | số base bắt buộc bám 2 phía junction **có trong GTF** |
| `--alignMultiEndNtrimMin` | **multi-mapping** | số base biên phải cắt khi đọc map đa locus |
| `--outFilterMultimapNmax` | lọc read multi-mapping **trước khi xuất** | số locus tối đa được xuất |
| `--twopassMode Basic` | **2 pass** | pass 1 thu junction mới, pass 2 dùng junction đã khám phá |
| `--sjdbGTFfile` + `--sjdbOverhang` | **annotated junctions** | `sjdbOverhang = read length − 1` |
| `--outSAMtype BAM SortedByCoordinate` | **đầu ra** | bắt buộc cho IGV/featureCounts |
| `--outWigType bedGraph` | coverage signal | đường bao phủ read (bedGraph/bigWig) |
| `--outFilterMismatchNmax` | chấp nhận mismatch | số mismatch tối đa mỗi read |
| `--outSAMunmapped Within` | xuất **unmapped** vào BAM | hữu ích cho QC, tăng kích thước BAM |
| `--outReadsUnmapped Fastx` | lưu **unmapped** thành FASTQ | dùng cho QC thêm |
| `--chimeraSegmentMinLength` | **chimeric/fusion** | phát hiện fusion gene |
| `--quantMode GeneCounts` | STAR tự đếm theo gene | **thường nhanh hơn** vì đếm ngay trong lúc align; chỉ theo GTF |

> [!WARNING]
> **Cờ quan trọng nhất trong lớp:** `--genomeSAindexNbases` **phải đặt bằng 12** cho reference 3 NST. **Whole genome = 14** (default). Quên đặt → **STAR segfault ngay khi dựng index**.

#### 5. Đọc hiểu BAM/SAM

##### 5.1. Định dạng và header

| Định dạng | Nội dung | Đặc điểm |
| :--- | :--- | :--- |
| **SAM** | văn bản, tab-separated | đọc được, lớn, không nén |
| **BAM** | nhị phân, gzipped (deflate) | **standard** trong NGS, cần `samtools view` |
| **CRAM** | lossy, **cần reference** khi decode | tiết kiệm nhất |
| **`.bai`** | index sidecar | tạo bằng `samtools index` |

Header BAM (`samtools view -H sample.bam`):

```text
@HD  VN:1.6  SO:coordinate
@SQ  SN:17  LN:83257441
@SQ  SN:21  LN:46709983
@SQ  SN:22  LN:50818468
@RG  ID:121  SM:SRR8836894  LB:121  PL:ILLUMINA
@PG  ID:STAR PN:STAR  VN:2.7.11b
     CL:STAR --runMode alignReads --genomeDir data/star_index ...
```

* `@SQ`: danh sách contig — **phải khớp tên với reference**. **Trong run này contig tên là `17`, `21`, `22` (không phải `chr17`!)** → đây chính là bẫy naming hay gặp.
* `@RG`: read group — `SM` (sample name), `LB` (library), `PL` (platform).
* `@PG`: **toàn bộ lệnh STAR** (`CL:`), phiên bản, thời gian chạy → **provenance**.
* SAM header **bị giới hạn ~64 KB** ở một số công cụ.

##### 5.2. 11 cột của SAM

| Cột | Tên | Nội dung |
| :--- | :--- | :--- |
| 1 | **QNAME** | tên read (`read1`/`read2`); **phải đồng nhất** giữa mates |
| 2 | **FLAG** | bit-mask trạng thái read/pair |
| 3 | **RNAME** | contig (`17`, `21`, `22`, `*`) |
| 4 | **POS** | vị trí gốc (leftmost) trên reference |
| 5 | **MAPQ** | độ tin cậy locus duy nhất |
| 6 | **CIGAR** | mô tả khối match/indel/intron/clip |
| 7 | **RNEXT** | contig của mate (`=`, `*`) |
| 8 | **PNEXT** | vị trí của mate |
| 9 | **TLEN** | độ dài template/fragment |
| 10 | **SEQ** | chuỗi read |
| 11 | **QUAL** | chuỗi chất lượng |

##### 5.3. FLAG — bit mask

| Bit | Hex | Ý nghĩa |
| :--- | :--- | :--- |
| 1 | `0x01` | paired |
| 2 | `0x02` | proper pair |
| 4 | `0x04` | **unmapped** |
| 8 | `0x08` | mate unmapped |
| 16 | `0x10` | **reverse strand** |
| 32 | `0x20` | mate reverse strand |
| 64 | `0x40` | **read1** trong pair |
| 128 | `0x80` | **read2** trong pair |
| 256 | `0x100` | **secondary alignment** |
| 512 | `0x200` | **QC fail** |
| 1024 | `0x400` | **duplicate** |
| 2048 | `0x800` | **supplementary** |

**Ví dụ:** `FLAG = 99` = $1 + 2 + 32 + 64$ = **paired + properly paired + mate forward strand + read1**.
Flag của mate: `147` = $1 + 2 + 16 + 128$ = **paired + properly paired + self reverse strand + read2**.

* **Trong BAM của lớp:** **300 records flag 99**, **300 records flag 147**, trên tổng **1,472 records**.

> [!NOTE]
> **Bit 16 (`0x10`) mô tả read** (read gắn vào **strand reverse** của reference), không có nghĩa read bị "lộn ngược". STAR đã complement khi báo cáo SEQ.

##### 5.4. CIGAR — đọc CIGAR như đọc bản đồ

| Op | Tên | Reference | Read |
| :--- | :--- | :--- | :--- |
| `M` | match/mismatch | tiêu tốn | tiêu tốn |
| `I` | insertion | không tiêu tốn | **tiêu tốn** |
| `D` | deletion | **tiêu tốn** | không tiêu tốn |
| `N` | **intron / gap** | **tiêu tốn** | không tiêu tốn |
| `S` | **soft clip** | không tiêu tốn | **tiêu tốn** |
| `H` | hard clip | không tiêu tốn | không tiêu tốn |
| `P` | padding (sparse array) | không tiêu tốn | không tiêu tốn |
| `=` | sequence match | tiêu tốn | tiêu tốn |
| `X` | sequence mismatch | tiêu tốn | tiêu tốn |

**Đếm:**

* độ dài **read** = $\sum M + I + S + H$
* độ dài **span reference** = $\sum M + D + N + =$ + $X$

**Splicing qua CIGAR:**

```text
110M7018N40M
```

$\Rightarrow$ read 150 bp, **110 bp ở exon 1**, **7018 bp intron** (biên `GT…AG`), **40 bp ở exon 2**.

**Decode record thật (record 3781):**

```text
SRR8836894.3781  99   17   79100   255   110M7018N40M   =   79158   7225
```

* read 1 map vào contig `17`, POS 79,100, **span reference = 110 + 7018 + 40 = 7,168 bp** → kết thúc ở **86,267**.
* **span read = 150 bp**.
* `= 79158` → mate map **cùng contig** (`=`), POS **79,158**.
* `TLEN 7225` = khoảng cách từ **POS trái nhất** → **rightmost mate end** = $79{,}100 + 7{,}225 - 1 = 86{,}324$.
* **Mate record**: flag `147`, CIGAR `52M7018N97M1S` — mate nằm ở **strand reverse** (SEQ được STAR báo ở dạng reverse-complement, CIGAR vẫn tính theo tọa độ reference), kết bằng **soft clip `1S`** — adapter!, kết ở **86,324**.
* $\Rightarrow$ **fragment chứa 1 junction, span 7,225 bp** = **2 exon của một gene trên contig `17`** + intron 7,018 bp.

**Record spliced khác (decode bài tập về nhà):**

```text
SRR8836894.3116  99   17  1875710  255   84M1418N66M   =  1878996  3589   NH:i:1
SRR8836894.3116  147  17  1878996  255   66M153N84M    =  1875710  -3589  NH:i:1
```

* **Exon blocks** (tự decode, đối chiếu IGV):
  * read1: `84M` (1,875,710–1,875,793) + `1418N` + `66M` (1,879,212–1,879,277) → span **1,568 bp**.
  * read2: `66M` (1,878,996–1,879,061) + `153N` + `84M` (1,879,215–1,879,298) → span **237 bp**.
  * `TLEN 3589` → rightmost end = $1{,}875{,}710 + 3{,}589 - 1 = 1{,}879{,}298$ ✓ (khớp cuối read2).
  * $\Rightarrow$ fragment chứa **2 junction** (1,418 bp và 153 bp).
* `NH:i:1` → **1 locus duy nhất** → MAPQ 255.

##### 5.5. MAPQ, multi-mapping & secondary

* STAR báo MAPQ ở **vài mức cố định**, không trải đều 0–255:
* **MAPQ 255 là "label unique" của STAR, không phải một xác suất.** MAPQ trả lời **"read này có thể đến từ bao nhiêu nơi?"**, **KHÔNG trả lời "base này đúng tới đâu?"**.

| MAPQ | Ý nghĩa |
| :--- | :--- |
| **255** | **best** — nhất quán cao, unique |
| **254** | best, 2 loci, 1 locus hơn locus kia 1 base |
| **253** | best, 2 loci, hơn ≥2 base |
| **252** | best, ≥3 loci, hơn 1 base |
| **250** | best, ≥3 loci, hơn ≥2 base |
| **249** | best, 4 loci, hơn ≥2 base |
| **1** | **multi** — không locus nào nổi bật |
| **3** | **multi** — kém hơn một chút |
| **0** | **multi** — nhiều locus, **read dài** |

* **STAR chỉ xuất 1 record primary** cho mỗi read; các locus còn lại → **secondary** (bit `0x100`).
* **Counting** (**featureCounts/STAR**): **secondary bị loại** — vì số lần map **đã được kế thừa qua `NH` và `MAPQ`**.
* **Distribution trong lớp (BAM 1,472 records):**

```text
1106  MAPQ 255   (553 fragments unique × 2 mates)
  48  MAPQ   3   ┐
  76  MAPQ   1   ┘ = 124 records = 62 fragments multi-mapping
```

* **Spike ở 255** = unique; **đuôi nhỏ ở 0–3** = multi-mapping. **Đuôi 0–3 lớn** = repeats/rRNA. **MAPQ 0 cũng có thể là "unmapped"** → **kiểm tra FLAG bit 4** trước khi kết luận.

```bash
samtools view BAM | cut -f5 | sort -n | uniq -c
```

##### 5.6. Tag phụ trợ

| Tag | Ý nghĩa |
| :--- | :--- |
| `NH` | số locus trong alignment (`NH:i:1` → unique) |
| `NPS` | số mismatch trong **best** alignment |
| `SO` | số **spliced** alignment của read |
| `AS` | alignment score |
| `KS` | read sequence đã trim |
| `XN` | số **N** trong read |
| `NCC` | số **N** trong CIGAR (số intron) |
| `MC` | số **M** trong CIGAR |
| `Xt` | strand của transcript (`+`/`-`) |
| `CR`/`CR2` | coordinate của read **trước** khi STAR map |
| `KQ`/`QB`/`QM`/`QR` | base/quality của read **trước** khi STAR map |


#### 6. QC sau alignment — hai tầng kiểm tra, một cái bẫy

**Nguyên tắc vàng:** **KHÔNG tin báo cáo của aligner cho đến khi nó được đối chiếu với chính BAM.**

| Tầng | Nguồn | Bản chất |
| :--- | :--- | :--- |
| **Tầng 1 — Ý kiến của aligner** | `sample.Log.final.out` | STAR **tự báo cáo** về chính nó (mapping rate, splice, mismatch) |
| **Tầng 2 — Bằng chứng trong BAM** | `samtools flagstat` / `idxstats` / `stats` | **đếm từ record thật**, **đọc thẳng từ BAM** |

##### 6.1. `Log.final.out` — báo cáo STAR annotated

```text
                                    Started job on       Oct 23 14:39:31
                                    Finished job on      Oct 23 14:39:32
                                    Input:               5000     ← số FRAGMENTS (cặp), không phải số read
                     Unique reads mapped to: 553
                     % uniquely mapped reads: 11.06%   ← ⚠️ denominator = 5000 fragments
                     Multi-map reads mapped to: 62
                     % reads mapped to multiple loci: 1.24%
                     Splices: Total 443
                     Mismatch rate per base: ...
```

**Cài cờ để mở rộng báo cáo:** `--outFilterMismatchNmax`, `--outFilterMultimapNmax`, `--outSAMunmapped Within`, `--outWigType bedGraph`, `--quantMode GeneCounts`, `--twopassMode Basic`.

##### 6.2. Cái bẫy denominator (bẫy mẫu số)

Con số `11.06%` **phải được diễn giải đúng**:

```text
5,000 input fragments (cặp read)
  × (11.06% unique + 1.24% multi) = 615 fragments mapped
  × 2 mates                        = 1,230 primary records
  + 242 secondary records          = 1,472 total records   ← số dòng trong BAM
```

**Ba điều phải nhớ khi đọc log:**

1. **Con số phải gắn với denominator của nó.** `11.06%` nghĩa là **553/5000 FRAGMENTS**, không phải 553/1,472 records, không phải % số dòng BAM.
2. **Số record ≠ số read.** 5,000 cặp = **10,000 read**; trong BAM chỉ **1,230 primary** + **242 secondary**.
3. **Primary + secondary = total.** 1,230 + 242 = 1,472. **Secondary không được đếm.**

##### 6.3. `samtools flagstat` — đếm từ record

```text
1472 + 0 records in total (Primary alignment: 1230)   ← total records (primary + secondary)
1472 + 0 records in quality-qualified samples
1230 + 0 records in primary alignment
 242 + 0 records in secondary alignment
1230 + 0 mapped
1230 + 0 paired in sequencing
1230 (100.0%) properly paired
1230 + 0 with itself and mate mapped
   0 + 0 singletons
   0 + 0 duplicated
1230 + 0 first in pair
1230 + 0 second in pair
```

* `1,230 primary` = **615 read1 + 615 read2** (553 unique fragments + 62 multi-mapping fragments).
* `100% properly paired` **tính trên primary**.
* **Red flag:** properly paired **thấp** = **vấn đề thư viện** (không phải aligner).

##### 6.4. `samtools idxstats` — reads per contig (bước quan trọng nhất)

```text
contig   length     mapped   unmapped
17       83,257,441 830      0
21       46,709,983 378      0
22       50,818,468 264      0
*        —          0        0
```

**Tổng = 830 + 378 + 264 = 1,472 record = khớp flagstat.**

* `idxstats` trả lời: **read đã map đi đâu**, và **bao nhiêu không có chỗ đáp**.
* Trong một reference thực thụ, `*` (unmapped) là **nửa số read** khi reference không khớp mẫu → **dấu hiệu reference sai / naming mismatch**.

##### 6.5. `samtools stats` — insert size & coverage bias

```bash
samtools stats BAM | grep 'insert size'
```

* Insert size là **độ dài fragment suy ra từ vị trí căn dòng**, **KHÔNG phải độ dài đo thật** của fragment.
* **Coverage bias** (5′/3′ bias), **strand bias**, **rRNA reads**, **duplicate**, **insert size peak** $\rightarrow$ là các metric của **Qualimap / Picard / MultiQC** dùng trong production.

##### 6.6. Bảng "RED FLAG" chẩn đoán

| Dấu hiệu | Nguyên nhân chính | Hành động |
| :--- | :--- | :--- |
| **Unmapped cao** | **sai reference / contig naming / rRNA** | so `@SQ` names với FASTA/GTF |
| **Unmapped cao** (50%+, trên reference whole-genome) | **sai reference** (species/build), **contamination** (nhiễm virus, mycoplasma, vi khuẩn, species khác), **adapter/thư viện lạ**, **naming mismatch** (`17` vs `chr17`) | dùng đúng reference, sửa naming, kiểm tra species |
| **Nhiều "too many loci"** | **repeats, rRNA, read quá ngắn** | `--outFilterMultimapNmax`, FastQC |
| **Mismatch > 2–3%** | **sai species/assembly, contamination** | reference build |
| **Nhiều "too short"** | **over-trimming** | trim settings, read length |
| **Unmapped cao** (chấp nhận được) | **reference bị rút gọn** — chỉ chr17/21/22 (5.85% hệ gen) | **KHÔNG phải lỗi** — mapping rate ~11% là **đúng kỳ vọng** |
| **Uniquely mapped thấp** | **quá nhiều locus** (repeats, transposon, gene family) | xem `NH`, MAPQ, `idxstats` |
| **Mismatch rate cao** | **sai reference / sai species / thư viện lạ** | đổi reference, kiểm tra adapter, QC FASTQ |
| **Properly paired thấp** | **vấn đề thư viện** (library prep), insert size bất thường, **số read R1/R2 không bằng nhau** | kiểm tra FASTQ, insert size distribution |
| **Một contig nhận ~10% reads, contig đó rất nhỏ** | **contamination** | BLAST/kraken, kiểm tra species |
| **`*` lớn bất thường** | read không có chỗ đáp (unmapped) | kiểm tra reference naming, `--outSAMunmapped` |
| **5′/3′ bias** | **RNA bị degrade / library bias** | RIN, coverage plot |
| **Duplicates > 50%** | **PCR over-amplification** | chỉ có ý nghĩa ở depth thật |

> [!WARNING]
> **One number is never a diagnosis.** Red flag là **pattern trải trên nhiều log**, không phải một ngưỡng đơn lẻ.

##### 6.7. `11% mapping` có phải là tệ?

**KHÔNG.** Với reference **rút gọn 3 NST (180.8 Mb = 5.85% hệ gen người)** và reads đến từ **toàn bộ transcriptome**, **~90% read không thể map** → mapping rate kỳ vọng **~11%**, và kết quả **11.06%** là **khớp chính xác với thiết kế**, **không phải thất bại**.

* **Throughput trong lớp:** ~**210 read pairs/giây**, 5,000 pairs trong **83 s**, peak RAM **4.1 GB**.
* **Vì sao chỉ 5,000 pairs:** reference nhỏ làm **tăng chi phí tìm kiếm** cho read không map (STAR quét full trước khi bỏ), Colab chỉ có 2 vCPU.

> [!TIP]
> **Cách báo cáo trong methods section (chuẩn):**
> "11.1% of reads mapped uniquely to the three-chromosome reference; the remaining reads are outside the indexed contigs." — cộng thêm **số junctions** và ** Assigned/fragments**

#### 7. Trực quan hóa BAM bằng IGV

**Locus 1 — contig `21`:8,210,178–8,219,821 (9,645 bp):**

* 74 records, coverage đến thành **đảo (islands)**, peak depth **13×**, **12 records soft-clipped** (`149M1S`, `88M62S`, `114M36S`).
* **2 annotated exons** trong window, **7/74 read bắt đầu trong một exon** → **67 read còn lại rơi ngoài feature** = **`Unassigned_NoFeatures` nhìn bằng mắt**.
* $\rightarrow$ **vùng không có read** = **intron**; **read bị xé qua junction** = spliced alignment; **soft clip** ở rìa = adapter.

**Locus 2 — contig `22`:39,313,952–39,318,985 (gene `RPL3`):**

* 14 records, **7 junction arcs**, intron dài nhất **2,020 bp** (39,315,458–39,317,478).
* **4 reads unique + 1 read multi**.
* Motif biên intron: **5 × `GT/AG`**, **1 × `GC/AG`**, **1 × `AT/AC`**.
  * `GT/AG` = major canonical.
  * `GC/AG` = minor (U2-type) intron.
  * `AT/AC` = minor.
* **12/14 reads** có **soft-clipped bases** (`S`) ở rìa exon.
* $\rightarrow$ **junction arcs chính là minh chứng trực quan** cho spliced alignment: một read nối hai exon cách nhau hàng kb, và **motif `GT…AG`** xác nhận junction là thật.

* **IGV yêu cầu:** BAM + `.bai` index (tạo bằng `samtools index`), reference genome cùng tên contig.

#### 8. Từ BAM tới Counts — featureCounts

**Counting là quyết định overlap, không phải cộng read:**

```text
              exon1        exon2
Gene A:       ======       ======
fragment 1:      [====]                 → overlaps 1 feature → assigned to gene A
fragment 2:       [=========]           → overlaps 2 genes   → Unassigned_Ambiguity
fragment 3:              [====]         → overlaps exon only in one isoform → assigned
fragment 4:         [====]              → intergenic / no feature → Unassigned_NoFeatures
```

**Câu hỏi counting:**

* **Count reads hay fragments?** $\rightarrow$ **Fragments** (`-p --countReadPairs`).
* **Fragment overlaps 1 feature → 1 count; fragment overlaps nhiều gene → ambiguity.**
* **Primary only** (`--secondary` không bật) — **secondary không được đếm**.

**Lệnh trong lớp:**

```bash
featureCounts -p --countReadPairs -T 2 -s 0 \
  -t exon -g gene_id \
  -a data/gtf/Homo_sapiens.GRCh38.sub.gtf \
  -o data/STAR/counts.txt \
  data/STAR/sample.Aligned.sortedByCoord.out.bam
```

* `-p --countReadPairs` — paired-end, **đếm fragment (cặp), không đếm từng mate**.
* `-s 0` — unstranded (`1`/`2` nếu stranded — **sai → mất một nửa counts**).
* `-t exon -g gene_id` — đếm exon, gộp theo gene.
* `-T 2` — số thread.

**Đọc file `.summary`, không chỉ ma trận:**

```text
            featureCounts v2.1.1
FIDs         GeneFIDs   %Processed Reads  %Unprocessed Reads
sample       1230       736 fragments     ...

Total fragments: 736 | Assigned: 448 (60.9%) | Unassigned: 288
  unassigned_multimapping : 183
  unassigned_ambiguity    : 74
  unassigned_nofeatures   : 31
  unassigned_mappingquality: 0
```

| Category | Count | Interpretation |
| :--- | :--- | :--- |
| **Total reads** | 1,472 | tổng record trong BAM |
| **quality passing** | 1,230 | primary (loại secondary/QC fail) |
| **assigned** | **448** | **60.9%** — gộp được vào gene |
| **unassigned: mapping quality** | 0 | read bị loại vì MAPQ thấp (`-M`) |
| **unassigned: multimapping** | **183** | **majority** — read không có locus duy nhất |
| **unassigned: ambiguity** | **74** | fragment chồng lên **nhiều gene** |
| **unassigned: no features** | **31** | intergenic, intron, không có exon |

**Ma trận counts (`counts.txt`):**

* **6,661 dòng gene** (annotation Ensembl 115), **253 gene non-zero**, **tổng column sum = 448**.
* Cột `Chr` và `Start` **liệt kê từng exon, phân tách bằng dấu `;`**.
* $\rightarrow$ đây chính là **đầu vào** của DESeq2/limma ở Bài 09.

> [!WARNING]
> **Assigned thấp?** **Đếm số fragment, không phải số read, và đọc đủ các mục unassigned.** Trong bài này unassigned là **multimapping (183) + ambiguity (74) + intergenic (31)** — **đa số là do reference nhỏ**, không phải pipeline hỏng.


---

### III. THỰC HÀNH & WORKFLOW MẪU

Toàn bộ phần thực hành chạy trên **Google Colab notebook**: `lecture-08/lecture-08_star_alignment.ipynb` (`bash` cell), dataset: **5,000 cặp read** của mẫu **PC9 control (GSM3702795 / SRR8836894, GSE129221, Paired-end 2×150 bp)** và reference **GRCh38 subset chr17/21/22, Ensembl 115 (6,661 genes, 44,417 transcripts)**.

#### 1. Môi trường & công cụ (bảng version)

| Package | Provides | Version |
| :--- | :--- | :--- |
| `rna-star` | STAR | **2.7.11b** |
| `samtools` | samtools | **1.19.2** |
| `subread` | featureCounts | **2.0.6 / 2.1.1** |
| `fastqc` | FastQC | **0.11.9** |
| `fastp` | fastp | **0.23.2** |
| `multiqc` | MultiQC | pip |

```bash
apt-get update -qq
apt-get install -y -qq rna-star samtools subread fastqc fastp
pip install -q multiqc

STAR --version; fastqc --version; fastp --version; multiqc --version
```

#### 2. Pre-flight — chứng minh input nguyên vẹn TRƯỚC khi dựng index

> **Pre-flight = "proof" logic:** hai kiểm tra bắt buộc trước khi bỏ 25 phút dựng index.

```bash
cd /content

# 1. Số record hai mate PHẢI bằng nhau và chia hết cho 4
for f in data/raw_fastq/*.sub.fq; do
  n=$(wc -l < "$f")
  echo "$(basename "$f"): $((n / 4)) reads"
done

# 2. Record đầu tiên đọc được: header, sequence, +, quality (4 dòng)
head -4 data/raw_fastq/SRR8836894_R1.sub.fq
```

Nếu một trong hai kiểm tra fail → **sửa ngay**. **STAR không sửa cho bạn.**

#### 3. FastQC → fastp → FastQC → MultiQC (nền của bài 07, khởi động bài 08)

```bash
cd /content

mkdir -p data/fastqc_raw data/fastqc_trimmed data/trimmed data/fastp

# 1) FastQC trên read thô
fastqc -t 2 -o data/fastqc_raw data/raw_fastq/*.sub.fq

# 2) fastp: cắt adapter + đuôi 3' chất lượng thấp, bỏ read quá ngắn sau trim
fastp \
  -i data/raw_fastq/SRR8836894_R1.sub.fq \
  -I data/raw_fastq/SRR8836894_R2.sub.fq \
  -o data/trimmed/SRR8836894_R1.trim.fq \
  -O data/trimmed/SRR8836894_R2.trim.fq \
  --detect_adapter_for_pe \
  -q 20 \
  -l 36 \
  -h data/fastp/fastp.html \
  -j data/fastp/fastp.json \
  --thread 2

# 3) FastQC trên read đã cắt → chứng minh chất lượng cải thiện
fastqc -t 2 -o data/fastqc_trimmed data/trimmed/*.trim.fq

# 4) MultiQC ONE time, cuối pipeline, gộp tất cả vào một HTML
multiqc data -o data/multiqc -n lecture08_raw_vs_trimmed --config data/multiqc_config.yaml
```

* `-q 20` — cắt đuôi 3′ khi quality dưới Q20; `-l 36` — bỏ read ngắn hơn 36 bp sau trim. **Hai mate đi cùng nhau:** nếu một read quá ngắn, fastp **bỏ cả cặp**.
* Tùy chọn: chỉ định adapter tường minh bằng `--adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA` (R1) và `--adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT` (R2) — `--detect_adapter_for_pe` tự suy adapter từ chính dữ liệu.

* **Kết quả FastQC raw:** R1 mean Q **35.5** (last 15 bp **30.5**), adapter **2.1%**, GC **49–50% (1 đỉnh)**; R2 mean Q **37.6** (last 15 bp **34.9**), adapter **2.5%**. Verdict: **trim adapters + 3′ tail, không sửa gì thêm**.
* **Kết quả sau fastp:** **4,944 cặp** còn lại (mỗi mate), length **45–150 bp**, mean Q **35.6 / 37.8**, adapter **0.02%**, GC **49%**, last 15 bp **30.6 / 35.1**.
* **MultiQC:** chạy **một lần duy nhất** ở cuối, gộp toàn bộ báo cáo vào **một HTML** (`multiqc_data/` chứa raw log của mỗi tool).

#### 4. Dựng index STAR — chạy sớm, chạy nền

> Index là bước **nặng nhất** trong Colab: **~25 phút** trên 2 vCPU (77 s với 16 threads). **Chiến thuật của lớp:** **start index construction early**, chạy **background**, rồi làm việc khác, **quay lại sau**.

```bash
# Reference rút gọn: sub-FASTA chứa contig `17`, `21`, `22` + GTF subset
# ⚠️ genomeSAindexNbases = 12 cho reference nhỏ (14 — default — → segfault)
# Tên contig trong @SQ do FASTA header quyết định → chính là bẫy naming
sparseD=1            # dense suffix array: ~1.6 GB, lấy tốc độ (RAM không phải khan hiếm ở đây)
saIndexNbases=12     # log2(len)/2 - 1 cho reference 181 Mb

STAR --runThreadN 2 \
     --runMode genomeGenerate \
     --genomeDir data/star_index \
     --genomeFastaFiles data/ref/Homo_sapiens.GRCh38.dna.primary_assembly.sub.fa \
     --sjdbGTFfile data/gtf/Homo_sapiens.GRCh38.sub.gtf \
     --sjdbGTFfeatureExon exon \
     --sjdbOverhang 149 \
     --genomeSAsparseD $sparseD \
     --genomeSAindexNbases $saIndexNbases \
     > data/star_index_build.log 2>&1 &

tail -n 5 data/star_index/Log.out    # xem tiến trình; build finish khi Log.out in "done" và SA tồn tại

# Guard: chỉ build nếu index chưa tồn tại
if [ ! -f "$indexDir/SA" ]; then
    STAR --runThreadN 16 --genomeDir "$indexDir" \
         --genomeFastaFiles "$ref" \
         --sjdbGTFfile "$gtf" --sjdbOverhang 149 \
         --genomeSAindexNbases 12
fi
```

* `Ctrl+C` **dừng `tail`, không dừng build** — build chạy nền.

**Ba điều phải nhớ về index:**

1. **`SA` + `SAindex` + `genome.txt` + `genome.txpout` + `genome.jobStates`** là sản phẩm của bước 1.
2. **Check sự tồn tại trước khi align:** `[ -f "$indexDir/SA" ]` — **index chưa xong → aligner không chạy**.
3. **Thời gian build** = 77 s (16 threads) vs **~25 phút** (2 vCPU, Colab). **Giới hạn là compute, không phải RAM.**
4. **Index là deterministic** → `data/star_index/` giữ lại, dùng cho lần sau, không build lại.

#### 5. Alignment STAR (83 s, throughput ~210 pairs/s)

```bash
STAR \
  --runThreadN 2 \
  --runMode alignReads \
  --genomeDir data/STAR/index \
  --readFilesIn data/trimmed/SRR8836894_R1.trim.fq data/trimmed/SRR8836894_R2.trim.fq \
  --outFileNamePrefix data/STAR/sample. \
  --sjdbGTFfile data/gtf/Homo_sapiens.GRCh38.sub.gtf \
  --sjdbOverhang 149 \
  --outSAMtype BAM SortedByCoordinate \
  --outFilterType BySJout \
  --outFilterMultimapNmax 20 \
  --alignSJoverhangMin 8 \
  --alignSJDBoverhangMin 1

# STAR chỉ ghi BAM lúc cuối → xem tiến trình qua progress file, không xem thư mục output
watch -n 2 'cat /content/data/STAR/sample.Log.progress.out'
```

* **`--outFilterType BySJout`** — giữ alignment nhất quán với filter splice junction; **KHÔNG phải bộ lọc duy nhất** (not a uniqueness filter).
* **`--alignSJoverhangMin 8`** — junction mới cần **ít nhất 8 base bám 2 phía**; **`--alignSJDBoverhangMin 1`** — annotated junction cần **1 base**.
* **`--outFilterMultimapNmax 20`** — read map quá 20 loci **bị loại**.
* **RAM lúc align bị cố định bởi index (~3.2 GB), KHÔNG tăng theo số read** — 5,000 pairs tốn cùng RAM như 1.5 M pairs, chỉ ít thời gian hơn.
* **Input trong notebook là trimmed pairs (4,944 cặp)**; slides dùng subset gzipped **5,000 cặp** → log báo `Input: 5000`.

* **5,000 cặp** (subset của slides) → 1,230 primary records, **83 s**.
* **Output chính:** `sample.Aligned.sortedByCoord.out.bam`
* **Output phụ:** `sample.Log.final.out`, `sample.Log.out`, `sample.Log.progress.out`, `sample.SJ.out.tab` (splice junctions), `sample.Gene.counts.tab` + `sample.Gene.long.tab` (nếu `--quantMode GeneCounts`), `sample.chimeric.out.junction` (fusion), `_STARtmp/` (delete after success).

#### 6. Đọc BAM

```bash
# Header
samtools view -H sample.Aligned.sortedByCoord.out.bam

# Một record + decode
samtools view -r 'SRR8836894.3781' sample.Aligned.sortedByCoord.out.bam

# Read có spliced alignment (CIGAR chứa N)
samtools view sample.bam | awk '$6 ~ /N/' | head -3

# All records vs primary
samtools view -c sample.bam          # 1,472 records
samtools view -c -F 256 sample.bam   # 1,230 primary records

# Distribution của MAPQ
samtools view sample.bam | cut -f5 | sort -n | uniq -c

# Index cho IGV / region query
samtools index sample.Aligned.sortedByCoord.out.bam
samtools view sample.bam 21:8210178-8219821 | wc -l   # 74
samtools view -r 'SRR8836894.3781' sample.bam | awk '{print $4, $6}'
```

#### 7. QC bộ ba: `Log.final.out` + `flagstat` + `idxstats`

```bash
samtools index sample.Aligned.sortedByCoord.out.bam

grep -E 'input reads|Uniquely mapped reads %|mapped to multiple loci|splices: Total|Mismatch rate' \
     sample.Log.final.out

samtools flagstat sample.Aligned.sortedByCoord.out.bam
samtools idxstats sample.Aligned.sortedByCoord.out.bam
samtools stats  sample.Aligned.sortedByCoord.out.bam | grep 'insert size'
```

**Production** dùng thêm: **Qualimap** (5′/3′ bias, duplication, coverage uniformity, insert size) và **MultiQC** (aggregated HTML). Qualimap **không có trong `apt` của Colab** → cần conda/jar; ở quy mô 5,000 pairs các metric này **không có ý nghĩa thống kê**.

#### 8. Counts

```bash
featureCounts -p --countReadPairs -T 2 -s 0 \
  -t exon -g gene_id \
  -a data/gtf/Homo_sapiens.GRCh38.sub.gtf \
  -o data/STAR/counts.txt \
  data/STAR/sample.Aligned.sortedByCoord.out.bam

cat data/STAR/counts.txt.summary
```

#### 9. Pipeline bash chuẩn hóa (mẫu cho Linux/WSL2 production)

```bash
#!/bin/bash
set -euo pipefail

REF=       # GRCh38 primary assembly
GTF=       # gene annotation
IDX=       # output index dir
R1=        # trimmed read1 FASTQ(.gz)
R2=        # trimmed read2 FASTQ(.gz)
PREFIX=sample.
N=16

# 1. Index (build one time, reuse)
if [ ! -f "$IDX/SA" ]; then
  mkdir -p "$IDX"
  STAR --runThreadN $N --genomeDir "$IDX" \
       --genomeFastaFiles $REF \
       --sjdbGTFfile $GTF --sjdbOverhang 149 \
       --genomeSAindexNbases 14
fi

# 2. Alignment
STAR --runThreadN $N --genomeDir "$IDX" \
     --readFilesIn $R1 $R2 --readFilesCommand zcat \
     --sjdbGTFfile $GTF --sjdbOverhang 149 \
     --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix "$PREFIX"

# 3. Post-alignment QC
samtools index "${PREFIX}Aligned.sortedByCoord.out.bam"
samtools flagstat "${PREFIX}Aligned.sortedByCoord.out.bam" > "${PREFIX}flagstat.txt"
samtools idxstats "${PREFIX}Aligned.sortedByCoord.out.bam" > "${PREFIX}idxstats.txt"

# 4. Counts
featureCounts -p --countReadPairs -T $N -s 2 \
  -t exon -g gene_id -a $GTF \
  -o "${PREFIX}counts.txt" "${PREFIX}Aligned.sortedByCoord.out.bam"

# 5. Aggregate report
multiqc -o "${PREFIX}multiqc" .
```

#### 10. Cạm bẫy thực hành (pitfalls gặp trong session)

* **Index build bị interrupt** (Ctrl+C khi build) → **phải build lại từ đầu**; index STAR **không resumable**.
* **Số record R1 ≠ R2** (4,998,000 vs 5,000,000) → **khung pairing bị lệch** từ record 4,998,001 → **insert size, counting, DE sai dây chuyền**.
* **Thiếu `.bai`** → `samtools idxstats`, region query, IGV **báo lỗi**.
* **Contig naming mismatch** (`17` vs `chr17`, hg19 vs GRCh38) → **unmapped tăng đột ngột**, `idxstats` hiện `*` lớn.
* **`--genomeSAindexNbases` default 14** trên reference nhỏ → **segfault** ngay khi bắt đầu build.
* **Quên `--readFilesCommand zcat`** với FASTQ `.gz` → STAR không đọc được input.
* **`--sjdbOverhang` ≠ read length − 1** → Junctions bị mất/lech, spliced alignment kém chính xác.


---

### IV. TỔNG HỢP HỎI - ĐÁP TRONG LỚP (Q&A SESSION)

#### Câu hỏi 1: Ký tự `I` ở dòng 4 của FASTQ mang ý nghĩa gì?

* **Câu hỏi lớp đặt ra:** Trong dòng quality `AFAI<FFF77<AF-AAF7FAAJJJ7JFAJ-FFF-FF--7---F<<F<AJJFFAFJJAJ-`, ký tự `I` có nghĩa là trình tự sai, không căn dòng được?
* **Giải đáp chi tiết:**
  * Dòng 4 của FASTQ **mã hóa chất lượng từng base** theo **thang Phred** (`Phred+33`).
  * `I` có mã ASCII = **73** → $Q = 73 - 33 = 40$.
  * $P_{\text{error}} = 10^{-Q/10} = 10^{-4}$ = **1/10,000 base** → $P_{\text{correct}} = 99.99\%$.
  * $\Rightarrow$ `Q40` là **chất lượng cao** (**không phải lỗi**). Trong thực tế `I`/`J`/`K` là các ký tự **top của Illumina** (Q40–Q42, mode của NovaSeq).
* **Bài học:** **Đọc bảng ASCII** và **quy đổi Phred** là kỹ năng bắt buộc khi đọc FastQC, BAM, log STAR, các hàm R ở bài sau.

#### Câu hỏi 2: FastQC plot cho thấy điều gì và nên cắt tỉa thế nào?

* **Phương án được nêu trong lớp:** "cut adapter + `--quality_avg 20 --minimum_length 36`".
* **Giải đáp của lớp:**
  * **Đúng** với plot đưa ra: chất lượng trung bình **32–34** (cao), chỉ **20–25 base cuối** suy giảm, adapter **2.1–2.5%**, GC **1 đỉnh** (không có dấu hiệu nhiễm).
  * **Không cắt toàn bộ** — chỉ cắt **phần suy giảm**: adapter + tail + read quá ngắn.
  * **Chạy FastQC trước**: nếu dữ liệu đã sạch → **không trim** (trim = mất dữ liệu, giảm số read, giảm độ phủ).
  * **Chạy FastQC sau** để **chứng minh** chất lượng được cải thiện → **QC là quyết định, không phải trang trí**.

#### Câu hỏi 3: Read 1 có 4,998,000 records, Read 2 có 5,000,000 records — align được không?

* **Trả lời được thống nhất trong lớp:** **Không**, vì số lượng read của R1 và R2 **không bằng nhau**, lệch **2,000 records**.
* **Giải đáp mở rộng:**
  * STAR đọc **mate-by-mate**: 1 dòng R1 + 1 dòng R2 → **1 fragment**.
  * Lệch 2,000 records $\Rightarrow$ **toàn bộ khung pairing bị lệch** từ record 4,998,001 trở đi: read R1 bị ghép với read R2 **không cùng fragment**.
  * Hậu quả **dây chuyền**: insert size sai $\rightarrow$ suy luận vị trí gen sai $\rightarrow$ **counting sai** $\rightarrow$ **kết luận differential expression sai**.
  * **Thói quen buộc:** đếm số hàng mỗi file FASTQ, **phải chia hết cho 4**, và **R1 = R2**.
* **Bài học:** **Pre-flight check trước khi dựng index** — STAR **không tự sửa** cho bạn.

#### Câu hỏi 4: Tại sao phải khởi tạo index STAR sớm, chạy nền?

* **Câu hỏi lớp đặt ra:** Build index có lâu không?
* **Giải đáp:**
  * Trên Colab (2 vCPU, 12 GB RAM): index 3 NST tốn **~25 phút** (16 threads chỉ **77 s**). Whole genome: **hàng giờ** + **~28 GB RAM** → **Colab không chạy được**.
  * **Chiến lược lớp học:** **start index construction early** trong Colab, **quay lại** làm việc khác, rồi quay lại khi index xong.
  * **Giới hạn thật là compute (CPU hours), không chỉ memory.**
  * **Guard bắt buộc:** `[ -f "$indexDir/SA" ]` trước khi align; index build bị ngắt $\rightarrow$ **phải build lại từ đầu** (không resumable).

#### Câu hỏi 5: Vì sao không thể "ngồi dò từng vị trí" hay dùng `grep` để align?

* **Câu hỏi lớp đặt ra:** Read 150 bp, hệ gen 3 Gb → có thể quét tuần tự không?
* **Giải đáp (4 lý do):**
  1. **Tổ hợp tính toán:** 3 Gb vị trí × nhiều triệu reads, mỗi read có thể **split qua nhiều exon** → **bất khả thi brute force**.
  2. **Không có exact match:** lỗi giải trình tự + SNP/indel → phải chấp nhận **mismatch** → không dùng exact string matching.
  3. **Hai strand:** read đến từ **cả forward lẫn reverse**; `grep`/`egrep`/regex **chỉ quét một chiều**.
  4. **Splicing:** read bắc qua junction, intron **6,500–7,000 bp** không có trong read → **không có một block liên tục để match**.
* **Giải pháp:** **suffix array** — STAR **lookup** trong bảng đã sắp xếp theo thứ tự từ điển, không cần đọc từng vị trí.

#### Câu hỏi 6: Vì sao đầu read bị "soft clip" (`S`) — read có bị mất không?

* **Giải đáp:**
  * Phần đầu/cuối read thường là **adapter** — adapter **không tồn tại trên hệ gen** (nó là trình tự mồi của kit/máy), nên **không map vào genome**.
  * STAR ghi nhận bằng **`S` trong CIGAR**; phần soft clip **vẫn nằm nguyên trong `SEQ`** của record, chỉ bị loại khỏi phần match.
  * $\Rightarrow$ **soft clip không phá hủy read**, chỉ khai báo "phần này không khớp reference".
* **Bài học:** Soft clip ở rìa exon trong IGV là **dấu hiệu adapter**, không phải mất exon.

#### Câu hỏi 7: Pseudo-aligner có thay thế được STAR không?

* **Câu hỏi lớp đặt ra:** salmon/kallisto nhanh hơn, sao không dùng?
* **Giải đáp:**
  * Pseudo-aligner **không sinh BAM** → **mất IGV**, **mất phân tích junction/fusion**, **mất QC tọa độ**, không dùng được cho **SNV/indel**.
  * Lớp học **cần BAM** cho: IGV, featureCounts, splicing analysis, QC.
  * **Space Ranger** (10x, nền tảng **Visium**) là công cụ **spatial transcriptomics**, **bên trong chạy STAR** — không phải pseudo-aligner.
* **Bài học:** Chọn công cụ theo **đầu ra cần dùng**, không chỉ theo tốc độ.

#### Câu hỏi 8: Năm câu hỏi cốt lõi của QC sau alignment là gì?

**Năm câu hỏi bắt buộc:**

1. **Bao nhiêu read đi được vào genome?** (mapping rate)
2. **Chúng đi đâu?** (phân bố theo contig — `idxstats`)
3. **Chúng khớp tốt tới đâu?** (mismatch rate, CIGAR, soft clip)
4. **Cặp có gắn kết lành mạnh không?** (properly paired, insert size)
5. **Độ phủ có đáng tin không?** (coverage uniformity, 5′/3′ bias, strand bias, rRNA, duplication)

* **Kỳ vọng thực tế:** whole-genome RNA-seq expect **80–90% unique** (trên 85–86% là tốt).
* **Trong bài này:** reference chỉ 3 NST = **5.85% hệ gen** → kỳ vọng **~11%**, kết quả **11.06%** → **KHÔNG phải là thất bại**.

#### Câu hỏi 9: Làm sao biết BAM "không nói xạo"?

* **Giải đáp:** Đối chiếu **log của aligner** với **bằng chứng đếm từ BAM**:

```text
5,000 fragments × (11.06% + 1.24%) = 615 fragments
615 × 2 mates                = 1,230 primary records
1,230 + 242 secondary        = 1,472 records   (flagstat: đúng)
MAPQ 255: 1,106 records      = 553 unique fragments × 2 mates  (khớp log 11.06%)
MAPQ 3 + MAPQ 1: 48 + 76 = 124 = 62 multi-mapped fragments × 2  (khớp log 1.24%)
```

* 553 unique fragments, **443 spliced junctions** → **junction nhiều hơn read spliced** vì 1 read có thể có nhiều junction.
* $\Rightarrow$ **Nghĩa là STAR báo cáo trung thực.**

#### Câu hỏi 10: Bốn bài tập tình huống QC — chẩn đoán red flag

**Exercise A — "2% uniquely mapped, 70% 'too many loci'"**

* **Đáp án: reads match many places in the genome.**
* **Lý do:** repeats/rRNA tạo **nhiều locus** → STAR báo "too many loci" thay vì đoán. **Read quá short** báo "too short"; **thiếu contig** cho unmapped, không tạo loci warning. **Reference sai** cho cùng một signature.

**Exercise B — "95% mapped, 40% mismatch rate"**

* **Đáp án: the reference does not match the reads.**
* **Lý do:** mismatch 40% = **sai species/assembly** (vd. mapping mouse vào human reference). **Duplicate không tăng mismatch rate**; **soft-clipped bases không bị tính là mismatch**.

**Exercise C — "Properly paired 60%, insert sizes huge"**

* **Đáp án: the library** (fragment dài, pairing lệch).
* **Lý do:** **xem insert size distribution trước khi đổ tội aligner**. **Thiếu intron** hiện trong **CIGAR**, không hiện trong **FLAG**; MAPQ thấp không gây mất proper pair.

**Exercise D — "10% reads land on one small contig"**

* **Đáp án: contamination, hoặc contig aligner không giải quyết được.**
* **Lý do:** contig nhỏ gánh 10% reads = **rRNA / adapter / spike-in**, hoặc **collapsed repeat** (mọi copy map về một chỗ). **Size và pairing không giải thích** được pile-up trên contig nhỏ.

#### Câu hỏi 11: Unmapped cao bất thường — nghi ngờ điều gì?

* **Giải đáp (từ kinh nghiệm thực tế của TS. Lưu Lợi):**
  * **Sai reference:** mapping đọc của **chuột lên reference người** → similarity có, nhưng **uniquely mapped rất thấp**.
  * **Contig naming:** `17` vs `chr17` — người hiểu là giống nhau, **tool đọc không hiểu**.
  * **Strandedness sai:** dùng lộn flag strand cho thư viện → **uniquely mapped giảm gần một nửa**. **Phải biết library chuẩn bị strand-specific hay không** (xem hướng dẫn kit).
  * **Multi-mapping:** read ngắn, repeats, rRNA → `--outFilterMultimapNmax`, `--seedMultimapNmax`, `--seedAttractor`.
  * **Contamination:** rRNA, mycoplasma, virus, spike-in, species khác.

#### Câu hỏi 12:featureCounts đếm read hay fragment? Unassigned thấp nghĩa gì?

* **Giải đáp:**
  * **Đếm fragment** (`-p --countReadPairs`): 1 molecule cDNA = 1 count, **không đếm 2 mate rời**. Trong bài: **736 fragments**, **448 assigned (60.9%)**.
  * **Unassigned** (`183 multimapping + 74 ambiguity + 31 no features`): **majority là multimapping** — do reference nhỏ, **không phải pipeline hỏng**.
  * **Strandedness `-s`:** `0` unstranded, `1`/`2` stranded. **Sai giá trị → mất ~một nửa counts** (448 → ~270).
  * **Đọc `.summary`, không chỉ ma trận.** Assigned là tử số, phần còn lại là **chẩn đoán**.
  * Ma trận: **6,661 gene rows, 253 non-zero, column sum = 448** → **đầu vào của DESeq2 ở Bài 09**.

#### Câu hỏi 13: Phương pháp học hiệu quả với dataset thật?

* **Câu hỏi lớp đặt ra:** cách học hiệu quả với dữ liệu thật?
  * **Khuyến nghị của giảng viên:** **học với AI theo tầng**: hỏi AI trước, **hỏi tiếp tục** cho tới khi hiểu, **chỉ hỏi thầy khi AI không trả lời được**. AI rất tốt cho **tổng hợp câu hỏi, quy tắc, kiến thức tổng quan** (ví dụ `data framework`, metadata).
  * Dataset **GSE129221** đầy đủ có **48 mẫu**; metadata có **12 mẫu** (PC9 control, các điều kiện), lớp **chỉ lấy 1 mẫu** cho bài này. Học viên **có thể tải toàn bộ và làm đầu đến cuối** để luyện.
  * **Bài tập về nhà** sẽ được **sửa sau** trong lớp.

---

### V. TỔNG KẾT CỐT LÕI & QUY TẮC THỰC HÀNH (KEY TAKEAWAYS)

> [!IMPORTANT]
> **8 nguyên tắc vàng trong alignment & post-alignment QC:**
> 1. **Pre-flight:** R1 = R2, số dòng chia hết cho 4, **TRƯỚC khi** dựng index.
> 2. **Index là lookup (suffix array), không phải scan** — hiểu vì sao `grep` thất bại.
> 3. **STAR = Seed → Extend → Stitch**; `N` trong CIGAR là **intron**, không phải `D`.
> 4. **BAM trả lời 3 câu hỏi:** Where = `POS`, How well = `CIGAR`, How sure = `MAPQ`.
> 5. **QC 2 tầng:** `Log.final.out` (ý kiến của aligner) **+** bằng chứng trong BAM (`flagstat`/`idxstats`).
> 6. **Mapping rate phải gắn denominator:** % của **fragments**, không phải % của records.
> 7. **11% mapping trên reference 3 NST là ĐÚNG thiết kế**, không phải thất bại.
> 8. **featureCounts đếm fragments**, `-s` phải đúng strand, **đọc `.summary`**.

**Chi tiết từng nguyên tắc:**

1. **Pre-flight — chứng minh input trước khi bỏ 25 phút dựng index:** số record R1 **phải bằng** R2 và số dòng **chia hết cho 4** (`zcat file.fastq.gz | wc -l`); record đầu phải đọc được 4 dòng. STAR **không sửa cho bạn**; khung pairing lệch từ record 4,998,001 → **insert size, counting, DE sai dây chuyền**.
2. **Index là lookup, không phải scan:** suffix array xếp mọi vị trí theo **thứ tự từ điển** của hậu tố bắt đầu tại đó, STAR **tra cứu nhị phân** — không quét từng vị trí như `grep`/`egrep`/regex. `grep` thất bại vì 4 lý do: **mismatch** (lỗi máy + SNP), **repeats/poly-A** (read map hàng trăm locus), **hai strand**, **splicing** (intron 6.5–7 kb không có trong read).
3. **STAR = Seed → Extend → Stitch:** seed bám → mở rộng 2 phía (chấp nhận mismatch) → cụm hóa anchor seeds → nối thành alignment. Khoảng trống lớn có biên `GT…AG` = **intron**, ghi bằng `N` (**không phải `D`**). Soft clip `S` **không phá hủy read** — `SEQ` vẫn nguyên, chỉ phần không khớp bị khai báo. Cờ bắt buộc: `--sjdbGTFfile` + `--sjdbOverhang 149` (= read length − 1).
4. **BAM trả lời 3 câu hỏi:** **Where** = cột 4 (`POS`), **How well** = cột 6 (`CIGAR`), **How sure** = cột 5 (`MAPQ`). Decode FLAG + TLEN: `TLEN = rightmost mate end − leftmost POS + 1`; `110M7018N40M` = 2 exon + intron 7,018 bp; **MAPQ 255 là label unique của STAR, không phải một xác suất**.
5. **QC 2 tầng — không tin log của aligner cho tới khi đối chiếu BAM:** tầng 1 = `sample.Log.final.out` (STAR tự báo cáo), tầng 2 = `samtools flagstat` + `samtools idxstats` + MAPQ distribution (đếm **từ record thật**).
6. **Denominator hygiene:** luôn hỏi "% của tập hợp nào?" STAR đếm **fragments**, `flagstat` đếm **records**, featureCounts đếm **fragments**.
   ```text
   5,000 fragments × (11.06% + 1.24%) = 615 fragments mapped
   615 × 2 mates = 1,230 primary records;  + 242 secondary = 1,472 records
   ```
7. **11% mapping là đúng thiết kế:** reference trong lớp = chr17+chr21+chr22 = **180.8 Mb = 5.85% hệ gen** → ~90% read không có chỗ đáp → kỳ vọng **~11%**, kết quả **11.06%**. Whole-genome RNA-seq chuẩn: **80–90% uniquely mapped**. Mapping rate **luôn đi kèm reference và denominator**.
8. **featureCounts:** `-p --countReadPairs` đếm **fragment**, chỉ **primary** (secondary không đếm), `-s` phải đúng strand (**sai → mất ~một nửa counts**), `-t exon -g gene_id`. **Đọc `.summary`, không chỉ ma trận:** 736 fragments → 448 assigned (60.9%), unassigned = 183 multimapping + 74 ambiguity + 31 no features. Ma trận 6,661 gene rows / 253 non-zero / column sum 448 = **đầu vào của DESeq2 ở Bài 09**.

**Ba nguyên tắc phụ (nối vào 8 nguyên tắc trên):**

* **Cờ là "bảng điều khiển" của giải thuật:** `--genomeSAindexNbases` (index), `--seed*` (seed), `--alignSJ*` (junction), `--outFilter*` (lọc output), `--twopassMode` (khám phá junction), `--quantMode GeneCounts` (count). **Hiểu từng flag thay vì copy lệnh** (xem §II.4).
* **Reference naming là bẫy lớn nhất:** `chr17` vs `17`, GRCh38 vs hg19, species mismatch → **mapping rate sụp đổ**; header BAM (`@SQ`) phải **khớp** GTF và reference.
* **Red flag map tới nguyên nhân, không tới cảm giác:** unmapped cao → reference/naming/contamination; mismatch cao → sai species/build; properly paired thấp → library; 10% trên contig nhỏ → contamination/collapsed repeat (xem bảng §II.6.6).

---

### VI. BÀI TẬP VỀ NHÀ & HƯỚNG DẪN GIẢI

**Đề bài từ notebook (Appendix):** *"Decode one spliced record, explain why the expected mapping rate is a property of this reduced reference, and bring one QC number you would report in a methods section."*

#### Bài 1 — Decode một record spliced

```text
SRR8836894.3116  99   17  1875710  255  84M1418N66M  =  1878996  3589  NH:i:1
SRR8836894.3116  147  17  1878996  255  66M153N84M   =  1875710 -3589  NH:i:1
```

**Phân tích:**

* `99` = paired + proper pair + mate forward + **read1**; `147` = paired + proper pair + **self reverse** + read2.
* **read1**: `84M` (1,875,710–1,875,793), intron **1,418 bp**, `66M` (1,879,212–1,879,277) → **span reference = 84+1418+66 = 1,568 bp**, kết ở **1,879,277**; **read length = 84+66 = 150**.
* **read2**: `66M` (1,878,996–1,879,061), intron **153 bp**, `84M` (1,879,215–1,879,298) → span **66+153+84 = 303 bp**, kết ở **1,879,298**; read length = 150.
* **Fragment span**: $1{,}879{,}298 - 1{,}875{,}710 + 1 = 3{,}589$ = **TLEN** $\Rightarrow$ **khớp chính xác với cột 9**.
* `NH:i:1` + `MAPQ 255` → **1 locus duy nhất** → **unique**.
* **$\Rightarrow$ Fragment chứa 2 junction** (1 trong read1, 1 trong read2); hai đầu đọc của cùng một fragment cover **3 exon** (84M, 66M overlap ở exon 2, 84M).

#### Bài 2 — Vì sao kỳ vọng mapping rate là ~11%?

* Reference trong lớp chỉ có **chr17 + chr21 + chr22 = 180.8 Mb** = **5.85%** hệ gen người.
* Reads đến từ **toàn bộ transcriptome** (poly-A selection) → **~90% read không có chỗ đáp**.
* Whole-genome RNA-seq chuẩn: **80–90% uniquely mapped**.
* $\Rightarrow$ **mapping rate là tính chất của reference được index**, không phải "chất lượng pipeline". Báo cáo mapping rate **luôn đi kèm reference và denominator**.

#### Bài 3 — Một con số QC đáng báo cáo trong methods

Ví dụ báo cáo chuẩn (một câu):

> "Paired-end 2×150 bp reads (SRR8836894, PC9 control, GSE129221) were aligned to GRCh38 chr17/21/22 (Ensembl 115) with STAR 2.7.11b (`--sjdbOverhang 149`, `--sjdbGTFfile`). **11.06% reads were uniquely mapped (553/5,000 fragments), 1.24% multi-mapped, 443 splice junctions detected**; `flagstat` reported 1,472 records (1,230 primary + 242 secondary, 100% properly paired). Gene-level counts were produced with featureCounts (`-p --countReadPairs -s 0 -t exon -g gene_id`): **448/736 fragments (60.9%) assigned**."

**Con số nên chọn:** uniquely mapped %, số junctions, properly paired %, Assigned %, insert size peak.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học (Part 1 & Part 2) và đối chiếu với slide `lecture-08_slides.qmd` cùng notebook `lecture-08_star_alignment.ipynb`. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
